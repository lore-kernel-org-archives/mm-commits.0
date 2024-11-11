Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF0A1598EE
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313690; cv=none; b=AUcntMx4nN4Dxlx7QwdUlXeV++L7yEnKJU2mrMkOSRcWg/96idmBRUXKLX+LJDtP61gRgfOHG3r362KZcgf9qXwtF+T6CmxgQw2np6saefhN8GEQPxJDF92o4TbUeCV92jfLudRxNYusEOd7+tAHtKicFtCzKWxhYHFs7txU8Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313690; c=relaxed/simple;
	bh=wR19c3CzKpQ9vKsiIIN2c/gWnIFKlnpRUBNdF2jOCHU=;
	h=Date:To:From:Subject:Message-Id; b=ZPhSHx95KBFY8uou0wBE+WAf3lpu8LzBfTk8WnrKJDCN+Bqk6jG6dyqMEN8B8Az+pH7Z+r2EQLvThG7pQ8JIuAbkNvYf3mJqLmOZYAYryRuDJ8BEOtKu/gYamZRhxS3zJUARwJj39CKZKcMTSeMuTowsX3baF3uzEWTetpBdhYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MzKk/AQ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MzKk/AQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92898C4CED4;
	Mon, 11 Nov 2024 08:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313690;
	bh=wR19c3CzKpQ9vKsiIIN2c/gWnIFKlnpRUBNdF2jOCHU=;
	h=Date:To:From:Subject:From;
	b=MzKk/AQ0z4aYmwxFHrXITJyFCuwp3nT1h/tXAjiRo5og7KVHLvF79tbIV57yzWM1E
	 +cvjqiZ0l+YMwVh3NkW22AO+2P5ES8U+42OJPP7Xe9eySINmULTjnAYtuoUEdCyABi
	 Uxczb0z57YAx5dr6m9SgpWDWFGbtDZwFCfUH1E2k=
Date: Mon, 11 Nov 2024 00:28:10 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,usamaarif642@gmail.com,ryan.roberts@arm.com,kasong@tencent.com,kanchana.p.sridhar@intel.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-per-order-mthp-swpin-counters.patch removed from -mm tree
Message-Id: <20241111082810.92898C4CED4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add per-order mTHP swpin counters
has been removed from the -mm tree.  Its filename was
     mm-add-per-order-mthp-swpin-counters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: add per-order mTHP swpin counters
Date: Sat, 26 Oct 2024 21:24:23 +1300

This helps profile the sizes of folios being swapped in. Currently,
only mTHP swap-out is being counted.
The new interface can be found at:
/sys/kernel/mm/transparent_hugepage/hugepages-<size>/stats
         swpin
For example,
cat /sys/kernel/mm/transparent_hugepage/hugepages-64kB/stats/swpin
12809
cat /sys/kernel/mm/transparent_hugepage/hugepages-32kB/stats/swpin
4763

[v-songbaohua@oppo.com: add a blank line in doc]
  Link: https://lkml.kernel.org/r/20241030233423.80759-1-21cnbao@gmail.com
Link: https://lkml.kernel.org/r/20241026082423.26298-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    4 ++++
 include/linux/huge_mm.h                    |    1 +
 mm/huge_memory.c                           |    3 +++
 mm/page_io.c                               |    3 +++
 4 files changed, 11 insertions(+)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-add-per-order-mthp-swpin-counters
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -534,6 +534,10 @@ zswpout
 	is incremented every time a huge page is swapped out to zswap in one
 	piece without splitting.
 
+swpin
+	is incremented every time a huge page is swapped in from a non-zswap
+	swap device in one piece.
+
 swpout
 	is incremented every time a huge page is swapped out to a non-zswap
 	swap device in one piece without splitting.
--- a/include/linux/huge_mm.h~mm-add-per-order-mthp-swpin-counters
+++ a/include/linux/huge_mm.h
@@ -120,6 +120,7 @@ enum mthp_stat_item {
 	MTHP_STAT_ANON_FAULT_FALLBACK,
 	MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE,
 	MTHP_STAT_ZSWPOUT,
+	MTHP_STAT_SWPIN,
 	MTHP_STAT_SWPOUT,
 	MTHP_STAT_SWPOUT_FALLBACK,
 	MTHP_STAT_SHMEM_ALLOC,
--- a/mm/huge_memory.c~mm-add-per-order-mthp-swpin-counters
+++ a/mm/huge_memory.c
@@ -616,6 +616,7 @@ DEFINE_MTHP_STAT_ATTR(anon_fault_alloc,
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback, MTHP_STAT_ANON_FAULT_FALLBACK);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback_charge, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
 DEFINE_MTHP_STAT_ATTR(zswpout, MTHP_STAT_ZSWPOUT);
+DEFINE_MTHP_STAT_ATTR(swpin, MTHP_STAT_SWPIN);
 DEFINE_MTHP_STAT_ATTR(swpout, MTHP_STAT_SWPOUT);
 DEFINE_MTHP_STAT_ATTR(swpout_fallback, MTHP_STAT_SWPOUT_FALLBACK);
 #ifdef CONFIG_SHMEM
@@ -635,6 +636,7 @@ static struct attribute *anon_stats_attr
 	&anon_fault_fallback_charge_attr.attr,
 #ifndef CONFIG_SHMEM
 	&zswpout_attr.attr,
+	&swpin_attr.attr,
 	&swpout_attr.attr,
 	&swpout_fallback_attr.attr,
 #endif
@@ -666,6 +668,7 @@ static struct attribute_group file_stats
 static struct attribute *any_stats_attrs[] = {
 #ifdef CONFIG_SHMEM
 	&zswpout_attr.attr,
+	&swpin_attr.attr,
 	&swpout_attr.attr,
 	&swpout_fallback_attr.attr,
 #endif
--- a/mm/page_io.c~mm-add-per-order-mthp-swpin-counters
+++ a/mm/page_io.c
@@ -495,6 +495,7 @@ static void sio_read_complete(struct kio
 		for (p = 0; p < sio->pages; p++) {
 			struct folio *folio = page_folio(sio->bvec[p].bv_page);
 
+			count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
 			count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
 			folio_mark_uptodate(folio);
 			folio_unlock(folio);
@@ -589,6 +590,7 @@ static void swap_read_folio_bdev_sync(st
 	 * attempt to access it in the page fault retry time check.
 	 */
 	get_task_struct(current);
+	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
 	count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
 	count_vm_events(PSWPIN, folio_nr_pages(folio));
 	submit_bio_wait(&bio);
@@ -605,6 +607,7 @@ static void swap_read_folio_bdev_async(s
 	bio->bi_iter.bi_sector = swap_folio_sector(folio);
 	bio->bi_end_io = end_swap_bio_read;
 	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
+	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
 	count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
 	count_vm_events(PSWPIN, folio_nr_pages(folio));
 	submit_bio(bio);
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are


