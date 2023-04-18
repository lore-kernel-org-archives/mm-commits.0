Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38001C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjDRXe1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbjDRXeD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5347EC2
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:33:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C84462ED3
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB2EC433D2;
        Tue, 18 Apr 2023 23:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860839;
        bh=5+UwsXvRw4oU+VCEBmNadtGUStPc/ZmDBHWN3v8+Qfk=;
        h=Date:To:From:Subject:From;
        b=zmoj1TNqWIM0a2F95ygelVFSNH6piiWUCEomwhlvA7xHIRJHVrh6myKShtpXGXhX9
         wqFWS48rWyWDvWtIs3aA9ITPG7opLKKK0PoCHUwHIKZMpA4jaH2cS/xQ56fHNbWiqS
         gCwKPczTPT8FB5BEHkZvjY+NwirgAcxoApqSoVUM=
Date:   Tue, 18 Apr 2023 16:33:58 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, nathan@kernel.org, hch@lst.de,
        ddstreet@ieee.org, liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-delay-the-initialization-of-zswap.patch removed from -mm tree
Message-Id: <20230418233358.DFB2EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/zswap: delay the initialization of zswap
has been removed from the -mm tree.  Its filename was
     mm-zswap-delay-the-initialization-of-zswap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/zswap: delay the initialization of zswap
Date: Mon, 3 Apr 2023 20:13:18 +0800

Since some users may not use zswap, the zswap_pool is wasted.  Save memory
by delaying the initialization of zswap until enabled.

[liushixin2@huawei.com: fix some pattern problem suggested by Christoph]
  Link: https://lkml.kernel.org/r/20230411093632.822290-4-liushixin2@huawei.com
Link: https://lkml.kernel.org/r/20230403121318.1876082-4-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   71 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 54 insertions(+), 17 deletions(-)

--- a/mm/zswap.c~mm-zswap-delay-the-initialization-of-zswap
+++ a/mm/zswap.c
@@ -81,6 +81,8 @@ static bool zswap_pool_reached_full;
 
 #define ZSWAP_PARAM_UNSET ""
 
+static int zswap_setup(void);
+
 /* Enable/disable zswap */
 static bool zswap_enabled = IS_ENABLED(CONFIG_ZSWAP_DEFAULT_ON);
 static int zswap_enabled_param_set(const char *,
@@ -222,6 +224,9 @@ enum zswap_init_type {
 
 static enum zswap_init_type zswap_init_state;
 
+/* used to ensure the integrity of initialization */
+static DEFINE_MUTEX(zswap_init_lock);
+
 /* init completed, but couldn't create the initial pool */
 static bool zswap_has_pool;
 
@@ -654,7 +659,7 @@ error:
 	return NULL;
 }
 
-static __init struct zswap_pool *__zswap_pool_create_fallback(void)
+static struct zswap_pool *__zswap_pool_create_fallback(void)
 {
 	bool has_comp, has_zpool;
 
@@ -755,29 +760,43 @@ static void zswap_pool_put(struct zswap_
 * param callbacks
 **********************************/
 
+static bool zswap_pool_changed(const char *s, const struct kernel_param *kp)
+{
+	/* no change required */
+	if (!strcmp(s, *(char **)kp->arg) && zswap_has_pool)
+		return false;
+	return true;
+}
+
 /* val must be a null-terminated string */
 static int __zswap_param_set(const char *val, const struct kernel_param *kp,
 			     char *type, char *compressor)
 {
 	struct zswap_pool *pool, *put_pool = NULL;
 	char *s = strstrip((char *)val);
-	int ret;
+	int ret = 0;
+	bool new_pool = false;
 
+	mutex_lock(&zswap_init_lock);
 	switch (zswap_init_state) {
 	case ZSWAP_UNINIT:
 		/* if this is load-time (pre-init) param setting,
 		 * don't create a pool; that's done during init.
 		 */
-		return param_set_charp(s, kp);
+		ret = param_set_charp(s, kp);
+		break;
 	case ZSWAP_INIT_SUCCEED:
-		/* no change required */
-		if (!strcmp(s, *(char **)kp->arg) && zswap_has_pool)
-			return 0;
+		new_pool = zswap_pool_changed(s, kp);
 		break;
 	case ZSWAP_INIT_FAILED:
 		pr_err("can't set param, initialization failed\n");
-		return -ENODEV;
+		ret = -ENODEV;
 	}
+	mutex_unlock(&zswap_init_lock);
+
+	/* no need to create a new pool, return directly */
+	if (!new_pool)
+		return ret;
 
 	if (!type) {
 		if (!zpool_has_pool(s)) {
@@ -867,19 +886,30 @@ static int zswap_zpool_param_set(const c
 static int zswap_enabled_param_set(const char *val,
 				   const struct kernel_param *kp)
 {
+	int ret = -ENODEV;
+
+	/* if this is load-time (pre-init) param setting, only set param. */
+	if (system_state != SYSTEM_RUNNING)
+		return param_set_bool(val, kp);
+
+	mutex_lock(&zswap_init_lock);
 	switch (zswap_init_state) {
 	case ZSWAP_UNINIT:
-		return param_set_bool(val, kp);
+		if (zswap_setup())
+			break;
+		fallthrough;
 	case ZSWAP_INIT_SUCCEED:
-		if (!zswap_has_pool) {
+		if (!zswap_has_pool)
 			pr_err("can't enable, no pool configured\n");
-			return -ENODEV;
-		} else
-			return param_set_bool(val, kp);
+		else
+			ret = param_set_bool(val, kp);
+		break;
 	case ZSWAP_INIT_FAILED:
 		pr_err("can't enable, initialization failed\n");
-		return -ENODEV;
 	}
+	mutex_unlock(&zswap_init_lock);
+
+	return ret;
 }
 
 /*********************************
@@ -1437,7 +1467,7 @@ static const struct frontswap_ops zswap_
 
 static struct dentry *zswap_debugfs_root;
 
-static int __init zswap_debugfs_init(void)
+static int zswap_debugfs_init(void)
 {
 	if (!debugfs_initialized())
 		return -ENODEV;
@@ -1468,7 +1498,7 @@ static int __init zswap_debugfs_init(voi
 	return 0;
 }
 #else
-static int __init zswap_debugfs_init(void)
+static int zswap_debugfs_init(void)
 {
 	return 0;
 }
@@ -1477,7 +1507,7 @@ static int __init zswap_debugfs_init(voi
 /*********************************
 * module init and exit
 **********************************/
-static int __init init_zswap(void)
+static int zswap_setup(void)
 {
 	struct zswap_pool *pool;
 	int ret;
@@ -1540,8 +1570,15 @@ cache_fail:
 	zswap_enabled = false;
 	return -ENOMEM;
 }
+
+static int __init zswap_init(void)
+{
+	if (!zswap_enabled)
+		return 0;
+	return zswap_setup();
+}
 /* must be late so crypto has time to come up */
-late_initcall(init_zswap);
+late_initcall(zswap_init);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Seth Jennings <sjennings@variantweb.net>");
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-hwpoison-support-recovery-from-hugepage-copy-on-write-faults.patch

