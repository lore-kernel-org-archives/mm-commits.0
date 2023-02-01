Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA60C636CC
	for <mm-commits@archiver.kernel.org>; Wed,  1 Feb 2023 00:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjBAAiV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Jan 2023 19:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjBAAiU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2023 19:38:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABF2268B
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 16:38:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6653B81ED8
        for <mm-commits@vger.kernel.org>; Wed,  1 Feb 2023 00:38:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBE5C4339B;
        Wed,  1 Feb 2023 00:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675211896;
        bh=JFhkNrUDhfKwYWSM9ia4P+MSSX6sRSc/yYmOFtPlXM4=;
        h=Date:To:From:Subject:From;
        b=Bjzp4UuT1qss+0n8eV40Rjjtft7WxBi5z2CDfgQUeFW5qpc2RpvDEJ1axRTrlOoYP
         5XPrr9YblLRPIrhXIfa5JLerWrMCoS3M4mhvr4ZtxoLjUK3r4FCu7Z336vgGjyt/GG
         s1zSIRG5cEmk2W3dDhm9DmC6CZHPhVSUi1mvWn4g=
Date:   Tue, 31 Jan 2023 16:38:15 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20230201003816.7FBE5C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes
Date: Tue Jan 17 04:08:34 PM PST 2023

fix indenting whitespace, reflow comment

Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mremap.c~mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes
+++ a/mm/mremap.c
@@ -1027,17 +1027,19 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 			}
 
 			/*
-			 * Function vma_merge() is called on the extension we are adding to
-			 * the already existing vma, vma_merge() will merge this extension with
-			 * the already existing vma (expand operation itself) and possibly also
-			 * with the next vma if it becomes adjacent to the expanded vma and
-			 * otherwise compatible.
+			 * Function vma_merge() is called on the extension we
+			 * are adding to the already existing vma, vma_merge()
+			 * will merge this extension with the already existing
+			 * vma (expand operation itself) and possibly also with
+			 * the next vma if it becomes adjacent to the expanded
+			 * vma and  otherwise compatible.
 			 *
-			 * However, vma_merge() can currently fail due to is_mergeable_vma()
-			 * check for vm_ops->close (see the comment there). Yet this should not
-			 * prevent vma expanding, so perform a simple expand for such vma.
-			 * Ideally the check for close op should be only done when a vma would
-			 * be actually removed due to a merge.
+			 * However, vma_merge() can currently fail due to
+			 * is_mergeable_vma() check for vm_ops->close (see the
+			 * comment there). Yet this should not prevent vma
+			 * expanding, so perform a simple expand for such vma.
+			 * Ideally the check for close op should be only done
+			 * when a vma would be actually removed due to a merge.
 			 */
 			if (!vma->vm_ops || !vma->vm_ops->close) {
 				vma = vma_merge(mm, vma, extension_start, extension_end,
@@ -1045,7 +1047,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 					extension_pgoff, vma_policy(vma),
 					vma->vm_userfaultfd_ctx, anon_vma_name(vma));
 			} else if (vma_adjust(vma, vma->vm_start, addr + new_len,
-                                   vma->vm_pgoff, NULL)) {
+				   vma->vm_pgoff, NULL)) {
 				vma = NULL;
 			}
 			if (!vma) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close.patch
mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix.patch
mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix-2.patch
mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
mm-remove-the-swap_readpage-return-value-fix.patch
block-remove-rw_page-fix.patch
mm-add-memcpy_from_file_folio-fix.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

