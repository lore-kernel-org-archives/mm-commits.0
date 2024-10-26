Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637FFB67E
	for <mm-commits@vger.kernel.org>; Sat, 26 Oct 2024 23:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729984429; cv=none; b=RkoPdr3NmbSs2Jto3d7n08iR35EM801ZeoedER5EwBJ/9is+QPpszsawe84TlnFTcRIw9k3n6qVyiYC8V2TeOCZcEpG21XC5ve6kt829ka7bfp1r4XLV+a0wG+kpxR70ZYMMhNoXXbsZOLlo1oEdlVTUaaOrfjB3ywnaTIMqIuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729984429; c=relaxed/simple;
	bh=Psm+MfT5j54Vz3zZR/Go9qoIezsE8LNcS/0lqP7lKEM=;
	h=Date:To:From:Subject:Message-Id; b=Ilu7ySnTnCzyENio7VYviBweAq4k/RdcYoFs1yhdEdoMODvTfbphfrb2j3AalfgzpWWFXRCAPtfSCJFuSMPuT8WQnJThlN4LnkRXYuVxjTf2kZG5j8JLmsnEC2QhSPEObOZ2v5NfLcHEeN6GFWAgVydQDk3jksBTrhpJ5taX/us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jE4FrxBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jE4FrxBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D236AC4CEC6;
	Sat, 26 Oct 2024 23:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729984428;
	bh=Psm+MfT5j54Vz3zZR/Go9qoIezsE8LNcS/0lqP7lKEM=;
	h=Date:To:From:Subject:From;
	b=jE4FrxBNSmrQQfx74xaZCyXY8oT5nyFuCQ10RObCKowhfLHNbADVS3QqlA9quJtrW
	 yXLsHH++mBLPGm1kkxl9zKRjgLhqjikHruR8fc1E36HuYG7VPK9nBl0Z1ufeVQlcEF
	 huXaY33SqqhsUa2AI0dq7hNWAGVhC+IFp2LzjdhQ=
Date: Sat, 26 Oct 2024 16:13:48 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,usamaarif642@gmail.com,ryan.roberts@arm.com,kasong@tencent.com,kanchana.p.sridhar@intel.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-per-order-mthp-swpin-counters.patch added to mm-unstable branch
Message-Id: <20241026231348.D236AC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add per-order mTHP swpin counters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-per-order-mthp-swpin-counters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-per-order-mthp-swpin-counters.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: add per-order mTHP swpin counters
Date: Sat, 26 Oct 2024 21:24:23 +1300

This helps profile the sizes of folios being swapped in. Currently,
only mTHP swap-out is being counted.

Link: https://lkml.kernel.org/r/20241026082423.26298-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    3 +++
 include/linux/huge_mm.h                    |    1 +
 mm/huge_memory.c                           |    3 +++
 mm/page_io.c                               |    3 +++
 4 files changed, 10 insertions(+)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-add-per-order-mthp-swpin-counters
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -533,6 +533,9 @@ anon_fault_fallback_charge
 zswpout
 	is incremented every time a huge page is swapped out to zswap in one
 	piece without splitting.
+swpin
+	is incremented every time a huge page is swapped in from a non-zswap
+	swap device in one piece.
 
 swpout
 	is incremented every time a huge page is swapped out to a non-zswap
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
@@ -487,6 +487,7 @@ static void sio_read_complete(struct kio
 		for (p = 0; p < sio->pages; p++) {
 			struct folio *folio = page_folio(sio->bvec[p].bv_page);
 
+			count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
 			count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
 			folio_mark_uptodate(folio);
 			folio_unlock(folio);
@@ -573,6 +574,7 @@ static void swap_read_folio_bdev_sync(st
 	 * attempt to access it in the page fault retry time check.
 	 */
 	get_task_struct(current);
+	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
 	count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
 	count_vm_events(PSWPIN, folio_nr_pages(folio));
 	submit_bio_wait(&bio);
@@ -589,6 +591,7 @@ static void swap_read_folio_bdev_async(s
 	bio->bi_iter.bi_sector = swap_folio_sector(folio);
 	bio->bi_end_io = end_swap_bio_read;
 	bio_add_folio_nofail(bio, folio, folio_size(folio), 0);
+	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
 	count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
 	count_vm_events(PSWPIN, folio_nr_pages(folio));
 	submit_bio(bio);
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-fix-pswpin-counter-for-large-folios-swap-in.patch
mm-add-per-order-mthp-swpin-counters.patch

