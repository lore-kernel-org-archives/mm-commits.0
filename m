Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC01C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D24B964F2A
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbhBXUDB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:03:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235152AbhBXUCK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40E4A64F2A;
        Wed, 24 Feb 2021 20:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196883;
        bh=O+gcSV7IoWq9TpjxG246UONGWhXkk6udUtmKMd8G5mE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pw/WQOneQ45Jmyk684TlbPAcIHY5FnsfrFvVbPgyfm0/DakFPllSDnSyUEKyfC+iz
         yiLM5fyQUWV55oaYV86cBsyOIFdYnHkXGZniwRhc+uclWeJH1OHItYqix1hbjh/dMD
         3eDphOOmiwpkdVMxvwjeEVjeeMWDEVYWDc3ho+rQ=
Date:   Wed, 24 Feb 2021 12:01:22 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, david@redhat.com,
        guro@fb.com, iamjoonsoo.kim@lge.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 022/173] mm, slub: remove slub_memcg_sysfs boot
 param and CONFIG_SLUB_MEMCG_SYSFS_ON
Message-ID: <20210224200122.rWHC1lQt0%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: remove slub_memcg_sysfs boot param and CONFIG_SLUB_MEMCG_SYSFS_ON

The boot param and config determine the value of memcg_sysfs_enabled,
which is unused since commit 10befea91b61 ("mm: memcg/slab: use a single
set of kmem_caches for all allocations") as there are no per-memcg kmem
caches anymore.

Link: https://lkml.kernel.org/r/20210127124745.7928-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    8 -------
 init/Kconfig                                    |   14 ------------
 mm/slub.c                                       |   16 --------------
 3 files changed, 38 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-slub-remove-slub_memcg_sysfs-boot-param-and-config_slub_memcg_sysfs_on
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -4899,14 +4899,6 @@
 			last alloc / free. For more information see
 			Documentation/vm/slub.rst.
 
-	slub_memcg_sysfs=	[MM, SLUB]
-			Determines whether to enable sysfs directories for
-			memory cgroup sub-caches. 1 to enable, 0 to disable.
-			The default is determined by CONFIG_SLUB_MEMCG_SYSFS_ON.
-			Enabling this can lead to a very high number of	debug
-			directories and files being created under
-			/sys/kernel/slub.
-
 	slub_max_order= [MM, SLUB]
 			Determines the maximum allowed order for slabs.
 			A high setting may cause OOMs due to memory
--- a/init/Kconfig~mm-slub-remove-slub_memcg_sysfs-boot-param-and-config_slub_memcg_sysfs_on
+++ a/init/Kconfig
@@ -1861,20 +1861,6 @@ config SLUB_DEBUG
 	  SLUB sysfs support. /sys/slab will not exist and there will be
 	  no support for cache validation etc.
 
-config SLUB_MEMCG_SYSFS_ON
-	default n
-	bool "Enable memcg SLUB sysfs support by default" if EXPERT
-	depends on SLUB && SYSFS && MEMCG
-	help
-	  SLUB creates a directory under /sys/kernel/slab for each
-	  allocation cache to host info and debug files. If memory
-	  cgroup is enabled, each cache can have per memory cgroup
-	  caches. SLUB can create the same sysfs directories for these
-	  caches under /sys/kernel/slab/CACHE/cgroup but it can lead
-	  to a very high number of debug files being created. This is
-	  controlled by slub_memcg_sysfs boot parameter and this
-	  config option determines the parameter's default value.
-
 config COMPAT_BRK
 	bool "Disable heap randomization"
 	default y
--- a/mm/slub.c~mm-slub-remove-slub_memcg_sysfs-boot-param-and-config_slub_memcg_sysfs_on
+++ a/mm/slub.c
@@ -4943,22 +4943,6 @@ enum slab_stat_type {
 #define SO_OBJECTS	(1 << SL_OBJECTS)
 #define SO_TOTAL	(1 << SL_TOTAL)
 
-#ifdef CONFIG_MEMCG
-static bool memcg_sysfs_enabled = IS_ENABLED(CONFIG_SLUB_MEMCG_SYSFS_ON);
-
-static int __init setup_slub_memcg_sysfs(char *str)
-{
-	int v;
-
-	if (get_option(&str, &v) > 0)
-		memcg_sysfs_enabled = v;
-
-	return 1;
-}
-
-__setup("slub_memcg_sysfs=", setup_slub_memcg_sysfs);
-#endif
-
 static ssize_t show_slab_objects(struct kmem_cache *s,
 				 char *buf, unsigned long flags)
 {
_
