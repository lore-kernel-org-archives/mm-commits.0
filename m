Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68F523EAAB
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343289; cv=none; b=Bwc4QlqKLohBbsGllcd/PKqAYj4y9ebONYmG8KoUrdeFvXfULM/8q4hD48MqDyd/EiWTK0OImDg3glrL21nME3ja5pGDxWVimDTgsf7RE1k0Vq0cDSGay8dO3zZJhzerO5h/072q4Pe2pestBym2EeJHtY4j5vu2/T7bO2e/H/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343289; c=relaxed/simple;
	bh=LvpcwnGYFFo/me21pmcRLWSK330QwKbL1YDS1bKSd8U=;
	h=Date:To:From:Subject:Message-Id; b=FIk6ZiuQGropcsJWerSeEHng5anSbaZg+HVQA8VTdh4orpQL5OTscC1nN7ZEmxML9xidZqp4MHjWf4bmMtsqMRyHgg0VZJS1pnA3r4bdlafE6Ox006MlFINUIZC6oVSQXJU3aakRzeIL8FmshTGFFwCO5ZhRRQZ9arJgxmR+sl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T2PIn/W6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T2PIn/W6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A459BC19421;
	Mon, 17 Nov 2025 01:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343289;
	bh=LvpcwnGYFFo/me21pmcRLWSK330QwKbL1YDS1bKSd8U=;
	h=Date:To:From:Subject:From;
	b=T2PIn/W6MTbf55l4qxWq78G2Jf8Dvd+23nxA3JvYALCUWMYdVrgVCdxTeb7GoURw5
	 IuGwMa79FpOG76nVA8TThBdePC9Vi3I+2Ky+21uGoR0ZaASpBq2zqasysYCe6fnRiZ
	 bVbrshmPxa0kD35CvSvh6SzbmbQUZR0qbtYfvrtk=
Date: Sun, 16 Nov 2025 17:34:49 -0800
To: mm-commits@vger.kernel.org,zhiw@nvidia.com,xueshuai@linux.alibaba.com,vsethi@nvidia.com,vbabka@suse.cz,u.kleine-koenig@baylibre.com,tony.luck@intel.com,targupta@nvidia.com,surenb@google.com,smita.koralahallichannabasappa@amd.com,rppt@kernel.org,peterz@infradead.org,nao.horiguchi@gmail.com,mochs@nvidia.com,mhocko@suse.com,mchehab@kernel.org,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,lenb@kernel.org,kwankhede@nvidia.com,kevin.tian@intel.com,Jonathan.Cameron@huawei.com,jgg@nvidia.com,ira.weiny@intel.com,guohanjun@huawei.com,david@redhat.com,cjia@nvidia.com,bp@alien8.de,aniketa@nvidia.com,alex@shazbot.org,ankita@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vfio-nvgrace-gpu-register-device-memory-for-poison-handling.patch removed from -mm tree
Message-Id: <20251117013449.A459BC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vfio/nvgrace-gpu: register device memory for poison handling
has been removed from the -mm tree.  Its filename was
     vfio-nvgrace-gpu-register-device-memory-for-poison-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ankit Agrawal <ankita@nvidia.com>
Subject: vfio/nvgrace-gpu: register device memory for poison handling
Date: Sun, 2 Nov 2025 18:44:34 +0000

The nvgrace-gpu-vfio-pci module [1] maps the device memory to the user VA
(Qemu) using remap_pfn_range() without adding the memory to the kernel. 
The device memory pages are not backed by struct page.  The previous patch
implements the mechanism to handle ECC/poison on memory page without
struct page.  This new mechanism is being used here.

The module registers its memory region and the address_space with the
kernel MM for ECC handling using the register_pfn_address_space()
registration API exposed by the kernel.

Link: https://lore.kernel.org/all/20240220115055.23546-1-ankita@nvidia.com/ [1]
Link: https://lkml.kernel.org/r/20251102184434.2406-4-ankita@nvidia.com
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
Acked-by: Alex Williamson <alex@shazbot.org>
Cc: Aniket Agashe <aniketa@nvidia.com>
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
Cc: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Smita Koralahalli Channabasappa <smita.koralahallichannabasappa@amd.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tarun Gupta <targupta@nvidia.com>
Cc: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Cc: Vikram Sethi <vsethi@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vfio/pci/nvgrace-gpu/main.c |   45 +++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

--- a/drivers/vfio/pci/nvgrace-gpu/main.c~vfio-nvgrace-gpu-register-device-memory-for-poison-handling
+++ a/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -8,6 +8,10 @@
 #include <linux/delay.h>
 #include <linux/jiffies.h>
 
+#ifdef CONFIG_MEMORY_FAILURE
+#include <linux/memory-failure.h>
+#endif
+
 /*
  * The device memory usable to the workloads running in the VM is cached
  * and showcased as a 64b device BAR (comprising of BAR4 and BAR5 region)
@@ -47,6 +51,9 @@ struct mem_region {
 		void *memaddr;
 		void __iomem *ioaddr;
 	};                      /* Base virtual address of the region */
+#ifdef CONFIG_MEMORY_FAILURE
+	struct pfn_address_space pfn_address_space;
+#endif
 };
 
 struct nvgrace_gpu_pci_core_device {
@@ -60,6 +67,28 @@ struct nvgrace_gpu_pci_core_device {
 	bool has_mig_hw_bug;
 };
 
+#ifdef CONFIG_MEMORY_FAILURE
+
+static int
+nvgrace_gpu_vfio_pci_register_pfn_range(struct mem_region *region,
+					struct vm_area_struct *vma)
+{
+	unsigned long nr_pages;
+	int ret = 0;
+
+	nr_pages = region->memlength >> PAGE_SHIFT;
+
+	region->pfn_address_space.node.start = vma->vm_pgoff;
+	region->pfn_address_space.node.last = vma->vm_pgoff + nr_pages - 1;
+	region->pfn_address_space.mapping = vma->vm_file->f_mapping;
+
+	ret = register_pfn_address_space(&region->pfn_address_space);
+
+	return ret;
+}
+
+#endif
+
 static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
 {
 	struct nvgrace_gpu_pci_core_device *nvdev =
@@ -127,6 +156,13 @@ static void nvgrace_gpu_close_device(str
 
 	mutex_destroy(&nvdev->remap_lock);
 
+#ifdef CONFIG_MEMORY_FAILURE
+	if (nvdev->resmem.memlength)
+		unregister_pfn_address_space(&nvdev->resmem.pfn_address_space);
+
+	unregister_pfn_address_space(&nvdev->usemem.pfn_address_space);
+#endif
+
 	vfio_pci_core_close_device(core_vdev);
 }
 
@@ -202,7 +238,14 @@ static int nvgrace_gpu_mmap(struct vfio_
 
 	vma->vm_pgoff = start_pfn;
 
-	return 0;
+#ifdef CONFIG_MEMORY_FAILURE
+	if (nvdev->resmem.memlength && index == VFIO_PCI_BAR2_REGION_INDEX)
+		ret = nvgrace_gpu_vfio_pci_register_pfn_range(&nvdev->resmem, vma);
+	else if (index == VFIO_PCI_BAR4_REGION_INDEX)
+		ret = nvgrace_gpu_vfio_pci_register_pfn_range(&nvdev->usemem, vma);
+#endif
+
+	return ret;
 }
 
 static long
_

Patches currently in -mm which might be from ankita@nvidia.com are


