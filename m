From: akpm@linux-foundation.org
Subject: + mm-shuffle-remove-dynamic-reconfiguration.patch added to
 -mm tree
Date: Wed, 24 Jun 2020 12:38:59 -0700
Message-ID: <20200624193859.UqLwn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391239AbgFXTjB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 15:39:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ying.huang@intel.com, richard.weiyang@linux.alibaba.com, richard.weiyang@gmail.com, minchan@kernel.org, mhocko@suse.com, mgorman@techsingularity.net, hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com


The patch titled
     Subject: mm/shuffle: remove dynamic reconfiguration
has been added to the -mm tree.  Its filename is
     mm-shuffle-remove-dynamic-reconfiguration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-shuffle-remove-dynamic-reconfiguration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-shuffle-remove-dynamic-reconfiguration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
