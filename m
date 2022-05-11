Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C804C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 11 May 2022 19:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346818AbiEKT2W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 May 2022 15:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346826AbiEKT2U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 May 2022 15:28:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BCB63512
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 12:28:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 555986165C
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 19:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3FAC340EE;
        Wed, 11 May 2022 19:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652297297;
        bh=kpt3UCuJJ0mZTRSyLoKeKY8F2wQ634oJlZ7elUCK2O0=;
        h=Date:To:From:Subject:From;
        b=XHYeSOAYiikfZZPRU6ZUvFdRP8nEbiSeE8n33qP7cK5a3Vi7N0bA7kfLAkTe3rnlj
         1bj2j1NYLkhOiYfmchgUsiY5UptwnyJthULByPPI7WQfQOzxy829nZpTR+roqZa13l
         Kv1zyRyaW5Rjaqc7Xr2YoVjdwENFwKMc2AlTE8SU=
Date:   Wed, 11 May 2022 12:28:17 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au, lkp@intel.com,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-memcg-accounting-fix.patch added to mm-unstable branch
Message-Id: <20220511192817.AE3FAC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zswap-memcg-accounting-fix
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-memcg-accounting-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-memcg-accounting-fix.patch

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
@@ -7451,7 +7451,7 @@ static struct cftype memsw_files[] = {
 	{ },	/* terminate */
 };
 
-#ifdef CONFIG_ZSWAP
+#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
 /**
  * obj_cgroup_may_zswap - check if this cgroup can zswap
  * @objcg: the object cgroup
@@ -7582,7 +7582,7 @@ static struct cftype zswap_files[] = {
 	},
 	{ }	/* terminate */
 };
-#endif /* CONFIG_ZSWAP */
+#endif /* CONFIG_MEMCG_KMEM && CONFIG_ZSWAP */
 
 /*
  * If mem_cgroup_swap_init() is implemented as a subsys_initcall()
@@ -7602,7 +7602,7 @@ static int __init mem_cgroup_swap_init(v
 
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
documentation-filesystems-proc-update-meminfo-section-fix.patch
mm-kconfig-move-swap-and-slab-config-options-to-the-mm-section.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus.patch
mm-kconfig-group-swap-slab-hotplug-and-thp-options-into-submenus-fix.patch
mm-kconfig-simplify-zswap-configuration.patch
mm-zswap-add-basic-meminfo-and-vmstat-coverage.patch
zswap-memcg-accounting.patch
zswap-memcg-accounting-fix.patch

