From: akpm@linux-foundation.org
Subject: + gfp-add-__gfp_noaccount.patch added to -mm tree
Date: Tue, 05 May 2015 14:26:51 -0700
Message-ID: <5549359b.dmJyoIeTiM+XJiaM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946008AbbEEV0w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2015 17:26:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, gregkh@linuxfoundation.org, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, stable@vger.kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: gfp: add __GFP_NOACCOUNT
has been added to the -mm tree.  Its filename is
     gfp-add-__gfp_noaccount.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gfp-add-__gfp_noaccount.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gfp-add-__gfp_noaccount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: gfp: add __GFP_NOACCOUNT

Not all kmem allocations should be accounted to memcg.  The following
patch ("kernfs: do not account ino_ida allocations to memcg") gives an
example where accounting of a certain type of allocations to memcg can
effectively result in a memory leak.

This patch adds the __GFP_NOACCOUNT flag which if passed to kmalloc and
friends will force the allocation to go through the root cgroup.  It will
be used by the next patch.

Note, since in case of kmemleak enabled each kmalloc implies yet another
allocation from the kmemleak_object cache, we add __GFP_NOACCOUNT to
gfp_kmemleak_mask.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>	[4.0.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h        |    2 ++
 include/linux/memcontrol.h |    4 ++++
 mm/kmemleak.c              |    3 ++-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff -puN include/linux/gfp.h~gfp-add-__gfp_noaccount include/linux/gfp.h
--- a/include/linux/gfp.h~gfp-add-__gfp_noaccount
+++ a/include/linux/gfp.h
@@ -30,6 +30,7 @@ struct vm_area_struct;
 #define ___GFP_HARDWALL		0x20000u
 #define ___GFP_THISNODE		0x40000u
 #define ___GFP_RECLAIMABLE	0x80000u
+#define ___GFP_NOACCOUNT	0x100000u
 #define ___GFP_NOTRACK		0x200000u
 #define ___GFP_NO_KSWAPD	0x400000u
 #define ___GFP_OTHER_NODE	0x800000u
@@ -87,6 +88,7 @@ struct vm_area_struct;
 #define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL) /* Enforce hardwall cpuset memory allocs */
 #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)/* No fallback, no policies */
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE) /* Page is reclaimable */
+#define __GFP_NOACCOUNT	((__force gfp_t)___GFP_NOACCOUNT) /* Don't account to memcg */
 #define __GFP_NOTRACK	((__force gfp_t)___GFP_NOTRACK)  /* Don't track with kmemcheck */
 
 #define __GFP_NO_KSWAPD	((__force gfp_t)___GFP_NO_KSWAPD)
diff -puN include/linux/memcontrol.h~gfp-add-__gfp_noaccount include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~gfp-add-__gfp_noaccount
+++ a/include/linux/memcontrol.h
@@ -463,6 +463,8 @@ memcg_kmem_newpage_charge(gfp_t gfp, str
 	if (!memcg_kmem_enabled())
 		return true;
 
+	if (gfp & __GFP_NOACCOUNT)
+		return true;
 	/*
 	 * __GFP_NOFAIL allocations will move on even if charging is not
 	 * possible. Therefore we don't even try, and have this allocation
@@ -522,6 +524,8 @@ memcg_kmem_get_cache(struct kmem_cache *
 {
 	if (!memcg_kmem_enabled())
 		return cachep;
+	if (gfp & __GFP_NOACCOUNT)
+		return cachep;
 	if (gfp & __GFP_NOFAIL)
 		return cachep;
 	if (in_interrupt() || (!current->mm) || (current->flags & PF_KTHREAD))
diff -puN mm/kmemleak.c~gfp-add-__gfp_noaccount mm/kmemleak.c
--- a/mm/kmemleak.c~gfp-add-__gfp_noaccount
+++ a/mm/kmemleak.c
@@ -115,7 +115,8 @@
 #define BYTES_PER_POINTER	sizeof(void *)
 
 /* GFP bitmask for kmemleak internal allocations */
-#define gfp_kmemleak_mask(gfp)	(((gfp) & (GFP_KERNEL | GFP_ATOMIC)) | \
+#define gfp_kmemleak_mask(gfp)	(((gfp) & (GFP_KERNEL | GFP_ATOMIC | \
+					   __GFP_NOACCOUNT)) | \
 				 __GFP_NORETRY | __GFP_NOMEMALLOC | \
 				 __GFP_NOWARN)
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

gfp-add-__gfp_noaccount.patch
kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
fix-a-misaligned-load-inside-ptrace_attach.patch
change-wait_on_bit-to-take-an-unsigned-long-not-a-void.patch
change-all-uses-of-jobctl_-from-int-to-long.patch

