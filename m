Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E34C4332F
	for <mm-commits@archiver.kernel.org>; Tue,  1 Nov 2022 20:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiKAUK7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Nov 2022 16:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKAUK6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2022 16:10:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707FE1BEAC
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 13:10:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FBDF61708
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 20:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65CF7C433D6;
        Tue,  1 Nov 2022 20:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667333456;
        bh=BS3gQjbUd5TcA2X7AQONZbnNLkTLVEV0Hw2HOOGWBeY=;
        h=Date:To:From:Subject:From;
        b=kgcjwq97YOlpSDyBIAusnuZ/V1eDLU8zCvqiL1h0BZVV8sPoalT3ijr6DsiHZ+8Nt
         hjZr6FDozjnATxENKLIQyeEh4yNtogv/ndcsEopSHcHoc7pWHPXDW/ZbGTA9yjdHrK
         FWQ5grBMFyR86dwO6w3akBOEuwLqRBmmbH1JxcEs=
Date:   Tue, 01 Nov 2022 13:10:55 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        shangxiaojing@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-memory-leak-in-ocfs2_stack_glue_init.patch added to mm-nonmm-unstable branch
Message-Id: <20221101201056.65CF7C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix memory leak in ocfs2_stack_glue_init()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-memory-leak-in-ocfs2_stack_glue_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-memory-leak-in-ocfs2_stack_glue_init.patch

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
From: Shang XiaoJing <shangxiaojing@huawei.com>
Subject: ocfs2: fix memory leak in ocfs2_stack_glue_init()
Date: Tue, 1 Nov 2022 19:15:33 +0800

ocfs2_table_header should be free in ocfs2_stack_glue_init() if
ocfs2_sysfs_init() failed, otherwise kmemleak will report memleak.

BUG: memory leak
unreferenced object 0xffff88810eeb5800 (size 128):
  comm "modprobe", pid 4507, jiffies 4296182506 (age 55.888s)
  hex dump (first 32 bytes):
    c0 40 14 a0 ff ff ff ff 00 00 00 00 01 00 00 00  .@..............
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000001e59e1cd>] __register_sysctl_table+0xca/0xef0
    [<00000000c04f70f7>] 0xffffffffa0050037
    [<000000001bd12912>] do_one_initcall+0xdb/0x480
    [<0000000064f766c9>] do_init_module+0x1cf/0x680
    [<000000002ba52db0>] load_module+0x6441/0x6f20
    [<000000009772580d>] __do_sys_finit_module+0x12f/0x1c0
    [<00000000380c1f22>] do_syscall_64+0x3f/0x90
    [<000000004cf473bc>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Link: https://lkml.kernel.org/r/41651ca1-432a-db34-eb97-d35744559de1@linux.alibaba.com
Fixes: 3878f110f71a ("ocfs2: Move the hb_ctl_path sysctl into the stack glue.")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stackglue.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/stackglue.c~ocfs2-fix-memory-leak-in-ocfs2_stack_glue_init
+++ a/fs/ocfs2/stackglue.c
@@ -669,6 +669,8 @@ static struct ctl_table_header *ocfs2_ta
 
 static int __init ocfs2_stack_glue_init(void)
 {
+	int ret;
+
 	strcpy(cluster_stack_name, OCFS2_STACK_PLUGIN_O2CB);
 
 	ocfs2_table_header = register_sysctl("fs/ocfs2/nm", ocfs2_nm_table);
@@ -678,7 +680,11 @@ static int __init ocfs2_stack_glue_init(
 		return -ENOMEM; /* or something. */
 	}
 
-	return ocfs2_sysfs_init();
+	ret = ocfs2_sysfs_init();
+	if (ret)
+		unregister_sysctl_table(ocfs2_table_header);
+
+	return ret;
 }
 
 static void __exit ocfs2_stack_glue_exit(void)
_

Patches currently in -mm which might be from shangxiaojing@huawei.com are

ocfs2-fix-memory-leak-in-ocfs2_stack_glue_init.patch

