Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10C37C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA19A61CF6
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbhF2AcV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232170AbhF2AcV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:32:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8A2B61CDA;
        Tue, 29 Jun 2021 00:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624926594;
        bh=kU4K2lxuj8Ezvy4CIgWcX/8LA1n18cyNhnXJThyQsYk=;
        h=Date:From:To:Subject:From;
        b=Z0/8NwGS7fDHf+kEyzp5YSboITGgqd9ChH3h09+0ZsZKfsymo7rmwiaXMCRCGf/0S
         v7eWJJw/DbBMA3Uw26FsZ+Q+0r5v8S2P3gB2FOpp8rdB5Qt2+I0zRp3ln618jRy1Ic
         MHEFTOh/ZmpnlUGDePhM+jd1sWFOwmGCTQyRYplo=
Date:   Mon, 28 Jun 2021 17:29:53 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, eugenis@google.com, kostyak@google.com,
        mm-commits@vger.kernel.org, pcc@google.com, peterx@redhat.com
Subject:  [folded-merged]
 mm-improve-mprotectrw-efficiency-on-pages-referenced-once-v5.patch removed
 from -mm tree
Message-ID: <20210629002953.Y0MvELeUK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: improve mprotect(R|W) efficiency on pages referenced once
has been removed from the -mm tree.  Its filename was
     mm-improve-mprotectrw-efficiency-on-pages-referenced-once-v5.patch

This patch was dropped because it was folded into mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch

------------------------------------------------------
From: Peter Collingbourne <pcc@google.com>
Subject: mm: improve mprotect(R|W) efficiency on pages referenced once

add comments, prohibit optimization for NUMA pages

Link: https://lkml.kernel.org/r/20210601185926.2623183-1-pcc@google.com
Signed-off-by: Peter Collingbourne <pcc@google.com>
Link: https://linux-review.googlesource.com/id/I98d75ef90e20330c578871c87494d64b1df3f1b8
Link: [1] https://source.android.com/devices/tech/debug/scudo
Link: [2] https://cs.android.com/android/platform/superproject/+/master:bionic/benchmarks/stdlib_benchmark.cpp;l=53;drc=e8693e78711e8f45ccd2b610e4dbe0b94d551cc9
Link: [3] https://github.com/pcc/llvm-project/commit/scudo-mprotect-secondary2
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kostya Kortchinsky <kostyak@google.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/mm/mprotect.c~mm-improve-mprotectrw-efficiency-on-pages-referenced-once-v5
+++ a/mm/mprotect.c
@@ -35,10 +35,16 @@
 
 #include "internal.h"
 
+/* Determine whether we can avoid taking write faults for known dirty pages. */
 static bool may_avoid_write_fault(pte_t pte, struct vm_area_struct *vma,
 				  unsigned long cp_flags)
 {
+	/*
+	 * The dirty accountable bit indicates that we can always make the page
+	 * writable regardless of the number of references.
+	 */
 	if (!(cp_flags & MM_CP_DIRTY_ACCT)) {
+		/* Otherwise, we must have exclusive access to the page. */
 		if (!(vma_is_anonymous(vma) && (vma->vm_flags & VM_WRITE)))
 			return false;
 
@@ -46,15 +52,31 @@ static bool may_avoid_write_fault(pte_t
 			return false;
 	}
 
+	/*
+	 * Don't do this optimization for clean pages as we need to be notified
+	 * of the transition from clean to dirty.
+	 */
 	if (!pte_dirty(pte))
 		return false;
 
+	/* Same for softdirty. */
 	if (!pte_soft_dirty(pte) && (vma->vm_flags & VM_SOFTDIRTY))
 		return false;
 
+	/*
+	 * For userfaultfd the user program needs to monitor write faults so we
+	 * can't do this optimization.
+	 */
 	if (pte_uffd_wp(pte))
 		return false;
 
+	/*
+	 * It is unclear whether this optimization can be done safely for NUMA
+	 * pages.
+	 */
+	if (cp_flags & MM_CP_PROT_NUMA)
+		return false;
+
 	return true;
 }
 
@@ -153,7 +175,6 @@ static unsigned long change_pte_range(st
 				ptent = pte_clear_uffd_wp(ptent);
 			}
 
-			/* Avoid taking write faults for known dirty pages */
 			if (may_avoid_write_fault(ptent, vma, cp_flags))
 				ptent = pte_mkwrite(ptent);
 			ptep_modify_prot_commit(vma, addr, pte, oldpte, ptent);
_

Patches currently in -mm which might be from pcc@google.com are

mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch

