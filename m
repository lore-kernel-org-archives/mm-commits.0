Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51503C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 03:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbiLLDby (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 22:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbiLLDb3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 22:31:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600A5DEAB
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 19:31:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA20D60ED6
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 03:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9B1C433F1;
        Mon, 12 Dec 2022 03:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670815883;
        bh=jsURbdXhIROWPR8a41r2Cr02doFyPWHwurUM2vAAiOA=;
        h=Date:To:From:Subject:From;
        b=1BaGb08XqZeLhwEGboqbl5Y9Taxy04y6XzILJSkMM2kRZO4QalmJDCd0Al0Blgn7W
         h+L2YFbyznflZ5L1emxPP5bipBJ8fGHiQAn+f/hwRe5KgNhKZkM6vTxLz5Tmy2nzmh
         5/LRGqRNJTGFGZfujwDQAtOlecCgRnR0/tRfysgM=
Date:   Sun, 11 Dec 2022 19:31:22 -0800
To:     mm-commits@vger.kernel.org, yuzhe@nfschina.com,
        yuehaibing@huawei.com, weiyongjun1@huawei.com,
        songmuchun@bytedance.com, roman.gushchin@linux.dev,
        manfred@colorfullife.com, longman@redhat.com, legion@kernel.org,
        jingyuwang_vip@163.com, ebiederm@xmission.com, dave@stgolabs.net,
        shaozhengchao@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ipc-fix-memory-leak-in-init_mqueue_fs.patch removed from -mm tree
Message-Id: <20221212033123.2B9B1C433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ipc: fix memory leak in init_mqueue_fs()
has been removed from the -mm tree.  Its filename was
     ipc-fix-memory-leak-in-init_mqueue_fs.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhengchao Shao <shaozhengchao@huawei.com>
Subject: ipc: fix memory leak in init_mqueue_fs()
Date: Fri, 9 Dec 2022 17:29:29 +0800

When setup_mq_sysctls() failed in init_mqueue_fs(), mqueue_inode_cachep is
not released.  In order to fix this issue, the release path is reordered.

Link: https://lkml.kernel.org/r/20221209092929.1978875-1-shaozhengchao@huawei.com
Fixes: dc55e35f9e81 ("ipc: Store mqueue sysctls in the ipc namespace")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jingyu Wang <jingyuwang_vip@163.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: YueHaibing <yuehaibing@huawei.com>
Cc: Yu Zhe <yuzhe@nfschina.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/ipc/mqueue.c~ipc-fix-memory-leak-in-init_mqueue_fs
+++ a/ipc/mqueue.c
@@ -1726,7 +1726,8 @@ static int __init init_mqueue_fs(void)
 
 	if (!setup_mq_sysctls(&init_ipc_ns)) {
 		pr_warn("sysctl registration failed\n");
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto out_kmem;
 	}
 
 	error = register_filesystem(&mqueue_fs_type);
@@ -1744,8 +1745,9 @@ static int __init init_mqueue_fs(void)
 out_filesystem:
 	unregister_filesystem(&mqueue_fs_type);
 out_sysctl:
-	kmem_cache_destroy(mqueue_inode_cachep);
 	retire_mq_sysctls(&init_ipc_ns);
+out_kmem:
+	kmem_cache_destroy(mqueue_inode_cachep);
 	return error;
 }
 
_

Patches currently in -mm which might be from shaozhengchao@huawei.com are


