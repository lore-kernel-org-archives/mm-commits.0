Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC07C76196
	for <mm-commits@archiver.kernel.org>; Mon,  3 Apr 2023 20:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbjDCU51 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Apr 2023 16:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbjDCU5W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2023 16:57:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E602691
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 13:57:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F36562B2C
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 20:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81DFC433D2;
        Mon,  3 Apr 2023 20:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680555440;
        bh=l+IsZEXgx7YeYZE+Mhiu5+hHsOrinoAjS0k8zOoM+Uo=;
        h=Date:To:From:Subject:From;
        b=c7oQ1ny19vGhkWxNtMe9/kPSLe1ML5kqT2jXG2psm1YMT5D/efeaF992BcgU7EyQz
         qzA7X8acs0tnw80lLSz/q2HM4JlFYuJlxaP3App1Te8oECJoqzqRaPWOdmK/nYcm49
         7uUGJt29Hr9MWLBcQA5fcIM9sleMRHG5UNhEJhuY=
Date:   Mon, 03 Apr 2023 13:57:19 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, nathan@kernel.org, hch@lst.de,
        ddstreet@ieee.org, liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-delay-the-initialization-of-zswap.patch added to mm-unstable branch
Message-Id: <20230403205719.E81DFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: delay the initialization of zswap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-delay-the-initialization-of-zswap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-delay-the-initialization-of-zswap.patch

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
Subject: mm/zswap: delay the initialization of zswap
Date: Mon, 3 Apr 2023 20:13:18 +0800

Since some users may not use zswap, the zswap_pool is wasted.  Save memory
by delaying the initialization of zswap until enabled.

Link: https://lkml.kernel.org/r/20230403121318.1876082-4-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   56 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 43 insertions(+), 13 deletions(-)

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
 
@@ -763,21 +768,28 @@ static int __zswap_param_set(const char
 	char *s = strstrip((char *)val);
 	int ret;
 
+	mutex_lock(&zswap_init_lock);
 	switch (zswap_init_state) {
 	case ZSWAP_UNINIT:
 		/* if this is load-time (pre-init) param setting,
 		 * don't create a pool; that's done during init.
 		 */
-		return param_set_charp(s, kp);
+		ret = param_set_charp(s, kp);
+		mutex_unlock(&zswap_init_lock);
+		return ret;
 	case ZSWAP_INIT_SUCCEED:
 		/* no change required */
-		if (!strcmp(s, *(char **)kp->arg) && zswap_has_pool)
+		if (!strcmp(s, *(char **)kp->arg) && zswap_has_pool) {
+			mutex_unlock(&zswap_init_lock);
 			return 0;
+		}
 		break;
 	case ZSWAP_INIT_FAILED:
 		pr_err("can't set param, initialization failed\n");
+		mutex_unlock(&zswap_init_lock);
 		return -ENODEV;
 	}
+	mutex_unlock(&zswap_init_lock);
 
 	if (!type) {
 		if (!zpool_has_pool(s)) {
@@ -867,19 +879,30 @@ static int zswap_zpool_param_set(const c
 static int zswap_enabled_param_set(const char *val,
 				   const struct kernel_param *kp)
 {
+	int ret = -ENODEV;
+
+	/*if this is load-time (pre-init) param setting, only set param.*/
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
@@ -1437,7 +1460,7 @@ static const struct frontswap_ops zswap_
 
 static struct dentry *zswap_debugfs_root;
 
-static int __init zswap_debugfs_init(void)
+static int zswap_debugfs_init(void)
 {
 	if (!debugfs_initialized())
 		return -ENODEV;
@@ -1468,7 +1491,7 @@ static int __init zswap_debugfs_init(voi
 	return 0;
 }
 #else
-static int __init zswap_debugfs_init(void)
+static int zswap_debugfs_init(void)
 {
 	return 0;
 }
@@ -1477,7 +1500,7 @@ static int __init zswap_debugfs_init(voi
 /*********************************
 * module init and exit
 **********************************/
-static int __init init_zswap(void)
+static int zswap_setup(void)
 {
 	struct zswap_pool *pool;
 	int ret;
@@ -1540,8 +1563,15 @@ cache_fail:
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

mm-zswap-remove-zswap_entry_cache_createdestroy-helper-function.patch
mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch
mm-zswap-delay-the-initialization-of-zswap.patch

