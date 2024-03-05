Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E570101CF
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600566; cv=none; b=ba9XLvjLNU5Lv0H8ti3IQN9VD5D6Dw7NdcPdT4vzuQOvgVVN8Pcv/R8r4nohZ8Bfhh2VPaYFRvfyAZ4lN2Bcrmyh2tK8h0XmAWMHbRyV6KYa/k4TwKhBw3YXpU4v48Knc8dZxXDYodyBWPZl+1cCtzGV6KKEYBkK1bhQaSx0ajY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600566; c=relaxed/simple;
	bh=8VlKxGso3+LB8rlwCwbyXR845f0mx+5DJZIFOmy1JEg=;
	h=Date:To:From:Subject:Message-Id; b=LhCqdgbL0f8o/QUUyitgb5G9QEOKq1wSZ0P7HJOn+P2uTE9QsDKcCFq7SlVZL1V2dxPbNFYzvdqDIUlne3b1rUncJV4EFbr3SX7wZlauSEe6fRz2V1+53+qp+S+H9YoXP3KGCqhqtajKcCiilIxSY2ckDNBGYaffN5KHTxLC4eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wNqUmprC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wNqUmprC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF71FC433F1;
	Tue,  5 Mar 2024 01:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600566;
	bh=8VlKxGso3+LB8rlwCwbyXR845f0mx+5DJZIFOmy1JEg=;
	h=Date:To:From:Subject:From;
	b=wNqUmprCJ931db0ZqpFzK42nPeGBxKW6J3Avlt9LLSjO9PaAXH2A1L0iyu6Lb1Nrr
	 M9mneXkFKllQTno7QWEBbdYgC85RRUmAwpjrdcltd127trhEANHtFIPJDXiSElJvw+
	 iW7wXYtieb2RRoBkWQhiGcYegZQH2IJ6qQuF9ea0=
Date: Mon, 04 Mar 2024 17:02:45 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-add-mem_cgroup_uncharge_folios.patch removed from -mm tree
Message-Id: <20240305010245.DF71FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: add mem_cgroup_uncharge_folios()
has been removed from the -mm tree.  Its filename was
     memcg-add-mem_cgroup_uncharge_folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: memcg: add mem_cgroup_uncharge_folios()
Date: Tue, 27 Feb 2024 17:42:39 +0000

Almost identical to mem_cgroup_uncharge_list(), except it takes a
folio_batch instead of a list_head.

Link: https://lkml.kernel.org/r/20240227174254.710559-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   14 ++++++++++++--
 mm/memcontrol.c            |   13 +++++++++++++
 2 files changed, 25 insertions(+), 2 deletions(-)

--- a/include/linux/memcontrol.h~memcg-add-mem_cgroup_uncharge_folios
+++ a/include/linux/memcontrol.h
@@ -721,10 +721,16 @@ static inline void mem_cgroup_uncharge_l
 	__mem_cgroup_uncharge_list(page_list);
 }
 
-void mem_cgroup_cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages);
+void __mem_cgroup_uncharge_folios(struct folio_batch *folios);
+static inline void mem_cgroup_uncharge_folios(struct folio_batch *folios)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_uncharge_folios(folios);
+}
 
+void mem_cgroup_cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages);
 void mem_cgroup_replace_folio(struct folio *old, struct folio *new);
-
 void mem_cgroup_migrate(struct folio *old, struct folio *new);
 
 /**
@@ -1299,6 +1305,10 @@ static inline void mem_cgroup_uncharge_l
 {
 }
 
+static inline void mem_cgroup_uncharge_folios(struct folio_batch *folios)
+{
+}
+
 static inline void mem_cgroup_cancel_charge(struct mem_cgroup *memcg,
 		unsigned int nr_pages)
 {
--- a/mm/memcontrol.c~memcg-add-mem_cgroup_uncharge_folios
+++ a/mm/memcontrol.c
@@ -33,6 +33,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/hugetlb.h>
 #include <linux/pagemap.h>
+#include <linux/pagevec.h>
 #include <linux/vm_event_item.h>
 #include <linux/smp.h>
 #include <linux/page-flags.h>
@@ -7530,6 +7531,18 @@ void __mem_cgroup_uncharge_list(struct l
 	if (ug.memcg)
 		uncharge_batch(&ug);
 }
+
+void __mem_cgroup_uncharge_folios(struct folio_batch *folios)
+{
+	struct uncharge_gather ug;
+	unsigned int i;
+
+	uncharge_gather_clear(&ug);
+	for (i = 0; i < folios->nr; i++)
+		uncharge_folio(folios->folios[i], &ug);
+	if (ug.memcg)
+		uncharge_batch(&ug);
+}
 
 /**
  * mem_cgroup_replace_folio - Charge a folio's replacement.
_

Patches currently in -mm which might be from willy@infradead.org are

mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-add-__dump_folio-fix.patch
mm-add-__dump_folio-fix-2.patch
mm-add-__dump_folio-fix-3.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch
mm-mempolicy-use-a-folio-in-do_mbind.patch

