Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C818DC433DB
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F4772310B
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 19:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390516AbhASTdm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jan 2021 14:33:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729433AbhASTdL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Jan 2021 14:33:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D12123108;
        Tue, 19 Jan 2021 19:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611084746;
        bh=+5HQXSLE+9feMXQ0AKMv75XNGzNASYyI17af+rjqGtc=;
        h=Date:From:To:Subject:From;
        b=uvihxSKCTFlYE1b0eM9o9njxYry8uF6C4QFQ8jB22B241chRcSBq22jy0nEJa7myn
         I4uMBAUJilQJuF2epfPTt84dVkHnoSS5LSCsvvzP+rCeyQPW+UOGf5Mwcow32wEdlf
         O2TxmTj0NF76v/RgzNThQZKbQMpbPha/2gH7xnUE=
Date:   Tue, 19 Jan 2021 11:32:25 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, bgeffon@google.com,
        kirill.shutemov@linux.intel.com, lixinhai.lxh@gmail.com,
        lokeshgidra@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  +
 mm-rmap-explicitly-reset-vma-anon_vma-in-unlink_anon_vmas.patch added to
 -mm tree
Message-ID: <20210119193225.5_RRP2X12%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rmap: explicitly reset vma->anon_vma in unlink_anon_vmas()
has been added to the -mm tree.  Its filename is
     mm-rmap-explicitly-reset-vma-anon_vma-in-unlink_anon_vmas.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-explicitly-reset-vma-anon_vma-in-unlink_anon_vmas.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-explicitly-reset-vma-anon_vma-in-unlink_anon_vmas.patch

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
Subject: mm: rmap: explicitly reset vma->anon_vma in unlink_anon_vmas()

In case the vma will continue to be used after unlink its relevant
anon_vma, we need to reset the vma->anon_vma pointer to NULL.  So, later
when fault happen within this vma again, a new anon_vma will be prepared.

By this way, the vma will only be checked for reverse mapping of pages
which been fault in after the unlink_anon_vmas call.

Currently, the mremap with MREMAP_DONTUNMAP scenario will continue use the
vma after moved its page table entries to a new vma.  For other scenarios,
the vma itself will be freed after call unlink_anon_vmas.

Link: https://lkml.kernel.org/r/20210119075126.3513154-1-lixinhai.lxh@gmail.com
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-explicitly-reset-vma-anon_vma-in-unlink_anon_vmas
+++ a/mm/rmap.c
@@ -413,8 +413,15 @@ void unlink_anon_vmas(struct vm_area_str
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}
-	if (vma->anon_vma)
+	if (vma->anon_vma) {
 		vma->anon_vma->degree--;
+
+		/*
+		 * vma would still be needed after unlink, and anon_vma will be prepared
+		 * when handle fault.
+		 */
+		vma->anon_vma = NULL;
+	}
 	unlock_anon_vma_root(root);
 
 	/*
_

Patches currently in -mm which might be from lixinhai.lxh@gmail.com are

mm-rmap-explicitly-reset-vma-anon_vma-in-unlink_anon_vmas.patch
mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success.patch
mm-hugetlbc-fix-unnecessary-address-expansion-of-pmd-sharing.patch

