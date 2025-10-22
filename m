Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E42169AD2;
	Wed, 22 Oct 2025 19:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761159723; cv=none; b=gQimT5gmU6eE7dlHaZkAL3eEL5UJ6Yhb0dhMXASiSdV3vx6Q3dFqGJTPYSkY/cdDezeK+0pNy2OHjBbOwLx0dTC/gw4jLg4xFcHWEu8FZ7aO1WDmaMOId2noNd+EQheNcOSxT3XQbrj1a8yz9D0P9OF1I14f8Er2RjXSJkyArqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761159723; c=relaxed/simple;
	bh=vRb2EcmjE0J8kyoIGAtBTehPankwaZCb8rtifDRRbrs=;
	h=Date:To:From:Subject:Message-Id; b=LLH7obG4RBEWYeMLQ4MnqxG2YYhxOJ4jN+MbwmzcjfuKdmO+Fz/oqoI6Uprpf2Bc3gZGB3a93H5x3ZoKuJZ4y1g0cfMxOagOz5cPslU2XpeC7soLNqku0ZvcA8PMVwETiJES2R0utJolSWiD06yOSNX96dTbraAZY1AnM/Av6dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XdbMiHE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XdbMiHE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DC3C4CEE7;
	Wed, 22 Oct 2025 19:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761159723;
	bh=vRb2EcmjE0J8kyoIGAtBTehPankwaZCb8rtifDRRbrs=;
	h=Date:To:From:Subject:From;
	b=XdbMiHE7nj7nrI1iQfs3aX8ApMRBDu2CDoKbMVd9cAyUI2A1g8LVGHamfR+OLHGGk
	 7DqEYqjkarzmRNCWvjWIgoA0oGZZT50y08qIIBiEKviRBbQnB+QBidWARlEY1x2B4v
	 GodPq3Zl9kMc7MRHCHsHyzo0RFnsjJwYrdwHPy3c=
Date: Wed, 22 Oct 2025 12:02:02 -0700
To: mm-commits@vger.kernel.org,yi1.lai@intel.com,willy@infradead.org,will@kernel.org,vinicius.gomes@intel.com,vbabka@suse.cz,vasant.hegde@amd.com,urezki@gmail.com,tglx@linutronix.de,stable@vger.kernel.org,rppt@kernel.org,robin.murphy@arm.com,peterz@infradead.org,mingo@redhat.com,mhocko@kernel.org,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.tian@intel.com,joro@8bytes.org,jgg@nvidia.com,jean-philippe@linaro.org,jannh@google.com,david@redhat.com,dave.hansen@intel.com,bp@alien8.de,apopple@nvidia.com,baolu.lu@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + iommu-disable-sva-when-config_x86-is-set.patch added to mm-new branch
Message-Id: <20251022190203.56DC3C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: iommu: disable SVA when CONFIG_X86 is set
has been added to the -mm mm-new branch.  Its filename is
     iommu-disable-sva-when-config_x86-is-set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iommu-disable-sva-when-config_x86-is-set.patch

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
From: Lu Baolu <baolu.lu@linux.intel.com>
Subject: iommu: disable SVA when CONFIG_X86 is set
Date: Wed, 22 Oct 2025 16:26:27 +0800

Patch series "Fix stale IOTLB entries for kernel address space", v7.

This proposes a fix for a security vulnerability related to IOMMU Shared
Virtual Addressing (SVA).  In an SVA context, an IOMMU can cache kernel
page table entries.  When a kernel page table page is freed and
reallocated for another purpose, the IOMMU might still hold stale,
incorrect entries.  This can be exploited to cause a use-after-free or
write-after-free condition, potentially leading to privilege escalation or
data corruption.

This solution introduces a deferred freeing mechanism for kernel page
table pages, which provides a safe window to notify the IOMMU to
invalidate its caches before the page is reused.


This patch (of 8):

In the IOMMU Shared Virtual Addressing (SVA) context, the IOMMU hardware
shares and walks the CPU's page tables.  The x86 architecture maps the
kernel's virtual address space into the upper portion of every process's
page table.  Consequently, in an SVA context, the IOMMU hardware can walk
and cache kernel page table entries.

The Linux kernel currently lacks a notification mechanism for kernel page
table changes, specifically when page table pages are freed and reused. 
The IOMMU driver is only notified of changes to user virtual address
mappings.  This can cause the IOMMU's internal caches to retain stale
entries for kernel VA.

Use-After-Free (UAF) and Write-After-Free (WAF) conditions arise when
kernel page table pages are freed and later reallocated.  The IOMMU could
misinterpret the new data as valid page table entries.  The IOMMU might
then walk into attacker-controlled memory, leading to arbitrary physical
memory DMA access or privilege escalation.  This is also a
Write-After-Free issue, as the IOMMU will potentially continue to write
Accessed and Dirty bits to the freed memory while attempting to walk the
stale page tables.

Currently, SVA contexts are unprivileged and cannot access kernel
mappings.  However, the IOMMU will still walk kernel-only page tables all
the way down to the leaf entries, where it realizes the mapping is for the
kernel and errors out.  This means the IOMMU still caches these
intermediate page table entries, making the described vulnerability a real
concern.

Disable SVA on x86 architecture until the IOMMU can receive notification
to flush the paging cache before freeing the CPU kernel page table pages.

Link: https://lkml.kernel.org/r/20251022082635.2462433-1-baolu.lu@linux.intel.com
Link: https://lkml.kernel.org/r/20251022082635.2462433-2-baolu.lu@linux.intel.com
Fixes: 26b25a2b98e4 ("iommu: Bind process address spaces to devices")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robin Murohy <robin.murphy@arm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yi Lai <yi1.lai@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/iommu-sva.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iommu/iommu-sva.c~iommu-disable-sva-when-config_x86-is-set
+++ a/drivers/iommu/iommu-sva.c
@@ -77,6 +77,9 @@ struct iommu_sva *iommu_sva_bind_device(
 	if (!group)
 		return ERR_PTR(-ENODEV);
 
+	if (IS_ENABLED(CONFIG_X86))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	mutex_lock(&iommu_sva_lock);
 
 	/* Allocate mm->pasid if necessary. */
_

Patches currently in -mm which might be from baolu.lu@linux.intel.com are

iommu-disable-sva-when-config_x86-is-set.patch
x86-mm-use-pagetable_free.patch
iommu-sva-invalidate-stale-iotlb-entries-for-kernel-address-space.patch

