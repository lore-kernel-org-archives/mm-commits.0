Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92771383
	for <mm-commits@vger.kernel.org>; Sat,  9 Aug 2025 00:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754700204; cv=none; b=ULCsNvMishhszevJTipqOrjqVRg9N4G/nJo4I1jqxbgXEsrALThchCyUSWGZHffDy8OW/eqDCqYWjVihnk8DPXmDNkBHh5l186vx8fswY4IPJVqvW+xM52BsK6Bv0+kCQOy9IihQ/spB9pUGf5QnNXXzV/qcosYF+x+W9phffSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754700204; c=relaxed/simple;
	bh=GwGEue+y00kh7m4QdCieOqP4I89SKc/gejbcjATtQFg=;
	h=Date:To:From:Subject:Message-Id; b=DKnJjjoL5DZGThGaNarouCzkxKzAEy40Ieex+ClCnxrvfPNv9Bsds2ITyRw9HwlrpMDLMSmCd7sJOrH+Ppk5d+i6u9a6HEOdeNNPzpMuR+R5dDoEt+Qn++LTdLrSWOyv8FN6mm3VYCmWGNbpLXINgJ0UsnrBl5RpB6ansh9PeL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QqYKdqhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QqYKdqhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDA1C4CEED;
	Sat,  9 Aug 2025 00:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754700204;
	bh=GwGEue+y00kh7m4QdCieOqP4I89SKc/gejbcjATtQFg=;
	h=Date:To:From:Subject:From;
	b=QqYKdqhh13z8pPNYPeRI7WMbvHr9NeMLehK2ul3G6a6qBX7txkxTavTOVTRnLeAg0
	 X0hYjHfeyvc0Ths/c2yGZPpwXXTOuCpK4r1W0lUEYx2QfXFKLAgtbg8hpW3N2f+Foc
	 NqyA32yIjX9NZkual3YdAEOy3OZjOWiJpS+6azVI=
Date: Fri, 08 Aug 2025 17:43:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-check_folio_orders-helper.patch added to mm-new branch
Message-Id: <20250809004324.4CDA1C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add check_folio_orders() helper.
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-check_folio_orders-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-check_folio_orders-helper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: add check_folio_orders() helper.
Date: Fri, 8 Aug 2025 15:01:43 -0400

The helper gathers an folio order statistics of folios within a virtual
address range and checks it against a given order list.  It aims to
provide a more precise folio order check instead of just checking the
existence of PMD folios.

Link: https://lkml.kernel.org/r/20250808190144.797076-3-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |    4 
 tools/testing/selftests/mm/vm_util.c              |  133 ++++++++++++
 tools/testing/selftests/mm/vm_util.h              |    7 
 3 files changed, 141 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-add-check_folio_orders-helper
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -34,8 +34,6 @@ uint64_t pmd_pagesize;
 #define PID_FMT_OFFSET "%d,0x%lx,0x%lx,%d,%d"
 #define PATH_FMT "%s,0x%lx,0x%lx,%d"
 
-#define PFN_MASK     ((1UL<<55)-1)
-#define KPF_THP      (1UL<<22)
 #define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
 
 int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
@@ -49,7 +47,7 @@ int is_backed_by_thp(char *vaddr, int pa
 
 		if (kpageflags_file) {
 			pread(kpageflags_file, &page_flags, sizeof(page_flags),
-				(paddr & PFN_MASK) * sizeof(page_flags));
+				PAGEMAP_PFN(paddr) * sizeof(page_flags));
 
 			return !!(page_flags & KPF_THP);
 		}
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-add-check_folio_orders-helper
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -338,6 +338,139 @@ int detect_hugetlb_page_sizes(size_t siz
 	return count;
 }
 
