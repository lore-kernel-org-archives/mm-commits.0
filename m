Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8C8361977;
	Wed, 23 Sep 2026 01:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790128177; cv=none; b=pQyc42MO1tTGxPcthcujAotpfmlp26hU66cUBe5OStC/Nm7i9cz8O2HZAgeujgLTuFPh/nD7ep/wlAsie81tz70Aka7lp9+6I6/QRXfNaDlwVo3XNk7Ub5UrYJRODPfBLD2gyggd1TVnSTa7gocJjNpXlo53tdETf26y1/0O6QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790128177; c=relaxed/simple;
	bh=e6hBqRr7szoTZeT7sWo4ffRhyJnKOWXS1C1lv8F+qd8=;
	h=Date:To:From:Subject:Message-Id; b=pmgOaWulrRgKlGQAcEGkv1X1B46X8+jcYEXR4F7h9GalpxKaoN1wg1T4ELz+sg6kYjK4Kfw+6hk0QnO8hPGmmlz0n1yCS144aVHgm/Pxk7JPA3c5g1z8iBc35kbp+zCXykG/qycgymoi9yCSNYCzjnYdHzKbeS8lftGFJSfcm+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BAM0geyR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BAM0geyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2B91F00893;
	Wed, 23 Sep 2026 01:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790128176;
	bh=Bs12zx4/6h5scsewjKKcecmQkKa10mP0qpHwayTPuL4=;
	h=Date:To:From:Subject;
	b=BAM0geyRGLMIFkoEDjqybxnOGow3vvx5pxcbEWJo6IZAwVZ+zFM67fdoPjKiX7pFY
	 LlN3JZH3BJ+y/aj4mJ/ODzeY9ymMr+V4tU0Osl9nD+9S13wuoRcIV5A9TBSil8VVOj
	 KnGHGh3hBQo3yxoZaFhchJlc6T3PkJrbWdeRfx7k=
Date: Tue, 22 Sep 2026 18:49:35 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,osalvador@suse.de,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,david@kernel.org,chris@chrisdown.name,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memcg-migrate-per-node-hugetlb-lruvec-stat-together-with-hugetlb-folio.patch removed from -mm tree
Message-Id: <20260923014936.0E2B91F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcg: migrate per-node hugetlb lruvec stat together with hugetlb folio
has been removed from the -mm tree.  Its filename was
     mm-memcg-migrate-per-node-hugetlb-lruvec-stat-together-with-hugetlb-folio.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm/memcg: migrate per-node hugetlb lruvec stat together with hugetlb folio
Date: Mon, 21 Sep 2026 17:12:35 +0800

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

Link: https://lore.kernel.org/20260921-for-hugetlb_state-v1-2-8a6eec92661f@kylinos.cn
Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/memcontrol.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-migrate-per-node-hugetlb-lruvec-stat-together-with-hugetlb-folio
+++ a/mm/memcontrol.c
@@ -5662,6 +5662,34 @@ void mem_cgroup_replace_folio(struct fol
 	rcu_read_unlock();
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+static void move_hugetlb_lruvec_stat(struct obj_cgroup *objcg,
+				     struct folio *old, struct folio *new)
+{
+	long nr_pages = folio_nr_pages(old);
+	struct mem_cgroup *memcg;
+	int old_nid = folio_nid(old);
+	int new_nid = folio_nid(new);
+
+	if (old_nid == new_nid)
+		return;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(old_nid)),
+			       NR_HUGETLB, -nr_pages);
+	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(new_nid)),
+			       NR_HUGETLB, nr_pages);
+	rcu_read_unlock();
+}
+#else /* CONFIG_HUGETLB_PAGE */
+static inline void move_hugetlb_lruvec_stat(struct obj_cgroup *objcg,
+					    struct folio *old,
+					    struct folio *new)
+{
+}
+#endif /* CONFIG_HUGETLB_PAGE */
+
 /**
  * mem_cgroup_migrate - Transfer the memcg data from the old to the new folio.
  * @old: Currently circulating folio.
@@ -5699,6 +5727,9 @@ void mem_cgroup_migrate(struct folio *ol
 
 	new_objcg = get_migration_objcg(old, new);
 
+	if (folio_test_hugetlb(old))
+		move_hugetlb_lruvec_stat(new_objcg, old, new);
+
 	/*
 	 * @old was charged through a non-root objcg, so its charge is in the
 	 * page counters. If the re-derivation walked up to the root objcg -
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-use-a-folio-in-the-softleaf_is_device_private-path.patch
mm-hugetlb-fix-resv_huge_pages-double-decrement-in-memfd-error-path.patch
mm-memcontrol-remove-unused-memcg-parameter-in-calculate_high_delay.patch
selftests-mm-khugepaged-consolidate-error-exits-via-kselftest-helpers.patch
mm-page_owner-preserve-original-free_pid-free_tgid-during-folio-migration.patch
mm-memfd-fix-hugetlb-reservation-accounting-in-error-paths.patch
selftests-mm-fix-ptrace-peekdata-check-in-memfd_secret-test.patch
mm-hugetlb_cgroup-move-per-node-usage-on-cross-node-migration.patch
mm-hugetlb_cgroup-move-per-node-usage-on-cgroup-reparenting.patch

