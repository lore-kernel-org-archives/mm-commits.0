Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70250C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbjDRXR5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbjDRXR4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:17:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0B9526E
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:17:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DC5A62C43
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888B5C433D2;
        Tue, 18 Apr 2023 23:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681859874;
        bh=nIHYw9AIOb8IyOY/+Ld14xcx7EuU/Y8ozejMPmYf1yA=;
        h=Date:To:From:Subject:From;
        b=WinZyIsvbWR8p+oULrSLmHFhAAsxmmQeZjlZ79imp31mq+O63HB/1KyXpJqLmgU1j
         04IMX2LA8s2VzTF+QT5SaWJRqdKg/R9HW9/wthUmPt0bB0idhKUEMlHQZzsrjmYwlO
         ghVDNdTbiElmx3QIXzNawh9uT+dx9rqLpdfcqKFk=
Date:   Tue, 18 Apr 2023 16:17:53 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, nathan@kernel.org, hch@lst.de,
        ddstreet@ieee.org, liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zswap-delay-the-initialization-of-zswap-v9.patch removed from -mm tree
Message-Id: <20230418231754.888B5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-zswap-delay-the-initialization-of-zswap-v9
has been removed from the -mm tree.  Its filename was
     mm-zswap-delay-the-initialization-of-zswap-v9.patch

This patch was dropped because it was folded into mm-zswap-delay-the-initialization-of-zswap.patch

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm-zswap-delay-the-initialization-of-zswap-v9
Date: Tue, 11 Apr 2023 17:36:32 +0800

fix some pattern problem suggested by Christoph

Link: https://lkml.kernel.org/r/20230411093632.822290-4-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/mm/zswap.c~mm-zswap-delay-the-initialization-of-zswap-v9
+++ a/mm/zswap.c
@@ -760,13 +760,22 @@ static void zswap_pool_put(struct zswap_
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
 
 	mutex_lock(&zswap_init_lock);
 	switch (zswap_init_state) {
@@ -775,22 +784,20 @@ static int __zswap_param_set(const char
 		 * don't create a pool; that's done during init.
 		 */
 		ret = param_set_charp(s, kp);
-		mutex_unlock(&zswap_init_lock);
-		return ret;
+		break;
 	case ZSWAP_INIT_SUCCEED:
-		/* no change required */
-		if (!strcmp(s, *(char **)kp->arg) && zswap_has_pool) {
-			mutex_unlock(&zswap_init_lock);
-			return 0;
-		}
+		new_pool = zswap_pool_changed(s, kp);
 		break;
 	case ZSWAP_INIT_FAILED:
 		pr_err("can't set param, initialization failed\n");
-		mutex_unlock(&zswap_init_lock);
-		return -ENODEV;
+		ret = -ENODEV;
 	}
 	mutex_unlock(&zswap_init_lock);
 
+	/* no need to create a new pool, return directly */
+	if (!new_pool)
+		return ret;
+
 	if (!type) {
 		if (!zpool_has_pool(s)) {
 			pr_err("zpool %s not available\n", s);
@@ -881,7 +888,7 @@ static int zswap_enabled_param_set(const
 {
 	int ret = -ENODEV;
 
-	/*if this is load-time (pre-init) param setting, only set param.*/
+	/* if this is load-time (pre-init) param setting, only set param. */
 	if (system_state != SYSTEM_RUNNING)
 		return param_set_bool(val, kp);
 
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-zswap-remove-zswap_entry_cache_createdestroy-helper-function.patch
mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch
mm-zswap-delay-the-initialization-of-zswap.patch
mm-hwpoison-support-recovery-from-hugepage-copy-on-write-faults.patch

