From: akpm@linux-foundation.org
Subject: [merged]
 memcg-only-account-kmem-allocations-marked-as-__gfp_account.patch removed
 from -mm tree
Date: Fri, 15 Jan 2016 14:32:16 -0800
Message-ID: <56997370.4EEhoazZAuW4vzhU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbcAOWcR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:32:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, cl@linux.com, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: only account kmem allocations marked as __GFP_ACCOUNT
has been removed from the -mm tree.  Its filename was
     memcg-only-account-kmem-allocations-marked-as-__gfp_account.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: memcg: only account kmem allocations marked as __GFP_ACCOUNT

Black-list kmem accounting policy (aka __GFP_NOACCOUNT) turned out to be
fragile and difficult to maintain, because there seem to be many more
allocations that should not be accounted than those that should be. 
Besides, false accounting an allocation might result in much worse
consequences than not accounting at all, namely increased memory
consumption due to pinned dead kmem caches.

So this patch switches kmem accounting to the white-policy: now only those
kmem allocations that are marked as __GFP_ACCOUNT are accounted to memcg. 
Currently, no kmem allocations are marked like this.  The following
patches will mark several kmem allocations that are known to be easily
triggered from userspace and therefore should be accounted to memcg.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h        |    9 +++++++++
 include/linux/memcontrol.h |    2 ++
 mm/page_alloc.c            |    3 ++-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff -puN include/linux/gfp.h~memcg-only-account-kmem-allocations-marked-as-__gfp_account include/linux/gfp.h
--- a/include/linux/gfp.h~memcg-only-account-kmem-allocations-marked-as-__gfp_account
+++ a/include/linux/gfp.h
@@ -30,6 +30,7 @@ struct vm_area_struct;
 #define ___GFP_HARDWALL		0x20000u
 #define ___GFP_THISNODE		0x40000u
 #define ___GFP_ATOMIC		0x80000u
+#define ___GFP_ACCOUNT		0x100000u
 #define ___GFP_NOTRACK		0x200000u
 #define ___GFP_DIRECT_RECLAIM	0x400000u
 #define ___GFP_OTHER_NODE	0x800000u
@@ -72,11 +73,15 @@ struct vm_area_struct;
  *
  * __GFP_THISNODE forces the allocation to be satisified from the requested
  *   node with no fallbacks or placement policy enforcements.
+ *
+ * __GFP_ACCOUNT causes the allocation to be accounted to kmemcg (only relevant
+ *   to kmem allocations).
  */
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)
 #define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL)
 #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)
+#define __GFP_ACCOUNT	((__force gfp_t)___GFP_ACCOUNT)
 
 /*
  * Watermark modifiers -- controls access to emergency reserves
@@ -195,6 +200,9 @@ struct vm_area_struct;
  * GFP_KERNEL is typical for kernel-internal allocations. The caller requires
  *   ZONE_NORMAL or a lower zone for direct access but can direct reclaim.
  *
+ * GFP_KERNEL_ACCOUNT is the same as GFP_KERNEL, except the allocation is
+ *   accounted to kmemcg.
+ *
  * GFP_NOWAIT is for kernel allocations that should not stall for direct
  *   reclaim, start physical IO or use any filesystem callback.
  *
@@ -234,6 +242,7 @@ struct vm_area_struct;
  */
 #define GFP_ATOMIC	(__GFP_HIGH|__GFP_ATOMIC|__GFP_KSWAPD_RECLAIM)
 #define GFP_KERNEL	(__GFP_RECLAIM | __GFP_IO | __GFP_FS)
+#define GFP_KERNEL_ACCOUNT (GFP_KERNEL | __GFP_ACCOUNT)
 #define GFP_NOWAIT	(__GFP_KSWAPD_RECLAIM)
 #define GFP_NOIO	(__GFP_RECLAIM)
 #define GFP_NOFS	(__GFP_RECLAIM | __GFP_IO)
diff -puN include/linux/memcontrol.h~memcg-only-account-kmem-allocations-marked-as-__gfp_account include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-only-account-kmem-allocations-marked-as-__gfp_account
+++ a/include/linux/memcontrol.h
@@ -773,6 +773,8 @@ static inline bool __memcg_kmem_bypass(g
 {
 	if (!memcg_kmem_enabled())
 		return true;
+	if (!(gfp & __GFP_ACCOUNT))
+		return true;
 	if (in_interrupt() || (!current->mm) || (current->flags & PF_KTHREAD))
 		return true;
 	return false;
diff -puN mm/page_alloc.c~memcg-only-account-kmem-allocations-marked-as-__gfp_account mm/page_alloc.c
--- a/mm/page_alloc.c~memcg-only-account-kmem-allocations-marked-as-__gfp_account
+++ a/mm/page_alloc.c
@@ -3402,7 +3402,8 @@ EXPORT_SYMBOL(__free_page_frag);
 
 /*
  * alloc_kmem_pages charges newly allocated pages to the kmem resource counter
- * of the current memory cgroup.
+ * of the current memory cgroup if __GFP_ACCOUNT is set, other than that it is
+ * equivalent to alloc_pages.
  *
  * It should be used when the caller would like to use kmalloc, but since the
  * allocation is large, it has to fall back to the page allocator.
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

