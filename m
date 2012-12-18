From: akpm@linux-foundation.org
Subject: [folded-dropped] slub-slub-specific-propagation-changes-fix.patch removed from -mm tree
Date: Tue, 18 Dec 2012 14:15:16 -0800
Message-ID: <20121218221516.7220582004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:37690 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab2LRWPS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 17:15:18 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so145173yen.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 14:15:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, fweisbec@redhat.com, glommer@parallels.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slub-slub-specific-propagation-changes-fix
has been removed from the -mm tree.  Its filename was
     slub-slub-specific-propagation-changes-fix.patch

This patch was dropped because it was folded into slub-slub-specific-propagation-changes.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: slub-slub-specific-propagation-changes-fix

tweak code to avoid __maybe_unused

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: JoonSoo Kim <js1304@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN mm/slub.c~slub-slub-specific-propagation-changes-fix mm/slub.c
--- a/mm/slub.c~slub-slub-specific-propagation-changes-fix
+++ a/mm/slub.c
@@ -5092,7 +5092,6 @@ static ssize_t slab_attr_store(struct ko
 	struct slab_attribute *attribute;
 	struct kmem_cache *s;
 	int err;
-	int i __maybe_unused;
 
 	attribute = to_slab_attr(attr);
 	s = to_slab(kobj);
@@ -5102,23 +5101,24 @@ static ssize_t slab_attr_store(struct ko
 
 	err = attribute->store(s, buf, len);
 #ifdef CONFIG_MEMCG_KMEM
-	if (slab_state < FULL)
-		return err;
+	if (slab_state >= FULL && err >= 0 && is_root_cache(s)) {
+		int i;
 
-	if ((err < 0) || !is_root_cache(s))
-		return err;
-
-	mutex_lock(&slab_mutex);
-	if (s->max_attr_size < len)
-		s->max_attr_size = len;
-
-	for_each_memcg_cache_index(i) {
-		struct kmem_cache *c = cache_from_memcg(s, i);
-		if (c)
-			/* return value determined by the parent cache only */
-			attribute->store(c, buf, len);
+		mutex_lock(&slab_mutex);
+		if (s->max_attr_size < len)
+			s->max_attr_size = len;
+
+		for_each_memcg_cache_index(i) {
+			struct kmem_cache *c = cache_from_memcg(s, i);
+			/*
+			 * This function's return value is determined by the
+			 * parent cache only
+			 */
+			if (c)
+				attribute->store(c, buf, len);
+		}
+		mutex_unlock(&slab_mutex);
 	}
-	mutex_unlock(&slab_mutex);
 #endif
 	return err;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
irq-tsk-comm-is-an-array.patch
memory-hotplug-document-and-enable-config_movable_node.patch
memcg-kmem-accounting-basic-infrastructure.patch
slub-slub-specific-propagation-changes.patch
mm-mprotectc-coding-style-cleanups.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2.patch
mm-avoid-possible-deadlock-caused-by-too_many_isolated-fix.patch

