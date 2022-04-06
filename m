Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36A38C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 20:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234782AbiDFU5k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Apr 2022 16:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235222AbiDFU53 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Apr 2022 16:57:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D37414925A
        for <mm-commits@vger.kernel.org>; Wed,  6 Apr 2022 12:18:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5225B82545
        for <mm-commits@vger.kernel.org>; Wed,  6 Apr 2022 19:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C48C385A1;
        Wed,  6 Apr 2022 19:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649272679;
        bh=eXxZIeboZnvMW6YYkBF22dUAmTEexE7udSfyXiYVumI=;
        h=Date:To:From:Subject:From;
        b=D/oRaRtWVnKiI4cuTyQwUJKWuxMVx8tW7rS5sRt9Krgh6pou+53p526Tns3aOWuu+
         4VLClbAvmmj0cs4eqELgBD1bDUlMno4qEExAgp6rY+rh2lU94n8hPJfXu6p2wBTuX6
         d9ZIWyX21Z8RLIXBGrQ28SVMLPbSv2nvYEvtZ2Yo=
Date:   Wed, 06 Apr 2022 12:17:58 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Message-Id: <20220406191759.A1C48C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

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

