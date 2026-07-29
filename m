Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021D73909B5;
	Wed, 29 Jul 2026 04:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298423; cv=none; b=nbPc+cuT7puf9+4qOdLn1b/LgeIkOP3W282Hi7rxJVAM8w0i2GOx8JS1yLqtrqTejrHTce/9BjlMDDeFYdjkOfnxqHUXmqbdvSiOO8lpj9frJkdZdHNnawSFbIFIr7QZXcuKhfcX0QrptJvH9sXr/xgQL9oGexrdieYe8ipagwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298423; c=relaxed/simple;
	bh=ssozr2e+eQBeCPHa5/lM+BNuK/oVa5lCOt7Z86KcarE=;
	h=Date:To:From:Subject:Message-Id; b=Hrgg/vNH/mKp2KWqMRTdhMG0V/eZADk+ljA7UjlkVwMbuIuxJfm7T+5h598Dp5MoHPOEzODlAmKhl+yJD6PGelqLhyvYbPv8S6Cot7rWFVgVpfNpwL3QYZlnzqOQ0IC0eZzp6bVzEPbR4vi+CsCadXy00nmlOV+zVZSXfmpsujg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RA3kEY7F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RA3kEY7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6251F000E9;
	Wed, 29 Jul 2026 04:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298421;
	bh=gCmxwnKkhjp3jloReJXdtG6/uWfy4qcguxqgjBTQ5tM=;
	h=Date:To:From:Subject;
	b=RA3kEY7FNbAB4fsL1IPCSkUGcyYBEgNOwtOqugytsMzqTFw+WXbJdP/C0F01nxDf3
	 sfuXVJ3cNgvjVyl+Y1IoVqfb+2HqUNdJLlmippM65VKx2TskotMotAI5IeWRYzgtMW
	 OobSjCa7fRRdhJeI47PSQL6hGFf8sIPQtZUrYcQY=
Date: Tue, 28 Jul 2026 21:13:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,sashiko-bot@kernel.org,mhocko@suse.com,ljs@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_owner-use-memcg_data-snapshot-to-avoid-toctou-in-print_page_owner_memcg.patch removed from -mm tree
Message-Id: <20260729041341.BB6251F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: use memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()
has been removed from the -mm tree.  Its filename was
     mm-page_owner-use-memcg_data-snapshot-to-avoid-toctou-in-print_page_owner_memcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: use memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()
Date: Tue, 14 Jul 2026 09:51:08 +0800

print_page_owner_memcg() reads page->memcg_data via READ_ONCE() at the
start to guard against tail pages and NULL data.  However, it later
re-reads page->memcg_data locklessly in two places:

1: page_memcg_check(page)

2: PageMemcgKmem(page) (via folio_memcg_kmem(), which includes
   VM_BUG_ON assertions for tail pages and MEMCG_DATA_OBJEXTS)

If the page is concurrently freed and reallocated as a THP tail page or
slab page between these calls, the VM_BUG_ON assertions can trigger on
CONFIG_DEBUG_VM=y builds, crashing the kernel.

Fix both TOCTOU issues by using the memcg_data snapshot throughout.

Link: https://lore.kernel.org/20260714015117.78351-10-ye.liu@linux.dev
Fixes: fcf8935832b8 ("mm/page_owner: print memcg information")
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-use-memcg_data-snapshot-to-avoid-toctou-in-print_page_owner_memcg
+++ a/mm/page_owner.c
@@ -540,6 +540,7 @@ static inline int print_page_owner_memcg
 					 struct page *page)
 {
 	unsigned long memcg_data;
+	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
 	bool online;
 	char name[80];
@@ -549,11 +550,14 @@ static inline int print_page_owner_memcg
 	if (!memcg_data || PageTail(page))
 		goto out_unlock;
 
-	if (memcg_data & MEMCG_DATA_OBJEXTS)
+	if (memcg_data & MEMCG_DATA_OBJEXTS) {
 		ret += scnprintf(kbuf + ret, count - ret,
 				"Slab cache page\n");
+		goto out_unlock;
+	}
 
-	memcg = page_memcg_check(page);
+	objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
+	memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;
 	if (!memcg)
 		goto out_unlock;
 
@@ -561,7 +565,7 @@ static inline int print_page_owner_memcg
 	cgroup_name(memcg->css.cgroup, name, sizeof(name));
 	ret += scnprintf(kbuf + ret, count - ret,
 			"Charged %sto %smemcg %s\n",
-			PageMemcgKmem(page) ? "(via objcg) " : "",
+			(memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " : "",
 			online ? "" : "offline ",
 			name);
 out_unlock:
_

Patches currently in -mm which might be from ye.liu@linux.dev are


