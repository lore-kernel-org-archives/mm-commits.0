From: akpm@linux-foundation.org
Subject: [merged]
 slab-replace-smp_read_barrier_depends-with-lockless_dereference.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:55:47 -0800
Message-ID: <5489e8b3.XV0PEs8XkOahZT0b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537AbaLKSzs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:55:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bobby.prani@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, paulmck@us.ibm.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: replace smp_read_barrier_depends() with lockless_dereference()
has been removed from the -mm tree.  Its filename was
     slab-replace-smp_read_barrier_depends-with-lockless_dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pranith Kumar <bobby.prani@gmail.com>
Subject: slab: replace smp_read_barrier_depends() with lockless_dereference()

Recently lockless_dereference() was added which can be used in place of
hard-coding smp_read_barrier_depends().  The following PATCH makes the
change.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/slab.h~slab-replace-smp_read_barrier_depends-with-lockless_dereference mm/slab.h
--- a/mm/slab.h~slab-replace-smp_read_barrier_depends-with-lockless_dereference
+++ a/mm/slab.h
@@ -209,15 +209,15 @@ cache_from_memcg_idx(struct kmem_cache *
 
 	rcu_read_lock();
 	params = rcu_dereference(s->memcg_params);
-	cachep = params->memcg_caches[idx];
-	rcu_read_unlock();
 
 	/*
 	 * Make sure we will access the up-to-date value. The code updating
 	 * memcg_caches issues a write barrier to match this (see
 	 * memcg_register_cache()).
 	 */
-	smp_read_barrier_depends();
+	cachep = lockless_dereference(params->memcg_caches[idx]);
+	rcu_read_unlock();
+
 	return cachep;
 }
 
_

Patches currently in -mm which might be from bobby.prani@gmail.com are

origin.patch
linux-next.patch

