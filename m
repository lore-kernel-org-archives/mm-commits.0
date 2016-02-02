From: akpm@linux-foundation.org
Subject: + mm-workingset-define-radix-entry-eviction-mask.patch added to
 -mm tree
Date: Tue, 02 Feb 2016 14:36:34 -0800
Message-ID: <56b12f72.Z7Ji5imRt0Yb6vSk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60782 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbcBBWgf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 17:36:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: #define radix entry eviction mask
has been added to the -mm tree.  Its filename is
     mm-workingset-define-radix-entry-eviction-mask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-workingset-define-radix-entry-eviction-mask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-workingset-define-radix-entry-eviction-mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: workingset: #define radix entry eviction mask

This is a compile-time constant, no need to calculate it on refault.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/workingset.c~mm-workingset-define-radix-entry-eviction-mask mm/workingset.c
--- a/mm/workingset.c~mm-workingset-define-radix-entry-eviction-mask
+++ a/mm/workingset.c
@@ -152,6 +152,10 @@
  * refault distance will immediately activate the refaulting page.
  */
 
+#define EVICTION_SHIFT	(RADIX_TREE_EXCEPTIONAL_ENTRY + \
+			 ZONES_SHIFT + NODES_SHIFT)
+#define EVICTION_MASK	(~0UL >> EVICTION_SHIFT)
+
 static void *pack_shadow(unsigned long eviction, struct zone *zone)
 {
 	eviction = (eviction << NODES_SHIFT) | zone_to_nid(zone);
@@ -168,7 +172,6 @@ static void unpack_shadow(void *shadow,
 	unsigned long entry = (unsigned long)shadow;
 	unsigned long eviction;
 	unsigned long refault;
-	unsigned long mask;
 	int zid, nid;
 
 	entry >>= RADIX_TREE_EXCEPTIONAL_SHIFT;
@@ -181,8 +184,7 @@ static void unpack_shadow(void *shadow,
 	*zone = NODE_DATA(nid)->node_zones + zid;
 
 	refault = atomic_long_read(&(*zone)->inactive_age);
-	mask = ~0UL >> (NODES_SHIFT + ZONES_SHIFT +
-			RADIX_TREE_EXCEPTIONAL_SHIFT);
+
 	/*
 	 * The unsigned subtraction here gives an accurate distance
 	 * across inactive_age overflows in most cases.
@@ -199,7 +201,7 @@ static void unpack_shadow(void *shadow,
 	 * inappropriate activation leading to pressure on the active
 	 * list is not a problem.
 	 */
-	*distance = (refault - eviction) & mask;
+	*distance = (refault - eviction) & EVICTION_MASK;
 }
 
 /**
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

proc-revert-proc-pid-maps-annotation.patch
mm-memcontrol-drop-superfluous-entry-in-the-per-memcg-stats-array.patch
documentation-cgroup-v2-add-memorystat-sock-description.patch
mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding.patch
mm-workingset-define-radix-entry-eviction-mask.patch
mm-workingset-separate-shadow-unpacking-and-refault-calculation.patch
mm-workingset-eviction-buckets-for-bigmem-lowbit-machines.patch
mm-workingset-per-cgroup-cache-thrash-detection.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch

