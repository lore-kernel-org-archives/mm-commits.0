From: akpm@linux-foundation.org
Subject: [merged] slab-print-slabinfo-header-in-seq-show.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 10:55:38 -0800
Message-ID: <5489e8aa.MRlccAVcfgPDoEFN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758507AbaLKSzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:55:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: print slabinfo header in seq show
has been removed from the -mm tree.  Its filename was
     slab-print-slabinfo-header-in-seq-show.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slab: print slabinfo header in seq show

Currently we print the slabinfo header in the seq start method, which
makes it unusable for showing leaks, so we have leaks_show, which does
practically the same as s_show except it doesn't show the header. 
However, we can print the header in the seq show method - we only need to
check if the current element is the first on the list.  This will allow us
to use the same set of seq iterators for both leaks and slabinfo
reporting, which is nice.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |    8 +-------
 mm/slab.h        |    1 +
 mm/slab_common.c |   15 ++++++---------
 3 files changed, 8 insertions(+), 16 deletions(-)

diff -puN mm/slab.c~slab-print-slabinfo-header-in-seq-show mm/slab.c
--- a/mm/slab.c~slab-print-slabinfo-header-in-seq-show
+++ a/mm/slab.c
@@ -4043,12 +4043,6 @@ ssize_t slabinfo_write(struct file *file
 
 #ifdef CONFIG_DEBUG_SLAB_LEAK
 
-static void *leaks_start(struct seq_file *m, loff_t *pos)
-{
-	mutex_lock(&slab_mutex);
-	return seq_list_start(&slab_caches, *pos);
-}
-
 static inline int add_caller(unsigned long *n, unsigned long v)
 {
 	unsigned long *p;
@@ -4170,7 +4164,7 @@ static int leaks_show(struct seq_file *m
 }
 
 static const struct seq_operations slabstats_op = {
-	.start = leaks_start,
+	.start = slab_start,
 	.next = slab_next,
 	.stop = slab_stop,
 	.show = leaks_show,
diff -puN mm/slab.h~slab-print-slabinfo-header-in-seq-show mm/slab.h
--- a/mm/slab.h~slab-print-slabinfo-header-in-seq-show
+++ a/mm/slab.h
@@ -357,6 +357,7 @@ static inline struct kmem_cache_node *ge
 
 #endif
 
+void *slab_start(struct seq_file *m, loff_t *pos);
 void *slab_next(struct seq_file *m, void *p, loff_t *pos);
 void slab_stop(struct seq_file *m, void *p);
 
diff -puN mm/slab_common.c~slab-print-slabinfo-header-in-seq-show mm/slab_common.c
--- a/mm/slab_common.c~slab-print-slabinfo-header-in-seq-show
+++ a/mm/slab_common.c
@@ -834,14 +834,9 @@ void print_slabinfo_header(struct seq_fi
 	seq_putc(m, '\n');
 }
 
-static void *s_start(struct seq_file *m, loff_t *pos)
+void *slab_start(struct seq_file *m, loff_t *pos)
 {
-	loff_t n = *pos;
-
 	mutex_lock(&slab_mutex);
-	if (!n)
-		print_slabinfo_header(m);
-
 	return seq_list_start(&slab_caches, *pos);
 }
 
@@ -903,10 +898,12 @@ int cache_show(struct kmem_cache *s, str
 	return 0;
 }
 
-static int s_show(struct seq_file *m, void *p)
+static int slab_show(struct seq_file *m, void *p)
 {
 	struct kmem_cache *s = list_entry(p, struct kmem_cache, list);
 
+	if (p == slab_caches.next)
+		print_slabinfo_header(m);
 	if (!is_root_cache(s))
 		return 0;
 	return cache_show(s, m);
@@ -926,10 +923,10 @@ static int s_show(struct seq_file *m, vo
  * + further values on SMP and with statistics enabled
  */
 static const struct seq_operations slabinfo_op = {
-	.start = s_start,
+	.start = slab_start,
 	.next = slab_next,
 	.stop = slab_stop,
-	.show = s_show,
+	.show = slab_show,
 };
 
 static int slabinfo_open(struct inode *inode, struct file *file)
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
memcg-zap-kmem_account_flags.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone-fix.patch
memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch
linux-next.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch

