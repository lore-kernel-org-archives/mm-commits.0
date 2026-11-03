Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672148;
	b=4cHGGA6OwRdCQOKbMwllHGRC/TD9BdTXTm9DkKY95qxLc/p/G/urGvrU/91Ro1htOalZ
	 thp/cuASFHVgjy4R5UNPGjmXJW2vnTMJayFdbTVnKDADwwJJQfORXZ6H+2CpY2uA6c6wE
	 FgkZVf9Pz5bClY3Hil66MJMyqZGM2c4cbGQpC4luDoqggzE80HM1gXnQqP/0jYgYbtMOn
	 1iZ+NoVTLc6ckFlo19cw3SqmK/YJfrPkNx1bIV1cvk1ZaqI3KiyhuWli/OsnDfhMwRT/K
	 Rh1LC7G+R21LoHJY07D0vUsNDd9ijB9tw80AmJzppyUp8To0ON+Too5DyFZlyDHgW8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672148;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ieqF8KJ7YD2uenPGC1WgamZRdSnLRXEr4jbCdmRURPM=;
	b=s5lxcfewDsUsS5DPpj1sgFWCYBGyi+lSbKpgyCcYJh2ZilNAgsVnB2Lm05qOgko7ObY2
	 3tuhcXv8LQTp2FHSZNNMSnYo98Iy/ii3zEKw9bq35FFKjmCsUXr8bCctYhoe2LGZ/51GM
	 IAaDXUFa+AUAB8xxttb+RbnpfRPXBOxDfqnMvhd6qAAYcPLs6H7ik1yGClw1Vv+unynQX
	 36bcQLdMrqXsRaJ/0kiGJnc9h5lGwQqPtW2FKjojjE56oGbkbbHozyJs4YcThdynjTpox
	 YCoENC6PmPDfp/JTH3wKDd0FHFn/hCXfAeVbRs6qJQBJd2AAI/oytFJWbigEfcEStSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xqmBzKtf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A1F606A337;
	Tue,  3 Nov 2026 02:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xqmBzKtf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD861F00919;
	Tue,  3 Nov 2026 02:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672147;
	bh=ieqF8KJ7YD2uenPGC1WgamZRdSnLRXEr4jbCdmRURPM=;
	h=Date:To:From:Subject;
	b=xqmBzKtfcgwf196MycRSediNeT4kSd7cKsBr0hbeO2DRxBM94D6uRRNxmhGyGr+4F
	 UIn9o8+3mD+aETUOtqy360bLp0ilEUwU5Z+P9fkEpF7wn3BxLx/j8VXq9ACXZjHbw4
	 kv07MwazwyZpLDtYy13Wc6gOZjk6XotEGr62+nHQ=
Date: Mon, 02 Nov 2026 18:15:47 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	willy@infradead.org,stable@vger.kernel.org,matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,
	apopple@nvidia.com,akpm@linux-foundation.org,laoar.shao@gmail.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate-snapshot-the-source-nid-before-the-misplaced-migration.patch removed from -mm tree
Message-Id: <20261103021547.8BD861F00919@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/migrate: snapshot the source nid before the misplaced migration
has been removed from the -mm tree.  Its filename was
     mm-migrate-snapshot-the-source-nid-before-the-misplaced-migration.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm/migrate: snapshot the source nid before the misplaced migration
Date: Tue, 27 Oct 2026 10:17:20 +0800

A successful migration frees the source folio before the promotion
counter update, so the folio_nid() read there operates on a freed
folio — which may already have been reallocated. It happens to work
today, as Zi explained:

  : Strictly speaking, it can be seen as a benign UAF. It works, because
  : 1. folio->flags happens to be the same as page->flags,
  : 2. folio/page nid is stored in the ->flags and never changed.
  :
  : In memdesc world, after a folio is freed, I assume folio->flags would be
  : zeroed since struct folio is freed and calling folio_nid() on a freed
  : folio would give a bogus result (yeah, it can be mitigated by not
  : zeroing node field and each node has its own struct folio pool, but that
  : makes folio_nid() implementation dependent).

and Matthew explained further:

  : once struct folio is separately allocated, it's a UAF.  It could be
  : recycled to a different NID or maybe the slab containing the folio could
  : be freed (assuming we're not holding the RCU read lock at this point in
  : migration, and I don't see why we would be).

A separate concern is memory hot-removal.  With memory-tiering mode
enabled, successful migration can release the source before the
promotion-accounting folio_nid() read.  If the task is preempted there,
an otherwise-free source block can be offlined and removed first.  On
the x86 path, removal can unmap the source's vmemmap, so the later read
can fault.  The snapshot avoids that read.

Link: https://lore.kernel.org/20261027021721.95781-1-laoar.shao@gmail.com
Fixes: e39bb6be9f2b ("NUMA Balancing: add page promotion counter")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
---

 mm/migrate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-snapshot-the-source-nid-before-the-misplaced-migration
+++ a/mm/migrate.c
@@ -2756,6 +2756,7 @@ int migrate_misplaced_folio(struct folio
 	pg_data_t *pgdat = NODE_DATA(node);
 	int nr_remaining;
 	unsigned int nr_succeeded;
+	int src_node = folio_nid(folio);
 	LIST_HEAD(migratepages);
 	struct mem_cgroup *memcg = get_mem_cgroup_from_folio(folio);
 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
@@ -2770,7 +2771,7 @@ int migrate_misplaced_folio(struct folio
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
 		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
-		    && !node_is_toptier(folio_nid(folio))
+		    && !node_is_toptier(src_node)
 		    && node_is_toptier(node))
 			mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS, nr_succeeded);
 	}
_

Patches currently in -mm which might be from laoar.shao@gmail.com are


