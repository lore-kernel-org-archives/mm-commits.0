Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E46ECAAA1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 01:51:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiHaBvl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Aug 2022 21:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiHaBvl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2022 21:51:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B15AF492
        for <mm-commits@vger.kernel.org>; Tue, 30 Aug 2022 18:51:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48E0E618DB
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 01:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9D7C433D7;
        Wed, 31 Aug 2022 01:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661910698;
        bh=mWAr/PE5J2OVD3IreXefDK0mePhQ6PErFD3UDPQqkL0=;
        h=Date:To:From:Subject:From;
        b=fPHnBKSCjwJeZohZebDXezny9kRX4zNx92y7oJ6rzJKGjOP2MOkf6QMLtrcU+3iVE
         E8UR/DRfRYLHPMuLu/2Apd902bHJpVi2UYRXoG9201YD2REer/x4bT2tz1AdfwNkH+
         DM2+9O5GbMhaw1u4g0/8vZQyuvIDJJxQkgV2hZVc=
Date:   Tue, 30 Aug 2022 18:51:37 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mgorman@suse.de,
        hch@infradead.org, hannes@cmpxchg.org, dan.carpenter@oracle.com,
        mhocko@suse.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-reduce-noise-in-show_mem-for-lowmem-allocations-update.patch added to mm-unstable branch
Message-Id: <20220831015138.9D9D7C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-reduce-noise-in-show_mem-for-lowmem-allocations-update
has been added to the -mm mm-unstable branch.  Its filename is
     mm-reduce-noise-in-show_mem-for-lowmem-allocations-update.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-reduce-noise-in-show_mem-for-lowmem-allocations-update.patch

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
From: Michal Hocko <mhocko@suse.com>
Subject: mm-reduce-noise-in-show_mem-for-lowmem-allocations-update
Date: Tue, 30 Aug 2022 09:34:06 +0200

Dan has brought up[1] that the use of gfp mask has confused his static
analyzer which assumes that GFP_HIGHUSER_MOVABLE implies a sleeping
allocation and that wouldn't be a great idea from the panic path. I
would add that most callers of this function would be really bad to
allocate.

The report itself is a false positive but it made me think a bit about
this. Even if the check is too simplistic I guess it resembles how many
developers are thinking (including me). If I see GFP_HIGHUSER_MOVABLE or
GF_KERNEL I automatically assume a sleeping allocation down the road.
And who know somebody might add one in the future even into show_mem
because the gfp parameter would be too tempting to not (ab)use.

My original intention was to use a natural allocation speak but this can
backfire so maybe it would be better to give the argument its real
meaning and that is the high_zone_idx. This is cryptic for code outside
of MM but that is not all that many callers and we can hide this fact
from them. In other words does the thing below looks better (incremental
for illustration, I will make it a proper patch if yes)?

[1] https://lore.kernel.org/all/Yw2ugrlZ8bwE5/hh@kili/?q=http%3A%2F%2Flkml.kernel.org%2Fr%2FYw2ugrlZ8bwE5%2Fhh%40kili
Link: https://lkml.kernel.org/r/Yw29bmJTIkKogTiW@dhcp22.suse.cz
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/xmon/xmon.c     |    2 +-
 arch/sparc/kernel/setup_32.c |    2 +-
 drivers/tty/sysrq.c          |    2 +-
 drivers/tty/vt/keyboard.c    |    2 +-
 include/linux/mm.h           |   13 +++++++++++--
 init/initramfs.c             |    2 +-
 kernel/panic.c               |    2 +-
 lib/show_mem.c               |    4 ++--
 mm/nommu.c                   |    6 +++---
 mm/oom_kill.c                |    2 +-
 mm/page_alloc.c              |    5 ++---
 11 files changed, 25 insertions(+), 17 deletions(-)

--- a/arch/powerpc/xmon/xmon.c~mm-reduce-noise-in-show_mem-for-lowmem-allocations-update
+++ a/arch/powerpc/xmon/xmon.c
@@ -1086,7 +1086,7 @@ cmds(struct pt_regs *excp)
 				memzcan();
 				break;
 			case 'i':
