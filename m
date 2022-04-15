Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D97DC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Apr 2022 18:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346313AbiDOSjD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Apr 2022 14:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345786AbiDOSjD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Apr 2022 14:39:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8833A5C9
        for <mm-commits@vger.kernel.org>; Fri, 15 Apr 2022 11:36:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31CBAB82E24
        for <mm-commits@vger.kernel.org>; Fri, 15 Apr 2022 18:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC834C385A5;
        Fri, 15 Apr 2022 18:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650047791;
        bh=FsONxFtLr2IwmuHg1LevKDlLu8/NG5hEHOUsW21zHvk=;
        h=Date:To:From:Subject:From;
        b=Zi/V/w6oY5WEp0Q1h5zOpvhhnxkCEGUDP014Xf/DeE3xgYG9QmifGPvRO+Khe2z5p
         3VnNjv3gvDff7A+jy8g0ZvE2DisUjZQ7uf0r6EvsjM1dsxv5pVGrpQgjuT3S/mD5lL
         jTKKkiM8JVgvbGbtvfvYy5cm5PNycmA/+SXdHETc=
Date:   Fri, 15 Apr 2022 11:36:29 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + linux-next-git-rejects.patch added to -mm tree
Message-Id: <20220415183630.DC834C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
@@ -102,10 +102,7 @@ static void mdp5_plane_reset(struct drm_
 	mdp5_state = kzalloc(sizeof(*mdp5_state), GFP_KERNEL);
 	if (!mdp5_state)
 		return;
-<<<<<<< HEAD
-=======
 
->>>>>>> linux-next/akpm-base
 	__drm_atomic_helper_plane_reset(plane, &mdp5_state->base);
 }
 
--- a/fs/cifs/cifsfs.c~linux-next-git-rejects
+++ a/fs/cifs/cifsfs.c
@@ -266,11 +266,7 @@ static void cifs_kill_sb(struct super_bl
 	 * before we kill the sb.
 	 */
 	if (cifs_sb->root) {
-<<<<<<< HEAD
-		for (node = rb_first(root); node; node = rb_next(node)) {
-=======
 		for(node = rb_first(root); node; node = rb_next(node)) {
->>>>>>> linux-next/akpm-base
 			tlink = rb_entry(node, struct tcon_link, tl_rbnode);
 			tcon = tlink_tcon(tlink);
 			if (IS_ERR(tcon))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-fs-binfmt_elf-fix-pt_load-p_align-values-for-loaders.patch
revert-fs-binfmt_elf-use-pt_load-p_align-values-for-static-pie.patch
mm.patch
kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel-fix.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-shmem-make-shmem_init-return-void-fix.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper-vs-maple-tree.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mglru-vs-maple-tree.patch
mm-vmscan-fix-comment-for-current_may_throttle-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
linux-next-git-rejects.patch

