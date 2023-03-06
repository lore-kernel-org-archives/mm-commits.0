Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6232C61DA4
	for <mm-commits@archiver.kernel.org>; Mon,  6 Mar 2023 01:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjCFBdS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 5 Mar 2023 20:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjCFBdR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 5 Mar 2023 20:33:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16C1EB63
        for <mm-commits@vger.kernel.org>; Sun,  5 Mar 2023 17:33:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71F8AB80B94
        for <mm-commits@vger.kernel.org>; Mon,  6 Mar 2023 01:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28D7C433EF;
        Mon,  6 Mar 2023 01:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678066388;
        bh=3hh+5UBjenG7PCz8l59/PvpeMD65H5u5sRy/0j5LwaM=;
        h=Date:To:From:Subject:From;
        b=DPlwhUIziP8HHU+p7LTJi9MUIKVeoHWhSipTltdvRe6C5tzrsq7Xx7lSixcnDvRZ2
         3kF0PmUO+ZuojT80vHNqQeBKFsPN4t4zRocck3r+mWOD+v2lx4NrxFSlIN7u/cRThN
         urmHiJcHpnjX4twjwScysPlTu9qqw0EDaEZKBSBQ=
Date:   Sun, 05 Mar 2023 17:33:07 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        sfr@canb.auug.org.au, peterx@redhat.com, mingo@elte.hu,
        linux@armlinux.org.uk, hpa@zytor.com, hca@linux.ibm.com,
        frederic@kernel.org, david@redhat.com, cl@linux.com,
        chenhuacai@kernel.org, atomlin@atomlin.com, mtosatti@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmstat-switch-per-cpu-vmstat-counters-to-32-bits.patch added to mm-unstable branch
Message-Id: <20230306013307.E28D7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmstat: switch per-cpu vmstat counters to 32-bits
has been added to the -mm mm-unstable branch.  Its filename is
     vmstat-switch-per-cpu-vmstat-counters-to-32-bits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmstat-switch-per-cpu-vmstat-counters-to-32-bits.patch

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
From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: vmstat: switch per-cpu vmstat counters to 32-bits
Date: Sun, 05 Mar 2023 10:37:06 -0300

Some architectures only provide xchg/cmpxchg in 32/64-bit quantities.

Since the next patch is about to use xchg on per-CPU vmstat counters,
switch them to s32.