+static int get_page_flags(char *vaddr, int pagemap_file, int kpageflags_file,
+			  uint64_t *flags)
+{
+	unsigned long pfn;
+	size_t count;
+
+	pfn = pagemap_get_pfn(pagemap_file, vaddr);
+	/*
+	 * Treat non-present page as a page without any flag, so that
+	 * gather_folio_orders() just record the current folio order.
+	 */
+	if (pfn == -1UL) {
+		*flags = 0;
+		return 0;
+	}
+
+	count = pread(kpageflags_file, flags, sizeof(*flags),
+		      pfn * sizeof(*flags));
+
+	if (count != sizeof(*flags))
+		return -1;
+
+	return 0;
+}
+
+static int gather_folio_orders(char *vaddr_start, size_t len,
+			       int pagemap_file, int kpageflags_file,
+			       int orders[], int nr_orders)
+{
+	uint64_t page_flags = 0;
+	int cur_order = -1;
+	char *vaddr;
+
+	if (!pagemap_file || !kpageflags_file)
+		return -1;
+	if (nr_orders <= 0)
+		return -1;
+
+	for (vaddr = vaddr_start; vaddr < vaddr_start + len; ) {
+		char *next_folio_vaddr;
+		int status;
+
+		if (get_page_flags(vaddr, pagemap_file, kpageflags_file, &page_flags))
+			return -1;
+
+		/* all order-0 pages with possible false postive (non folio) */
+		if (!(page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))) {
+			orders[0]++;
+			vaddr += psize();
+			continue;
+		}
+
+		/* skip non thp compound pages */
+		if (!(page_flags & KPF_THP)) {
+			vaddr += psize();
+			continue;
+		}
+
+		/* vpn points to part of a THP at this point */
+		if (page_flags & KPF_COMPOUND_HEAD)
+			cur_order = 1;
+		else {
+			/* not a head nor a tail in a THP? */
+			if (!(page_flags & KPF_COMPOUND_TAIL))
+				return -1;
+			continue;
+		}
+
+		next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
+
+		if (next_folio_vaddr >= vaddr_start + len)
+			break;
+
+		while (!(status = get_page_flags(next_folio_vaddr, pagemap_file,
+						 kpageflags_file,
+						 &page_flags))) {
+			/* next compound head page or order-0 page */
+			if ((page_flags & KPF_COMPOUND_HEAD) ||
+			    !(page_flags & (KPF_COMPOUND_HEAD |
+			      KPF_COMPOUND_TAIL))) {
+				if (cur_order < nr_orders) {
+					orders[cur_order]++;
+					cur_order = -1;
+					vaddr = next_folio_vaddr;
+				}
+				break;
+			}
+
+			/* not a head nor a tail in a THP? */
+			if (!(page_flags & KPF_COMPOUND_TAIL))
+				return -1;
+
+			cur_order++;
+			next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
+		}
+
+		if (status)
+			return status;
+	}
+	if (cur_order > 0 && cur_order < nr_orders)
+		orders[cur_order]++;
+	return 0;
+}
+
+int check_folio_orders(char *vaddr_start, size_t len, int pagemap_file,
+			int kpageflags_file, int orders[], int nr_orders)
+{
+	int *vaddr_orders;
+	int status;
+	int i;
+
+	vaddr_orders = (int *)malloc(sizeof(int) * nr_orders);
+
+	if (!vaddr_orders)
+		ksft_exit_fail_msg("Cannot allocate memory for vaddr_orders");
+
+	memset(vaddr_orders, 0, sizeof(int) * nr_orders);
+	status = gather_folio_orders(vaddr_start, len, pagemap_file,
+				     kpageflags_file, vaddr_orders, nr_orders);
+	if (status)
+		return status;
+
+	status = 0;
+	for (i = 0; i < nr_orders; i++)
+		if (vaddr_orders[i] != orders[i]) {
+			ksft_print_msg("order %d: expected: %d got %d\n", i,
+				       orders[i], vaddr_orders[i]);
+			status = -1;
+		}
+
+	return status;
+}
+
 /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
 int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls)
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-add-check_folio_orders-helper
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -18,6 +18,11 @@
 #define PM_SWAP                       BIT_ULL(62)
 #define PM_PRESENT                    BIT_ULL(63)
 
+#define KPF_COMPOUND_HEAD             BIT_ULL(15)
+#define KPF_COMPOUND_TAIL             BIT_ULL(16)
+#define KPF_THP                       BIT_ULL(22)
+
+
 /*
  * Ignore the checkpatch warning, we must read from x but don't want to do
  * anything with it in order to trigger a read page fault. We therefore must use
@@ -85,6 +90,8 @@ bool check_huge_shmem(void *addr, int nr
 int64_t allocate_transhuge(void *ptr, int pagemap_fd);
 unsigned long default_huge_page_size(void);
 int detect_hugetlb_page_sizes(size_t sizes[], int max);
+int check_folio_orders(char *vaddr_start, size_t len, int pagemap_file,
+			int kpageflags_file, int orders[], int nr_orders);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-fix-force_read-to-read-input-value-correctly.patch
mm-huge_memory-add-new_order-and-offset-to-split_huge_pages-pr_debug.patch
selftests-mm-add-check_folio_orders-helper.patch
selftests-mm-check-after-split-folio-orders-in-split_huge_page_test.patch

