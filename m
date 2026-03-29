Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AE91C5F1B
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744771; cv=none; b=avrjAPtpB/djyTGTxsDWwX/b0eETLKKsxD8fCbhh5yYwMnG6Q4v4H5vlAPR75TTFpyOkuYe14hDW2duuNYCrk7K6EwUkv4KCld2eO2e1SOLLZM7yshL0AqpS8jw252tN5dJ5pfd/2aVQAq9IcLG27n1BUmnoDu1ojtG/Z5FeyPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744771; c=relaxed/simple;
	bh=GqZK6M4YaxTVgHGiLMQpmQMMrn7AQR1+V50TWj9HETk=;
	h=Date:To:From:Subject:Message-Id; b=lrp2Mk/0NIo1k/wZ8N5iOziqHNN8qswDeMgpFVNQOtkVC0W/E+CWQqiCyRdZFGC+w2oplFPhY/N9QQaJ2W2EVT4cCWm5QOFiCxH13PUWaGTlWMWixdQVaOb3elCKJl5w98URzT6UTIkC5LmWxQ+g9wI24M29kd3hMM8JwpgghoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gT9p+0zF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gT9p+0zF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380FDC4CEF7;
	Sun, 29 Mar 2026 00:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744771;
	bh=GqZK6M4YaxTVgHGiLMQpmQMMrn7AQR1+V50TWj9HETk=;
	h=Date:To:From:Subject:From;
	b=gT9p+0zF1bP6Q8tcBqj/6FOx7JAFKvvO3crp0MKJwu8cMG/Cr53pXGwFpQF04ByBk
	 r7/fCcOPo5o/3fkbxYAzHErcKGdP1VviNkaUAWZxgZ7viugbMAKZcax/3pFG5OkTpu
	 Y1qDNBuhZ7Ru0j1cnYKgxMB24ppajEzxwYU2fLRY=
Date: Sat, 28 Mar 2026 17:39:30 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,jannh@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,axelrasmussen@google.com,apopple@nvidia.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rename-ptep-pmdp_clear_young_notify-to-ptep-pmdp_test_and_clear_young_notify.patch removed from -mm tree
Message-Id: <20260329003931.380FDC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rename ptep/pmdp_clear_young_notify() to ptep/pmdp_test_and_clear_young_notify()
has been removed from the -mm tree.  Its filename was
     mm-rename-ptep-pmdp_clear_young_notify-to-ptep-pmdp_test_and_clear_young_notify.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: rename ptep/pmdp_clear_young_notify() to ptep/pmdp_test_and_clear_young_notify()
Date: Fri, 6 Mar 2026 14:43:38 +0800

Rename ptep/pmdp_clear_young_notify() to
ptep/pmdp_test_and_clear_young_notify() to make the function names
consistent.

Link: https://lkml.kernel.org/r/b3454077ce88745e6f88386b1763721746884565.1772778858.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    8 ++++----
 mm/vmscan.c   |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/mm/internal.h~mm-rename-ptep-pmdp_clear_young_notify-to-ptep-pmdp_test_and_clear_young_notify
+++ a/mm/internal.h
@@ -1819,7 +1819,7 @@ static inline int pmdp_clear_flush_young
 	return young;
 }
 
-static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
+static inline int ptep_test_and_clear_young_notify(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep)
 {
 	int young;
@@ -1829,7 +1829,7 @@ static inline int ptep_clear_young_notif
 	return young;
 }
 
-static inline int pmdp_clear_young_notify(struct vm_area_struct *vma,
+static inline int pmdp_test_and_clear_young_notify(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp)
 {
 	int young;
@@ -1843,8 +1843,8 @@ static inline int pmdp_clear_young_notif
 
 #define clear_flush_young_ptes_notify	clear_flush_young_ptes
 #define pmdp_clear_flush_young_notify	pmdp_clear_flush_young
-#define ptep_clear_young_notify	ptep_test_and_clear_young
-#define pmdp_clear_young_notify	pmdp_test_and_clear_young
+#define ptep_test_and_clear_young_notify	ptep_test_and_clear_young
+#define pmdp_test_and_clear_young_notify	pmdp_test_and_clear_young
 
 #endif /* CONFIG_MMU_NOTIFIER */
 
--- a/mm/vmscan.c~mm-rename-ptep-pmdp_clear_young_notify-to-ptep-pmdp_test_and_clear_young_notify
+++ a/mm/vmscan.c
@@ -3533,7 +3533,7 @@ restart:
 		if (!folio)
 			continue;
 
-		if (!ptep_clear_young_notify(args->vma, addr, pte + i))
+		if (!ptep_test_and_clear_young_notify(args->vma, addr, pte + i))
 			continue;
 
 		if (last != folio) {
@@ -3624,7 +3624,7 @@ static void walk_pmd_range_locked(pud_t
 		if (!folio)
 			goto next;
 
-		if (!pmdp_clear_young_notify(vma, addr, pmd + i))
+		if (!pmdp_test_and_clear_young_notify(vma, addr, pmd + i))
 			goto next;
 
 		if (last != folio) {
@@ -4214,7 +4214,7 @@ bool lru_gen_look_around(struct page_vma
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
 
-	if (!ptep_clear_young_notify(vma, addr, pte))
+	if (!ptep_test_and_clear_young_notify(vma, addr, pte))
 		return false;
 
 	if (spin_is_contended(pvmw->ptl))
@@ -4260,7 +4260,7 @@ bool lru_gen_look_around(struct page_vma
 		if (!folio)
 			continue;
 
-		if (!ptep_clear_young_notify(vma, addr, pte + i))
+		if (!ptep_test_and_clear_young_notify(vma, addr, pte + i))
 			continue;
 
 		if (last != folio) {
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-filemap-fix-nr_pages-calculation-overflow-in-filemap_map_pages.patch
mm-vmscan-fix-dirty-folios-throttling-on-cgroup-v1-for-mglru.patch

