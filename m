Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1762C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82D6E611EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345629AbhIIVGk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348104AbhIIVGL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C412611CE;
        Thu,  9 Sep 2021 21:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221501;
        bh=tCD3HJsTrhTRj1XzrmJtrA54WqLSKdX6EgbbB5u2I4g=;
        h=Date:From:To:Subject:From;
        b=2fHjZhx2MXVfaje/pkPofQg1vCFhCifnaABzr812LvNEC+lS1tN2TrRTTpEC9vIUV
         nAefBRfj31yVgJ5az5IFbkV8KxOOh70wETR6h6PF2j0QBmRTKdNm5ErETtO7uxR/3w
         6SdFTv2leNmdbCK3qW/YRwcfl4i0LoKqeboeRNis=
Date:   Thu, 09 Sep 2021 14:05:01 -0700
From:   akpm@linux-foundation.org
To:     hulkci@huawei.com, konishi.ryusuke@gmail.com,
        mm-commits@vger.kernel.org, sunnanyong@huawei.com
Subject:  [merged]
 nilfs2-fix-memory-leak-in-nilfs_sysfs_create_device_group.patch removed
 from -mm tree
Message-ID: <20210909210501.B4i8R3iSe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix memory leak in nilfs_sysfs_create_device_group
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-memory-leak-in-nilfs_sysfs_create_device_group.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nanyong Sun <sunnanyong@huawei.com>
Subject: nilfs2: fix memory leak in nilfs_sysfs_create_device_group

Patch series "nilfs2: fix incorrect usage of kobject".

This patchset from Nanyong Sun fixes memory leak issues and a NULL pointer
dereference issue caused by incorrect usage of kboject in nilfs2 sysfs
implementation.


This patch (of 6):

Reported by syzkaller:
BUG: memory leak
unreferenced object 0xffff888100ca8988 (size 8):
comm "syz-executor.1", pid 1930, jiffies 4294745569 (age 18.052s)
hex dump (first 8 bytes):
6c 6f 6f 70 31 00 ff ff loop1...
backtrace:
[<000000009d9e0ac4>] slab_alloc_node mm/slub.c:2972 [inline]
[<000000009d9e0ac4>] slab_alloc mm/slub.c:2980 [inline]
[<000000009d9e0ac4>] __kmalloc_track_caller+0x164/0x330 mm/slub.c:4644
[<00000000b1825477>] kstrdup+0x36/0x70 mm/util.c:60
[<00000000fa081499>] kstrdup_const+0x35/0x60 mm/util.c:83
[<0000000024d13570>] kvasprintf_const+0xf1/0x180 lib/kasprintf.c:48
[<0000000024b69715>] kobject_set_name_vargs+0x56/0x150 lib/kobject.c:289
[<000000003fedac3d>] kobject_add_varg lib/kobject.c:384 [inline]
[<000000003fedac3d>] kobject_init_and_add+0xc9/0x150 lib/kobject.c:473
[<000000002795bd99>] nilfs_sysfs_create_device_group+0x150/0x7d0 fs/nilfs2/sysfs.c:986
[<00000000567fa12d>] init_nilfs+0xa21/0xea0 fs/nilfs2/the_nilfs.c:637
[<00000000082e7458>] nilfs_fill_super fs/nilfs2/super.c:1046 [inline]
[<00000000082e7458>] nilfs_mount+0x7b4/0xe80 fs/nilfs2/super.c:1316
[<00000000adc3fd88>] legacy_get_tree+0x105/0x210 fs/fs_context.c:592
[<00000000a98c45b8>] vfs_get_tree+0x8e/0x2d0 fs/super.c:1498
[<00000000e96282d3>] do_new_mount fs/namespace.c:2905 [inline]
[<00000000e96282d3>] path_mount+0xf9b/0x1990 fs/namespace.c:3235
[<000000003d2eb1b0>] do_mount+0xea/0x100 fs/namespace.c:3248
[<00000000e1ce771a>] __do_sys_mount fs/namespace.c:3456 [inline]
[<00000000e1ce771a>] __se_sys_mount fs/namespace.c:3433 [inline]
[<00000000e1ce771a>] __x64_sys_mount+0x14b/0x1f0 fs/namespace.c:3433
[<000000007c7f81e8>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
[<000000007c7f81e8>] do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
[<00000000fd23ff06>] entry_SYSCALL_64_after_hwframe+0x44/0xae

If kobject_init_and_add return with error, then the cleanup of kobject is
needed because memory may be allocated in kobject_init_and_add without
freeing.

And the place of cleanup_dev_kobject should use kobject_put to free the
memory associated with the kobject.  As the section "Kobject removal" of
"Documentation/core-api/kobject.rst" says, kobject_del() just makes the
kobject "invisible", but it is not cleaned up.  And no more cleanup will
do after cleanup_dev_kobject, so kobject_put is needed here.

Link: https://lkml.kernel.org/r/1625651306-10829-1-git-send-email-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/1625651306-10829-2-git-send-email-konishi.ryusuke@gmail.com
Reported-by: Hulk Robot <hulkci@huawei.com>
Link: https://lkml.kernel.org/r/20210629022556.3985106-2-sunnanyong@huawei.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sysfs.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/nilfs2/sysfs.c~nilfs2-fix-memory-leak-in-nilfs_sysfs_create_device_group
+++ a/fs/nilfs2/sysfs.c
@@ -986,7 +986,7 @@ int nilfs_sysfs_create_device_group(stru
 	err = kobject_init_and_add(&nilfs->ns_dev_kobj, &nilfs_dev_ktype, NULL,
 				    "%s", sb->s_id);
 	if (err)
-		goto free_dev_subgroups;
+		goto cleanup_dev_kobject;
 
 	err = nilfs_sysfs_create_mounted_snapshots_group(nilfs);
 	if (err)
@@ -1023,9 +1023,7 @@ delete_mounted_snapshots_group:
 	nilfs_sysfs_delete_mounted_snapshots_group(nilfs);
 
 cleanup_dev_kobject:
-	kobject_del(&nilfs->ns_dev_kobj);
-
-free_dev_subgroups:
+	kobject_put(&nilfs->ns_dev_kobj);
 	kfree(nilfs->ns_dev_subgroups);
 
 failed_create_device_group:
_

Patches currently in -mm which might be from sunnanyong@huawei.com are


