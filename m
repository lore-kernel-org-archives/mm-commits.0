Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56CF3C76188
	for <mm-commits@archiver.kernel.org>; Mon,  3 Apr 2023 20:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbjDCU5V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Apr 2023 16:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbjDCU5U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2023 16:57:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D2C2691
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 13:57:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C86AA62B24
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 20:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E995C433EF;
        Mon,  3 Apr 2023 20:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680555438;
        bh=xe/3WP3yMfHRA+J04vZJmv5Qx9/mGQtAB1Kr9AtI7jQ=;
        h=Date:To:From:Subject:From;
        b=2eAKq3WI+4GemSye0maZLSaOEKoR35s3zxJJWhwFbqXy5zszcRY8kDNHzT0ptbSam
         ZmyO+bx8AfA/x+WdvyWHH/OHnabA4Vvk3qqRyY1WU/3M3rbffRCUsv+uemkELCgjp5
         xN26d95Mxz569QIIlfJt5exeaxZD4FdzDNS5GcZU=
Date:   Mon, 03 Apr 2023 13:57:17 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, nathan@kernel.org, hch@lst.de,
        ddstreet@ieee.org, liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch added to mm-unstable branch
Message-Id: <20230403205718.2E995C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: replace zswap_init_{started/failed} with zswap_init_state
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch

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
Subject: mm/zswap: replace zswap_init_{started/failed} with zswap_init_state
Date: Mon, 3 Apr 2023 20:13:17 +0800

The zswap_init_started variable name has a bit confusing.  Actually, there
are three state: uninitialized, initial failed and initial succeed.  Add a
new variable zswap_init_state to replace zswap_init_{started/failed}.

Link: https://lkml.kernel.org/r/20230403121318.1876082-3-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   55 +++++++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

--- a/mm/zswap.c~mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state
+++ a/mm/zswap.c
@@ -214,11 +214,13 @@ static DEFINE_SPINLOCK(zswap_pools_lock)
 /* pool counter to provide unique names to zpool */
 static atomic_t zswap_pools_count = ATOMIC_INIT(0);
 
-/* used by param callback function */
-static bool zswap_init_started;
+enum zswap_init_type {
+	ZSWAP_UNINIT,
+	ZSWAP_INIT_SUCCEED,
+	ZSWAP_INIT_FAILED
+};
 
-/* fatal error during init */
-static bool zswap_init_failed;
+static enum zswap_init_type zswap_init_state;
 
 /* init completed, but couldn't create the initial pool */
 static bool zswap_has_pool;
@@ -761,21 +763,22 @@ static int __zswap_param_set(const char
 	char *s = strstrip((char *)val);
 	int ret;
 
-	if (zswap_init_failed) {
+	switch (zswap_init_state) {
+	case ZSWAP_UNINIT:
+		/* if this is load-time (pre-init) param setting,
+		 * don't create a pool; that's done during init.
+		 */
+		return param_set_charp(s, kp);
+	case ZSWAP_INIT_SUCCEED:
+		/* no change required */
+		if (!strcmp(s, *(char **)kp->arg) && zswap_has_pool)
+			return 0;
+		break;
+	case ZSWAP_INIT_FAILED:
 		pr_err("can't set param, initialization failed\n");
 		return -ENODEV;
 	}
 
-	/* no change required */
-	if (!strcmp(s, *(char **)kp->arg) && zswap_has_pool)
-		return 0;
-
-	/* if this is load-time (pre-init) param setting,
-	 * don't create a pool; that's done during init.
-	 */
-	if (!zswap_init_started)
-		return param_set_charp(s, kp);
-
 	if (!type) {
 		if (!zpool_has_pool(s)) {
 			pr_err("zpool %s not available\n", s);
@@ -864,16 +867,19 @@ static int zswap_zpool_param_set(const c
 static int zswap_enabled_param_set(const char *val,
 				   const struct kernel_param *kp)
 {
-	if (zswap_init_failed) {
+	switch (zswap_init_state) {
+	case ZSWAP_UNINIT:
+		return param_set_bool(val, kp);
+	case ZSWAP_INIT_SUCCEED:
+		if (!zswap_has_pool) {
+			pr_err("can't enable, no pool configured\n");
+			return -ENODEV;
+		} else
+			return param_set_bool(val, kp);
+	case ZSWAP_INIT_FAILED:
 		pr_err("can't enable, initialization failed\n");
 		return -ENODEV;
 	}
-	if (!zswap_has_pool && zswap_init_started) {
-		pr_err("can't enable, no pool configured\n");
-		return -ENODEV;
-	}
-
-	return param_set_bool(val, kp);
 }
 
 /*********************************
@@ -1476,8 +1482,6 @@ static int __init init_zswap(void)
 	struct zswap_pool *pool;
 	int ret;
 
-	zswap_init_started = true;
-
 	zswap_entry_cache = KMEM_CACHE(zswap_entry, 0);
 	if (!zswap_entry_cache) {
 		pr_err("entry cache creation failed\n");
@@ -1518,6 +1522,7 @@ static int __init init_zswap(void)
 		goto destroy_wq;
 	if (zswap_debugfs_init())
 		pr_warn("debugfs initialization failed\n");
+	zswap_init_state = ZSWAP_INIT_SUCCEED;
 	return 0;
 
 destroy_wq:
@@ -1531,7 +1536,7 @@ dstmem_fail:
 	kmem_cache_destroy(zswap_entry_cache);
 cache_fail:
 	/* if built-in, we aren't unloaded on failure; don't allow use */
-	zswap_init_failed = true;
+	zswap_init_state = ZSWAP_INIT_FAILED;
 	zswap_enabled = false;
 	return -ENOMEM;
 }
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-zswap-remove-zswap_entry_cache_createdestroy-helper-function.patch
mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch
mm-zswap-delay-the-initialization-of-zswap.patch

