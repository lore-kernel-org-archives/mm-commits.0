Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DC4C6FA8E
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 05:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjBZFbf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 00:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBZFbd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 00:31:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CF4D302
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 21:31:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22435B80882
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 05:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EA0C433D2;
        Sun, 26 Feb 2023 05:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677389489;
        bh=e9+j2pJ/yTd88Bi2pnpU6aoKSh+cP9GeodyLbmkrNhI=;
        h=Date:To:From:Subject:From;
        b=LJBGC/KyfqXJDWDCk7U459TE8wudm2bBgIjjOxm89+wk9JDJHgLQg1Ruiv8VQAFKc
         iLeWH/3HQ+Qqoi9bSHkcz3cf1hDi7MGgdm1FRX5Rs/iVEI1s5gQVSJvatMCsN6OHaK
         KXJ8Ema66gU0bueJQpMPTRJgam32dpKL06PsVurc=
Date:   Sat, 25 Feb 2023 21:31:29 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, talumbau@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-clean-up-sysfs-code.patch added to mm-unstable branch
Message-Id: <20230226053129.B3EA0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: clean up sysfs code
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-clean-up-sysfs-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-clean-up-sysfs-code.patch

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


--- a/include/linux/mmzone.h~mm-multi-gen-lru-clean-up-sysfs-code
+++ b/include/linux/mmzone.h
@@ -1369,7 +1369,7 @@ typedef struct pglist_data {
 
 #ifdef CONFIG_LRU_GEN
 	/* kswap mm walk data */
-	struct lru_gen_mm_walk	mm_walk;
+	struct lru_gen_mm_walk mm_walk;
 	/* lru_gen_folio list */
 	struct lru_gen_memcg memcg_lru;
 #endif
--- a/mm/vmscan.c~mm-multi-gen-lru-clean-up-sysfs-code
+++ b/mm/vmscan.c
@@ -5663,14 +5663,14 @@ static void lru_gen_change_state(bool enabled)
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
 
@@ -5682,11 +5682,9 @@ static ssize_t store_min_ttl(struct kobject *kobj, struct kobj_attribute *attr,
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
 
@@ -5703,7 +5701,7 @@ static ssize_t show_enabled(struct kobject *kobj, struct kobj_attribute *attr, c
 }
 
 /* see Documentation/admin-guide/mm/multigen_lru.rst for details */
-static ssize_t store_enabled(struct kobject *kobj, struct kobj_attribute *attr,
+static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
 			     const char *buf, size_t len)
 {
 	int i;
@@ -5730,9 +5728,7 @@ static ssize_t store_enabled(struct kobject *kobj, struct kobj_attribute *attr,
 	return len;
 }
 
-static struct kobj_attribute lru_gen_enabled_attr = __ATTR(
-	enabled, 0644, show_enabled, store_enabled
-);
+static struct kobj_attribute lru_gen_enabled_attr = __ATTR_RW(enabled);
 
 static struct attribute *lru_gen_attrs[] = {
 	&lru_gen_min_ttl_attr.attr,
@@ -5740,7 +5736,7 @@ static struct attribute *lru_gen_attrs[] = {
 	NULL
 };
 
-static struct attribute_group lru_gen_attr_group = {
+static const struct attribute_group lru_gen_attr_group = {
 	.name = "lru_gen",
 	.attrs = lru_gen_attrs,
 };
_

Patches currently in -mm which might be from talumbau@google.com are

mm-multi-gen-lru-clean-up-sysfs-code.patch
mm-multi-gen-lru-improve-design-doc.patch

