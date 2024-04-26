Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D30A7E112
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103998; cv=none; b=izienuNpyazLPOOnl9avjP1FDQhsjooJIFgkblusiP5boCaGdLWUntvqZkZOFNhtgNBE40tlr5B59lrBO1e9ur8ZdFFwT7GJdhH1FzWP7N+G5QbBnS2LyNN0OF4Abi7NxD5J6RdHUkfhMPx2h9/Og4310mkJbuiFexdAOv6O5JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103998; c=relaxed/simple;
	bh=SLLrBgNgpC9qbjtRp/s37veOaVZT/Mg6N4DjSjnm7Ko=;
	h=Date:To:From:Subject:Message-Id; b=m233CT5Di6pHrKd5vyVu7c8wweHRQ+yu9VQrqWKkrgSiFJKVzTGzJeVteCnfClmOW+zMEWThKDtdOwnUj2vq0m+9dK0ucWQbncGL192ruBee+o1yCma4rfMYjg8QPsYdWKW5pmjZB2BK01YcfRUWtOvycO1dKc6gxoCdq5hLwLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j/mZHrnl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j/mZHrnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F28C113CD;
	Fri, 26 Apr 2024 03:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103998;
	bh=SLLrBgNgpC9qbjtRp/s37veOaVZT/Mg6N4DjSjnm7Ko=;
	h=Date:To:From:Subject:From;
	b=j/mZHrnlU2/A83xLKm9X+0xuhqrWztGDo4ehflMwmtKlSpuuLjWLjgt6WirTSWsvq
	 FIKUcUuThLDkp6513s3uhANMNUealuyXtY2VhSbbtMSr+W5XLZdNPobqXiQOS/4gcL
	 f8Db9ChJysx6OeBLiJjnnfFOmovFYj/dkMVmyNEU=
Date: Thu, 25 Apr 2024 20:59:57 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-add-new-function-calc_nr_all_pages.patch removed from -mm tree
Message-Id: <20240426035958.01F28C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init.c: add new function calc_nr_all_pages()
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-add-new-function-calc_nr_all_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/mm_init.c: add new function calc_nr_all_pages()
Date: Mon, 25 Mar 2024 22:56:43 +0800

This is a preparation to calculate nr_kernel_pages and nr_all_pages, both
of which will be used later in alloc_large_system_hash().

nr_all_pages counts up all free but not reserved memory in memblock
allocator, including HIGHMEM memory.  While nr_kernel_pages counts up all
free but not reserved low memory in memblock allocator, excluding HIGHMEM
memory.

Link: https://lkml.kernel.org/r/20240325145646.1044760-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/mm/mm_init.c~mm-mm_initc-add-new-function-calc_nr_all_pages
+++ a/mm/mm_init.c
@@ -1265,6 +1265,30 @@ static void __init reset_memoryless_node
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

documentation-kdump-clean-up-the-outdated-description.patch
kexec-fix-the-unexpected-kexec_dprintk-macro.patch
crash-add-prefix-for-crash-dumping-messages.patch

