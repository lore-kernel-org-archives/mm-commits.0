Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832258;
	b=GcXRk9TFGdNeqoFolRm4lETjaTW+9ybEUVrWOLUlwmvVHf2se2d5rNNhhfLlOC16EUtM
	 zsSI/ZujkSwpQiaxWlGvvnIysZA09nxL/xLb14VXsFgQfknlJR/azPq/RJtwRXHihboU7
	 ha0cBytgAMhkHQjciz9bJE2LJSdEE5oexG9eD88VVnwnX1YIR8y2NzJapiGnuKi6DLNjD
	 YkmFczBRo6CCAN+GGwwAAKd/ymobLGewbDNj8iufe4YIJW9DRM1PwoEW/GItfOvTB1W5k
	 DJj8HHWQuGUuJOYpuJI0RN0LaFrFJ6eQoe0XX9uLdRx/Y75dbb76oR0rdMvCWOispkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832258;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=7FF7ut+g2bzGoIAQSyAHpjtvKeZal/aOPMZvIqR5SMM=;
	b=S+acAcwVw0apzcdhefQAFv6ni297PXpoJgpEtsHLWlzVx5+60rsLvotJBEdN/Ec6VjdH
	 3BZK43z5OAWYFKphWxM4GLttz5xY9k2WN3NV1dFQIO9n3z8HrRG7KTig58I+Avn9WrERC
	 9/1icbkCWGipU2eYBHTUQF8unxNFmiwzqWxNkECp+YyENUIETKq8O7zEbvE6eGUUL6Iuy
	 hkTyd4eTayLHFN5bb4egZsB49wvRoD1Oxn/nSoeM07Au+zvg5n3zZSYuVPRSD5uS7JPq+
	 FCdvtYyDUElSWnjfobc6EKSq9Zcd6NV6iCyNfl8fERtf7+EutEmp4lvz2hwnpbqQVSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WOiXiwGF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12843606A31E;
	Sat, 24 Oct 2026 08:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WOiXiwGF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889631F01825;
	Sat, 24 Oct 2026 08:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832257;
	bh=7FF7ut+g2bzGoIAQSyAHpjtvKeZal/aOPMZvIqR5SMM=;
	h=Date:To:From:Subject;
	b=WOiXiwGFCYl8M0GYIATm5Xfj6zXPYwPLqqdce0jBHEsA2/p/x1E2hHFPs3jCLK3WV
	 XwCoQm/w9AGL0zjtp5o7uH7MBhazn4JurpHBpxhY4r6XZ8UqJ+M6N7B8FPHrDwpZiv
	 se6MyiHsVWcZr3QtDJZqVtpZMmva1KYBB9PPznxk=
Date: Sat, 24 Oct 2026 01:57:37 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,osalvador@suse.de,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,david@kernel.org,chris@chrisdown.name,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-migrate-per-node-hugetlb-lruvec-stat-together-with-hugetlb-folio.patch removed from -mm tree
Message-Id: <20261024085737.889631F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/memcg: migrate per-node hugetlb lruvec stat together with hugetlb folio
has been removed from the -mm tree.  Its filename was
     mm-memcg-migrate-per-node-hugetlb-lruvec-stat-together-with-hugetlb-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm/memcg: migrate per-node hugetlb lruvec stat together with hugetlb folio
Date: Wed, 23 Sep 2026 10:05:16 +0800

memory.numa_stat exposes per-node hugetlb counters from per-node lruvec
stats.  These stats are accounted against folio_nid(): incremented on the
folio's node when handed to a user, decremented when the folio is returned
to the pool.

During hugetlb folio migration, mem_cgroup_migrate() moves the charge to
the new folio and drops the memcg data of the old one, so the free of the
old folio right after the migration skips the memcg per-node lruvec
decrement.  The hugetlb count stays attributed to the old node for the
rest of the life of the charge, while the target folio gets no increment
on the new node; its later free decrements a counter that was never
incremented.

Migrate the per-node lruvec accounting alongside migration.  Global memcg
totals remain balanced because they track resource consumption, not node
placement.

Link: https://lore.kernel.org/20260923-for-hugetlb_state3-v2-2-e8a36245bfab@kylinos.cn
Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Chris Down <chris@chrisdown.name>
Cc: <stable@vger.kernel.org>
---

 include/linux/memcontrol.h |    8 ++++++++
 mm/hugetlb.c               |   25 +++++++++++++++++++++++++
 mm/memcontrol.c            |    5 ++---
 3 files changed, 35 insertions(+), 3 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-migrate-per-node-hugetlb-lruvec-stat-together-with-hugetlb-folio
+++ a/include/linux/memcontrol.h
@@ -983,6 +983,9 @@ unsigned long lruvec_page_state_monotoni
 unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 				      enum node_stat_item idx);
 
+void mod_memcg_lruvec_state(struct lruvec *lruvec,
+			    enum node_stat_item idx, int val);
+
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
 
@@ -1451,6 +1454,11 @@ static inline unsigned long lruvec_page_
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
 
+static inline void mod_memcg_lruvec_state(struct lruvec *lruvec,
+					  enum node_stat_item idx, int val)
+{
+}
+
 static inline void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 {
 }
--- a/mm/hugetlb.c~mm-memcg-migrate-per-node-hugetlb-lruvec-stat-together-with-hugetlb-folio
+++ a/mm/hugetlb.c
@@ -23,6 +23,7 @@
 #include <linux/mmdebug.h>
 #include <linux/sched/signal.h>
 #include <linux/rmap.h>
+#include <linux/rcupdate.h>
 #include <linux/string_choices.h>
 #include <linux/string_helpers.h>
 #include <linux/swap.h>
@@ -7396,12 +7397,36 @@ void folio_putback_hugetlb(struct folio
 	folio_put(folio);
 }
 
+static void move_hugetlb_lruvec_stat(struct folio *old_folio,
+				     struct folio *new_folio)
+{
+	struct mem_cgroup *memcg;
+	long nr_pages = folio_nr_pages(old_folio);
+	int old_nid = folio_nid(old_folio);
+	int new_nid = folio_nid(new_folio);
+
+	if (old_nid == new_nid)
+		return;
+
+	guard(rcu)();
+
+	memcg = folio_memcg(new_folio);
+	if (!memcg)
+		return;
+
+	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(old_nid)),
+			       NR_HUGETLB, -nr_pages);
+	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(new_nid)),
+			       NR_HUGETLB, nr_pages);
+}
+
 void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio,
 			enum migrate_reason reason)
 {
 	struct hstate *h = folio_hstate(old_folio);
 
 	hugetlb_cgroup_migrate(old_folio, new_folio);
+	move_hugetlb_lruvec_stat(old_folio, new_folio);
 	folio_set_owner_migrate_reason(new_folio, reason);
 
 	/*
--- a/mm/memcontrol.c~mm-memcg-migrate-per-node-hugetlb-lruvec-stat-together-with-hugetlb-folio
+++ a/mm/memcontrol.c
@@ -1015,9 +1015,8 @@ static void __mod_memcg_lruvec_state(str
 	put_cpu();
 }
 
-static void mod_memcg_lruvec_state(struct lruvec *lruvec,
-				     enum node_stat_item idx,
-				     int val)
+void mod_memcg_lruvec_state(struct lruvec *lruvec,
+			    enum node_stat_item idx, int val)
 {
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup_per_node *pn;
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are


