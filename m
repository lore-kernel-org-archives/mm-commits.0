Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B9FC83F33
	for <mm-commits@archiver.kernel.org>; Mon,  4 Sep 2023 19:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjIDTg1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Sep 2023 15:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjIDTg0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Sep 2023 15:36:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FB81A7
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 12:36:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5FFDB80E6D
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 19:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8ECC433C7;
        Mon,  4 Sep 2023 19:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693856180;
        bh=1W6avQUEG0A/Skh17qLr68tI5Tfa+oQqVEVzRIs4xEI=;
        h=Date:To:From:Subject:From;
        b=fbd867stK471PUf2zgQ9xdyneyZO1kB7nWbUzRqZj5fe6FhsX7yMNOmrIXj8NKnMr
         c5GVbS827BsQ8peu/ulrHX35N5dM06vjkC805c3xB9BkCB5p9PnHhjEed7jtWwo6cc
         y/I2bylGv7ZA5Qn8r8Qy+UsM4Y2n2fCiVScJfg7I=
Date:   Mon, 04 Sep 2023 12:36:19 -0700
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-use-this_cpu_try_cmpxchg-in-mod_zonenode_state.patch added to mm-unstable branch
Message-Id: <20230904193620.7E8ECC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: use this_cpu_try_cmpxchg in mod_{zone,node}_state
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmstat-use-this_cpu_try_cmpxchg-in-mod_zonenode_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-use-this_cpu_try_cmpxchg-in-mod_zonenode_state.patch

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

mm-vmstat-use-this_cpu_try_cmpxchg-in-mod_zonenode_state.patch
panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic.patch

