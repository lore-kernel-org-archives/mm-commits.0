Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 115E2C4321E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 21:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiK3VTf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 16:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiK3VTe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 16:19:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89BCB55
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 13:19:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3255261D53
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 21:19:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69721C433C1;
        Wed, 30 Nov 2022 21:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669843172;
        bh=+SuDtsfI3c0ZyLLaLnzylzJgZg6AIZ4AUTPQdIlWYZA=;
        h=Date:To:From:Subject:From;
        b=VZ3v/VUyLayh3V2HqLEDcj3TvKlTdVrqHpxKflhzelEm1NcLBDSImOqSJP4QdFlCg
         GSRMDDkSM6voj2T/ah+Eg3FyCJUAAn4d/5yOw/zeJB0kK+Hj1D4wg/ddgFx2vnRmQU
         OHLozJiGdhfLsheX6YNP90wHdtGUZntxgGC1HKNo=
Date:   Wed, 30 Nov 2022 13:19:31 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com,
        syzbot+e836ff7133ac02be825f@syzkaller.appspotmail.com,
        sunnanyong@huawei.com, slava@dubeyko.com, jlayton@kernel.org,
        ira.weiny@intel.com, damien.lemoal@opensource.wdc.com,
        zhangpeng362@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hfs-fix-oob-read-in-__hfs_brec_find.patch added to mm-nonmm-unstable branch
Message-Id: <20221130211932.69721C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hfs: fix OOB Read in __hfs_brec_find
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hfs-fix-oob-read-in-__hfs_brec_find.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hfs-fix-oob-read-in-__hfs_brec_find.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

nilfs2-fix-null-pointer-dereference-in-nilfs_palloc_commit_free_entry.patch
hfs-fix-oob-read-in-__hfs_brec_find.patch

