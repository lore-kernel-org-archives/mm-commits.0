Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7688F2D9EE7
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866030; cv=none; b=QJcEBtk1XfBYJrpERegGK7v4m2bqPHZfxdJtP3v1vUs0lIjcZ1J01pyENv2W9dMOY9IbI/e6uBBjaXrU8gLPokve1VXpyWhErl5EXLf+59aR/3nPsMv6blg46Bp6H+DWQYYVtxaaQVROqRBPMF1UcenYWxullE0VUxZ4HcYsXj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866030; c=relaxed/simple;
	bh=3RH4O4O01s4JVezEbCYMsENgCxBXkyarjqatbbrrLuI=;
	h=Date:To:From:Subject:Message-Id; b=iufob6VouiGwYbioFext2Lr1Vw08fJKkqpyFhYnjQkl3dxjjzTsvc7krG+vpobl8KU1MICrx/qz9raOL46j0dRycjKIVNVwtG34rwcZCWHIixlRDdrgtSF4n9/8FnN0WoWV/mfo0V4+zfDTLac1JjztkltTsaXD/x93NdSevYW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=07q90qd+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="07q90qd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70471F0089A;
	Tue, 13 Oct 2026 04:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866025;
	bh=La7IQHLumuc7oaLk++E0X1y98Qs214v2HC4ua5Y5SHY=;
	h=Date:To:From:Subject;
	b=07q90qd+xp6lZ50ZrDNDvuRsfFL5sX7dqF+ZmDktMa9hmKVvnNQOgCOHPZqJSrUEw
	 +mSne4d/4JfbxVqnCwTzmnl64Z1YPxLFwgdJpjvtnXq35sHHbwpje0Bl5uNaOYlkE4
	 1SxDoF4YDALT2MB+4iRA/vN8jvMh3JkVKsHb+CQE=
Date: Mon, 12 Oct 2026 21:33:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,kernel-team@meta.com,jgg@ziepe.ca,hughd@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,agordeev@linux.ibm.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-folio-order-check-for-address-ranges.patch removed from -mm tree
Message-Id: <20261013043344.E70471F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add folio-order check for address ranges
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-folio-order-check-for-address-ranges.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: selftests/mm: add folio-order check for address ranges
Date: Sat, 19 Sep 2026 01:24:38 +0100

An mTHP collapse test needs to know that a range is backed by folios of
the target order, and that they sit where a collapse would put them. 
Nothing answers both: is_backed_by_folio() classifies the folio behind a
single page, and check_huge_anon() counts the folios of an order in a
range without saying where they start.

Add is_range_backed_by_order().  It requires every folio-sized, folio-
aligned part of the range to map one folio of that order, head to tail,
with the head at the start of the part.

A part backed by two smaller folios fails, and so does a folio mapped off
its natural alignment.  The mTHP cases need both to tell a collapsed range
from the one beside it.

Link: https://lore.kernel.org/20260919002451.496763-9-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Assisted-by: LLM
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: kernel-team@meta.com
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache (Red Hat) <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 tools/testing/selftests/mm/vm_util.c |   47 +++++++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h |    2 +
 2 files changed, 49 insertions(+)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-add-folio-order-check-for-address-ranges
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -551,6 +551,53 @@ fail:
 	ksft_exit_fail_msg("Failed to get folio info\n");
 }
 
+/**
+ * is_range_backed_by_order() - check that a range is backed by @order folios
+ * @start: start of the range, a multiple of the folio size
+ * @len: length of the range in bytes, a multiple of the folio size
+ * @order: the folio order to check for
+ * @pagemap_fd: open /proc/<pid>/pagemap of the range's owner
+ * @kpageflags_fd: open /proc/kpageflags
+ *
+ * Every folio-sized, folio-aligned part of the range must map one folio of
+ * @order, head to tail, with the head at the start of the part.  A part
+ * backed by several smaller folios fails, and so does a folio mapped off
+ * its natural alignment.
+ *
+ * Returns: true if the whole range is backed that way, false otherwise.
+ */
+bool is_range_backed_by_order(char *start, size_t len, int order,
+			      int pagemap_fd, int kpageflags_fd)
+{
+	const unsigned long nr_pages = 1UL << order;
+	const size_t folio_size = nr_pages * psize();
+	char *vaddr;
+
+	if ((uintptr_t)start % folio_size || len % folio_size)
+		return false;
+
+	for (vaddr = start; vaddr < start + len; vaddr += folio_size) {
+		const unsigned long pfn = pagemap_get_pfn(pagemap_fd, vaddr);
+		unsigned long i;
+
+		/* Not present, or a tail page */
+		if (pfn == -1UL || pfn % nr_pages)
+			return false;
+
+		for (i = 1; i < nr_pages; i++) {
+			char *page = vaddr + i * psize();
+
+			if (pagemap_get_pfn(pagemap_fd, page) != pfn + i)
+				return false;
+		}
+
+		if (!is_backed_by_folio(vaddr, order, pagemap_fd, kpageflags_fd))
+			return false;
+	}
+
+	return true;
+}
+
 /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
 int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls)
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-add-folio-order-check-for-address-ranges
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -101,6 +101,8 @@ int gather_folio_orders(char *vaddr_star
 		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders);
 bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 			int kpageflags_fd);
+bool is_range_backed_by_order(char *start, size_t len, int order,
+			      int pagemap_fd, int kpageflags_fd);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
_

Patches currently in -mm which might be from kas@kernel.org are

mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-call-collapse_file-from-collapse_single_pmd.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch

