Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26664C6FA82
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiILE6f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiILE5F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:57:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A12220E9
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:57:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC55AB80B9F
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70427C433C1;
        Mon, 12 Sep 2022 04:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958620;
        bh=OCV2hiQveIkapoKS6h9F92z6/SFuPA5AbugOZbU4Bl8=;
        h=Date:To:From:Subject:From;
        b=S1tGcJUTy6Ka4N2c0FAuxaAX24Y1heDdoYFHj5DCHbk2PIHlsDu7MTA8Jx0W9nT/F
         i4slC3IVLMn16vBu5qZrYbAX2iu3YraeoRhErU3CqWV5rE/rscwtBwnTyZvO4a/y6R
         QQaE/WQXASxhEtGIand/Tc+i90hSQ3QT2EPmARgU=
Date:   Sun, 11 Sep 2022 21:56:59 -0700
To:     mm-commits@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        dan.carpenter@oracle.com, chenxiaosong2@huawei.com,
        anton@tuxera.com, yin31149@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ntfs-fix-out-of-bounds-read-in-ntfs_attr_find.patch removed from -mm tree
Message-Id: <20220912045700.70427C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ntfs: fix out-of-bounds read in ntfs_attr_find()
has been removed from the -mm tree.  Its filename was
     ntfs-fix-out-of-bounds-read-in-ntfs_attr_find.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hawkins Jiawei <yin31149@gmail.com>
Subject: ntfs: fix out-of-bounds read in ntfs_attr_find()
Date: Thu, 1 Sep 2022 00:09:36 +0800

Kernel iterates over ATTR_RECORDs in mft record in ntfs_attr_find().  To
ensure access on these ATTR_RECORDs are within bounds, kernel will do some
checking during iteration.

The problem is that during checking whether ATTR_RECORD's name is within
bounds, kernel will dereferences the ATTR_RECORD name_offset field, before
checking this ATTR_RECORD strcture is within bounds.  This problem may
result out-of-bounds read in ntfs_attr_find(), reported by Syzkaller:

==================================================================
BUG: KASAN: use-after-free in ntfs_attr_find+0xc02/0xce0 fs/ntfs/attrib.c:597
Read of size 2 at addr ffff88807e352009 by task syz-executor153/3607

[...]
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:317 [inline]
 print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
 kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
 ntfs_attr_find+0xc02/0xce0 fs/ntfs/attrib.c:597
 ntfs_attr_lookup+0x1056/0x2070 fs/ntfs/attrib.c:1193
 ntfs_read_inode_mount+0x89a/0x2580 fs/ntfs/inode.c:1845
 ntfs_fill_super+0x1799/0x9320 fs/ntfs/super.c:2854
 mount_bdev+0x34d/0x410 fs/super.c:1400
 legacy_get_tree+0x105/0x220 fs/fs_context.c:610
 vfs_get_tree+0x89/0x2f0 fs/super.c:1530
 do_new_mount fs/namespace.c:3040 [inline]
 path_mount+0x1326/0x1e20 fs/namespace.c:3370
 do_mount fs/namespace.c:3383 [inline]
 __do_sys_mount fs/namespace.c:3591 [inline]
 __se_sys_mount fs/namespace.c:3568 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3568
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
 [...]
 </TASK>

The buggy address belongs to the physical page:
page:ffffea0001f8d400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7e350
head:ffffea0001f8d400 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888011842140
raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
Memory state around the buggy address:
 ffff88807e351f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88807e351f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88807e352000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff88807e352080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807e352100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

This patch solves it by moving the ATTR_RECORD strcture's bounds checking
earlier, then checking whether ATTR_RECORD's name is within bounds. 
What's more, this patch also add some comments to improve its
maintainability.

Link: https://lkml.kernel.org/r/20220831160935.3409-3-yin31149@gmail.com
Link: https://lore.kernel.org/all/1636796c-c85e-7f47-e96f-e074fee3c7d3@huawei.com/
Link: https://groups.google.com/g/syzkaller-bugs/c/t_XdeKPGTR4/m/LECAuIGcBgAJ
Signed-off-by: chenxiaosong (A) <chenxiaosong2@huawei.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
Reported-by: syzbot+5f8dcabe4a3b2c51c607@syzkaller.appspotmail.com
Tested-by: syzbot+5f8dcabe4a3b2c51c607@syzkaller.appspotmail.com
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/attrib.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/fs/ntfs/attrib.c~ntfs-fix-out-of-bounds-read-in-ntfs_attr_find
+++ a/fs/ntfs/attrib.c
@@ -594,11 +594,23 @@ static int ntfs_attr_find(const ATTR_TYP
 	for (;;	a = (ATTR_RECORD*)((u8*)a + le32_to_cpu(a->length))) {
 		u8 *mrec_end = (u8 *)ctx->mrec +
 		               le32_to_cpu(ctx->mrec->bytes_allocated);
-		u8 *name_end = (u8 *)a + le16_to_cpu(a->name_offset) +
-			       a->name_length * sizeof(ntfschar);
-		if ((u8*)a < (u8*)ctx->mrec || (u8*)a > mrec_end ||
-		    name_end > mrec_end)
+		u8 *name_end;
+
+		/* check whether ATTR_RECORD wrap */
+		if ((u8 *)a < (u8 *)ctx->mrec)
 			break;
+
+		/* check whether Attribute Record Header is within bounds */
+		if ((u8 *)a > mrec_end ||
+		    (u8 *)a + sizeof(ATTR_RECORD) > mrec_end)
+			break;
+
+		/* check whether ATTR_RECORD's name is within bounds */
+		name_end = (u8 *)a + le16_to_cpu(a->name_offset) +
+			   a->name_length * sizeof(ntfschar);
+		if (name_end > mrec_end)
+			break;
+
 		ctx->attr = a;
 		if (unlikely(le32_to_cpu(a->type) > le32_to_cpu(type) ||
 				a->type == AT_END))
_

Patches currently in -mm which might be from yin31149@gmail.com are


