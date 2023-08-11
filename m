Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413BBC04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbjHKXFW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235401AbjHKXDs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6803C14
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DADD67AFA
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AE2C433C8;
        Fri, 11 Aug 2023 23:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794914;
        bh=498tBOjhSldxkFnngbFo0dZMddLhXq4yDl5zBEow6do=;
        h=Date:To:From:Subject:From;
        b=zD3leFl7mYOo3odpHrTlAoErC4FvKK/lEMV4Zrqu6SxOMEORj7jySNodTmHY1mHDq
         +n6gEdjFelmvxlETyQlm7ZPnZYP0gA0YCvkaO2SMipFQu3zjrisDo/fZCrfMAa8iiY
         SLRlAEeQIo6Td0Td5ctshYLyD6Nwi0uBgd3tUhWw=
Date:   Fri, 11 Aug 2023 16:01:53 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-tier-use-helper-macro-__attr_rw.patch removed from -mm tree
Message-Id: <20230811230154.63AE2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memory tier: use helper macro __ATTR_RW()
has been removed from the -mm tree.  Its filename was
     memory-tier-use-helper-macro-__attr_rw.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: memory tier: use helper macro __ATTR_RW()
Date: Sat, 15 Jul 2023 11:51:11 +0800

Use helper macro __ATTR_RW to define numa demotion attributes.  Minor
readability improvement.

Link: https://lkml.kernel.org/r/20230715035111.2656784-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/memory-tiers.c~memory-tier-use-helper-macro-__attr_rw
+++ a/mm/memory-tiers.c
@@ -672,16 +672,16 @@ bool numa_demotion_enabled = false;
 
 #ifdef CONFIG_MIGRATION
 #ifdef CONFIG_SYSFS
-static ssize_t numa_demotion_enabled_show(struct kobject *kobj,
-					  struct kobj_attribute *attr, char *buf)
+static ssize_t demotion_enabled_show(struct kobject *kobj,
+				     struct kobj_attribute *attr, char *buf)
 {
 	return sysfs_emit(buf, "%s\n",
 			  numa_demotion_enabled ? "true" : "false");
 }
 
-static ssize_t numa_demotion_enabled_store(struct kobject *kobj,
-					   struct kobj_attribute *attr,
-					   const char *buf, size_t count)
+static ssize_t demotion_enabled_store(struct kobject *kobj,
+				      struct kobj_attribute *attr,
+				      const char *buf, size_t count)
 {
 	ssize_t ret;
 
@@ -693,8 +693,7 @@ static ssize_t numa_demotion_enabled_sto
 }
 
 static struct kobj_attribute numa_demotion_enabled_attr =
-	__ATTR(demotion_enabled, 0644, numa_demotion_enabled_show,
-	       numa_demotion_enabled_store);
+	__ATTR_RW(demotion_enabled);
 
 static struct attribute *numa_attrs[] = {
 	&numa_demotion_enabled_attr.attr,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memcg-fix-obsolete-function-name-in-mem_cgroup_protection.patch
mm-memory-failure-add-pageoffline-check.patch
mm-page_alloc-avoid-unneeded-alike_pages-calculation.patch
mm-memcg-update-obsolete-comment-above-parent_mem_cgroup.patch
mm-page_alloc-remove-unneeded-variable-base.patch
mm-memcg-fix-wrong-function-name-above-obj_cgroup_charge_zswap.patch
mm-memory-failure-use-helper-macro-llist_for_each_entry_safe.patch
mm-mm_init-use-helper-macro-bits_per_long-and-bits_per_byte.patch

