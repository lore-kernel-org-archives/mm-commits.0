Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C57C4332F
	for <mm-commits@archiver.kernel.org>; Sat, 10 Dec 2022 00:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiLJAKR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Dec 2022 19:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLJAKR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2022 19:10:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5923C12D01
        for <mm-commits@vger.kernel.org>; Fri,  9 Dec 2022 16:10:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD88960C12
        for <mm-commits@vger.kernel.org>; Sat, 10 Dec 2022 00:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1121BC433D2;
        Sat, 10 Dec 2022 00:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670631015;
        bh=hVDPpVtK19wCzHNn8UgTUbXW7SehasQn5YwyvLl3Mfs=;
        h=Date:To:From:Subject:From;
        b=TJugf4bNly3wIQn+P+ughuMe57JHMUr0EAzl701sTFQnY4Wv+/QMIEIsVCIL+dzeE
         JeGlAtgEpQZPyJ1VczWo5pqw6rKrRwHefVtsBO3x7HS9yhPTnsJnXP1/KwHQKHlZL7
         HUzOVM4YKVQmVHlfQvNtoJOEJ0uf1I70gCdbM8BI=
Date:   Fri, 09 Dec 2022 16:10:14 -0800
To:     mm-commits@vger.kernel.org, yuzhe@nfschina.com,
        yuehaibing@huawei.com, weiyongjun1@huawei.com,
        songmuchun@bytedance.com, roman.gushchin@linux.dev,
        manfred@colorfullife.com, longman@redhat.com, legion@kernel.org,
        jingyuwang_vip@163.com, ebiederm@xmission.com, dave@stgolabs.net,
        shaozhengchao@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-fix-memory-leak-in-init_mqueue_fs.patch added to mm-nonmm-unstable branch
Message-Id: <20221210001015.1121BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: fix memory leak in init_mqueue_fs()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-fix-memory-leak-in-init_mqueue_fs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-fix-memory-leak-in-init_mqueue_fs.patch

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

ipc-fix-memory-leak-in-init_mqueue_fs.patch

