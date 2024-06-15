Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FE41EB3D;
	Sat, 15 Jun 2024 17:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473434; cv=none; b=jq3VDcre0ZIVE8mazYuOfXN0HG5sDGBgWVS9gKsKz0QtT141FMDUmDX++HM/s3KAT6DKyc7dwpjSYlTA0zOT8TPkRnOM5FTjOuDfeMKYc1KXJdmD3+YUiUhF8jFiXjIc9as2AOZWaWoQ8P1km53eSek/B0QhklC7B+JS9gyvlxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473434; c=relaxed/simple;
	bh=AX+WEblTaMgIbNJmnbIR1QBP4wAGyaCzRE37RLy2Z2E=;
	h=Date:To:From:Subject:Message-Id; b=u3tpWvrZeAWD4g1LR5DMa8hGcRtBMyVMr1IMsoV0eRMV6jUxIlYpD+M0kGf71cUdTG/imwFJBb/OQXMA8aj0N737PcVEfZ2h/y+ofJZgmvU3B6Jxe30rx4RdoX6qmFmILq+FYxYrkUFQpD1saOuB8sUSogIh1zZopKQ931SoGeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d8+UwGj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d8+UwGj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26177C116B1;
	Sat, 15 Jun 2024 17:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473434;
	bh=AX+WEblTaMgIbNJmnbIR1QBP4wAGyaCzRE37RLy2Z2E=;
	h=Date:To:From:Subject:From;
	b=d8+UwGj0Ek0xgBqjGiuCV/x0uzZ4BPpoBreh37Z78YBObMS+yxG0PUStMxnfeDwpT
	 iahzfo47YEzbXI0l2AFYvbnaOWuh0umsWJiw3XMlsm3Lb7mNophIGJ24AYOHZsWoc8
	 2LHmMM3XxmT6jWwo6jMEGJ6IeALzIsqme4OBka6g=
Date: Sat, 15 Jun 2024 10:43:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,stable@vger.kernel.org,mhocko@kernel.org,david@redhat.com,baohua@kernel.org,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_memory-fix-misused-mapping_large_folio_support-for-anon-folios.patch removed from -mm tree
Message-Id: <20240615174354.26177C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: huge_memory: fix misused mapping_large_folio_support() for anon folios
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-misused-mapping_large_folio_support-for-anon-folios.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: mm: huge_memory: fix misused mapping_large_folio_support() for anon folios
Date: Fri, 7 Jun 2024 17:40:48 +0800 (CST)

When I did a large folios split test, a WARNING "[ 5059.122759][ T166]
Cannot split file folio to non-0 order" was triggered.  But the test cases
are only for anonmous folios.  while mapping_large_folio_support() is only
reasonable for page cache folios.

In split_huge_page_to_list_to_order(), the folio passed to
mapping_large_folio_support() maybe anonmous folio.  The folio_test_anon()
check is missing.  So the split of the anonmous THP is failed.  This is
also the same for shmem_mapping().  We'd better add a check for both.  But
the shmem_mapping() in __split_huge_page() is not involved, as for
anonmous folios, the end parameter is set to -1, so (head[i].index >= end)
is always false.  shmem_mapping() is not called.

Also add a VM_WARN_ON_ONCE() in mapping_large_folio_support() for anon
mapping, So we can detect the wrong use more easily.

THP folios maybe exist in the pagecache even the file system doesn't
support large folio, it is because when CONFIG_TRANSPARENT_HUGEPAGE is
enabled, khugepaged will try to collapse read-only file-backed pages to
THP.  But the mapping does not actually support multi order large folios
properly.

Using /sys/kernel/debug/split_huge_pages to verify this, with this patch,
large anon THP is successfully split and the warning is ceased.

Link: https://lkml.kernel.org/r/202406071740485174hcFl7jRxncsHDtI-Pz-o@zte.com.cn
Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    4 ++++
 mm/huge_memory.c        |   28 +++++++++++++++++-----------
 2 files changed, 21 insertions(+), 11 deletions(-)

--- a/include/linux/pagemap.h~mm-huge_memory-fix-misused-mapping_large_folio_support-for-anon-folios
+++ a/include/linux/pagemap.h
@@ -381,6 +381,10 @@ static inline void mapping_set_large_fol
  */
 static inline bool mapping_large_folio_support(struct address_space *mapping)
 {
+	/* AS_LARGE_FOLIO_SUPPORT is only reasonable for pagecache folios */
+	VM_WARN_ONCE((unsigned long)mapping & PAGE_MAPPING_ANON,
+			"Anonymous mapping always supports large folio");
+
 	return IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 		test_bit(AS_LARGE_FOLIO_SUPPORT, &mapping->flags);
 }
--- a/mm/huge_memory.c~mm-huge_memory-fix-misused-mapping_large_folio_support-for-anon-folios
+++ a/mm/huge_memory.c
@@ -3009,30 +3009,36 @@ int split_huge_page_to_list_to_order(str
 	if (new_order >= folio_order(folio))
 		return -EINVAL;
 
-	/* Cannot split anonymous THP to order-1 */
-	if (new_order == 1 && folio_test_anon(folio)) {
-		VM_WARN_ONCE(1, "Cannot split to order-1 folio");
-		return -EINVAL;
-	}
-
-	if (new_order) {
-		/* Only swapping a whole PMD-mapped folio is supported */
-		if (folio_test_swapcache(folio))
+	if (folio_test_anon(folio)) {
+		/* order-1 is not supported for anonymous THP. */
+		if (new_order == 1) {
+			VM_WARN_ONCE(1, "Cannot split to order-1 folio");
 			return -EINVAL;
+		}
+	} else if (new_order) {
 		/* Split shmem folio to non-zero order not supported */
 		if (shmem_mapping(folio->mapping)) {
 			VM_WARN_ONCE(1,
 				"Cannot split shmem folio to non-0 order");
 			return -EINVAL;
 		}
-		/* No split if the file system does not support large folio */
-		if (!mapping_large_folio_support(folio->mapping)) {
+		/*
+		 * No split if the file system does not support large folio.
+		 * Note that we might still have THPs in such mappings due to
+		 * CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping
+		 * does not actually support large folios properly.
+		 */
+		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
+		    !mapping_large_folio_support(folio->mapping)) {
 			VM_WARN_ONCE(1,
 				"Cannot split file folio to non-0 order");
 			return -EINVAL;
 		}
 	}
 
+	/* Only swapping a whole PMD-mapped folio is supported */
+	if (folio_test_swapcache(folio) && new_order)
+		return -EINVAL;
 
 	is_hzp = is_huge_zero_folio(folio);
 	if (is_hzp) {
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are

mm-huge_memory-mark-racy-access-onhuge_anon_orders_always.patch

