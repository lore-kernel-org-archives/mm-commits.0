From: akpm@linux-foundation.org
Subject: [merged] revert-gfp-add-__gfp_noaccount.patch removed from -mm
 tree
Date: Fri, 15 Jan 2016 14:32:13 -0800
Message-ID: <5699736d.twtA3uKXr3o+VYx2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbcAOWcO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:32:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, cl@linux.com, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@kernel.org, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "gfp: add __GFP_NOACCOUNT"
has been removed from the -mm tree.  Its filename was
     revert-gfp-add-__gfp_noaccount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: Revert "gfp: add __GFP_NOACCOUNT"

This reverts commit 8f4fc071b1926d0b2 ("gfp: add __GFP_NOACCOUNT").

Black-list kmem accounting policy (aka __GFP_NOACCOUNT) turned out to be
fragile and difficult to maintain, because there seem to be many more
allocations that should not be accounted than those that should be. 
Besides, false accounting an allocation might result in much worse
consequences than not accounting at all, namely increased memory
consumption due to pinned dead kmem caches.

So it was decided to switch to the white-list policy.  This patch reverts
bits introducing the black-list policy.  The white-list policy will be
introduced later in the series.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h        |    2 --
 include/linux/memcontrol.h |    2 --
 mm/kmemleak.c              |    3 +--
 3 files changed, 1 insertion(+), 6 deletions(-)

diff -puN include/linux/gfp.h~revert-gfp-add-__gfp_noaccount include/linux/gfp.h
--- a/include/linux/gfp.h~revert-gfp-add-__gfp_noaccount
+++ a/include/linux/gfp.h
@@ -30,7 +30,6 @@ struct vm_area_struct;
 #define ___GFP_HARDWALL		0x20000u
 #define ___GFP_THISNODE		0x40000u
 #define ___GFP_ATOMIC		0x80000u
-#define ___GFP_NOACCOUNT	0x100000u
 #define ___GFP_NOTRACK		0x200000u
 #define ___GFP_DIRECT_RECLAIM	0x400000u
 #define ___GFP_OTHER_NODE	0x800000u
@@ -104,7 +103,6 @@ struct vm_area_struct;
 #define __GFP_HIGH	((__force gfp_t)___GFP_HIGH)
 #define __GFP_MEMALLOC	((__force gfp_t)___GFP_MEMALLOC)
 #define __GFP_NOMEMALLOC ((__force gfp_t)___GFP_NOMEMALLOC)
-#define __GFP_NOACCOUNT	((__force gfp_t)___GFP_NOACCOUNT)
 
 /*
  * Reclaim modifiers
diff -puN include/linux/memcontrol.h~revert-gfp-add-__gfp_noaccount include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~revert-gfp-add-__gfp_noaccount
+++ a/include/linux/memcontrol.h
@@ -773,8 +773,6 @@ static inline bool __memcg_kmem_bypass(g
 {
 	if (!memcg_kmem_enabled())
 		return true;
-	if (gfp & __GFP_NOACCOUNT)
-		return true;
 	if (in_interrupt() || (!current->mm) || (current->flags & PF_KTHREAD))
 		return true;
 	return false;
diff -puN mm/kmemleak.c~revert-gfp-add-__gfp_noaccount mm/kmemleak.c
--- a/mm/kmemleak.c~revert-gfp-add-__gfp_noaccount
+++ a/mm/kmemleak.c
@@ -122,8 +122,7 @@
 #define BYTES_PER_POINTER	sizeof(void *)
 
 /* GFP bitmask for kmemleak internal allocations */
-#define gfp_kmemleak_mask(gfp)	(((gfp) & (GFP_KERNEL | GFP_ATOMIC | \
-					   __GFP_NOACCOUNT)) | \
+#define gfp_kmemleak_mask(gfp)	(((gfp) & (GFP_KERNEL | GFP_ATOMIC)) | \
 				 __GFP_NORETRY | __GFP_NOMEMALLOC | \
 				 __GFP_NOWARN)
 
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-add-page_check_address_transhuge-helper.patch
mm-memcontrol-allow-to-disable-kmem-accounting-for-cgroup2.patch
net-drop-tcp_memcontrolc.patch
mm-memcontrol-charge-swap-to-cgroup2.patch
mm-vmscan-pass-memcg-to-get_scan_count.patch
mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online.patch
swaph-move-memcg-related-stuff-to-the-end-of-the-file.patch
mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit.patch
mm-free-swap-cache-aggressively-if-memcg-swap-is-full.patch
documentation-cgroup-add-memoryswapcurrentmax-description.patch

