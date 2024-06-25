Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C124A143890
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291638; cv=none; b=VAI8lAuVRkOwUVkpPKY7QLyRWbaZwd63bgGTaGt0wVt1ubHLlhdls39e8D/STs4zeUM4plg4orgbBx/gyqEApmR1TJ101TDqDrh18XEE/pFxswtIOIOaYCc+P8+Wy6PkwZ+ZDyueF7Z8NSm/l4ZuI9xO3K8Z92xZX+HzcVsDkdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291638; c=relaxed/simple;
	bh=iVrD9zUsz0wUJPs9WgER3OcJvbXgCsOqZ58e1BfM/nk=;
	h=Date:To:From:Subject:Message-Id; b=TLYPLFWloQrZCnteCJxfIqqHBBxiN9jepDQfVQzYyYfscSdne9kcjdz0f/wnMYRTjl2ctk/nPoQ6+sBpNRuJZNPKkDR+VId2IoxvdWn8BsM+4jmGp+CuEa9ce+HhEi2NDAIMHB8Se98VXzCtZ3UB6Z6ZFh4knzbV0OaM72C3Yi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=knGFsuM1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="knGFsuM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A1CC32789;
	Tue, 25 Jun 2024 05:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291638;
	bh=iVrD9zUsz0wUJPs9WgER3OcJvbXgCsOqZ58e1BfM/nk=;
	h=Date:To:From:Subject:From;
	b=knGFsuM1AOKoIIB/SiNZqZNdG6pQFUNwX4Qgtmb5zsE6F0JjAlc9uP9hcQeNJdQRm
	 xK2Qiv4+H+Pn9k6qVQ2PbWViRJZnaj7c1ZigW52nwSX5BDvuVsuM6TPbQk9VoldQ2s
	 6MjwuYd4ZMOaYl4COsMvw+SkafYu3lwMdCE9VsxY=
Date: Mon, 24 Jun 2024 22:00:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-add-mthp-counters-for-anonymous-shmem.patch removed from -mm tree
Message-Id: <20240625050038.94A1CC32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: add mTHP counters for anonymous shmem
has been removed from the -mm tree.  Its filename was
     mm-shmem-add-mthp-counters-for-anonymous-shmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: add mTHP counters for anonymous shmem
Date: Tue, 11 Jun 2024 18:11:10 +0800

Add mTHP counters for anonymous shmem.

[baolin.wang@linux.alibaba.com: update Documentation/admin-guide/mm/transhuge.rst]
  Link: https://lkml.kernel.org/r/d86e2e7f-4141-432b-b2ba-c6691f36ef0b@linux.alibaba.com
Link: https://lkml.kernel.org/r/4fd9e467d49ae4a747e428bcd821c7d13125ae67.1718090413.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <ioworker0@gmail.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   13 +++++++++++++
 include/linux/huge_mm.h                    |    3 +++
 mm/huge_memory.c                           |    6 ++++++
 mm/shmem.c                                 |   18 +++++++++++++++---
 4 files changed, 37 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-shmem-add-mthp-counters-for-anonymous-shmem
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -501,6 +501,19 @@ swpout_fallback
 	Usually because failed to allocate some continuous swap space
 	for the huge page.
 
+file_alloc
+	is incremented every time a file huge page is successfully
+	allocated.
+
+file_fallback
+	is incremented if a file huge page is attempted to be allocated
+	but fails and instead falls back to using small pages.
+
+file_fallback_charge
+	is incremented if a file huge page cannot be charged and instead
+	falls back to using small pages even though the allocation was
+	successful.
+
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
 huge page for use. There are some counters in ``/proc/vmstat`` to help
--- a/include/linux/huge_mm.h~mm-shmem-add-mthp-counters-for-anonymous-shmem
+++ a/include/linux/huge_mm.h
@@ -281,6 +281,9 @@ enum mthp_stat_item {
 	MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE,
 	MTHP_STAT_SWPOUT,
 	MTHP_STAT_SWPOUT_FALLBACK,
+	MTHP_STAT_FILE_ALLOC,
+	MTHP_STAT_FILE_FALLBACK,
+	MTHP_STAT_FILE_FALLBACK_CHARGE,
 	__MTHP_STAT_COUNT
 };
 
--- a/mm/huge_memory.c~mm-shmem-add-mthp-counters-for-anonymous-shmem
+++ a/mm/huge_memory.c
@@ -556,6 +556,9 @@ DEFINE_MTHP_STAT_ATTR(anon_fault_fallbac
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback_charge, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
 DEFINE_MTHP_STAT_ATTR(swpout, MTHP_STAT_SWPOUT);
 DEFINE_MTHP_STAT_ATTR(swpout_fallback, MTHP_STAT_SWPOUT_FALLBACK);
+DEFINE_MTHP_STAT_ATTR(file_alloc, MTHP_STAT_FILE_ALLOC);
+DEFINE_MTHP_STAT_ATTR(file_fallback, MTHP_STAT_FILE_FALLBACK);
+DEFINE_MTHP_STAT_ATTR(file_fallback_charge, MTHP_STAT_FILE_FALLBACK_CHARGE);
 
 static struct attribute *stats_attrs[] = {
 	&anon_fault_alloc_attr.attr,
@@ -563,6 +566,9 @@ static struct attribute *stats_attrs[] =
 	&anon_fault_fallback_charge_attr.attr,
 	&swpout_attr.attr,
 	&swpout_fallback_attr.attr,
+	&file_alloc_attr.attr,
+	&file_fallback_attr.attr,
+	&file_fallback_charge_attr.attr,
 	NULL,
 };
 
--- a/mm/shmem.c~mm-shmem-add-mthp-counters-for-anonymous-shmem
+++ a/mm/shmem.c
@@ -1772,6 +1772,9 @@ static struct folio *shmem_alloc_and_add
 
 			if (pages == HPAGE_PMD_NR)
 				count_vm_event(THP_FILE_FALLBACK);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+			count_mthp_stat(order, MTHP_STAT_FILE_FALLBACK);
+#endif
 			order = next_order(&suitable_orders, order);
 		}
 	} else {
@@ -1791,9 +1794,15 @@ allocated:
 		if (xa_find(&mapping->i_pages, &index,
 				index + pages - 1, XA_PRESENT)) {
 			error = -EEXIST;
-		} else if (pages == HPAGE_PMD_NR) {
-			count_vm_event(THP_FILE_FALLBACK);
-			count_vm_event(THP_FILE_FALLBACK_CHARGE);
+		} else if (pages > 1) {
+			if (pages == HPAGE_PMD_NR) {
+				count_vm_event(THP_FILE_FALLBACK);
+				count_vm_event(THP_FILE_FALLBACK_CHARGE);
+			}
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+			count_mthp_stat(folio_order(folio), MTHP_STAT_FILE_FALLBACK);
+			count_mthp_stat(folio_order(folio), MTHP_STAT_FILE_FALLBACK_CHARGE);
+#endif
 		}
 		goto unlock;
 	}
@@ -2167,6 +2176,9 @@ repeat:
 		if (!IS_ERR(folio)) {
 			if (folio_test_pmd_mappable(folio))
 				count_vm_event(THP_FILE_ALLOC);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+			count_mthp_stat(folio_order(folio), MTHP_STAT_FILE_ALLOC);
+#endif
 			goto alloced;
 		}
 		if (PTR_ERR(folio) == -EEXIST)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


