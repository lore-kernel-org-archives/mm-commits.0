Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053BD3D7A
	for <mm-commits@vger.kernel.org>; Sat, 24 Aug 2024 01:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724463766; cv=none; b=SCcvnjh/5J8ES4kvnZE+jctgiv7ENjGsWQQMGOS5tf1VCIukOqXJt0gECPN8wPV1zm2/gDXoedyGZOgIE3FdL+YVtMfmBdcp6/lR9hQcc5Sf8kQkNe4DROC/m7MT2rUJ4ba7eulBwSAMAAo8QosUGxoViggx/QFdZ8QVILyf+tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724463766; c=relaxed/simple;
	bh=eRQBMUblAe57pM/gdv/1c2Kl4HLUCKSVtD8gwq0tUK0=;
	h=Date:To:From:Subject:Message-Id; b=oNvYU3l1dSm84IydGOTDqrl2CYztkchzKBrzOGx03OwfFRyiQRqoj6xswDMSHPNdntscPwRLRoQVEes7pujWIDJ++cNalWLGk7OoRtcBqIExat1d8oqK6JWl+t+GQ8x5wnaK9cAG9j/aV1tJxvKKdvjVzu6qiP4kt2TfuTRCQG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cCpRvWfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cCpRvWfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697FBC32786;
	Sat, 24 Aug 2024 01:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724463765;
	bh=eRQBMUblAe57pM/gdv/1c2Kl4HLUCKSVtD8gwq0tUK0=;
	h=Date:To:From:Subject:From;
	b=cCpRvWfpunBDsTGwBjU0WnYmJgHbu85tSLxvvBysGsIsMKtvGcBtqWANKiAKgdEZF
	 Px2Qv5JJh66RKn0KIJBUpxi8bTywYvs/PTpDQtYVZWCEyOW+6Y/+JmiU8jmtCjyFII
	 9/nR759ZddXpE50/JrBDDtw7vhbjd/6Vfwop/yls=
Date: Fri, 23 Aug 2024 18:42:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanshuai@oppo.com,usamaarif642@gmail.com,ryan.roberts@arm.com,kasong@tencent.com,kaleshsingh@google.com,ioworker0@gmail.com,hanchuanhua@oppo.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-count-the-number-of-partially-mapped-anonymous-thps-per-size.patch added to mm-unstable branch
Message-Id: <20240824014245.697FBC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: count the number of partially mapped anonymous THPs per size
has been added to the -mm mm-unstable branch.  Its filename is
     mm-count-the-number-of-partially-mapped-anonymous-thps-per-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-count-the-number-of-partially-mapped-anonymous-thps-per-size.patch

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
Subject: mm: count the number of partially mapped anonymous THPs per size
Date: Sat, 24 Aug 2024 13:04:41 +1200

When a THP is added to the deferred_list due to partially mapped, its
partial pages are unused, leading to wasted memory and potentially
increasing memory reclamation pressure.

Detailing the specifics of how unmapping occurs is quite difficult and not
that useful, so we adopt a simple approach: each time a THP enters the
deferred_list, we increment the count by 1; whenever it leaves for any
reason, we decrement the count by 1.

Link: https://lkml.kernel.org/r/20240824010441.21308-3-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuai Yuan <yuanshuai@oppo.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    7 +++++++
 include/linux/huge_mm.h                    |    1 +
 mm/huge_memory.c                           |    6 ++++++
 3 files changed, 14 insertions(+)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-count-the-number-of-partially-mapped-anonymous-thps-per-size
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -556,6 +556,13 @@ nr_anon
        These huge pages could be entirely mapped or have partially
        unmapped/unused subpages.
 
+nr_anon_partially_mapped
+       the number of anonymous THP which are likely partially mapped, possibly
+       wasting memory, and have been queued for deferred memory reclamation.
+       Note that in corner some cases (e.g., failed migration), we might detect
+       an anonymous THP as "partially mapped" and count it here, even though it
+       is not actually partially mapped anymore.
+
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
 huge page for use. There are some counters in ``/proc/vmstat`` to help
--- a/include/linux/huge_mm.h~mm-count-the-number-of-partially-mapped-anonymous-thps-per-size
+++ a/include/linux/huge_mm.h
@@ -127,6 +127,7 @@ enum mthp_stat_item {
 	MTHP_STAT_SPLIT_FAILED,
 	MTHP_STAT_SPLIT_DEFERRED,
 	MTHP_STAT_NR_ANON,
+	MTHP_STAT_NR_ANON_PARTIALLY_MAPPED,
 	__MTHP_STAT_COUNT
 };
 
--- a/mm/huge_memory.c~mm-count-the-number-of-partially-mapped-anonymous-thps-per-size
+++ a/mm/huge_memory.c
@@ -598,6 +598,7 @@ DEFINE_MTHP_STAT_ATTR(split, MTHP_STAT_S
 DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_FAILED);
 DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
 DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
+DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPPED);
 
 static struct attribute *anon_stats_attrs[] = {
 	&anon_fault_alloc_attr.attr,
@@ -611,6 +612,7 @@ static struct attribute *anon_stats_attr
 	&split_failed_attr.attr,
 	&split_deferred_attr.attr,
 	&nr_anon_attr.attr,
+	&nr_anon_partially_mapped_attr.attr,
 	NULL,
 };
 
@@ -3457,6 +3459,7 @@ int split_huge_page_to_list_to_order(str
 		if (folio_order(folio) > 1 &&
 		    !list_empty(&folio->_deferred_list)) {
 			ds_queue->split_queue_len--;
+			mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 			/*
 			 * Reinitialize page_deferred_list after removing the
 			 * page from the split_queue, otherwise a subsequent
@@ -3523,6 +3526,7 @@ void __folio_undo_large_rmappable(struct
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	if (!list_empty(&folio->_deferred_list)) {
 		ds_queue->split_queue_len--;
+		mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 		list_del_init(&folio->_deferred_list);
 	}
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
@@ -3564,6 +3568,7 @@ void deferred_split_folio(struct folio *
 		if (folio_test_pmd_mappable(folio))
 			count_vm_event(THP_DEFERRED_SPLIT_PAGE);
 		count_mthp_stat(folio_order(folio), MTHP_STAT_SPLIT_DEFERRED);
+		mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, 1);
 		list_add_tail(&folio->_deferred_list, &ds_queue->split_queue);
 		ds_queue->split_queue_len++;
 #ifdef CONFIG_MEMCG
@@ -3611,6 +3616,7 @@ static unsigned long deferred_split_scan
 			list_move(&folio->_deferred_list, &list);
 		} else {
 			/* We lost race with folio_put() */
+			mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 			list_del_init(&folio->_deferred_list);
 			ds_queue->split_queue_len--;
 		}
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-extend-usage-parameter-so-that-cluster_swap_free_nr-can-be-reused.patch
mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios.patch
mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios-fix.patch
vpda-try-to-fix-the-potential-crash-due-to-misusing-__gfp_nofail.patch
mm-document-__gfp_nofail-must-be-blockable.patch
mm-bug_on-to-avoid-null-deference-while-__gfp_nofail-fails.patch
mm-prohibit-null-deference-exposed-for-unsupported-non-blockable-__gfp_nofail.patch
mm-rename-instances-of-swap_info_struct-to-meaningful-si.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix.patch
mm-override-mthp-enabled-defaults-at-kernel-cmdline-fix.patch
mm-count-the-number-of-anonymous-thps-per-size.patch
mm-count-the-number-of-partially-mapped-anonymous-thps-per-size.patch

