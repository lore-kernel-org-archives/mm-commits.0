Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAC937F31C
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 04:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785990003; cv=none; b=BvbaUVi01IneuO9uGY/UWlPxT2GjSLM6hlZqTCF3c3CJhGOuS/CywQoV7Y7gsSdcYY+w85fDu/mZSTxkZFOzOqrUXRJlJ+UCZM1zVyBKhVlPPSpQw864oEiailpvj8Posr+V89OTfwbfTdbEtyC7paKI7PkILMfFaP5cXFV6M0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785990003; c=relaxed/simple;
	bh=5XVES3/WtQ71tSZ9WGnA1OWavm2WCBQLTfHQvruBC4Y=;
	h=Date:To:From:Subject:Message-Id; b=RM8dTGXZ9Rkzx82wh5mFdkRRBpee1y+kvF870WEv8jErrlWYCKS+AgGNSmUsTODUXs3hzM9xm/TWpNgOH2GKGPaE5WUm8jonbz6AkdgeiPCGQZZCsAOq17w5R1ycE7TiKhRzy1RJjmP75VdEYMxCZL3Z20AClb5/aG7AwZ8joK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zx1H5PUU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zx1H5PUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8DD1F000E9;
	Thu,  6 Aug 2026 04:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785989999;
	bh=/3ywRXwDgamrdsZAM6UOwPzD/s5Vd/LYyHkJf9X99wQ=;
	h=Date:To:From:Subject;
	b=zx1H5PUUsoUXvG0x98hfD88zerec9DnFEmxHg4kBeN2N49zS8olnhQj9tB/Ke3/Ir
	 JKTeojOOLt0Efg7XKVEablzuSdobB+Btrt9Mf8YWSMcao+VmrU7AoC2nkBtvs+Wf1n
	 59cUqc4bySaRFhhx8dlW2KGbkUuy8KbL+YVMsE1I=
Date: Wed, 05 Aug 2026 21:19:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,nico.pache@linux.dev,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,david@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-move-gather_after_split_folio_orders-into-vm_utilc-file.patch added to mm-new branch
Message-Id: <20260806041959.0B8DD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mm: move gather_after_split_folio_orders() into vm_util.c file
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-move-gather_after_split_folio_orders-into-vm_utilc-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-move-gather_after_split_folio_orders-into-vm_utilc-file.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: selftests: mm: move gather_after_split_folio_orders() into vm_util.c file
Date: Thu, 6 Aug 2026 11:34:13 +0800

Move gather_after_split_folio_orders() to vm_util.c as a helper function
in preparation for implementing checks for mTHP collapse.  While we are at
it, rename this function to indicate that it is not only used for large
folio splits.

No functional changes.

Link: https://lore.kernel.org/30a0a99556adf11c2bf97aa08d6da4830bb43f6f.1785985999.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Tested-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |  125 ------------
 tools/testing/selftests/mm/vm_util.c              |  119 +++++++++++
 tools/testing/selftests/mm/vm_util.h              |    2 
 3 files changed, 122 insertions(+), 124 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-move-gather_after_split_folio_orders-into-vm_utilc-file
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -104,129 +104,6 @@ fail:
 	return false;
 }
 
