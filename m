From: akpm@linux-foundation.org
Subject: +
 mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations-fix.patch
 added to -mm tree
Date: Sat, 20 Jun 2020 18:05:19 -0700
Message-ID: <20200621010519.2rjFE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728927AbgFUBFW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 20 Jun 2020 21:05:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vjitta@codeaurora.org, vinmenon@codeaurora.org, vbabka@suse.cz, tobin@kernel.org, tj@kernel.org, shakeelb@google.com, rientjes@google.com, penberg@kernel.org, mhocko@kernel.org, mgorman@techsingularity.net, longman@redhat.com, keescook@chromium.org, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, guro@fb.com, dennis@kernel.org, cl@linux.com, akpm@linux-foundation.org


The patch titled
     Subject: mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations-fix
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations-fix

fixups for Vlastoimil's "mm, slab/slub: improve error reporting and
overhead of cache_from_obj()"

Link: http://lkml.kernel.org/r/afeda7ac-748b-33d8-a905-56b708148ad5@suse.cz
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tobin C. Harding <tobin@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/slab.h~mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations-fix
+++ a/mm/slab.h
@@ -456,12 +456,11 @@ static inline struct kmem_cache *cache_f
 	struct kmem_cache *cachep;
 
 	if (!IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) &&
-	    !memcg_kmem_enabled() &&
 	    !kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS))
 		return s;
 
 	cachep = virt_to_cache(x);
-	if (WARN(cachep && !slab_equal_or_root(cachep, s),
+	if (WARN(cachep && cachep != s,
 		  "%s: Wrong slab cache. %s but object is from %s\n",
 		  __func__, s->name, cachep->name))
 		print_tracking(cachep, x);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
