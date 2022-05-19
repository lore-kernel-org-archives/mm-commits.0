Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D97D4C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 21:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244987AbiESVCf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 17:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244985AbiESVCe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 17:02:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512E25BD2E
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 14:02:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03552B8288A
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 21:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64DCC385AA;
        Thu, 19 May 2022 21:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652994150;
        bh=vvtYTOlrdlmev0Ss/UqBH6JEM7XFkY017gBvL9en9VE=;
        h=Date:To:From:Subject:From;
        b=pIb2Gx7LKkXLprsOHm1ZlRsYRlymxVZ3TF6gvy4alOb5qSaAMR7NNLHQivU4D9/TY
         C8Lh0UCZ849jt+ZevMWMdejW33QgVCOcreyphj0+A3maL7Pm/4eZTebrmCSqB7x+y9
         r+u4KbpDsPCPZZLFBZNqyK1lq9DLhT1wGcAjLoBk=
Date:   Thu, 19 May 2022 14:02:30 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au, lkp@intel.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zswap-memcg-accounting-fix.patch removed from -mm tree
Message-Id: <20220519210230.A64DCC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zswap-memcg-accounting-fix
has been removed from the -mm tree.  Its filename was
     zswap-memcg-accounting-fix.patch

This patch was dropped because it was folded into zswap-memcg-accounting.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: zswap-memcg-accounting-fix

Fix for CONFIG_SLOB builds:

>> mm/memcontrol.c:7467:6: error: redefinition of 'obj_cgroup_may_zswap'
   bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
	^
   include/linux/memcontrol.h:1816:20: note: previous definition is here
   static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)

The header file uses CONFIG_MEMCG_KMEM && CONFIG_ZSWAP to decide on
implementation vs dummies; the .c file uses CONFIG_ZSWAP.  SLOB builds
don't have CONFIG_MEMCG_KMEM (for historical reasons).

Gate everything in the code file on CONFIG_MEMCG_KMEM as well for now. 
Eventually, CONFIG_MEMCG_KMEM should be removed and folded into
CONFIG_MEMCG.

Link: https://lkml.kernel.org/r/YnwD14zxYjUJPc2w@cmpxchg.org
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 mm/memcontrol.c            |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/memcontrol.h~zswap-memcg-accounting-fix
+++ a/include/linux/memcontrol.h
@@ -254,7 +254,7 @@ struct mem_cgroup {
 	/* Range enforcement for interrupt charges */
 	struct work_struct high_work;
 
-#ifdef CONFIG_ZSWAP
+#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
 	unsigned long zswap_max;
 #endif
 
--- a/mm/memcontrol.c~zswap-memcg-accounting-fix
+++ a/mm/memcontrol.c
@@ -1398,7 +1398,7 @@ static const struct memory_stat memory_s
 	{ "sock",			MEMCG_SOCK			},
 	{ "vmalloc",			MEMCG_VMALLOC			},
 	{ "shmem",			NR_SHMEM			},
-#ifdef CONFIG_ZSWAP
+#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
 	{ "zswap",			MEMCG_ZSWAP_B			},
 	{ "zswapped",			MEMCG_ZSWAPPED			},
 #endif
@@ -1517,7 +1517,7 @@ static char *memory_stat_format(struct m
 	seq_buf_printf(&s, "%s %lu\n", vm_event_name(PGLAZYFREED),
 		       memcg_events(memcg, PGLAZYFREED));
 
-#ifdef CONFIG_ZSWAP
+#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
 	seq_buf_printf(&s, "%s %lu\n", vm_event_name(ZSWPIN),
 		       memcg_events(memcg, ZSWPIN));
 	seq_buf_printf(&s, "%s %lu\n", vm_event_name(ZSWPOUT),
@@ -5184,7 +5184,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
 	memcg->soft_limit = PAGE_COUNTER_MAX;
-#ifdef CONFIG_ZSWAP
+#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
 	memcg->zswap_max = PAGE_COUNTER_MAX;
 #endif
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
@@ -7466,7 +7466,7 @@ static struct cftype memsw_files[] = {
 	{ },	/* terminate */
 };
 
-#ifdef CONFIG_ZSWAP
+#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
 /**
  * obj_cgroup_may_zswap - check if this cgroup can zswap
  * @objcg: the object cgroup
@@ -7597,7 +7597,7 @@ static struct cftype zswap_files[] = {
 	},
 	{ }	/* terminate */
 };
-#endif /* CONFIG_ZSWAP */
+#endif /* CONFIG_MEMCG_KMEM && CONFIG_ZSWAP */
 
 /*
  * If mem_cgroup_swap_init() is implemented as a subsys_initcall()
@@ -7617,7 +7617,7 @@ static int __init mem_cgroup_swap_init(v
 
 	WARN_ON(cgroup_add_dfl_cftypes(&memory_cgrp_subsys, swap_files));
 	WARN_ON(cgroup_add_legacy_cftypes(&memory_cgrp_subsys, memsw_files));
-#ifdef CONFIG_ZSWAP
+#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
 	WARN_ON(cgroup_add_dfl_cftypes(&memory_cgrp_subsys, zswap_files));
 #endif
 	return 0;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

documentation-filesystems-proc-update-meminfo-section.patch
mm-kconfig-move-swap-and-slab-config-options-to-the-mm-section.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus.patch
mm-kconfig-simplify-zswap-configuration.patch
mm-zswap-add-basic-meminfo-and-vmstat-coverage.patch
zswap-memcg-accounting.patch
zswap-memcg-accounting-fix-2.patch
revert-mm-vmscan-never-demote-for-memcg-reclaim.patch

