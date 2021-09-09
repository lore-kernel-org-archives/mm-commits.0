Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52BB3C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 400C2611C8
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347901AbhIIVGx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348312AbhIIVGY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFE63611C0;
        Thu,  9 Sep 2021 21:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221514;
        bh=6lHqxtHPYYLtmQAxR441dZ/B9D/0P9ArhmLWtNMv38A=;
        h=Date:From:To:Subject:From;
        b=gIX7vmoTAbQi4/gQLo+/WCroaOO8wfKTjnypLlSVFP1Fl2lrg4vzUntW6ZeT/BFzZ
         ZPxWpz9edcMMorEfn3Q2yy3Dr6QuBL1W91baJzSO13b+qpIaPWDAerb3xFfcDA3y8r
         4Dz20fCGfGx3qP/a9KmLtXreA95/954ebXJLe1gk=
Date:   Thu, 09 Sep 2021 14:05:14 -0700
From:   akpm@linux-foundation.org
To:     konishi.ryusuke@gmail.com, mm-commits@vger.kernel.org,
        thunder.leizhen@huawei.com
Subject:  [merged]
 nilfs2-use-refcount_dec_and_lock-to-fix-potential-uaf.patch removed from
 -mm tree
Message-ID: <20210909210514.Hou5dhIAj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: use refcount_dec_and_lock() to fix potential UAF
has been removed from the -mm tree.  Its filename was
     nilfs2-use-refcount_dec_and_lock-to-fix-potential-uaf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: nilfs2: use refcount_dec_and_lock() to fix potential UAF

When the refcount is decreased to 0, the resource reclamation branch is
entered.  Before CPU0 reaches the race point (1), CPU1 may obtain the
spinlock and traverse the rbtree to find 'root', see nilfs_lookup_root(). 
Although CPU1 will call refcount_inc() to increase the refcount, it is
obviously too late.  CPU0 will release 'root' directly, CPU1 then accesses
'root' and triggers UAF.

Use refcount_dec_and_lock() to ensure that both the operations of decrease
refcount to 0 and link deletion are lock protected eliminates this risk.

     CPU0                      CPU1
nilfs_put_root():
			    <-------- (1)
spin_lock(&nilfs->ns_cptree_lock);
rb_erase(&root->rb_node, &nilfs->ns_cptree);
spin_unlock(&nilfs->ns_cptree_lock);

kfree(root);
			    <-------- use-after-free

========================================================================
refcount_t: underflow; use-after-free.
WARNING: CPU: 2 PID: 9476 at lib/refcount.c:28 \
refcount_warn_saturate+0x1cf/0x210 lib/refcount.c:28
Modules linked in:
CPU: 2 PID: 9476 Comm: syz-executor.0 Not tainted 5.10.45-rc1+ #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), ...
RIP: 0010:refcount_warn_saturate+0x1cf/0x210 lib/refcount.c:28
... ...
Call Trace:
 __refcount_sub_and_test include/linux/refcount.h:283 [inline]
 __refcount_dec_and_test include/linux/refcount.h:315 [inline]
 refcount_dec_and_test include/linux/refcount.h:333 [inline]
 nilfs_put_root+0xc1/0xd0 fs/nilfs2/the_nilfs.c:795
 nilfs_segctor_destroy fs/nilfs2/segment.c:2749 [inline]
 nilfs_detach_log_writer+0x3fa/0x570 fs/nilfs2/segment.c:2812
 nilfs_put_super+0x2f/0xf0 fs/nilfs2/super.c:467
 generic_shutdown_super+0xcd/0x1f0 fs/super.c:464
 kill_block_super+0x4a/0x90 fs/super.c:1446
 deactivate_locked_super+0x6a/0xb0 fs/super.c:335
 deactivate_super+0x85/0x90 fs/super.c:366
 cleanup_mnt+0x277/0x2e0 fs/namespace.c:1118
 __cleanup_mnt+0x15/0x20 fs/namespace.c:1125
 task_work_run+0x8e/0x110 kernel/task_work.c:151
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:164 [inline]
 exit_to_user_mode_prepare+0x13c/0x170 kernel/entry/common.c:191
 syscall_exit_to_user_mode+0x16/0x30 kernel/entry/common.c:266
 do_syscall_64+0x45/0x80 arch/x86/entry/common.c:56
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

There is no reproduction program, and the above is only theoretical
analysis.

Link: https://lkml.kernel.org/r/1629859428-5906-1-git-send-email-konishi.ryusuke@gmail.com
Fixes: ba65ae4729bf ("nilfs2: add checkpoint tree to nilfs object")
Link: https://lkml.kernel.org/r/20210723012317.4146-1-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/the_nilfs.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/nilfs2/the_nilfs.c~nilfs2-use-refcount_dec_and_lock-to-fix-potential-uaf
+++ a/fs/nilfs2/the_nilfs.c
@@ -792,14 +792,13 @@ nilfs_find_or_create_root(struct the_nil
 
 void nilfs_put_root(struct nilfs_root *root)
 {
-	if (refcount_dec_and_test(&root->count)) {
-		struct the_nilfs *nilfs = root->nilfs;
+	struct the_nilfs *nilfs = root->nilfs;
 
-		nilfs_sysfs_delete_snapshot_group(root);
-
-		spin_lock(&nilfs->ns_cptree_lock);
+	if (refcount_dec_and_lock(&root->count, &nilfs->ns_cptree_lock)) {
 		rb_erase(&root->rb_node, &nilfs->ns_cptree);
 		spin_unlock(&nilfs->ns_cptree_lock);
+
+		nilfs_sysfs_delete_snapshot_group(root);
 		iput(root->ifile);
 
 		kfree(root);
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are


