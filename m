Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4493F33DEF7
	for <mm-commits@vger.kernel.org>; Tue,  7 Jul 2026 19:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783451374; cv=none; b=YnUsnx9vosJSnx1B9q1GunWACtM9dgYjJjHzMRhCkDAUE9iYMvPrH8qU3tDgRZLcCHpogpYA3LbRRgrjuBbKm1b7zCSEGNxJ2hvCBcSRglFy5HR0NFr6KLkugYC+e8SxN3FtJBGTdllE+S7AszfydvIFUjlDIeeHWa0fZe29+Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783451374; c=relaxed/simple;
	bh=v4nVnK3rfnOIFMhprR+DPdAvbprJYLGFI7ZfnvVFtb8=;
	h=Date:To:From:Subject:Message-Id; b=RSAgs52VwDpfHIkSNMiH377TYiObx2plh7xFMEa0/xPaiM1DwcfYihRnQlXOTuFg0nUkBa3xRU2M6sA6xzjHEr3K1oGRxzcphTgYeRnnIlL04KDiCHNHRrqHN0IhoVmOvHy6ynDAJkLe+bY6CEg9rFDFZWOyVmXwx9QmEV4G6ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GeGcMN/7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GeGcMN/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F521F00A3A;
	Tue,  7 Jul 2026 19:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783451372;
	bh=rvt9G/Zh1POIqHFfLrrHETPkyVcx5JlJC4hI+wtVDKc=;
	h=Date:To:From:Subject;
	b=GeGcMN/7SCM4hIiwBXTvmb0YELn2wNdIYy3Pwz1miv6WFqPR6kGU2LLYmaTb0l5P3
	 ISLibnUdC1Q13PJd/NPNCdzGEVeoF7dFoTcgeu1H54VYKf4L91zZN9/+PvUt0LR6rm
	 Yp3AIGpiz8TYG7VMDzO5/NlkUhTi2u5pSzkQ6foQ=
Date: Tue, 07 Jul 2026 12:09:32 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-add-print_mode-filter-fix.patch removed from -mm tree
Message-Id: <20260707190932.D3F521F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_owner-add-print_mode-filter-fix
has been removed from the -mm tree.  Its filename was
     mm-page_owner-add-print_mode-filter-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_owner-add-print_mode-filter-fix
Date: Thu Jun 25 12:18:25 PM PDT 2026

remove local max_input_len. per Zi Yan

Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>
Cc: Yichong Chen <chenyichong@uniontech.com>
Cc: Zhen Ni <zhen.ni@easystack.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-add-print_mode-filter-fix
+++ a/mm/page_owner.c
@@ -926,7 +926,6 @@ static ssize_t page_owner_write(struct f
 	char *orig;
 	char *token;
 	int ret;
-	size_t max_input_len;
 	struct page_owner_filter_state *state = file->private_data;
 	enum page_owner_print_mode new_print_mode;
 	unsigned long flags;
@@ -935,9 +934,7 @@ static ssize_t page_owner_write(struct f
 	 * Maximum input length for filter commands:
 	 * 32: print_mode command max length is 17 ("mode=stack_handle").
 	 */
-	max_input_len = 32;
-
-	if (count > max_input_len)
+	if (count > 32)
 		return -EINVAL;
 
 	kbuf = memdup_user_nul(buf, count);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch
mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

