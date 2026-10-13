Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90282484889;
	Tue, 13 Oct 2026 04:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865989; cv=none; b=Vbww67KCbjU14N+4XVWkw5Z8DoOcK7YJh/TO4LPQ+MTu/cGyUX65THvnvSMWX3b7KR7OpvevKxlyzPLjEojRshRibodrBMARCfkbnIkvqykH645VzovyDg7yLsygBv6Iwc6Sy87wWX203Jx+lMf4c4U2RocY3Ra3Gunrx9FdSZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865989; c=relaxed/simple;
	bh=kjtoB2WbLZN+4WMIePtmXIPTf6oLK7EidU6vfqUYegs=;
	h=Date:To:From:Subject:Message-Id; b=sZtNb8wh5SLodWZHlHHtsY00oDQ9ll+faHyb0KouCRSJivez30g/UyPrgmZVv1o3VImfkvUKwvaCZwO4qYp4FmZqqwQqRIoOQRpHwuhLVl1XyucIhGJgUhSDgbYNzdY3ZSVy5MlnLCOSKjiO5SJUfdGcH04NJUdYvejcg8Uby6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jf/FASTD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jf/FASTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632C51F000FF;
	Tue, 13 Oct 2026 04:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865987;
	bh=a5PKf1Hg0CIdy55n8qMp4eapn+6iEoBK7AWlQ5AIOnk=;
	h=Date:To:From:Subject;
	b=jf/FASTDhzT0o5gFyjPzTSadcnZeq1ZN6NjGjFBzntoozrkvnSp3rBlDyUIq6Qd84
	 e0wvY+22QLjdfsdrqTs2TsMyE6dBHwdRnxW4GrbhUF/JP/FEv6Ki30c/ni+35zFL/L
	 y0gpu8VJ4ZV3SrJp01cmKbJeCK74z6/WhzgClknQ=
Date: Mon, 12 Oct 2026 21:33:07 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,osalvador@suse.de,muchun.song@linux.dev,kees@kernel.org,david@kernel.org,colin.i.king@gmail.com,almasrymina@google.com,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_cgroup-move-per-node-usage-on-cross-node-migration.patch removed from -mm tree
Message-Id: <20261013043307.632C51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb_cgroup: move per-node usage on cross node migration
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cgroup-move-per-node-usage-on-cross-node-migration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm/hugetlb_cgroup: move per-node usage on cross node migration
Date: Fri, 18 Sep 2026 10:56:10 +0800

Patch series "mm/hugetlb_cgroup: move the per-node usage along with the
folio", v2.

The per-node usage reported by hugetlb.<size>.numa_stat is accounted
against folio_nid() in __hugetlb_cgroup_commit_charge() and
__hugetlb_cgroup_uncharge_folio(), so it is only correct while a folio
stays charged on the same node and in the same hugetlb_cgroup.

Two paths move a folio which stays charged, and neither moves the usage
with it.  hugetlb_cgroup_migrate() only moves the hugetlb_cgroup pointers
of a folio migrated to another node, and hugetlb_cgroup_move_parent() only
moves the page_counter charges and the hugetlb_cgroup pointer of the
folios of a dying cgroup.  In both cases the node (or cgroup) which was
charged keeps a usage which never goes away, while the node (or cgroup)
which ends up uncharging the folio underflows as soon as the folio is
freed.

Patch 1/2 moves the usage along with the folio on cross node migration,
patch 2/2 does the same for the folios a dying cgroup reparents.


This patch (of 2):

hugetlb.<size>.numa_stat uses folio_nid() to account usage in
__hugetlb_cgroup_commit_charge() and __hugetlb_cgroup_uncharge_folio(). 
hugetlb_cgroup_migrate() only moves hugetlb_cgroup pointers, leaving
per-node usage behind on the source node during cross-node migration.

When the migrated folio gets uncharged, we subtract usage from the
destination node counter.  This creates stale usage on the source node and
unsigned long counter underflow on the destination node.  The
hugetlb.<size>.numa_stat interface exposes these incorrect per-node usage
values to userspace.

Add a hugetlb_cgroup_move_usage() helper which moves the usage from the
old node to the new node, and call it from hugetlb_cgroup_migrate().

Link: https://lore.kernel.org/20260918-for-hugetlb-charge-v2-0-2b6d8c2bdc36@kylinos.cn
Link: https://lore.kernel.org/20260918-for-hugetlb-charge-v2-1-2b6d8c2bdc36@kylinos.cn
Fixes: f47761999052 ("hugetlb: add hugetlb.*.numa_stat file")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
---

 mm/hugetlb_cgroup.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-move-per-node-usage-on-cross-node-migration
+++ a/mm/hugetlb_cgroup.c
@@ -179,6 +179,34 @@ static void hugetlb_cgroup_css_free(stru
 	hugetlb_cgroup_free(hugetlb_cgroup_from_css(css));
 }
 
+static void hugetlb_cgroup_move_usage(struct hugetlb_cgroup *from,
+				      struct hugetlb_cgroup *to,
+				      struct folio *from_folio,
+				      struct folio *to_folio)
+{
+	int idx = hstate_index(folio_hstate(from_folio));
+	unsigned long nr_pages = folio_nr_pages(from_folio);
+	int from_nid = folio_nid(from_folio);
+	int to_nid = folio_nid(to_folio);
+	unsigned long usage;
+
+	lockdep_assert_held(&hugetlb_lock);
+
+	if (!from || !to)
+		return;
+
+	if (from == to && from_nid == to_nid)
+		return;
+
+	usage = from->nodeinfo[from_nid]->usage[idx];
+	if (WARN_ON_ONCE(usage < nr_pages))
+		return;
+	WRITE_ONCE(from->nodeinfo[from_nid]->usage[idx], usage - nr_pages);
+
+	usage = to->nodeinfo[to_nid]->usage[idx];
+	WRITE_ONCE(to->nodeinfo[to_nid]->usage[idx], usage + nr_pages);
+}
+
 /*
  * Should be called with hugetlb_lock held.
  * Since we are holding hugetlb_lock, pages cannot get moved from
@@ -906,6 +934,9 @@ void hugetlb_cgroup_migrate(struct folio
 	/* move the h_cg details to new cgroup */
 	set_hugetlb_cgroup(new_folio, h_cg);
 	set_hugetlb_cgroup_rsvd(new_folio, h_cg_rsvd);
+
+	hugetlb_cgroup_move_usage(h_cg, h_cg, old_folio, new_folio);
+
 	list_move(&new_folio->lru, &h->hugepage_activelist);
 	spin_unlock_irq(&hugetlb_lock);
 }
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-hugetlb-account-migration-target-folio-in-per-node-nr_hugetlb-vmstat.patch
mm-memcg-migrate-per-node-hugetlb-lruvec-stat-together-with-hugetlb-folio.patch
mm-memfd-fix-hugetlb-reservation-accounting-in-error-paths.patch

