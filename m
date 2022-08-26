Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 027B1ECAAA3
	for <mm-commits@archiver.kernel.org>; Fri, 26 Aug 2022 02:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244260AbiHZCCD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Aug 2022 22:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244551AbiHZCCA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2022 22:02:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B358BCAC77
        for <mm-commits@vger.kernel.org>; Thu, 25 Aug 2022 19:01:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 597E961E08
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 02:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5EBC433D7;
        Fri, 26 Aug 2022 02:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661479317;
        bh=UlAS9sT8GikMZ0sYopHOkK3w/o13HbnGUCnTz/tI9VU=;
        h=Date:To:From:Subject:From;
        b=S8pws+tXS9Ko+w/8IgRIQt2I5cUrdylUYKaP/t0zIblBVfal9jYRgAgCVhPiLTRDO
         a26r6uoteWNlGaPclXOURF+sCfvjsdE4YAc7lBJG3CLBhFKRLonJISK/1zfrLYTCgX
         ZtgKzNeMv3J8vlPVhXLWFDTM9/p3zUrFHdeShbLc=
Date:   Thu, 25 Aug 2022 19:01:56 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, ddstreet@ieee.org, liushixin2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch added to mm-unstable branch
Message-Id: <20220826020157.AA5EBC433D7@smtp.kernel.org>
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
Date: Thu, 25 Aug 2022 22:20:35 +0800

Patch series "Delay the initializaton of zswap".

In the initialization of zswap, about 18MB memory will be allocated for
zswap_pool.  Since not all users use zswap, the memory may be wasted. 
Save the memory for these users by delaying the initialization of zswap to
first enablement.


This patch (of 3):

zswap_init_started indicates that the initialization is started.  And
zswap_init_failed indicates that the initialization is failed.  As we will
support to init zswap after system startup, it's necessary to add a state
to indicate the initialization is complete and succeed to avoid
concurrency issues.  Since we don't care about the difference between init
started with init completion.  We only need three states: uninitialized,
initial failed, initial succeed.

Link: https://lkml.kernel.org/r/20220825142037.3214152-1-liushixin2@huawei.com
Link: https://lkml.kernel.org/r/20220825142037.3214152-2-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/zswap.c~mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state
+++ a/mm/zswap.c
@@ -214,11 +214,12 @@ static DEFINE_SPINLOCK(zswap_pools_lock)
 /* pool counter to provide unique names to zpool */
 static atomic_t zswap_pools_count = ATOMIC_INIT(0);
 
-/* used by param callback function */
-static bool zswap_init_started;
+#define ZSWAP_UNINIT		0
+#define ZSWAP_INIT_SUCCEED	1
+#define ZSWAP_INIT_FAILED	2
 
-/* fatal error during init */
-static bool zswap_init_failed;
+/* init state */
+static int zswap_init_state;
 
 /* init completed, but couldn't create the initial pool */
 static bool zswap_has_pool;
@@ -772,7 +773,7 @@ static int __zswap_param_set(const char
 	char *s = strstrip((char *)val);
 	int ret;
 
-	if (zswap_init_failed) {
+	if (zswap_init_state == ZSWAP_INIT_FAILED) {
 		pr_err("can't set param, initialization failed\n");
 		return -ENODEV;
 	}
@@ -784,7 +785,7 @@ static int __zswap_param_set(const char
 	/* if this is load-time (pre-init) param setting,
 	 * don't create a pool; that's done during init.
 	 */
-	if (!zswap_init_started)
+	if (zswap_init_state == ZSWAP_UNINIT)
 		return param_set_charp(s, kp);
 
 	if (!type) {
@@ -875,11 +876,11 @@ static int zswap_zpool_param_set(const c
 static int zswap_enabled_param_set(const char *val,
 				   const struct kernel_param *kp)
 {
-	if (zswap_init_failed) {
+	if (zswap_init_state == ZSWAP_INIT_FAILED) {
 		pr_err("can't enable, initialization failed\n");
 		return -ENODEV;
 	}
-	if (!zswap_has_pool && zswap_init_started) {
+	if (!zswap_has_pool && zswap_init_state == ZSWAP_INIT_SUCCEED) {
 		pr_err("can't enable, no pool configured\n");
 		return -ENODEV;
 	}
@@ -1476,8 +1477,6 @@ static int __init init_zswap(void)
 	struct zswap_pool *pool;
 	int ret;
 
-	zswap_init_started = true;
-
 	if (zswap_entry_cache_create()) {
 		pr_err("entry cache creation failed\n");
 		goto cache_fail;
@@ -1517,6 +1516,7 @@ static int __init init_zswap(void)
 		goto destroy_wq;
 	if (zswap_debugfs_init())
 		pr_warn("debugfs initialization failed\n");
+	zswap_init_state = ZSWAP_INIT_SUCCEED;
 	return 0;
 
 destroy_wq:
@@ -1530,7 +1530,7 @@ dstmem_fail:
 	zswap_entry_cache_destroy();
 cache_fail:
 	/* if built-in, we aren't unloaded on failure; don't allow use */
-	zswap_init_failed = true;
+	zswap_init_state = ZSWAP_INIT_FAILED;
 	zswap_enabled = false;
 	return -ENOMEM;
 }
_

Patches currently in -mm which might be from liushixin2@huawei.com are

bootmem-remove-the-vmemmap-pages-from-kmemleak-in-put_page_bootmem.patch
mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch
mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement.patch
mm-zswap-skip-confusing-print-info.patch