-static int vaddr_pageflags_get(char *vaddr, int pagemap_fd, int kpageflags_fd,
-		uint64_t *flags)
-{
-	unsigned long pfn;
-
-	pfn = pagemap_get_pfn(pagemap_fd, vaddr);
-
-	/* non-present PFN */
-	if (pfn == -1UL)
-		return 1;
-
-	if (pageflags_get(pfn, kpageflags_fd, flags))
-		return -1;
-
-	return 0;
-}
-
-/*
- * gather_after_split_folio_orders - scan through [vaddr_start, len) and record
- * folio orders
- *
- * @vaddr_start: start vaddr
- * @len: range length
- * @pagemap_fd: file descriptor to /proc/<pid>/pagemap
- * @kpageflags_fd: file descriptor to /proc/kpageflags
- * @orders: output folio order array
- * @nr_orders: folio order array size
- *
- * gather_after_split_folio_orders() scan through [vaddr_start, len) and check
- * all folios within the range and record their orders. All order-0 pages will
- * be recorded. Non-present vaddr is skipped.
- *
- * NOTE: the function is used to check folio orders after a split is performed,
- * so it assumes [vaddr_start, len) fully maps to after-split folios within that
- * range.
- *
- * Return: 0 - no error, -1 - unhandled cases
- */
-static int gather_after_split_folio_orders(char *vaddr_start, size_t len,
-		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders)
-{
-	uint64_t page_flags = 0;
-	int cur_order = -1;
-	char *vaddr;
-
-	if (pagemap_fd == -1 || kpageflags_fd == -1)
-		return -1;
-	if (!orders)
-		return -1;
-	if (nr_orders <= 0)
-		return -1;
-
-	for (vaddr = vaddr_start; vaddr < vaddr_start + len;) {
-		char *next_folio_vaddr;
-		int status;
-
-		status = vaddr_pageflags_get(vaddr, pagemap_fd, kpageflags_fd,
-					&page_flags);
-		if (status < 0)
-			return -1;
-
-		/* skip non present vaddr */
-		if (status == 1) {
-			vaddr += psize();
-			continue;
-		}
-
-		/* all order-0 pages with possible false postive (non folio) */
-		if (!(page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))) {
-			orders[0]++;
-			vaddr += psize();
-			continue;
-		}
-
-		/* skip non thp compound pages */
-		if (!(page_flags & KPF_THP)) {
-			vaddr += psize();
-			continue;
-		}
-
-		/* vpn points to part of a THP at this point */
-		if (page_flags & KPF_COMPOUND_HEAD)
-			cur_order = 1;
-		else {
-			vaddr += psize();
-			continue;
-		}
-
-		next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
-
-		if (next_folio_vaddr >= vaddr_start + len)
-			break;
-
-		while ((status = vaddr_pageflags_get(next_folio_vaddr,
-						     pagemap_fd, kpageflags_fd,
-						     &page_flags)) >= 0) {
-			/*
-			 * non present vaddr, next compound head page, or
-			 * order-0 page
-			 */
-			if (status == 1 ||
-			    (page_flags & KPF_COMPOUND_HEAD) ||
-			    !(page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))) {
-				if (cur_order < nr_orders) {
-					orders[cur_order]++;
-					cur_order = -1;
-					vaddr = next_folio_vaddr;
-				}
-				break;
-			}
-
-			cur_order++;
-			next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
-		}
-
-		if (status < 0)
-			return status;
-	}
-	if (cur_order > 0 && cur_order < nr_orders)
-		orders[cur_order]++;
-	return 0;
-}
-
 static int check_after_split_folio_orders(char *vaddr_start, size_t len,
 		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders)
 {
@@ -240,7 +117,7 @@ static int check_after_split_folio_order
 		ksft_exit_fail_msg("Cannot allocate memory for vaddr_orders");
 
 	memset(vaddr_orders, 0, sizeof(int) * nr_orders);
-	status = gather_after_split_folio_orders(vaddr_start, len, pagemap_fd,
+	status = gather_folio_orders(vaddr_start, len, pagemap_fd,
 				     kpageflags_fd, vaddr_orders, nr_orders);
 	if (status)
 		ksft_exit_fail_msg("gather folio info failed\n");
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-move-gather_after_split_folio_orders-into-vm_utilc-file
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -194,6 +194,125 @@ err_out:
 	return rss_anon;
 }
 
+static int vaddr_pageflags_get(char *vaddr, int pagemap_fd, int kpageflags_fd,
+		uint64_t *flags)
+{
+	unsigned long pfn;
+
+	pfn = pagemap_get_pfn(pagemap_fd, vaddr);
+
+	/* non-present PFN */
+	if (pfn == -1UL)
+		return 1;
+
+	if (pageflags_get(pfn, kpageflags_fd, flags))
+		return -1;
+
+	return 0;
+}
+
+/*
+ * gather_folio_orders - scan through [vaddr_start, len) and record
+ * folio orders
+ *
+ * @vaddr_start: start vaddr
+ * @len: range length
+ * @pagemap_fd: file descriptor to /proc/<pid>/pagemap
+ * @kpageflags_fd: file descriptor to /proc/kpageflags
+ * @orders: output folio order array
+ * @nr_orders: folio order array size
+ *
+ * gather_folio_orders() scan through [vaddr_start, len) and check
+ * all folios within the range and record their orders. All order-0 pages will
+ * be recorded. Non-present vaddr is skipped.
+ *
+ * Return: 0 - no error, -1 - unhandled cases
+ */
+int gather_folio_orders(char *vaddr_start, size_t len,
+		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders)
+{
+	uint64_t page_flags = 0;
+	int cur_order = -1;
+	char *vaddr;
+
+	if (pagemap_fd == -1 || kpageflags_fd == -1)
+		return -1;
+	if (!orders)
+		return -1;
+	if (nr_orders <= 0)
+		return -1;
+
+	for (vaddr = vaddr_start; vaddr < vaddr_start + len;) {
+		char *next_folio_vaddr;
+		int status;
+
+		status = vaddr_pageflags_get(vaddr, pagemap_fd, kpageflags_fd,
+				&page_flags);
+		if (status < 0)
+			return -1;
+
+		/* skip non present vaddr */
+		if (status == 1) {
+			vaddr += psize();
+			continue;
+		}
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
+			vaddr += psize();
+			continue;
+		}
+
+		next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
+
+		if (next_folio_vaddr >= vaddr_start + len)
+			break;
+
+		while ((status = vaddr_pageflags_get(next_folio_vaddr,
+						     pagemap_fd, kpageflags_fd,
+						     &page_flags)) >= 0) {
+			/*
+			 * non present vaddr, next compound head page, or
+			 * order-0 page
+			 */
+			if (status == 1 ||
+			    (page_flags & KPF_COMPOUND_HEAD) ||
+			    !(page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))) {
+				if (cur_order < nr_orders) {
+					orders[cur_order]++;
+					cur_order = -1;
+					vaddr = next_folio_vaddr;
+				}
+				break;
+			}
+
+			cur_order++;
+			next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
+		}
+
+		if (status < 0)
+			return status;
+	}
+	if (cur_order > 0 && cur_order < nr_orders)
+		orders[cur_order]++;
+	return 0;
+}
+
 char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
 {
 	int ret;
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-move-gather_after_split_folio_orders-into-vm_utilc-file
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -95,6 +95,8 @@ bool check_huge_file(void *addr, size_t
 bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
 int64_t allocate_transhuge(void *ptr, int pagemap_fd);
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
+int gather_folio_orders(char *vaddr_start, size_t len,
+		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-vmscan-convert-folio_referenced-to-use-vma_flags_t.patch
mm-vmscan-add-a-helper-to-identify-file-backed-executable-folios.patch
mm-mglru-promote-mapped-executable-folios-after-first-usage.patch
selftests-mm-extend-the-check_huge-to-support-mthp-check.patch
selftests-mm-move-gather_after_split_folio_orders-into-vm_utilc-file.patch
selftests-mm-implement-the-mthp-sized-hugepage-check-helpers.patch
selftests-mm-add-mthp-collapse-test-cases.patch

