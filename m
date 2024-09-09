Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36D218A925
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925212; cv=none; b=OJmMxqD2dUXFZ/jT1Aqwlz8E90o+qWRZqpCjJYvspmnlfpZAqVPxWXWK9i07iChXIuJs0WBT0n4KaWtf1JEMvJdWi0VFWVM1Wia2DNEyI+/Rw2a/+mbJyS51te4ldfKINpOX2i01doopIbMHJ+bWxqj5UjTbL99NsGuAlWiF+VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925212; c=relaxed/simple;
	bh=IYUma5ZY6+LNsOky8oAhmdqykxNwgytha1J5uK0B28E=;
	h=Date:To:From:Subject:Message-Id; b=qbuR1fiCmO2gUQhUEy3NLj+jV4Z06bPNyh5+TG6e8xcjMzokebmJivMxGHRADJLYilcgH0cKp8hVNzLbu73eVtc3qPvdkWqxY9Y89M+JomasxxFOxapkn1YulSA+Gl5UceovyiLkdd7z214gHs7GsXg6nZXU6kAJK8ZdrBg7ZHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DvPBy5FC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DvPBy5FC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741F4C4CEC5;
	Mon,  9 Sep 2024 23:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925212;
	bh=IYUma5ZY6+LNsOky8oAhmdqykxNwgytha1J5uK0B28E=;
	h=Date:To:From:Subject:From;
	b=DvPBy5FC1TZaL5mvVShbuenvt/Vja/yfsGHyC0pm9WOK8Qb5Z9BKV/fSllJivIJRp
	 hqZPpoksk/harC7AJvpYGyF6LFLdK9CJ82xquK7pSDesy0z2XF9M3AsMh7tb1lqh38
	 hFbUVz+rKKfdnRShsl2plV4+/IoXqwcpMAwhRpKU=
Date: Mon, 09 Sep 2024 16:40:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanshuai@oppo.com,usamaarif642@gmail.com,ryan.roberts@arm.com,kasong@tencent.com,kaleshsingh@google.com,ioworker0@gmail.com,hanchuanhua@oppo.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-count-the-number-of-partially-mapped-anonymous-thps-per-size.patch removed from -mm tree
Message-Id: <20240909234012.741F4C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: count the number of partially mapped anonymous THPs per size
has been removed from the -mm tree.  Its filename was
     mm-count-the-number-of-partially-mapped-anonymous-thps-per-size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
        might be currently entirely mapped or have partially unmapped/unused
        subpages.
 
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
@@ -609,6 +610,7 @@ static struct attribute *anon_stats_attr
 #endif
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


