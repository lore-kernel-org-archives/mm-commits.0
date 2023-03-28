Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F888C76196
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjC1XVK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjC1XVI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BD9269E
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2917CB81F55
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E44C433EF;
        Tue, 28 Mar 2023 23:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045661;
        bh=oiDyidRxIrKL2PwHBjPJ2XvWq3bQZjrcktpEn8V6u8Y=;
        h=Date:To:From:Subject:From;
        b=U7KQTVxwU1ZMsiQntiUp6QZf5VJ2seFzd6/sMUs7ilNr0zt1LMnoUHlgxdLUR4psm
         2+InFiLE7sK1NWlJ6gflpXCVxUrI5mUzvZFVlD573ymlpvGQp+D/mrrEnCXDmvVg79
         BsktFtvAWGLqvi1LQ0mUSHhvXh/gpmb2r6tWTNB0=
Date:   Tue, 28 Mar 2023 16:21:01 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, talumbau@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-multi-gen-lru-clean-up-sysfs-code.patch removed from -mm tree
Message-Id: <20230328232101.B7E44C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: multi-gen LRU: clean up sysfs code
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-clean-up-sysfs-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "T.J. Alumbaugh" <talumbau@google.com>
Subject: mm: multi-gen LRU: clean up sysfs code
Date: Tue, 14 Feb 2023 03:54:44 +0000

This patch cleans up the sysfs code. Specifically,
  1. use sysfs_emit(),
  2. use __ATTR_RW(), and
  3. constify multi-gen LRU struct attribute_group.

Link: https://lkml.kernel.org/r/20230214035445.1250139-1-talumbau@google.com
Signed-off-by: T.J. Alumbaugh <talumbau@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 mm/vmscan.c            |   22 +++++++++-------------
 2 files changed, 10 insertions(+), 14 deletions(-)

--- a/include/linux/mmzone.h~mm-multi-gen-lru-clean-up-sysfs-code
+++ a/include/linux/mmzone.h
@@ -1369,7 +1369,7 @@ typedef struct pglist_data {
 
 #ifdef CONFIG_LRU_GEN
 	/* kswap mm walk data */
-	struct lru_gen_mm_walk	mm_walk;
+	struct lru_gen_mm_walk mm_walk;
 	/* lru_gen_folio list */
 	struct lru_gen_memcg memcg_lru;
 #endif
--- a/mm/vmscan.c~mm-multi-gen-lru-clean-up-sysfs-code
+++ a/mm/vmscan.c
@@ -5663,14 +5663,14 @@ unlock:
  *                          sysfs interface
  ******************************************************************************/
 
-static ssize_t show_min_ttl(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
+static ssize_t min_ttl_ms_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%u\n", jiffies_to_msecs(READ_ONCE(lru_gen_min_ttl)));
+	return sysfs_emit(buf, "%u\n", jiffies_to_msecs(READ_ONCE(lru_gen_min_ttl)));
 }
 
 /* see Documentation/admin-guide/mm/multigen_lru.rst for details */
-static ssize_t store_min_ttl(struct kobject *kobj, struct kobj_attribute *attr,
-			     const char *buf, size_t len)
+static ssize_t min_ttl_ms_store(struct kobject *kobj, struct kobj_attribute *attr,
+				const char *buf, size_t len)
 {
 	unsigned int msecs;
 
@@ -5682,11 +5682,9 @@ static ssize_t store_min_ttl(struct kobj
 	return len;
 }
 
-static struct kobj_attribute lru_gen_min_ttl_attr = __ATTR(
-	min_ttl_ms, 0644, show_min_ttl, store_min_ttl
-);
+static struct kobj_attribute lru_gen_min_ttl_attr = __ATTR_RW(min_ttl_ms);
 
-static ssize_t show_enabled(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
+static ssize_t enabled_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
 	unsigned int caps = 0;
 
@@ -5703,7 +5701,7 @@ static ssize_t show_enabled(struct kobje
 }
 
 /* see Documentation/admin-guide/mm/multigen_lru.rst for details */
-static ssize_t store_enabled(struct kobject *kobj, struct kobj_attribute *attr,
+static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
 			     const char *buf, size_t len)
 {
 	int i;
@@ -5730,9 +5728,7 @@ static ssize_t store_enabled(struct kobj
 	return len;
 }
 
-static struct kobj_attribute lru_gen_enabled_attr = __ATTR(
-	enabled, 0644, show_enabled, store_enabled
-);
+static struct kobj_attribute lru_gen_enabled_attr = __ATTR_RW(enabled);
 
 static struct attribute *lru_gen_attrs[] = {
 	&lru_gen_min_ttl_attr.attr,
@@ -5740,7 +5736,7 @@ static struct attribute *lru_gen_attrs[]
 	NULL
 };
 
-static struct attribute_group lru_gen_attr_group = {
+static const struct attribute_group lru_gen_attr_group = {
 	.name = "lru_gen",
 	.attrs = lru_gen_attrs,
 };
_

Patches currently in -mm which might be from talumbau@google.com are


