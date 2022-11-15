Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29AACC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbiKOWd1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbiKOWdA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:33:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A94C3121E
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDC5E61A66
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405DFC433D6;
        Tue, 15 Nov 2022 22:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551554;
        bh=NLsJN15zMMkDyaMK57p9FGPoIc3xPF1TJDPfax+WKGU=;
        h=Date:To:From:Subject:From;
        b=n/HFhOlq9je0gETr7k6ss4HVs/aXXP7JU7lu+wLM89HfWcywcuRhDCUSXXFABLA3+
         x/1nDeLKABktU3jcL3oXTjUoS064munxhgXRyPQEg/1/rJo6ZGyuVWc2f62bKiwA1D
         XIE9RgKaKc2LpeRU3hszyFsuw5K42qZDjPqCsHsI=
Date:   Tue, 15 Nov 2022 14:32:33 -0800
To:     mm-commits@vger.kernel.org, yukuai3@huawei.com,
        yi.zhang@huawei.com, phillip@squashfs.org.uk,
        nixiaoming@huawei.com, libaokun1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-fix-null-ptr-deref-in-squashfs_fill_super.patch removed from -mm tree
Message-Id: <20221115223234.405DFC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: squashfs: fix null-ptr-deref in squashfs_fill_super
has been removed from the -mm tree.  Its filename was
     squashfs-fix-null-ptr-deref-in-squashfs_fill_super.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baokun Li <libaokun1@huawei.com>
Subject: squashfs: fix null-ptr-deref in squashfs_fill_super
Date: Tue, 1 Nov 2022 15:33:43 +0800

When squashfs_read_table() returns an error or `sb->s_magic !=
SQUASHFS_MAGIC`, enters the error branch and calls
msblk->thread_ops->destroy(msblk) to destroy msblk.  However,
msblk->thread_ops has not been initialized.  Therefore, the following
problem is triggered:

==================================================================
BUG: KASAN: null-ptr-deref in squashfs_fill_super+0xe7a/0x13b0
Read of size 8 at addr 0000000000000008 by task swapper/0/1

CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc3-next-20221031 #367
Call Trace:
 <TASK>
 dump_stack_lvl+0x73/0x9f
 print_report+0x743/0x759
 kasan_report+0xc0/0x120
 __asan_load8+0xd3/0x140
 squashfs_fill_super+0xe7a/0x13b0
 get_tree_bdev+0x27b/0x450
 squashfs_get_tree+0x19/0x30
 vfs_get_tree+0x49/0x150
 path_mount+0xaae/0x1350
 init_mount+0xad/0x100
 do_mount_root+0xbc/0x1d0
 mount_block_root+0x173/0x316
 mount_root+0x223/0x236
 prepare_namespace+0x1eb/0x237
 kernel_init_freeable+0x528/0x576
 kernel_init+0x29/0x250
 ret_from_fork+0x1f/0x30
 </TASK>
==================================================================

To solve this issue, msblk->thread_ops is initialized immediately after
msblk is assigned a value.

Link: https://lkml.kernel.org/r/20221101073343.3961562-1-libaokun1@huawei.com
Fixes: b0645770d3c7 ("squashfs: add the mount parameter theads=<single|multi|percpu>")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Xiaoming Ni <nixiaoming@huawei.com>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/squashfs/super.c~squashfs-fix-null-ptr-deref-in-squashfs_fill_super
+++ a/fs/squashfs/super.c
@@ -197,6 +197,7 @@ static int squashfs_fill_super(struct su
 		return -ENOMEM;
 	}
 	msblk = sb->s_fs_info;
+	msblk->thread_ops = opts->thread_ops;
 
 	msblk->panic_on_errors = (opts->errors == Opt_errors_panic);
 
@@ -231,7 +232,7 @@ static int squashfs_fill_super(struct su
 			       sb->s_bdev);
 		goto failed_mount;
 	}
-	msblk->thread_ops = opts->thread_ops;
+
 	if (opts->thread_num == 0) {
 		msblk->max_thread_num = msblk->thread_ops->max_decompressors();
 	} else {
_

Patches currently in -mm which might be from libaokun1@huawei.com are