-				show_mem(0, NULL, GFP_HIGHUSER_MOVABLE);
+				show_mem(0, NULL);
 				break;
 			default:
 				termch = cmd;
--- a/arch/sparc/kernel/setup_32.c~mm-reduce-noise-in-show_mem-for-lowmem-allocations-update
+++ a/arch/sparc/kernel/setup_32.c
@@ -83,7 +83,7 @@ static void prom_sync_me(void)
 			     "nop\n\t" : : "r" (&trapbase));
 
 	prom_printf("PROM SYNC COMMAND...\n");
-	show_free_areas(0, NULL, GFP_HIGHUSER_MOVABLE);
+	show_free_areas(0, NULL);
 	if (!is_idle_task(current)) {
 		local_irq_enable();
 		ksys_sync();
--- a/drivers/tty/sysrq.c~mm-reduce-noise-in-show_mem-for-lowmem-allocations-update
+++ a/drivers/tty/sysrq.c
@@ -342,7 +342,7 @@ static const struct sysrq_key_op sysrq_f
 
 static void sysrq_handle_showmem(int key)
 {
-	show_mem(0, NULL, GFP_HIGHUSER_MOVABLE);
+	show_mem(0, NULL);
 }
 static const struct sysrq_key_op sysrq_showmem_op = {
 	.handler	= sysrq_handle_showmem,
--- a/drivers/tty/vt/keyboard.c~mm-reduce-noise-in-show_mem-for-lowmem-allocations-update
+++ a/drivers/tty/vt/keyboard.c
@@ -606,7 +606,7 @@ static void fn_scroll_back(struct vc_dat
 
 static void fn_show_mem(struct vc_data *vc)
 {
-	show_mem(0, NULL, GFP_HIGHUSER_MOVABLE);
+	show_mem(0, NULL);
 }
 
 static void fn_show_state(struct vc_data *vc)
--- a/include/linux/mm.h~mm-reduce-noise-in-show_mem-for-lowmem-allocations-update
+++ a/include/linux/mm.h
@@ -1838,7 +1838,11 @@ extern void pagefault_out_of_memory(void
  */
 #define SHOW_MEM_FILTER_NODES		(0x0001u)	/* disallowed nodes */
 
-extern void show_free_areas(unsigned int flags, nodemask_t *nodemask, gfp_t gfp_mask);
+extern void __show_free_areas(unsigned int flags, nodemask_t *nodemask, int max_zone_idx);
+static void __maybe_unused show_free_areas(unsigned int flags, nodemask_t *nodemask)
+{
+	__show_free_areas(flags, nodemask, MAX_NR_ZONES - 1);
+}
 
 #ifdef CONFIG_MMU
 extern bool can_do_mlock(void);
@@ -2578,7 +2582,12 @@ extern void calculate_min_free_kbytes(vo
 extern int __meminit init_per_zone_wmark_min(void);
 extern void mem_init(void);
 extern void __init mmap_init(void);
-extern void show_mem(unsigned int flags, nodemask_t *nodemask, gfp_t gfp_mask);
+
+extern void __show_mem(unsigned int flags, nodemask_t *nodemask, int max_zone_idx);
+static inline void show_mem(unsigned int flags, nodemask_t *nodemask)
+{
+	__show_mem(flags, nodemask, MAX_NR_ZONES - 1);
+}
 extern long si_mem_available(void);
 extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
--- a/init/initramfs.c~mm-reduce-noise-in-show_mem-for-lowmem-allocations-update
+++ a/init/initramfs.c
@@ -63,7 +63,7 @@ static void panic_show_mem(const char *f
 {
 	va_list args;
 
-	show_mem(0, NULL, GFP_HIGHUSER_MOVABLE);
+	show_mem(0, NULL);
 	va_start(args, fmt);
 	panic(fmt, args);
 	va_end(args);
--- a/kernel/panic.c~mm-reduce-noise-in-show_mem-for-lowmem-allocations-update
+++ a/kernel/panic.c
@@ -187,7 +187,7 @@ static void panic_print_sys_info(bool co
 		show_state();
 
 	if (panic_print & PANIC_PRINT_MEM_INFO)
-		show_mem(0, NULL, GFP_HIGHUSER_MOVABLE);
+		show_mem(0, NULL);
 
 	if (panic_print & PANIC_PRINT_TIMER_INFO)
 		sysrq_timer_list_show();
--- a/lib/show_mem.c~mm-reduce-noise-in-show_mem-for-lowmem-allocations-update
+++ a/lib/show_mem.c
@@ -8,13 +8,13 @@
 #include <linux/mm.h>
 #include <linux/cma.h>
 
-void show_mem(unsigned int filter, nodemask_t *nodemask, gfp_t gfp_mask)
+void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
 {
 	pg_data_t *pgdat;
 	unsigned long total = 0, reserved = 0, highmem = 0;
 
 	printk("Mem-Info:\n");
-	show_free_areas(filter, nodemask, gfp_mask);
+	show_free_areas(filter, nodemask, max_zone_idx);
 
 	for_each_online_pgdat(pgdat) {
 		int zoneid;
--- a/mm/nommu.c~mm-reduce-noise-in-show_mem-for-lowmem-allocations-update
+++ a/mm/nommu.c
@@ -1030,7 +1030,7 @@ error_free:
 enomem:
 	pr_err("Allocation of length %lu from process %d (%s) failed\n",
 	       len, current->pid, current->comm);
-	show_free_areas(0, NULL, GFP_KERNEL);
+	show_free_areas(0, NULL);
 	return -ENOMEM;
 }
 
@@ -1259,13 +1259,13 @@ error_getting_vma:
 	kmem_cache_free(vm_region_jar, region);
 	pr_warn("Allocation of vma for %lu byte allocation from process %d failed\n",
 			len, current->pid);
-	show_free_areas(0, NULL, GFP_KERNEL);
+	show_free_areas(0, NULL);
 	return -ENOMEM;
 
 error_getting_region:
 	pr_warn("Allocation of vm region for %lu byte allocation from process %d failed\n",
 			len, current->pid);
-	show_free_areas(0, NULL, GFP_KERNEL);
+	show_free_areas(0, NULL);
 	return -ENOMEM;
 
 error_maple_preallocate:
--- a/mm/oom_kill.c~mm-reduce-noise-in-show_mem-for-lowmem-allocations-update
+++ a/mm/oom_kill.c
@@ -461,7 +461,7 @@ static void dump_header(struct oom_contr
 	if (is_memcg_oom(oc))
 		mem_cgroup_print_oom_meminfo(oc->memcg);
 	else {
-		show_mem(SHOW_MEM_FILTER_NODES, oc->nodemask, oc->gfp_mask);
+		__show_mem(SHOW_MEM_FILTER_NODES, oc->nodemask, gfp_zone(oc->gfp_mask));
 		if (should_dump_unreclaim_slab())
 			dump_unreclaimable_slab();
 	}
--- a/mm/page_alloc.c~mm-reduce-noise-in-show_mem-for-lowmem-allocations-update
+++ a/mm/page_alloc.c
@@ -4329,7 +4329,7 @@ static void warn_alloc_show_mem(gfp_t gf
 	if (!in_task() || !(gfp_mask & __GFP_DIRECT_RECLAIM))
 		filter &= ~SHOW_MEM_FILTER_NODES;
 
-	show_mem(filter, nodemask, gfp_mask);
+	__show_mem(filter, nodemask, gfp_zone(gfp_mask));
 }
 
 void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
@@ -6067,10 +6067,9 @@ static bool node_has_managed_zones(pg_da
  * SHOW_MEM_FILTER_NODES: suppress nodes that are not allowed by current's
  *   cpuset.
  */
-void show_free_areas(unsigned int filter, nodemask_t *nodemask, gfp_t gfp_mask)
+void __show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
 {
 	unsigned long free_pcp = 0;
-	int max_zone_idx = gfp_zone(gfp_mask);
 	int cpu, nid;
 	struct zone *zone;
 	pg_data_t *pgdat;
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-reduce-noise-in-show_mem-for-lowmem-allocations.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-update.patch

