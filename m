Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66944C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 21:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3943764DBD
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 21:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbhA0VMy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Jan 2021 16:12:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:51004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233935AbhA0VMq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Jan 2021 16:12:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C5C660C3E;
        Wed, 27 Jan 2021 21:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611781926;
        bh=ZFD4v2D1KOEL18U1w5KGcjJA+e1Bi2e4b00AaIuhlLc=;
        h=Date:From:To:Subject:From;
        b=xfPHRdvbhi+xYN836PHJLWdQlnzIYd8NZzfa7y+AJvucitKryIatS0gsuz6gLR19N
         W6OZjugKC2YwHGU1282bEOl1RyEe6c+2blC6xW1gOaGdM6G5RpFX3nKsbSiG0BQQr1
         e1ERcWOjSZHKSXv6V10dbHGfaQd1uxOIeo0SLqLI=
Date:   Wed, 27 Jan 2021 13:12:05 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, david@redhat.com, guro@fb.com,
        iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?mm-slub-remove-slub=5Fmemcg=5Fsysfs-boot-param-and-conf?=
 =?US-ASCII?Q?ig=5Fslub=5Fmemcg=5Fsysfs=5Fon.patch?= added to -mm tree
Message-ID: <20210127211205.8n0U1XXYs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: remove slub_memcg_sysfs boot param and CONFIG_SLUB_MEMCG_SYSFS_ON
has been added to the -mm tree.  Its filename is
     mm-slub-remove-slub_memcg_sysfs-boot-param-and-config_slub_memcg_sysfs_on.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-remove-slub_memcg_sysfs-boot-param-and-config_slub_memcg_sysfs_on.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-remove-slub_memcg_sysfs-boot-param-and-config_slub_memcg_sysfs_on.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -4854,14 +4854,6 @@
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
@@ -1850,20 +1850,6 @@ config SLUB_DEBUG
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
@@ -4889,22 +4889,6 @@ enum slab_stat_type {
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

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-stop-freeing-kmem_cache_node-structures-on-node-offline.patch
mm-slab-slub-stop-taking-memory-hotplug-lock.patch
mm-slab-slub-stop-taking-cpu-hotplug-lock.patch
mm-slub-splice-cpu-and-page-freelists-in-deactivate_slab.patch
mm-slub-remove-slub_memcg_sysfs-boot-param-and-config_slub_memcg_sysfs_on.patch

