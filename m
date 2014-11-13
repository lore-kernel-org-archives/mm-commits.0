From: akpm@linux-foundation.org
Subject: +
 slab-replace-smp_read_barrier_depends-with-lockless_dereference.patch added to -mm tree
Date: Thu, 13 Nov 2014 13:41:22 -0800
Message-ID: <54652582.pubL9uAnSlSx4ySS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934734AbaKMVlX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Nov 2014 16:41:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bobby.prani@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, paulmck@us.ibm.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: replace smp_read_barrier_depends() with lockless_dereference()
has been added to the -mm tree.  Its filename is
     slab-replace-smp_read_barrier_depends-with-lockless_dereference.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-replace-smp_read_barrier_depends-with-lockless_dereference.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/slab-replace-smp_read_barrier_depends-with-lockless_dereference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

slab-replace-smp_read_barrier_depends-with-lockless_dereference.patch
ksm-replace-smp_read_barrier_depends-with-lockless_dereference.patch
linux-next.patch

