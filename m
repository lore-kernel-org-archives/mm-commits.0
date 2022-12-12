Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 581AAC4167B
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 03:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbiLLDbl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 22:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbiLLDb2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 22:31:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA017D137
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 19:31:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CA89B80A1F
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 03:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10A3C433EF;
        Mon, 12 Dec 2022 03:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670815877;
        bh=hmIeVLFbGpUzwsU4nWP82n2AS3XCxWno1EaC0EaLq8A=;
        h=Date:To:From:Subject:From;
        b=qi6ebjOyMjs1WDwevp3GPGDFdXooLChS+kBp5VNoHc/DPdein6GDkmmclCdDintWJ
         fQUYXBpeQc0zS5+6u48P8skxC4/HvyuBMRKw/rWRb87t6/VrOtzfR4DOvSq7g8rKEu
         EmdlngA6CRxGYOMcfR/qW+yQFjZvygZCTEQR7qo0=
Date:   Sun, 11 Dec 2022 19:31:16 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com,
        syzbot+e836ff7133ac02be825f@syzkaller.appspotmail.com,
        sunnanyong@huawei.com, slava@dubeyko.com, jlayton@kernel.org,
        ira.weiny@intel.com, damien.lemoal@opensource.wdc.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hfs-fix-oob-read-in-__hfs_brec_find.patch removed from -mm tree
Message-Id: <20221212033116.F10A3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hfs: fix OOB Read in __hfs_brec_find
has been removed from the -mm tree.  Its filename was
     hfs-fix-oob-read-in-__hfs_brec_find.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: hfs: fix OOB Read in __hfs_brec_find
Date: Wed, 30 Nov 2022 06:59:59 +0000

Syzbot reported a OOB read bug:

==================================================================
BUG: KASAN: slab-out-of-bounds in hfs_strcmp+0x117/0x190
fs/hfs/string.c:84
Read of size 1 at addr ffff88807eb62c4e by task kworker/u4:1/11
CPU: 1 PID: 11 Comm: kworker/u4:1 Not tainted
6.1.0-rc6-syzkaller-00308-g644e9524388a #0
Workqueue: writeback wb_workfn (flush-7:0)
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1b1/0x28e lib/dump_stack.c:106
 print_address_description+0x74/0x340 mm/kasan/report.c:284
 print_report+0x107/0x1f0 mm/kasan/report.c:395
 kasan_report+0xcd/0x100 mm/kasan/report.c:495
 hfs_strcmp+0x117/0x190 fs/hfs/string.c:84
 __hfs_brec_find+0x213/0x5c0 fs/hfs/bfind.c:75
 hfs_brec_find+0x276/0x520 fs/hfs/bfind.c:138
 hfs_write_inode+0x34c/0xb40 fs/hfs/inode.c:462
 write_inode fs/fs-writeback.c:1440 [inline]

If the input inode of hfs_write_inode() is incorrect:
struct inode
  struct hfs_inode_info
    struct hfs_cat_key
      struct hfs_name
        u8 len # len is greater than HFS_NAMELEN(31) which is the
maximum length of an HFS filename

OOB read occurred:
hfs_write_inode()
  hfs_brec_find()
    __hfs_brec_find()
      hfs_cat_keycmp()
        hfs_strcmp() # OOB read occurred due to len is too large

Fix this by adding a Check on len in hfs_write_inode() before calling
hfs_brec_find().

Link: https://lkml.kernel.org/r/20221130065959.2168236-1-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reported-by: <syzbot+e836ff7133ac02be825f@syzkaller.appspotmail.com>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/hfs/inode.c~hfs-fix-oob-read-in-__hfs_brec_find
+++ a/fs/hfs/inode.c
@@ -458,6 +458,8 @@ int hfs_write_inode(struct inode *inode,
 		/* panic? */
 		return -EIO;
 
+	if (HFS_I(main_inode)->cat_key.CName.len > HFS_NAMELEN)
+		return -EIO;
 	fd.search_key->cat = HFS_I(main_inode)->cat_key;
 	if (hfs_brec_find(&fd))
 		/* panic? */
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are


