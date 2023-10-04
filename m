Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46201E7C4F7
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243894AbjJDUSK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243896AbjJDUSH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E66AD
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D802FC433C7;
        Wed,  4 Oct 2023 20:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450684;
        bh=gKYpzxAemXkww+/DnNjzQreVl+cfZS9gVGtp3vqpp/Q=;
        h=Date:To:From:Subject:From;
        b=QXNaqFNSlPfgqcg51uMV68ITnQHwGQ1J9qjNpv1BwC7L2Vz2NaKgLRh/wb2wOjfwF
         IpD15lOzvVSMX+hTx7X2eczNA6I8CZU0O/u6D4nckOaMVN+7yR+nIv+VylgwU9dxW1
         tuVCKl8uXxyc7f1UJRCOUXdAv1vPDvtr4/V7GJi0=
Date:   Wed, 04 Oct 2023 13:18:02 -0700
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmstat-use-this_cpu_try_cmpxchg-in-mod_zonenode_state.patch removed from -mm tree
Message-Id: <20231004201803.D802FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmstat: use this_cpu_try_cmpxchg in mod_{zone,node}_state
has been removed from the -mm tree.  Its filename was
     mm-vmstat-use-this_cpu_try_cmpxchg-in-mod_zonenode_state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: mm/vmstat: use this_cpu_try_cmpxchg in mod_{zone,node}_state
Date: Mon, 4 Sep 2023 17:08:49 +0200

Use this_cpu_try_cmpxchg instead of this_cpu_cmpxchg (*ptr, old, new) ==
old in mod_zone_state and mod_node_state.  x86 CMPXCHG instruction returns
success in ZF flag, so this change saves a compare after cmpxchg (and
related move instruction in front of cmpxchg).

Also, try_cmpxchg implicitly assigns old *ptr value to "old" when cmpxchg
fails.  There is no need to re-read the value in the loop.

No functional change intended.

Link: https://lkml.kernel.org/r/20230904150917.8318-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-use-this_cpu_try_cmpxchg-in-mod_zonenode_state
+++ a/mm/vmstat.c
@@ -559,8 +559,10 @@ static inline void mod_zone_state(struct
 {
 	struct per_cpu_zonestat __percpu *pcp = zone->per_cpu_zonestats;
 	s8 __percpu *p = pcp->vm_stat_diff + item;
-	long o, n, t, z;
+	long n, t, z;
+	s8 o;
 
+	o = this_cpu_read(*p);
 	do {
 		z = 0;  /* overflow to zone counters */
 
@@ -576,8 +578,7 @@ static inline void mod_zone_state(struct
 		 */
 		t = this_cpu_read(pcp->stat_threshold);
 
-		o = this_cpu_read(*p);
-		n = delta + o;
+		n = delta + (long)o;
 
 		if (abs(n) > t) {
 			int os = overstep_mode * (t >> 1) ;
@@ -586,7 +587,7 @@ static inline void mod_zone_state(struct
 			z = n + os;
 			n = -os;
 		}
-	} while (this_cpu_cmpxchg(*p, o, n) != o);
+	} while (!this_cpu_try_cmpxchg(*p, &o, n));
 
 	if (z)
 		zone_page_state_add(z, zone, item);
@@ -616,7 +617,8 @@ static inline void mod_node_state(struct
 {
 	struct per_cpu_nodestat __percpu *pcp = pgdat->per_cpu_nodestats;
 	s8 __percpu *p = pcp->vm_node_stat_diff + item;
-	long o, n, t, z;
+	long n, t, z;
+	s8 o;
 
 	if (vmstat_item_in_bytes(item)) {
 		/*
@@ -629,6 +631,7 @@ static inline void mod_node_state(struct
 		delta >>= PAGE_SHIFT;
 	}
 
+	o = this_cpu_read(*p);
 	do {
 		z = 0;  /* overflow to node counters */
 
@@ -644,8 +647,7 @@ static inline void mod_node_state(struct
 		 */
 		t = this_cpu_read(pcp->stat_threshold);
 
-		o = this_cpu_read(*p);
-		n = delta + o;
+		n = delta + (long)o;
 
 		if (abs(n) > t) {
 			int os = overstep_mode * (t >> 1) ;
@@ -654,7 +656,7 @@ static inline void mod_node_state(struct
 			z = n + os;
 			n = -os;
 		}
-	} while (this_cpu_cmpxchg(*p, o, n) != o);
+	} while (!this_cpu_try_cmpxchg(*p, &o, n));
 
 	if (z)
 		node_page_state_add(z, pgdat, item);
_

Patches currently in -mm which might be from ubizjak@gmail.com are

panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic.patch
panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic-v2.patch

