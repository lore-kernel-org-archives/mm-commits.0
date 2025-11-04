Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FD6255F2C
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 02:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762224498; cv=none; b=nkfqW5J11zOfnoCTc1+nDBjnWFeX1YNRbvxkVYjISjVYK/Mp8Y7NPw7F/FuTX/brjf1L+jRsOaxD1P9wgRGom1cg+11H0+BHQYe60/v154++knCRdzV50kbyDnAhVTxJV79QWF0Q9Wb+Rum9aO5l95K2qkgVXUQ21UIfKwdRY3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762224498; c=relaxed/simple;
	bh=X0lVaxJ4QlOhudRRnU3tqbHcFYFfhQlMrAwGUVEHLew=;
	h=Date:To:From:Subject:Message-Id; b=PFveChYzZqMdv4NV3qZTvclEqMIpHbMXo9uLU08B2qAIRaGS6BgSyPd9CFS6CYj3OR+QJQetbphCVOkuIwWyd/6W9GD6cNDXLZ195TeCu5F6a1uJ4EdJ9ZY+U1BPxvJS9RmuhTEN9E/Ogfy5dXa6rOM/cIC8GQFOUCY7rBYgi40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=01piLdQE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="01piLdQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16BDC4CEFD;
	Tue,  4 Nov 2025 02:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762224498;
	bh=X0lVaxJ4QlOhudRRnU3tqbHcFYFfhQlMrAwGUVEHLew=;
	h=Date:To:From:Subject:From;
	b=01piLdQEZPU+FHh8UajVVbn3rvvXuyb6WCmj5Bo5ekcFcvRp/O4eiX2PCfGttyy77
	 61NkxP8FA8GZOwptJ4r0tOdkSO8CFu7XHh70wMbDQ9jbGMrH3BEc8rfdHkaUHGW8rm
	 ZKKTUh1+9gkwzLmxjKpWuU9OfK2ZZT4DSyNLKFl4=
Date: Mon, 03 Nov 2025 18:48:17 -0800
To: mm-commits@vger.kernel.org,zhiw@nvidia.com,xueshuai@linux.alibaba.com,vsethi@nvidia.com,vbabka@suse.cz,u.kleine-koenig@baylibre.com,tony.luck@intel.com,targupta@nvidia.com,surenb@google.com,smita.koralahallichannabasappa@amd.com,rppt@kernel.org,peterz@infradead.org,nao.horiguchi@gmail.com,mochs@nvidia.com,mhocko@suse.com,mchehab@kernel.org,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,lenb@kernel.org,kwankhede@nvidia.com,kevin.tian@intel.com,Jonathan.Cameron@huawei.com,jgg@nvidia.com,ira.weiny@intel.com,guohanjun@huawei.com,david@redhat.com,cjia@nvidia.com,bp@alien8.de,aniketa@nvidia.com,ankita@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-ghes-code-to-allow-poison-of-non-struct-pfn.patch added to mm-new branch
Message-Id: <20251104024817.F16BDC4CEFD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: change ghes code to allow poison of non-struct pfn
has been added to the -mm mm-new branch.  Its filename is
     mm-change-ghes-code-to-allow-poison-of-non-struct-pfn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-ghes-code-to-allow-poison-of-non-struct-pfn.patch

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

mm-change-ghes-code-to-allow-poison-of-non-struct-pfn.patch
mm-handle-poisoning-of-pfn-without-struct-pages.patch
vfio-nvgrace-gpu-register-device-memory-for-poison-handling.patch

