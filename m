Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B91C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 320F9206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027201;
	bh=c8XuGVn3ZI6HZZWsJ50N4w6/IhQyGRWR6zZp+qGV++4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ti//jpB5Y4J+MEsfIwCskmeFAeQuH7EPK3TG7ZHAcY2OcXu/lnipNyT7yRYmSTkzF
	 Ts6LpYPx8pGvINIIzv+GmzIVmN8PjyjxOsag7t1bdohevpZQ/5z/vzpqPeRPK0GzAc
	 oEkQA1A+wrfYTA/OZBWq1VeLtyjj4lZaRidtamnk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgHJCkA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:40:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgHJCkA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:40:00 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D28AE2065D;
        Mon, 10 Aug 2020 02:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027200;
        bh=c8XuGVn3ZI6HZZWsJ50N4w6/IhQyGRWR6zZp+qGV++4=;
        h=Date:From:To:Subject:From;
        b=ZW31gyGj1eQG/209O8oEuZqV0va8C075r2M4+tguvlyAsSZgcnL95fgLhR1Ig9lMr
         2tbXgTCfLsgA2jMwriqR3l09hwJvUu+/TsssH7MEk5w1Mypq+OsWAKC8qaU1lo3Dvj
         UOCiHIlQ5elSQOneQjkrty1tyXr6chVUeqs7UdqI=
Date:   Sun, 09 Aug 2020 19:39:59 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, david@redhat.com, hannes@cmpxchg.org,
        mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        richard.weiyang@linux.alibaba.com, ying.huang@intel.com
Subject:  [merged] mm-shuffle-remove-dynamic-reconfiguration.patch
 removed from -mm tree
Message-ID: <20200810023959.OM9awM6QX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shuffle: remove dynamic reconfiguration
has been removed from the -mm tree.  Its filename was
     mm-shuffle-remove-dynamic-reconfiguration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/shuffle: remove dynamic reconfiguration

Commit e900a918b098 ("mm: shuffle initial free memory to improve
memory-side-cache utilization") promised "autodetection of a
memory-side-cache (to be added in a follow-on patch)" over a year ago.

The original series included patches [1], however, they were dropped
during review [2] to be followed-up later.

Due to lack of platforms that publish an HMAT, autodetection is currently
not implemented.  However, manual activation is actively used [3].  Let's
simplify for now and re-add when really (ever?) needed.

[1] https://lkml.kernel.org/r/154510700291.1941238.817190985966612531.stgit@dwillia2-desk3.amr.corp.intel.com
[2] https://lkml.kernel.org/r/154690326478.676627.103843791978176914.stgit@dwillia2-desk3.amr.corp.intel.com
[3] https://lkml.kernel.org/r/CAPcyv4irwGUU2x+c6b4L=KbB1dnasNKaaZd6oSpYjL9kfsnROQ@mail.gmail.com

Link: http://lkml.kernel.org/r/20200624094741.9918-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shuffle.c |   28 ++--------------------------
 mm/shuffle.h |   17 -----------------
 2 files changed, 2 insertions(+), 43 deletions(-)

--- a/mm/shuffle.c~mm-shuffle-remove-dynamic-reconfiguration
+++ a/mm/shuffle.c
@@ -10,33 +10,11 @@
 #include "shuffle.h"
 
 DEFINE_STATIC_KEY_FALSE(page_alloc_shuffle_key);
-static unsigned long shuffle_state __ro_after_init;
-
-/*
- * Depending on the architecture, module parameter parsing may run
- * before, or after the cache detection. SHUFFLE_FORCE_DISABLE prevents,
- * or reverts the enabling of the shuffle implementation. SHUFFLE_ENABLE
- * attempts to turn on the implementation, but aborts if it finds
- * SHUFFLE_FORCE_DISABLE already set.
- */
-__meminit void page_alloc_shuffle(enum mm_shuffle_ctl ctl)
-{
-	if (ctl == SHUFFLE_FORCE_DISABLE)
-		set_bit(SHUFFLE_FORCE_DISABLE, &shuffle_state);
-
-	if (test_bit(SHUFFLE_FORCE_DISABLE, &shuffle_state)) {
-		if (test_and_clear_bit(SHUFFLE_ENABLE, &shuffle_state))
-			static_branch_disable(&page_alloc_shuffle_key);
-	} else if (ctl == SHUFFLE_ENABLE
-			&& !test_and_set_bit(SHUFFLE_ENABLE, &shuffle_state))
-		static_branch_enable(&page_alloc_shuffle_key);
-}
 
 static bool shuffle_param;
 static int shuffle_show(char *buffer, const struct kernel_param *kp)
 {
-	return sprintf(buffer, "%c\n", test_bit(SHUFFLE_ENABLE, &shuffle_state)
-			? 'Y' : 'N');
+	return sprintf(buffer, "%c\n", shuffle_param ? 'Y' : 'N');
 }
 
 static __meminit int shuffle_store(const char *val,
@@ -47,9 +25,7 @@ static __meminit int shuffle_store(const
 	if (rc < 0)
 		return rc;
 	if (shuffle_param)
-		page_alloc_shuffle(SHUFFLE_ENABLE);
-	else
-		page_alloc_shuffle(SHUFFLE_FORCE_DISABLE);
+		static_branch_enable(&page_alloc_shuffle_key);
 	return 0;
 }
 module_param_call(shuffle, shuffle_store, shuffle_show, &shuffle_param, 0400);
--- a/mm/shuffle.h~mm-shuffle-remove-dynamic-reconfiguration
+++ a/mm/shuffle.h
@@ -4,23 +4,10 @@
 #define _MM_SHUFFLE_H
 #include <linux/jump_label.h>
 
-/*
- * SHUFFLE_ENABLE is called from the command line enabling path, or by
- * platform-firmware enabling that indicates the presence of a
- * direct-mapped memory-side-cache. SHUFFLE_FORCE_DISABLE is called from
- * the command line path and overrides any previous or future
- * SHUFFLE_ENABLE.
- */
-enum mm_shuffle_ctl {
-	SHUFFLE_ENABLE,
-	SHUFFLE_FORCE_DISABLE,
-};
-
 #define SHUFFLE_ORDER (MAX_ORDER-1)
 
 #ifdef CONFIG_SHUFFLE_PAGE_ALLOCATOR
 DECLARE_STATIC_KEY_FALSE(page_alloc_shuffle_key);
-extern void page_alloc_shuffle(enum mm_shuffle_ctl ctl);
 extern void __shuffle_free_memory(pg_data_t *pgdat);
 extern bool shuffle_pick_tail(void);
 static inline void shuffle_free_memory(pg_data_t *pgdat)
@@ -58,10 +45,6 @@ static inline void shuffle_zone(struct z
 {
 }
 
-static inline void page_alloc_shuffle(enum mm_shuffle_ctl ctl)
-{
-}
-
 static inline bool is_shuffle_order(int order)
 {
 	return false;
_

Patches currently in -mm which might be from david@redhat.com are


