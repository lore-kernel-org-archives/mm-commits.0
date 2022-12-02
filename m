Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFBB6C4332F
	for <mm-commits@archiver.kernel.org>; Fri,  2 Dec 2022 21:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbiLBVFO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Dec 2022 16:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiLBVFO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2022 16:05:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFD7E98AC
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 13:05:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF6ACB82212
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 21:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8F5C433C1;
        Fri,  2 Dec 2022 21:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670015109;
        bh=j3adXp1maONyIaqm/EGpFXnjZbiawnn9Bkv+9Fv3I4E=;
        h=Date:To:From:Subject:From;
        b=x6CArNrcNaiyIA6lkJVD0YslRA98Emmp/OPTzLN0p3WREPa49SnnMhfMycB5VBvaS
         pRDmev3Lp90lDQo/QTu9+pMGTENRyAq+FI/wiO5GCtW+VqYB4hymjHeCfhz344Zznu
         yuhZxNEb5GsGnjaet+bDxZHbzzCtz3Ry3J64TnKU=
Date:   Fri, 02 Dec 2022 13:05:08 -0800
To:     mm-commits@vger.kernel.org,
        syzbot+dc3b1cf9111ab5fe98e7@syzkaller.appspotmail.com,
        slava@dubeyko.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hfs-fix-oob-write-in-hfs_asc2mac.patch added to mm-nonmm-unstable branch
Message-Id: <20221202210509.8C8F5C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hfs: Fix OOB Write in hfs_asc2mac
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hfs-fix-oob-write-in-hfs_asc2mac.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hfs-fix-oob-write-in-hfs_asc2mac.patch

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
Subject: hfs: Fix OOB Write in hfs_asc2mac
Date: Fri, 2 Dec 2022 03:00:38 +0000

Syzbot reported a OOB Write bug:

loop0: detected capacity change from 0 to 64
==================================================================
BUG: KASAN: slab-out-of-bounds in hfs_asc2mac+0x467/0x9a0
fs/hfs/trans.c:133
Write of size 1 at addr ffff88801848314e by task syz-executor391/3632

Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1b1/0x28e lib/dump_stack.c:106
 print_address_description+0x74/0x340 mm/kasan/report.c:284
 print_report+0x107/0x1f0 mm/kasan/report.c:395
 kasan_report+0xcd/0x100 mm/kasan/report.c:495
 hfs_asc2mac+0x467/0x9a0 fs/hfs/trans.c:133
 hfs_cat_build_key+0x92/0x170 fs/hfs/catalog.c:28
 hfs_lookup+0x1ab/0x2c0 fs/hfs/dir.c:31
 lookup_open fs/namei.c:3391 [inline]
 open_last_lookups fs/namei.c:3481 [inline]
 path_openat+0x10e6/0x2df0 fs/namei.c:3710
 do_filp_open+0x264/0x4f0 fs/namei.c:3740

If in->len is much larger than HFS_NAMELEN(31) which is the maximum
length of an HFS filename, a OOB write could occur in hfs_asc2mac(). In
that case, when the dst reaches the boundary, the srclen is still
greater than 0, which causes a OOB write.
Fix this by adding a check on dstlen in while() before writing to dst
address.

Link: https://lkml.kernel.org/r/20221202030038.1391945-1-zhangpeng362@huawei.com
Fixes: 328b92278650 ("[PATCH] hfs: NLS support")
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Reported-by: <syzbot+dc3b1cf9111ab5fe98e7@syzkaller.appspotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/trans.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hfs/trans.c~hfs-fix-oob-write-in-hfs_asc2mac
+++ a/fs/hfs/trans.c
@@ -109,7 +109,7 @@ void hfs_asc2mac(struct super_block *sb,
 	if (nls_io) {
 		wchar_t ch;
 
-		while (srclen > 0) {
+		while (srclen > 0 && dstlen > 0) {
 			size = nls_io->char2uni(src, srclen, &ch);
 			if (size < 0) {
 				ch = '?';
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

hfs-fix-oob-read-in-__hfs_brec_find.patch
hfs-fix-oob-write-in-hfs_asc2mac.patch

