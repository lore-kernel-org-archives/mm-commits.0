Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278004317B
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 18:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711390275; cv=none; b=S4Cz7G9yAXJe1nW6BOeRHVFDIHv7wxWohTzS9VHmmDxhQ7LZsiRu94UjZLDfu8Te0lv81ksKpzYFmZ6nLWd6slM7oIiri0dCXigpCGkPp1ln6QcJcY3MlKmLawF4oG/MVwzYd/LD7bGdDwUseAUJDRcV1jtJnQru93c8afi6VqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711390275; c=relaxed/simple;
	bh=UTht7TcsUcSF+F62hw5pp29knl3iOAYIYav4ov9ENNc=;
	h=Date:To:From:Subject:Message-Id; b=K8EIGggqIk8f0yoctvN3GSI8ekK+8MM/tOCuAEMhUGhuCruTfz36yFWVA2MEG2ShB3Ckxln/pfLN4Ef1sPMnaG+DJ/h6OhnBNzxTXigtKLy85XQlhTGpwDqvofwo2SAopiHvOfQxHve3WjfBjoKECpGR2eutAD4BkAsdIn3AxtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eCM//NSS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eCM//NSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04A2C433F1;
	Mon, 25 Mar 2024 18:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711390274;
	bh=UTht7TcsUcSF+F62hw5pp29knl3iOAYIYav4ov9ENNc=;
	h=Date:To:From:Subject:From;
	b=eCM//NSS++uQPMpgYqpv4hhSu/8RKCsSFT1bAtV+byJUoIeULGOtASn7ZMBYkf7z8
	 Wx0bjvMTBHF3YcLfiA/V87PFSfZmMXGUiN8nQDs9DAHOs/GFE55ymmtF95G3rLisaC
	 ST3WedFJnqImpK9PmOfLdGUxA1edoC/f6VRfLULM=
Date: Mon, 25 Mar 2024 11:11:14 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-add-new-function-calc_nr_all_pages.patch added to mm-unstable branch
Message-Id: <20240325181114.D04A2C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init.c: add new function calc_nr_all_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-add-new-function-calc_nr_all_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-add-new-function-calc_nr_all_pages.patch

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
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
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

mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch
x86-remove-unneeded-memblock_find_dma_reserve.patch
mm-mm_initc-remove-the-useless-dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_all_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch

