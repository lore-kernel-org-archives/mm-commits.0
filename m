Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D06C38159
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 01:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjARBGO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Jan 2023 20:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjARBFY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2023 20:05:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D2349407
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2023 16:53:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E16861579
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 00:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BE7C433EF;
        Wed, 18 Jan 2023 00:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674003231;
        bh=JlZbjrKTJ5ZN4ec/1ZpEGVcJMHEbSrvavNIxCDhD9ug=;
        h=Date:To:From:Subject:From;
        b=Rmd7RE6Hce4N4pjsA9iVTUPxv8+I52jkN5rewdHdewji+yjJsHp11FMWVJMquqTzH
         aJgarIug8o3SIHsp0Z2sXnheRbLPzR9X+rj8MmRfglcLD0VW5zbGBLqWKLlZmi+44u
         58vtxZF1V6R/i1KP+y9SDgrtRmi+g6JtKY07ScgM=
Date:   Tue, 17 Jan 2023 16:53:50 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes.patch added to mm-hotfixes-unstable branch
Message-Id: <20230118005351.82BE7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix.patch
mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch
mm-memcontrol-deprecate-charge-moving-fix.patch
mm-swap-convert-deactivate_page-to-folio_deactivate-fix.patch
mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes.patch
mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch

