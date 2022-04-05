Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53765C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239689AbiDFB4V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573207AbiDESRC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 14:17:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EB5A76FA
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 11:15:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61F80B81F6A
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 18:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15652C385A0;
        Tue,  5 Apr 2022 18:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649182500;
        bh=Gf5jh+qVm11EaxYa8xgGR6xveXlWGdCCRyLhSuZUUb0=;
        h=Date:To:From:Subject:From;
        b=f65ilQ/UTYNM3ljTiqDLMQMmVZ2DD9il2sMZFVWv9U8VRg6R1Wty02SGqSiG4czlN
         XyyzHq42JG6gcYGu26cKZQvQsB3VqS0gc2otAA7aSJuP4w9e2mxdPXG2JGWeWiYlyX
         uoAzKptzMvQc+Yz/mwBDrv1d1EzzEYsKNI3LfpD4=
Date:   Tue, 05 Apr 2022 11:14:59 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + linux-next-git-rejects.patch added to -mm tree
Message-Id: <20220405181500.15652C385A0@smtp.kernel.org>
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

 fs/btrfs/file.c |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/fs/btrfs/file.c~linux-next-git-rejects
+++ a/fs/btrfs/file.c
@@ -3386,21 +3386,6 @@ static long btrfs_fallocate(struct file
 
 	if (mode & FALLOC_FL_PUNCH_HOLE)
 		return btrfs_punch_hole(file, offset, len);
-<<<<<<< HEAD
-
-	/*
-	 * Only trigger disk allocation, don't trigger qgroup reserve
-	 *
-	 * For qgroup space, it will be checked later.
-	 */
-	if (!(mode & FALLOC_FL_ZERO_RANGE)) {
-		ret = btrfs_alloc_data_chunk_ondemand(BTRFS_I(inode),
-						      alloc_end - alloc_start);
-		if (ret < 0)
-			return ret;
-	}
-=======
->>>>>>> linux-next/akpm-base
 
 	btrfs_inode_lock(inode, BTRFS_ILOCK_MMAP);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-list_lruc-revert-mm-list_lru-optimize-memcg_reparent_list_lru_node.patch
mm.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-shmem-make-shmem_init-return-void-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
linux-next-git-rejects.patch

