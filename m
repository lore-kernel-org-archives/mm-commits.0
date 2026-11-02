Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793640268;
	b=vl1O2ySbht3+5zffR5ncJEnVKCM7hBRGupXyP/6gRU0rC/i6FGPq7atSCQU4vv+LJ/9+
	 zGVpCD3OVwKKp4g5XjGBrfNvqCnBWrpYxwfelgwFFXP9aXf/Z4PhWTNpLNiekS6cGtiyQ
	 Y5SJhHZ7cIpx+tNFz4/sXYudb/+Gls2beXi6fuB4pBTXU/eOZBCoWAWpo3/6yL5qAvAlS
	 Y/Gp1WJg/8i31xKUshlG2PIaRbprSbqOnGtWjPKzD/jdETgb3qrUB73A1sNaQDsB9VS/t
	 J6/U8pfpECwvt16aw/sPkK7GCQBSkKO/lleFt8oha6MrDtx2ZVv9v3KQvBty9uv5zcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640268;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=vGZDTFv9imuoh2FAgZMoqDe1n1dfImv5a+FLkKO3cVo=;
	b=xKCYMmgB/o6mz9uFXntXTbnzvtSm7Y1igObOeyd7CkdEJpbuKodWqQt1PqKiSMDsC3gj
	 zHXbUEPU5C2B+YYHy97Es0s/BxwIgx9kgUuceKDqbu0kF/Qvcev1TZ2IXFNB4WnFsHy+g
	 zDovcqLNww5WZAgyzW3JtjwQOr1CZG3TdhKcXG5DOrjUm8pqCdGI5rjMv9fQ9xVzMcgvU
	 vEPqIw4a3iYNRrB0zbzYDsVrk8CTsSsdoHr4jSPBI+4qbhSgkUTY97mcFDC0DgFvSuZLl
	 /IdWkNbM/x5rhpe6MegqAL+9cfQMbqafzkSQZ+ZzpOdNjhXnESYXGcAoQVvs5QuAJag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LxxUlFYY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B53F606B922
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 17:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LxxUlFYY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051391F00A16;
	Mon,  2 Nov 2026 17:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793640268;
	bh=vGZDTFv9imuoh2FAgZMoqDe1n1dfImv5a+FLkKO3cVo=;
	h=Date:To:From:Subject;
	b=LxxUlFYYV/+A2cmchWm/RVNnOBxCE5GsRcxg8xxinP7iB6d3IMN9SWCJytyc/Q9nl
	 GX46oCA+yr+yFktgF+EDa5OvVeiogpOFoKdSG19qWUj1O9xloR9wqaPOGZQE9VCbs8
	 yOC4ZWJWj+ISCGw80MZDUpn/6LsNlzwIWvYS+ZtI=
Date: Mon, 02 Nov 2026 09:24:27 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,sh@gentwo.org,
	ruanjinjie@huawei.com,manuelebnerli@mailbox.org,lienze@kylinos.cn,
	jaeyeon.lee.dev@gmail.com,bijan311@gmail.com,adrianhuang0701@gmail.com,
	jm5905938@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-pvaddr-skip-folios-already-on-the-migration-target-node.patch added to mm-new branch
Message-Id: <20261102172428.051391F00A16@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/{p,v}addr: skip folios already on the migration target node
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-pvaddr-skip-folios-already-on-the-migration-target-node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-pvaddr-skip-folios-already-on-the-migration-target-node.patch

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
From: Aveline Noir <jm5905938@gmail.com>
Subject: mm/damon/{p,v}addr: skip folios already on the migration target node
Date: Mon, 02 Nov 2026 07:07:52 -0800

While measuring DAMOS migration overhead, I found that the target_nid
path isolates folios already on the target node, then puts them back on
the LRU without migrating them.

Skip them before isolation in vaddr and paddr, as the vaddr explicit
destinations path already does.

