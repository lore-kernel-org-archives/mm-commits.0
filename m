Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E273B12F399
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619833; cv=none; b=l/po8LvhGgOWwEfvYVTekd1mF0KajkD0MR9Lmb7uEhRywYK7bfM+tpoGjejAifvnusUaTi2FqlzMaNZpBGgtUW1qC6KKBuHQuvgKBHKNnLXSbf15QyQb36+hcsN30vn+nPdyi284yKPGYUHt1esKt9ou3fPH9Bkh8ELxnNGWVmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619833; c=relaxed/simple;
	bh=EHt8HaWADxOu0qHXEPSxnOODCBtkR5qLhCU1Liv0zNk=;
	h=Date:To:From:Subject:Message-Id; b=NUKqGO2iwswaG1PmI2fl4YSG+VU84z59v6wRURiGlJnNnkgZilA63TDiCPPpFsE93PEnnYcYpyX71tjhutNdY6e62TgTfI5u+VM3ubLLkK/T/Qyme5UhO+AXYS1L+vHHjJJWtD7gA7XXi1tGgtv6VfVs2sE7oiwSJ837EvqudfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=edUu1Trw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="edUu1Trw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF28C4CEDD;
	Sat, 22 Mar 2025 05:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619832;
	bh=EHt8HaWADxOu0qHXEPSxnOODCBtkR5qLhCU1Liv0zNk=;
	h=Date:To:From:Subject:From;
	b=edUu1Trwc4GjffMBk6sluqJLXp0/LFn7LKxKPhNxXI8X7+4+inGglgZa9XBRbbG50
	 Wc9Lyu0wjEHuOlovrkQvc6hvzzfwbl/S3GZ+/2ddMIc0YL4NQYaBPy89QZ5on0Sqo7
	 FfcaRc8UQuHEtLBd4diud4iYhNd3YIvKyfRUnm8I=
Date: Fri, 21 Mar 2025 22:03:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-references-to-folio-in-split_page_memcg.patch removed from -mm tree
Message-Id: <20250322050352.ADF28C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove references to folio in split_page_memcg()
has been removed from the -mm tree.  Its filename was
     mm-remove-references-to-folio-in-split_page_memcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove references to folio in split_page_memcg()
Date: Fri, 14 Mar 2025 13:36:13 +0000

We know that the passed in page is not part of a folio (it's a plain page
allocated with GFP_ACCOUNT), so we should get rid of the misleading
references to folios.

Introduce page_objcg() and page_set_objcg() helpers to make things more
clear.

Link: https://lkml.kernel.org/r/20250314133617.138071-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c~mm-remove-references-to-folio-in-split_page_memcg
+++ a/mm/memcontrol.c
@@ -2677,6 +2677,23 @@ out:
 	return ret;
 }
 
+static struct obj_cgroup *page_objcg(const struct page *page)
+{
+	unsigned long memcg_data = page->memcg_data;
+
+	if (mem_cgroup_disabled() || !memcg_data)
+		return NULL;
+
+	VM_BUG_ON_PAGE((memcg_data & OBJEXTS_FLAGS_MASK) != MEMCG_DATA_KMEM,
+			page);
+	return (struct obj_cgroup *)(memcg_data - MEMCG_DATA_KMEM);
+}
+
+static void page_set_objcg(struct page *page, const struct obj_cgroup *objcg)
+{
+	page->memcg_data = (unsigned long)objcg | MEMCG_DATA_KMEM;
+}
+
 /**
  * __memcg_kmem_charge_page: charge a kmem page to the current memory cgroup
  * @page: page to charge
@@ -2695,8 +2712,7 @@ int __memcg_kmem_charge_page(struct page
 		ret = obj_cgroup_charge_pages(objcg, gfp, 1 << order);
 		if (!ret) {
 			obj_cgroup_get(objcg);
-			page->memcg_data = (unsigned long)objcg |
-				MEMCG_DATA_KMEM;
+			page_set_objcg(page, objcg);
 			return 0;
 		}
 	}
@@ -3069,18 +3085,18 @@ void __memcg_slab_free_hook(struct kmem_
  * The objcg is only set on the first page, so transfer it to all the
  * other pages.
  */
-void split_page_memcg(struct page *first, unsigned order)
+void split_page_memcg(struct page *page, unsigned order)
 {
-	struct folio *folio = page_folio(first);
+	struct obj_cgroup *objcg = page_objcg(page);
 	unsigned int i, nr = 1 << order;
 
-	if (mem_cgroup_disabled() || !folio_memcg_charged(folio))
+	if (!objcg)
 		return;
 
 	for (i = 1; i < nr; i++)
-		folio_page(folio, i)->memcg_data = folio->memcg_data;
+		page_set_objcg(&page[i], objcg);
 
-	obj_cgroup_get_many(__folio_objcg(folio), nr - 1);
+	obj_cgroup_get_many(objcg, nr - 1);
 }
 
 void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
_

Patches currently in -mm which might be from willy@infradead.org are


