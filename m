Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C2DECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiILE6e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiILE5C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:57:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0C127FE2
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:57:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6858AB80BA8
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E834C433D6;
        Mon, 12 Sep 2022 04:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958619;
        bh=eR8TCXwmbg/zJOYuIZhYSnNAJLUUfNdHg9xpou2qJJ8=;
        h=Date:To:From:Subject:From;
        b=W2gElhgv7ZpdM5S5P9FX48nDv93t9tXBjT1ReEpcuQ/IY/VmWHHmeL54jIgKnP4WS
         ZID5h3O6kDBhmdM28JebN1hs8ocrp6khCprfhrDujSYQl6nL6j1Kp0t1CsfwgK74Ht
         KLi8dhPUITLBc70FuKI4xKW1dSJp8RPF6FZag/pw=
Date:   Sun, 11 Sep 2022 21:56:58 -0700
To:     mm-commits@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        dan.carpenter@oracle.com, chenxiaosong2@huawei.com,
        anton@tuxera.com, yin31149@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ntfs-fix-use-after-free-in-ntfs_attr_find.patch removed from -mm tree
Message-Id: <20220912045659.1E834C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ntfs: fix use-after-free in ntfs_attr_find()
has been removed from the -mm tree.  Its filename was
     ntfs-fix-use-after-free-in-ntfs_attr_find.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hawkins Jiawei <yin31149@gmail.com>
Subject: ntfs: fix use-after-free in ntfs_attr_find()
Date: Thu, 1 Sep 2022 00:09:34 +0800

Patch series "ntfs: fix bugs about Attribute", v2.

This patchset fixes three bugs relative to Attribute in record:

Patch 1 adds a sanity check to ensure that, attrs_offset field in first
mft record loading from disk is within bounds.

Patch 2 moves the ATTR_RECORD's bounds checking earlier, to avoid
dereferencing ATTR_RECORD before checking this ATTR_RECORD is within
bounds.

Patch 3 adds an overflow checking to avoid possible forever loop in
ntfs_attr_find().

Without patch 1 and patch 2, the kernel triggersa KASAN use-after-free
detection as reported by Syzkaller.

Although one of patch 1 or patch 2 can fix this, we still need both of
them.  Because patch 1 fixes the root cause, and patch 2 not only fixes
the direct cause, but also fixes the potential out-of-bounds bug.


This patch (of 3):

Syzkaller reported use-after-free read as follows:
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

Kernel will loads $MFT/$DATA's first mft record in
ntfs_read_inode_mount().

Yet the problem is that after loading, kernel doesn't check whether
attrs_offset field is a valid value.

To be more specific, if attrs_offset field is larger than bytes_allocated
field, then it may trigger the out-of-bounds read bug(reported as
use-after-free bug) in ntfs_attr_find(), when kernel tries to access the
corresponding mft record's attribute.

This patch solves it by adding the sanity check between attrs_offset field
and bytes_allocated field, after loading the first mft record.

Link: https://lkml.kernel.org/r/20220831160935.3409-1-yin31149@gmail.com
Link: https://lkml.kernel.org/r/20220831160935.3409-2-yin31149@gmail.com
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: ChenXiaoSong <chenxiaosong2@huawei.com>
Cc: syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/inode.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ntfs/inode.c~ntfs-fix-use-after-free-in-ntfs_attr_find
+++ a/fs/ntfs/inode.c
@@ -1829,6 +1829,13 @@ int ntfs_read_inode_mount(struct inode *
 		goto err_out;
 	}
 
+	/* Sanity check offset to the first attribute */
+	if (le16_to_cpu(m->attrs_offset) >= le32_to_cpu(m->bytes_allocated)) {
+		ntfs_error(sb, "Incorrect mft offset to the first attribute %u in superblock.",
+			       le16_to_cpu(m->attrs_offset));
+		goto err_out;
+	}
+
 	/* Need this to sanity check attribute list references to $MFT. */
 	vi->i_generation = ni->seq_no = le16_to_cpu(m->sequence_number);
 
_

Patches currently in -mm which might be from yin31149@gmail.com are


