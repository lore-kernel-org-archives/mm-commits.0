Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793071062;
	b=YNP+EW2HIrxBqbGvrB1CBizotYcFg+SadXRO0vhATuDu7AN0gODWLxc2EVfizLsmeRF7
	 XTKMdQ6a6w3r0bVDEfpg86ixyjET6izDUSsskOnr4bfAfZSy25tzWn19gCbOiksRQg032
	 mDpIKekCbqneCXSWphUNwunF48vElNjqP/SmAxxy/cW5vztLjIK/DLG8WR5S0LOz1cZba
	 IPDWTbVDJermY3+DuxaLYWInb5ulzgNyeOy4iqe5BErOwKC3h5XuDyDJ9ruhAABw0hihP
	 OuAlzCUO6w9Byr5YRCa11l9CUhjySHuUm34/Ds+kKVSjRJnRXS00TUpPq+OsvFPTiXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793071062;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=OpJ2utDSBImls4mOeO8g4xVCZeJHj4xsCzGQPkiDauU=;
	b=Nm202RG/ommij/4JJx3VMTVeCEUPWVatrcv++VG4qlsP5PO+ShLr9Ce2rPPiU5NEmywD
	 FiG5ezlTmA/bweRftfwW7p0oIUz6Qv63v1Ma/LdPpVEosUaSBlHVeRF+7PwC2AlIvsM7V
	 tHUKMI+VcxI1u+bt+yZz7pjNeFoAD6cW5mBhTqPpNnAj3SqfEGRT0q6XXjiyBqERqWNxm
	 +NOZI0cVJgGU7F3Z0X8m7sRpIfmyi6guKxGho/oHuoFW/nFTvqJrPtNX/+A+fzCCszvnw
	 9+HRPKXfA91+l3qvnjKmR+92mcF7F3ym34GRm0v/imhlflqGBT5itDc2mam1CKjR/VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=P8AgF0OH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2FF606A322;
	Tue, 27 Oct 2026 03:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=P8AgF0OH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799FA1F01825;
	Tue, 27 Oct 2026 03:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793071061;
	bh=OpJ2utDSBImls4mOeO8g4xVCZeJHj4xsCzGQPkiDauU=;
	h=Date:To:From:Subject;
	b=P8AgF0OHw6A9I86iQt5aJtwtDyVBC3h5e9/QE4cMeAQKpJvl4L9E9AJ/WWkq5GHll
	 buNAeRkPTb886GLn/XWkurSjIiBkH5xpv9Sc81oBrdjCM0PTMyjAC9uRlNbB0KjvmL
	 3NCn13GBwixX3IYfKFJbikisBvdVg6h9JnU9xwPs=
Date: Mon, 26 Oct 2026 20:17:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	willy@infradead.org,stable@vger.kernel.org,matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,
	apopple@nvidia.com,akpm@linux-foundation.org,laoar.shao@gmail.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-snapshot-the-source-nid-before-the-misplaced-migration.patch added to mm-unstable branch
Message-Id: <20261027031741.799FA1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/migrate: snapshot the source nid before the misplaced migration
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-snapshot-the-source-nid-before-the-misplaced-migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-snapshot-the-source-nid-before-the-misplaced-migration.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
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

mm-migrate-snapshot-the-source-nid-before-the-misplaced-migration.patch

