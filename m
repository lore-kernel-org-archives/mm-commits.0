Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB90F33BBB9;
	Tue, 22 Sep 2026 03:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790048999; cv=none; b=RIqQFnzhAPlxBcV/mO0cxTURIUTsv/79S/sFpwKBQX+QuFtkCQyhYNjBvU0RfLmdjXvEKnXn0vfk/elXHW8NpU0go0OP3pVAaXUVZiuF9PXDCYGAFAX6TREJMvADopOfBFWIogbTsCT5l3FXsn6Vqgei8zS4Y9tdFglVYNq1dj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790048999; c=relaxed/simple;
	bh=4gLimFfwJ5kFypJXAx81/U1deun6pvYXVvHJ7VJuRj8=;
	h=Date:To:From:Subject:Message-Id; b=I5LyyoHnO40Y8CrRK+vMgp+3UbMdtdFWno0ji9ceZtXnS4JKSeXCuPNYHLSDLOaTNfQaG0x5IPO85y7ZAcXOJs+MH9VdkkLDfgLAgOcnF9kZgilPGFy3u+YmvJR8Ph0bY0eRIb8pfVNSPWgHQfAtXi3ybKxuM1UhU2SKYwyIPqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0PNOuBEN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0PNOuBEN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553D41F000FF;
	Tue, 22 Sep 2026 03:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790048997;
	bh=e2kdCDeEueRZ0sxl4zVMwhHaHn/H+jEsqS5cdQwbXt8=;
	h=Date:To:From:Subject;
	b=0PNOuBEN84yIfOcywP1S1D+FsiWrNlwo6cXBtd7GJOtjDNfDBqo4+LXVR/DTEOsa/
	 xCHaP1JiEkQ5ivktuXDtOUxwXhbhBzNYanTlbRt9WzUfpyc4P/IoEXaWQ3vEDFJ6+E
	 7mMEa8o2WFKtA++eA5Nqbxzhp3JA3Vi1cXe9oGoE=
Date: Mon, 21 Sep 2026 20:49:56 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,osalvador@suse.de,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,david@kernel.org,chris@chrisdown.name,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-migrate-per-node-hugetlb-lruvec-stat-together-with-hugetlb-folio.patch added to mm-new branch
Message-Id: <20260922034957.553D41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcg: migrate per-node hugetlb lruvec stat together with hugetlb folio
has been added to the -mm mm-new branch.  Its filename is
     mm-memcg-migrate-per-node-hugetlb-lruvec-stat-together-with-hugetlb-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-migrate-per-node-hugetlb-lruvec-stat-together-with-hugetlb-folio.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
mm-hugetlb-account-migration-target-folio-in-per-node-nr_hugetlb-vmstat.patch
mm-memcg-migrate-per-node-hugetlb-lruvec-stat-together-with-hugetlb-folio.patch

