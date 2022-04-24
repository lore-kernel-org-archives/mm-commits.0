Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD45C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 24 Apr 2022 21:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237265AbiDXV4C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Apr 2022 17:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239690AbiDXVz6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 24 Apr 2022 17:55:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C813FDB5
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 14:52:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A38896135C
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 21:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5F1C385A9;
        Sun, 24 Apr 2022 21:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650837175;
        bh=ms3wyMAXgfHFhkCwEZPqZ6Ltxs29URnwsC7FltANNR4=;
        h=Date:To:From:Subject:From;
        b=ar1tYB53lA13wAjaSLq1SksRJe2BpOEEmGsxVZJ9kwwKuDENpE4yygWivoDDBrVmk
         BoKrlbo1bxEDJlG5Ryh6DhcYadrRJt55ICqaJUJN9AyqpV2we4upLxPiqME5zON4UE
         RRSdM0BLszzVNpb8IysFEVwiEa8n25WotTj5kcq0=
Date:   Sun, 24 Apr 2022 14:52:54 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        linmiaohe@huawei.com, hughd@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-make-shmem_init-return-void-fix.patch removed from -mm tree
Message-Id: <20220424215254.ED5F1C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-shmem-make-shmem_init-return-void-fix
has been removed from the -mm tree.  Its filename was
     mm-shmem-make-shmem_init-return-void-fix.patch

This patch was dropped because it was folded into mm-shmem-make-shmem_init-return-void.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-shmem-make-shmem_init-return-void-fix

remove `return;' from void-returning function, per Muchun Song

Cc: Hugh Dickins <hughd@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-make-shmem_init-return-void-fix
+++ a/mm/shmem.c
@@ -4004,8 +4004,6 @@ void __init shmem_init(void)
 
 	shm_mnt = kern_mount(&shmem_fs_type);
 	BUG_ON(IS_ERR(shm_mnt));
-
-	return;
 }
 
 int shmem_unuse(unsigned int type)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-shmem-make-shmem_init-return-void.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
mm-vmscan-fix-comment-for-current_may_throttle-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

