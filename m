Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ADCEC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 20:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344856AbiC1U0t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 16:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344600AbiC1U0s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 16:26:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E803666628
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 13:24:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85BACB81212
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 20:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA6FC34114;
        Mon, 28 Mar 2022 20:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648499095;
        bh=3RAFFGZR12SCGSGC6w0WfXd5iGzY3m6CGfvM6QrlIUg=;
        h=Date:To:From:Subject:From;
        b=OpnRciIzafP2J2To4hUhFsDftInHCLZNzV5nla4823sjpp6MiLyiHgiEEhZSA7XWh
         9B42v6G24fyf1LQY2LvjIGytI09OJCkYYK0TduZZIZDOljf21/xoNt3WCRHr1dbJyl
         kLf9Zi4KbYOLpp4cOxg8P4M020BCR2C01tkcH3OU=
Date:   Mon, 28 Mar 2022 13:24:54 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        hughd@google.com, linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-make-shmem_init-return-void.patch added to -mm tree
Message-Id: <20220328202455.1DA6FC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shmem: make shmem_init return void
has been added to the -mm tree.  Its filename is
     mm-shmem-make-shmem_init-return-void.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-make-shmem_init-return-void.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-make-shmem_init-return-void.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: shmem: make shmem_init return void

The return value of shmem_init is never used.  So we can make it return
void now.

Link: https://lkml.kernel.org/r/20220328112707.22217-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    2 +-
 mm/shmem.c               |    9 ++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

--- a/include/linux/shmem_fs.h~mm-shmem-make-shmem_init-return-void
+++ a/include/linux/shmem_fs.h
@@ -56,7 +56,7 @@ static inline struct shmem_inode_info *S
  * Functions in mm/shmem.c called directly from elsewhere:
  */
 extern const struct fs_parameter_spec shmem_fs_parameters[];
-extern int shmem_init(void);
+extern void shmem_init(void);
 extern int shmem_init_fs_context(struct fs_context *fc);
 extern struct file *shmem_file_setup(const char *name,
 					loff_t size, unsigned long flags);
--- a/mm/shmem.c~mm-shmem-make-shmem_init-return-void
+++ a/mm/shmem.c
@@ -3879,7 +3879,7 @@ static struct file_system_type shmem_fs_
 	.fs_flags	= FS_USERNS_MOUNT,
 };
 
-int __init shmem_init(void)
+void __init shmem_init(void)
 {
 	int error;
 
@@ -3904,14 +3904,13 @@ int __init shmem_init(void)
 	else
 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
 #endif
-	return 0;
+	return;
 
 out1:
 	unregister_filesystem(&shmem_fs_type);
 out2:
 	shmem_destroy_inodecache();
 	shm_mnt = ERR_PTR(error);
-	return error;
 }
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SYSFS)
@@ -3989,14 +3988,14 @@ static struct file_system_type shmem_fs_
 	.fs_flags	= FS_USERNS_MOUNT,
 };
 
-int __init shmem_init(void)
+void __init shmem_init(void)
 {
 	BUG_ON(register_filesystem(&shmem_fs_type) != 0);
 
 	shm_mnt = kern_mount(&shmem_fs_type);
 	BUG_ON(IS_ERR(shm_mnt));
 
-	return 0;
+	return;
 }
 
 int shmem_unuse(unsigned int type)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-shmem-make-shmem_init-return-void.patch
mm-memcg-remove-unneeded-nr_scanned.patch
mm-mremap-use-helper-mlock_future_check.patch
mm-mlock-fix-two-bugs-in-user_shm_lock.patch
mm-compaction-use-helper-isolation_suitable.patch