In a synthetic same-node fvaddr test on a two-node x86-64 KVM guest (8
interleaved runs per kernel), guest-kernel cycles fell by about 29% with
4 KiB regions and 90% with 16 MiB regions. Median kdamond CPU time fell
by about 76% with 16 MiB regions, with no clear change with 4 KiB
regions.

Link: https://lore.kernel.org/20261102150757.93058-6-sj@kernel.org
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Bijan Tabatabai <bijan311@gmail.com>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: Enze Li <lienze@kylinos.cn>
Cc: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Cc: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>
---

 mm/damon/paddr.c |    2 ++
 mm/damon/vaddr.c |   18 ++++++++++--------
 2 files changed, 12 insertions(+), 8 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-pvaddr-skip-folios-already-on-the-migration-target-node
+++ a/mm/damon/paddr.c
@@ -368,6 +368,8 @@ static unsigned long damon_pa_migrate(st
 		else
 			*sz_filter_passed += folio_size(folio) / addr_unit;
 
+		if (folio_nid(folio) == s->target_nid)
+			goto put_folio;
 		if (!folio_isolate_lru(folio))
 			goto put_folio;
 		node_stat_add_folio(folio, NR_ISOLATED_ANON +
--- a/mm/damon/vaddr.c~mm-damon-pvaddr-skip-folios-already-on-the-migration-target-node
+++ a/mm/damon/vaddr.c
@@ -786,14 +786,15 @@ struct damos_va_migrate_private {
  */
 static void damos_va_migrate_dests_add(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr,
-		struct damos_migrate_dests *dests,
+		struct damos *s,
 		struct list_head *migration_lists)
 {
+	struct damos_migrate_dests *dests = &s->migrate_dests;
 	pgoff_t ilx;
 	int order;
 	unsigned int target;
 	unsigned int weight_total = 0;
-	int i;
+	int i, nid;
 
 	/*
 	 * If dests is empty, there is only one migration list corresponding
@@ -801,7 +802,8 @@ static void damos_va_migrate_dests_add(s
 	 */
 	if (!dests->nr_dests) {
 		i = 0;
-		goto isolate;
+		nid = s->target_nid;
+		goto check_nid;
 	}
 
 	order = folio_order(folio);
@@ -821,12 +823,13 @@ static void damos_va_migrate_dests_add(s
 			break;
 		target -= dests->weight_arr[i];
 	}
+	nid = dests->node_id_arr[i];
 
+check_nid:
 	/* If the folio is already in the right node, don't do anything */
-	if (folio_nid(folio) == dests->node_id_arr[i])
+	if (folio_nid(folio) == nid)
 		return;
 
-isolate:
 	if (!folio_isolate_lru(folio))
 		return;
 	node_stat_add_folio(folio, NR_ISOLATED_ANON +
@@ -840,7 +843,6 @@ static int damos_va_migrate_pmd_entry(pm
 	struct damos_va_migrate_private *priv = walk->private;
 	struct list_head *migration_lists = priv->migration_lists;
 	struct damos *s = priv->scheme;
-	struct damos_migrate_dests *dests = &s->migrate_dests;
 	struct folio *folio;
 	spinlock_t *ptl;
 	pte_t *start_pte, *pte, ptent;
@@ -858,7 +860,7 @@ static int damos_va_migrate_pmd_entry(pm
 			goto huge_out;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
 			goto huge_out;
-		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
+		damos_va_migrate_dests_add(folio, walk->vma, addr, s,
 				migration_lists);
 huge_out:
 		spin_unlock(ptl);
@@ -883,7 +885,7 @@ huge_out:
 			continue;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
 			continue;
-		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
+		damos_va_migrate_dests_add(folio, walk->vma, addr, s,
 				migration_lists);
 		page_idx = folio_page_idx(folio, pte_page(ptent));
 		nr = folio_nr_pages(folio) - page_idx;
_

Patches currently in -mm which might be from jm5905938@gmail.com are

mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pmd-young-bit.patch
mm-damon-stat-avoid-32-bit-overflow-in-idle-percentiles.patch
mm-damon-pvaddr-skip-folios-already-on-the-migration-target-node.patch