Link: https://lkml.kernel.org/r/20230305134053.638239404@redhat.com
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Xu <peterx@redhat.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mmzone.h~vmstat-switch-per-cpu-vmstat-counters-to-32-bits
+++ a/include/linux/mmzone.h
@@ -686,8 +686,8 @@ struct per_cpu_pages {
 
 struct per_cpu_zonestat {
 #ifdef CONFIG_SMP
-	s8 vm_stat_diff[NR_VM_ZONE_STAT_ITEMS];
-	s8 stat_threshold;
+	s32 vm_stat_diff[NR_VM_ZONE_STAT_ITEMS];
+	s32 stat_threshold;
 #endif
 #ifdef CONFIG_NUMA
 	/*
@@ -700,8 +700,8 @@ struct per_cpu_zonestat {
 };
 
 struct per_cpu_nodestat {
-	s8 stat_threshold;
-	s8 vm_node_stat_diff[NR_VM_NODE_STAT_ITEMS];
+	s32 stat_threshold;
+	s32 vm_node_stat_diff[NR_VM_NODE_STAT_ITEMS];
 };
 
 #endif /* !__GENERATING_BOUNDS.H */
--- a/mm/vmstat.c~vmstat-switch-per-cpu-vmstat-counters-to-32-bits
+++ a/mm/vmstat.c
@@ -351,7 +351,7 @@ static inline void mod_zone_state(struct
 				  long delta, int overstep_mode)
 {
 	struct per_cpu_zonestat __percpu *pcp = zone->per_cpu_zonestats;
-	s8 __percpu *p = pcp->vm_stat_diff + item;
+	s32 __percpu *p = pcp->vm_stat_diff + item;
 	long o, n, t, z;
 
 	do {
@@ -428,7 +428,7 @@ static inline void mod_node_state(struct
 				  int delta, int overstep_mode)
 {
 	struct per_cpu_nodestat __percpu *pcp = pgdat->per_cpu_nodestats;
-	s8 __percpu *p = pcp->vm_node_stat_diff + item;
+	s32 __percpu *p = pcp->vm_node_stat_diff + item;
 	long o, n, t, z;
 
 	if (vmstat_item_in_bytes(item)) {
@@ -525,7 +525,7 @@ void __mod_zone_page_state(struct zone *
 			   long delta)
 {
 	struct per_cpu_zonestat __percpu *pcp = zone->per_cpu_zonestats;
-	s8 __percpu *p = pcp->vm_stat_diff + item;
+	s32 __percpu *p = pcp->vm_stat_diff + item;
 	long x;
 	long t;
 
@@ -556,7 +556,7 @@ void __mod_node_page_state(struct pglist
 				long delta)
 {
 	struct per_cpu_nodestat __percpu *pcp = pgdat->per_cpu_nodestats;
-	s8 __percpu *p = pcp->vm_node_stat_diff + item;
+	s32 __percpu *p = pcp->vm_node_stat_diff + item;
 	long x;
 	long t;
 
@@ -614,8 +614,8 @@ EXPORT_SYMBOL(__mod_node_page_state);
 void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
 {
 	struct per_cpu_zonestat __percpu *pcp = zone->per_cpu_zonestats;
-	s8 __percpu *p = pcp->vm_stat_diff + item;
-	s8 v, t;
+	s32 __percpu *p = pcp->vm_stat_diff + item;
+	s32 v, t;
 
 	/* See __mod_node_page_state */
 	preempt_disable_nested();
@@ -623,7 +623,7 @@ void __inc_zone_state(struct zone *zone,
 	v = __this_cpu_inc_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v > t)) {
-		s8 overstep = t >> 1;
+		s32 overstep = t >> 1;
 
 		zone_page_state_add(v + overstep, zone, item);
 		__this_cpu_write(*p, -overstep);
@@ -635,8 +635,8 @@ void __inc_zone_state(struct zone *zone,
 void __inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
 {
 	struct per_cpu_nodestat __percpu *pcp = pgdat->per_cpu_nodestats;
-	s8 __percpu *p = pcp->vm_node_stat_diff + item;
-	s8 v, t;
+	s32 __percpu *p = pcp->vm_node_stat_diff + item;
+	s32 v, t;
 
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
 
@@ -646,7 +646,7 @@ void __inc_node_state(struct pglist_data
 	v = __this_cpu_inc_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v > t)) {
-		s8 overstep = t >> 1;
+		s32 overstep = t >> 1;
 
 		node_page_state_add(v + overstep, pgdat, item);
 		__this_cpu_write(*p, -overstep);
@@ -670,8 +670,8 @@ EXPORT_SYMBOL(__inc_node_page_state);
 void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
 {
 	struct per_cpu_zonestat __percpu *pcp = zone->per_cpu_zonestats;
-	s8 __percpu *p = pcp->vm_stat_diff + item;
-	s8 v, t;
+	s32 __percpu *p = pcp->vm_stat_diff + item;
+	s32 v, t;
 
 	/* See __mod_node_page_state */
 	preempt_disable_nested();
@@ -679,7 +679,7 @@ void __dec_zone_state(struct zone *zone,
 	v = __this_cpu_dec_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v < - t)) {
-		s8 overstep = t >> 1;
+		s32 overstep = t >> 1;
 
 		zone_page_state_add(v - overstep, zone, item);
 		__this_cpu_write(*p, overstep);
@@ -691,8 +691,8 @@ void __dec_zone_state(struct zone *zone,
 void __dec_node_state(struct pglist_data *pgdat, enum node_stat_item item)
 {
 	struct per_cpu_nodestat __percpu *pcp = pgdat->per_cpu_nodestats;
-	s8 __percpu *p = pcp->vm_node_stat_diff + item;
-	s8 v, t;
+	s32 __percpu *p = pcp->vm_node_stat_diff + item;
+	s32 v, t;
 
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
 
@@ -702,7 +702,7 @@ void __dec_node_state(struct pglist_data
 	v = __this_cpu_dec_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v < - t)) {
-		s8 overstep = t >> 1;
+		s32 overstep = t >> 1;
 
 		node_page_state_add(v - overstep, pgdat, item);
 		__this_cpu_write(*p, overstep);
_

Patches currently in -mm which might be from mtosatti@redhat.com are

mm-vmstat-remove-remote-node-draining.patch
this_cpu_cmpxchg-arm64-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-loongarch-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-s390-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-x86-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
add-this_cpu_cmpxchg_local-and-asm-generic-definitions.patch
convert-this_cpu_cmpxchg-users-to-this_cpu_cmpxchg_local.patch
mm-vmstat-switch-counter-modification-to-cmpxchg.patch
vmstat-switch-per-cpu-vmstat-counters-to-32-bits.patch
mm-vmstat-use-xchg-in-cpu_vm_stats_fold.patch
mm-vmstat-switch-vmstat-shepherd-to-flush-per-cpu-counters-remotely.patch
mm-vmstat-refresh-stats-remotely-instead-of-via-work-item.patch

