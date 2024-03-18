Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC93381C8
	for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2024 18:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710788006; cv=none; b=iAj13wENX3CyWfGPWzaA3D2v9MT6GxviFXPeO1jESA/z3fte+K+Ruo89FpbX5pQRxd5GAdoZEMy5odq0JZiy+xWS3e5fmGXJNVFCxHN7xzdz8ENheb9+Mpj/qRtuKwrH1DDDb7MhFRP+nrdWuTLksgvjFYmVa4VZnSUezBc1+KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710788006; c=relaxed/simple;
	bh=KIXny4RTbL7HNH0lyZFTkmSNRClLj8L5tkw8KDZpsGU=;
	h=Date:To:From:Subject:Message-Id; b=Gw9x4yBoQVmaan0jr4bh6JI/vUXMCY2b6vl1xP83pHvuD+NR96Nimim3wEXCb0ePj+Dvpp+LfEnmjfPN5SH5I2Qp9p4p4UX6Tu2Ag1VKM8yfmPWYP1/zX2co6Af+IDA9+J/eiHIea7566dmfF/f09XRKRTcrwD39XN4K+YYUrGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WoI2UsjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WoI2UsjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B903C433C7;
	Mon, 18 Mar 2024 18:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710788006;
	bh=KIXny4RTbL7HNH0lyZFTkmSNRClLj8L5tkw8KDZpsGU=;
	h=Date:To:From:Subject:From;
	b=WoI2UsjHHRQjswsZq9GNsCICp2epiuWKfqEgnRVTDFhggSiODpX6VUm+6WMYvRG6c
	 M7QfB5cgQThRk4dZyOp3ulUap/xpTdGKDuc33026KgwdHiaGgW8Fl+1tnZgU2jdyoD
	 uaPPeIvpGtg7ReP1mPXV9JPmw5B7avCEZg6Ydb80=
Date: Mon, 18 Mar 2024 11:53:25 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-add-new-function-calc_nr_kernel_pages.patch added to mm-unstable branch
Message-Id: <20240318185326.2B903C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init.c: add new function calc_nr_kernel_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-add-new-function-calc_nr_kernel_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-add-new-function-calc_nr_kernel_pages.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/mm_init.c: add new function calc_nr_kernel_pages()
Date: Mon, 18 Mar 2024 22:21:35 +0800

This is a preparation to calculate nr_kernel_pages and nr_all_pages, both
of which will be used later in alloc_large_system_hash().

nr_all_pages counts up all free but not reserved memory in memblock
allocator, including HIGHMEM memory.  While nr_kernel_pages counts up all
free but not reserved low memory in memblock allocator, excluding HIGHMEM
memory.

Link: https://lkml.kernel.org/r/20240318142138.783350-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/mm/mm_init.c~mm-mm_initc-add-new-function-calc_nr_kernel_pages
+++ a/mm/mm_init.c
@@ -1264,6 +1264,30 @@ static void __init reset_memoryless_node
 	pr_debug("On node %d totalpages: 0\n", pgdat->node_id);
 }
 
+static void __init calc_nr_kernel_pages(void)
+{
+	unsigned long start_pfn, end_pfn;
+	phys_addr_t start_addr, end_addr;
+	u64 u;
+#ifdef CONFIG_HIGHMEM
+	unsigned long high_zone_low = arch_zone_lowest_possible_pfn[ZONE_HIGHMEM];
+#endif
+
+	for_each_free_mem_range(u, NUMA_NO_NODE, MEMBLOCK_NONE, &start_addr, &end_addr, NULL) {
+		start_pfn = PFN_UP(start_addr);
+		end_pfn   = PFN_DOWN(end_addr);
+
+		if (start_pfn < end_pfn) {
+			nr_all_pages += end_pfn - start_pfn;
+#ifdef CONFIG_HIGHMEM
+			start_pfn = clamp(start_pfn, 0, high_zone_low);
+			end_pfn = clamp(end_pfn, 0, high_zone_low);
+#endif
+			nr_kernel_pages += end_pfn - start_pfn;
+		}
+	}
+}
+
 static void __init calculate_node_totalpages(struct pglist_data *pgdat,
 						unsigned long node_start_pfn,
 						unsigned long node_end_pfn)
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-mm_initc-remove-the-useless-dma_reserve.patch
x86-remove-memblock_find_dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_kernel_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch

