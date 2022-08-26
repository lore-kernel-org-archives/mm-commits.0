Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF45CECAAD1
	for <mm-commits@archiver.kernel.org>; Fri, 26 Aug 2022 02:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244501AbiHZCCG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Aug 2022 22:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244634AbiHZCCE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2022 22:02:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900A3CAC69
        for <mm-commits@vger.kernel.org>; Thu, 25 Aug 2022 19:02:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A73FB82F68
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 02:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0904C433D6;
        Fri, 26 Aug 2022 02:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661479319;
        bh=YQGnStRuJwS9r6c1aPWeCu3Ya0wPlmPbeuBke7NPWqk=;
        h=Date:To:From:Subject:From;
        b=XxbThyglnzwoml/1aGyWyajGJBNglzh1rFkJ0Zpn8ke0ZcJsukvkSgkc47hJ+VwxM
         Zp9tQOxPR1el7pCoDDmoQo95IV1/cxNd/c67FOCBD1Vj0X9LHTJwlponBC3pICAUh/
         YZZ1iJVlZ7TRGr5pxpKeYut0z99vjVgNV2DFkM/E=
Date:   Thu, 25 Aug 2022 19:01:58 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, ddstreet@ieee.org, liushixin2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement.patch added to mm-unstable branch
Message-Id: <20220826020159.B0904C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: delay the initializaton of zswap until the first enablement
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement.patch

This patch will later appear in the mm-unstable branch at
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
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/zswap: delay the initializaton of zswap until the first enablement
Date: Thu, 25 Aug 2022 22:20:36 +0800

In the initialization of zswap, about 18MB memory will be allocated for
zswap_pool in my machine.  Since not all users use zswap, the memory may
be wasted.  Save the memory for these users by delaying the initialization
of zswap to first enablement.

Link: https://lkml.kernel.org/r/20220825142037.3214152-3-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   48 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 9 deletions(-)

--- a/mm/zswap.c~mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement
+++ a/mm/zswap.c
@@ -81,6 +81,8 @@ static bool zswap_pool_reached_full;
 
 #define ZSWAP_PARAM_UNSET ""
 
+static int zswap_setup(void);
+
 /* Enable/disable zswap */
 static bool zswap_enabled = IS_ENABLED(CONFIG_ZSWAP_DEFAULT_ON);
 static int zswap_enabled_param_set(const char *,
@@ -220,6 +222,8 @@ static atomic_t zswap_pools_count = ATOM
 
 /* init state */
 static int zswap_init_state;
+/* used to ensure the integrity of initialization */
+static DEFINE_MUTEX(zswap_init_lock);
 
 /* init completed, but couldn't create the initial pool */
 static bool zswap_has_pool;
@@ -273,13 +277,13 @@ static void zswap_update_total_size(void
 **********************************/
 static struct kmem_cache *zswap_entry_cache;
 
-static int __init zswap_entry_cache_create(void)
+static int zswap_entry_cache_create(void)
 {
 	zswap_entry_cache = KMEM_CACHE(zswap_entry, 0);
 	return zswap_entry_cache == NULL;
 }
 
-static void __init zswap_entry_cache_destroy(void)
+static void zswap_entry_cache_destroy(void)
 {
 	kmem_cache_destroy(zswap_entry_cache);
 }
@@ -664,7 +668,7 @@ error:
 	return NULL;
 }
 
-static __init struct zswap_pool *__zswap_pool_create_fallback(void)
+static struct zswap_pool *__zswap_pool_create_fallback(void)
 {
 	bool has_comp, has_zpool;
 
@@ -782,11 +786,17 @@ static int __zswap_param_set(const char
 	if (!strcmp(s, *(char **)kp->arg) && zswap_has_pool)
 		return 0;
 
-	/* if this is load-time (pre-init) param setting,
+	/*
+	 * if zswap has not been initialized,
 	 * don't create a pool; that's done during init.
 	 */
-	if (zswap_init_state == ZSWAP_UNINIT)
-		return param_set_charp(s, kp);
+	mutex_lock(&zswap_init_lock);
+	if (zswap_init_state == ZSWAP_UNINIT) {
+		ret = param_set_charp(s, kp);
+		mutex_unlock(&zswap_init_lock);
+		return ret;
+	}
+	mutex_unlock(&zswap_init_lock);
 
 	if (!type) {
 		if (!zpool_has_pool(s)) {
@@ -876,6 +886,14 @@ static int zswap_zpool_param_set(const c
 static int zswap_enabled_param_set(const char *val,
 				   const struct kernel_param *kp)
 {
+	if (system_state == SYSTEM_RUNNING) {
+		mutex_lock(&zswap_init_lock);
+		if (zswap_setup()) {
+			mutex_unlock(&zswap_init_lock);
+			return -ENODEV;
+		}
+		mutex_unlock(&zswap_init_lock);
+	}
 	if (zswap_init_state == ZSWAP_INIT_FAILED) {
 		pr_err("can't enable, initialization failed\n");
 		return -ENODEV;
@@ -1432,7 +1450,7 @@ static const struct frontswap_ops zswap_
 
 static struct dentry *zswap_debugfs_root;
 
-static int __init zswap_debugfs_init(void)
+static int zswap_debugfs_init(void)
 {
 	if (!debugfs_initialized())
 		return -ENODEV;
@@ -1463,7 +1481,7 @@ static int __init zswap_debugfs_init(voi
 	return 0;
 }
 #else
-static int __init zswap_debugfs_init(void)
+static int zswap_debugfs_init(void)
 {
 	return 0;
 }
@@ -1472,11 +1490,14 @@ static int __init zswap_debugfs_init(voi
 /*********************************
 * module init and exit
 **********************************/
-static int __init init_zswap(void)
+static int zswap_setup(void)
 {
 	struct zswap_pool *pool;
 	int ret;
 
+	if (zswap_init_state != ZSWAP_UNINIT)
+		return 0;
+
 	if (zswap_entry_cache_create()) {
 		pr_err("entry cache creation failed\n");
 		goto cache_fail;
@@ -1534,6 +1555,15 @@ cache_fail:
 	zswap_enabled = false;
 	return -ENOMEM;
 }
+
+static int __init init_zswap(void)
+{
+	/* skip init if zswap is disabled when system startup */
+	if (!zswap_enabled)
+		return 0;
+	return zswap_setup();
+}
+
 /* must be late so crypto has time to come up */
 late_initcall(init_zswap);
 
_

Patches currently in -mm which might be from liushixin2@huawei.com are

bootmem-remove-the-vmemmap-pages-from-kmemleak-in-put_page_bootmem.patch
mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch
mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement.patch
mm-zswap-skip-confusing-print-info.patch

