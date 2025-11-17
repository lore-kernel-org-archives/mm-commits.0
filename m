Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B2223BD17
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343286; cv=none; b=k7uXHjLs4rTkPv2XpI2pYpj0fpxoq/HoOoHaVNPD9qIHhF7W6ksk+nt3p0LB4DLdoLzVgARY2IASnDSoQKMunnu1yFPrDtIbZGM2dpSo716LieCWSURk8zmS/NosrK3pmrrGg4JQkQ50CRzXH86exeC126KxwEQA36NmsO7f9X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343286; c=relaxed/simple;
	bh=LL8Bg0TEkCeRV5q+CqpH42hLW/F9MLvhww+zRRFUlv8=;
	h=Date:To:From:Subject:Message-Id; b=i1UeREw30BJ7luSitaVI7Sq1uYx4IoY9ee7Z38R90yc+iqpbFAIUiXpV+8SbNasrJjSGrHgsPAjD+DwFptIsTHRcpxQBOZD6KNpJmTnZ0IqDd3xGHbI4+YkuyeHdTWW8WNKkYjnLF8MRQb+4Z0Kevuti/aJWFCejgwqx/9QNrBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q4T3p2MM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q4T3p2MM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AFDC4CEF5;
	Mon, 17 Nov 2025 01:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343286;
	bh=LL8Bg0TEkCeRV5q+CqpH42hLW/F9MLvhww+zRRFUlv8=;
	h=Date:To:From:Subject:From;
	b=q4T3p2MMegVplq6UtlmsLpRP0pqd0uGHr6IBf10QI2SvuWGphiFdPl2fPPdX4QT61
	 Khf4y6zJOkwTiA1OHeDRtkbDt3d14p8YhF04T0fXAFMwzyB0usCuaMvaMcfrxyaRaA
	 z2AnfWYk3qPp1Km/96I8/ba8z6BgS220FhONZu6E=
Date: Sun, 16 Nov 2025 17:34:46 -0800
To: mm-commits@vger.kernel.org,zhiw@nvidia.com,xueshuai@linux.alibaba.com,vsethi@nvidia.com,vbabka@suse.cz,u.kleine-koenig@baylibre.com,tony.luck@intel.com,targupta@nvidia.com,surenb@google.com,smita.koralahallichannabasappa@amd.com,rppt@kernel.org,peterz@infradead.org,nao.horiguchi@gmail.com,mochs@nvidia.com,mhocko@suse.com,mchehab@kernel.org,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,lenb@kernel.org,kwankhede@nvidia.com,kevin.tian@intel.com,Jonathan.Cameron@huawei.com,jgg@nvidia.com,ira.weiny@intel.com,guohanjun@huawei.com,david@redhat.com,cjia@nvidia.com,bp@alien8.de,aniketa@nvidia.com,ankita@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-change-ghes-code-to-allow-poison-of-non-struct-pfn.patch removed from -mm tree
Message-Id: <20251117013446.97AFDC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: change ghes code to allow poison of non-struct pfn
has been removed from the -mm tree.  Its filename was
     mm-change-ghes-code-to-allow-poison-of-non-struct-pfn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ankit Agrawal <ankita@nvidia.com>
Subject: mm: change ghes code to allow poison of non-struct pfn
Date: Sun, 2 Nov 2025 18:44:32 +0000

Poison (or ECC) errors can be very common on a large size cluster.  The
kernel MM currently handles ECC errors / poison only on memory page backed
by struct page.  The handling is currently missing for the PFNMAP memory
that does not have struct pages.  The series adds such support.

Implement a new ECC handling for memory without struct pages.  Kernel MM
expose registration APIs to allow modules that are managing the device to
register its device memory region.  MM then tracks such regions using
interval tree.

The mechanism is largely similar to that of ECC on pfn with struct pages. 
If there is an ECC error on a pfn, all the mapping to it are identified
and a SIGBUS is sent to the user space processes owning those mappings. 
Note that there is one primary difference versus the handling of the
poison on struct pages, which is to skip unmapping to the faulty PFN. 
This is done to handle the huge PFNMAP support added recently [1] that
enables VM_PFNMAP vmas to map at PMD or PUD level.  A poison to a PFN
mapped in such as way would need breaking the PMD/PUD mapping into PTEs
that will get mirrored into the S2.  This can greatly increase the cost of
table walks and have a major performance impact.

nvgrace-gpu-vfio-pci module maps the device memory to user VA (Qemu) using
remap_pfn_range without being added to the kernel [2].  These device
memory PFNs are not backed by struct page.  So make nvgrace-gpu-vfio-pci
module make use of the mechanism to get poison handling support on the
device memory.


This patch (of 3):

The GHES code allows calling of memory_failure() on the PFNs that pass the
pfn_valid() check.  This contract is broken for the remapped PFNs which
fails the check and ghes_do_memory_failure() returns without triggering
memory_failure().

Update code to allow memory_failure() call on PFNs failing pfn_valid().

Link: https://lkml.kernel.org/r/20251102184434.2406-1-ankita@nvidia.com
Link: https://lkml.kernel.org/r/20251102184434.2406-2-ankita@nvidia.com
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Aniket Agashe <aniketa@nvidia.com>
Cc: Ankit Agrawal <ankita@nvidia.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Kirti Wankhede <kwankhede@nvidia.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Matthew R. Ochs <mochs@nvidia.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Neo Jia <cjia@nvidia.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Smita Koralahalli Channabasappa <smita.koralahallichannabasappa@amd.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tarun Gupta <targupta@nvidia.com>
Cc: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Cc: Vikram Sethi <vsethi@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/apei/ghes.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/acpi/apei/ghes.c~mm-change-ghes-code-to-allow-poison-of-non-struct-pfn
+++ a/drivers/acpi/apei/ghes.c
@@ -505,12 +505,6 @@ static bool ghes_do_memory_failure(u64 p
 		return false;
 
 	pfn = PHYS_PFN(physical_addr);
-	if (!pfn_valid(pfn) && !arch_is_platform_page(physical_addr)) {
-		pr_warn_ratelimited(FW_WARN GHES_PFX
-		"Invalid address in generic error data: %#llx\n",
-		physical_addr);
-		return false;
-	}
 
 	if (flags == MF_ACTION_REQUIRED && current->mm) {
 		twcb = (void *)gen_pool_alloc(ghes_estatus_pool, sizeof(*twcb));
_

Patches currently in -mm which might be from ankita@nvidia.com are


