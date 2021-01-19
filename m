Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3236EC433E0
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E38A523104
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbhASTjm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jan 2021 14:39:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388647AbhASTdL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Jan 2021 14:33:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98EC923109;
        Tue, 19 Jan 2021 19:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611084750;
        bh=6MOoE39XQ4kbaVp9FiudvPPObgGFo8kM5na7RaTyaB4=;
        h=Date:From:To:Subject:From;
        b=OgjZB0NZ6YBHA+dMovqc5Jl62ayyuNuqCUpB1CagE+3+B8zgTCO5RYlhsqnEWXENQ
         ZHO6/ivPB7SGTN1XwWtGnDoN2EsUJKhSYX+kAbNlqghRSXqGvVTIzBD9chteZy85QJ
         ptwuwSufc28ZOr6NAdEqKIpYYTTsNid6AQdWpX6E=
Date:   Tue, 19 Jan 2021 11:32:28 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, bgeffon@google.com,
        kirill.shutemov@linux.intel.com, lixinhai.lxh@gmail.com,
        lokeshgidra@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  +
 mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success.patch
 added to -mm tree
Message-ID: <20210119193228.8J478mJSk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success
has been added to the -mm tree.  Its filename is
     mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li Xinhai <lixinhai.lxh@gmail.com>
Subject: mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success

mremap with MREMAP_DONTUNMAP will move all page table entries to new vma,
which means all pages allocated for the old vma are not relevant to it
anymore, and the relevant anon_vma links needs to be unlinked, in nature
the old vma is much like been freshly created and have no pages been fault
in.

But we should not do unlink, if the new vma has effectively merged with
the old one.

Link: https://lkml.kernel.org/r/20210119075126.3513154-2-lixinhai.lxh@gmail.com
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/mremap.c~mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success
+++ a/mm/mremap.c
@@ -595,6 +595,13 @@ static unsigned long move_vma(struct vm_
 		/* We always clear VM_LOCKED[ONFAULT] on the old vma */
 		vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
 
+		/*
+		 * anon_vma links of the old vma is no longer needed after its page
+		 * table has been moved.
+		 */
+		if (new_vma != vma)
+			unlink_anon_vmas(vma);
+
 		/* Because we won't unmap we don't need to touch locked_vm */
 		return new_addr;
 	}
_

Patches currently in -mm which might be from lixinhai.lxh@gmail.com are

mm-rmap-explicitly-reset-vma-anon_vma-in-unlink_anon_vmas.patch
mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success.patch
mm-hugetlbc-fix-unnecessary-address-expansion-of-pmd-sharing.patch

