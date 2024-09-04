Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2272F34
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725421703; cv=none; b=lDplZ2u1CzsCYVk69HTksyUN/5XId+hKQxwc6ZFykrBdgjFvQ66YlAiUub6FO1k/A7a7q3o9OYQZ2prubaPd+7QeIREwbWn2asnxDEHcmhfR18uTH4QmxUIXPReH+WqvfTFvs56lJX8HsvmkaBQNIG5Cb3jUU/hjEtj0KJUpJgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725421703; c=relaxed/simple;
	bh=M+7tO7A504SdPovkJhCUhRMVIx8iAucTYvrQ7PF8CgQ=;
	h=Date:To:From:Subject:Message-Id; b=WONRHTwvNO0dEdLn2MsBQbmkEMnL0rY716kPeo9qBSat/VlYcj4TWv9gxBIrrvXMEBMz3rGLHPMXgWONYtEcij7A0nTZHI+SPlQHq4lVye9iHPnJq0CK4p3Pvw7GKsWhikM+cSQC0v4vlGQ/hXJM3zT9r7QS7dBDeN+oNkGTa/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KhkQ8/7H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KhkQ8/7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F096CC4CEC2;
	Wed,  4 Sep 2024 03:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725421703;
	bh=M+7tO7A504SdPovkJhCUhRMVIx8iAucTYvrQ7PF8CgQ=;
	h=Date:To:From:Subject:From;
	b=KhkQ8/7HxVos0HahCQeJ2SjlgW3WtzRKqifPyDphhibCh3UT8fqh0yg3csBo/2ePU
	 J9uWBa0LKrj7miKFhXsq9OfzaUAfAfuZEck2oI0utfDDf3NXns7+wj4ZpXzH4TEy0l
	 i5Qtyo+SFZ5ddLsxBHXwscKXWtk1QpuaTevz602o=
Date: Tue, 03 Sep 2024 20:48:22 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,Jonathan.Cameron@huawei.com,david@redhat.com,dan.j.williams@intel.com,bfaccini@nvidia.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] arch_numa-switch-over-to-numa_memblks-fix-2.patch removed from -mm tree
Message-Id: <20240904034822.F096CC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch_numa-switch-over-to-numa_memblks-fix-2
has been removed from the -mm tree.  Its filename was
     arch_numa-switch-over-to-numa_memblks-fix-2.patch

This patch was dropped because it was folded into arch_numa-switch-over-to-numa_memblks.patch

------------------------------------------------------
From: Mike Rapoport <rppt@kernel.org>
Subject: arch_numa-switch-over-to-numa_memblks-fix-2
Date: Tue, 27 Aug 2024 11:52:55 +0300

PFN_PHYS() translation is unnecessary here, as memblock_start_of_DRAM() +
SZ_4G is already a memory size.

Link: https://lkml.kernel.org/r/Zs2T5wkSYO9MGcab@kernel.org
Signed-off-by: Mike Rapoport <rppt@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Bruno Faccini <bfaccini@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/arch_numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/arch_numa.c~arch_numa-switch-over-to-numa_memblks-fix-2
+++ a/drivers/base/arch_numa.c
@@ -346,7 +346,7 @@ void __init numa_emu_update_cpu_to_node(
 
 u64 __init numa_emu_dma_end(void)
 {
-	return PFN_PHYS(memblock_start_of_DRAM() + SZ_4G);
+	return memblock_start_of_DRAM() + SZ_4G;
 }
 
 void debug_cpumask_set_cpu(unsigned int cpu, int node, bool enable)
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-move-kernel-numac-to-mm.patch
mips-sgi-ip27-make-node_data-the-same-as-on-all-other-architectures.patch
mips-sgi-ip27-ensure-node_possible_map-only-contains-valid-nodes.patch
mips-sgi-ip27-drop-have_arch_nodedata_extension.patch
mips-loongson64-rename-__node_data-to-node_data.patch
mips-loongson64-drop-have_arch_nodedata_extension.patch
arch-mm-move-definition-of-node_data-to-generic-code.patch
mm-drop-config_have_arch_nodedata_extension.patch
arch-mm-pull-out-allocation-of-node_data-to-generic-code.patch
x86-numa-simplify-numa_distance-allocation.patch
x86-numa-use-get_pfn_range_for_nid-to-verify-that-node-spans-memory.patch
x86-numa-move-fake_node_-defines-to-numa_emu.patch
x86-numa_emu-simplify-allocation-of-phys_dist.patch
x86-numa_emu-split-__apicid_to_node-update-to-a-helper-function.patch
x86-numa_emu-use-a-helper-function-to-get-max_dma32_pfn.patch
x86-numa-numa_addremove_cpu-make-cpu-parameter-unsigned.patch
mm-introduce-numa_memblks.patch
mm-move-numa_distance-and-related-code-from-x86-to-numa_memblks.patch
mm-introduce-numa_emulation.patch
mm-numa_memblks-introduce-numa_memblks_init.patch
mm-numa_memblks-make-several-functions-and-variables-static.patch
mm-numa_memblks-use-memblock_startend_of_dram-when-sanitizing-meminfo.patch
of-numa-return-einval-when-no-numa-node-id-is-found.patch
arch_numa-switch-over-to-numa_memblks.patch
mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks.patch
mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks-fix.patch
docs-move-numa=fake-description-to-kernel-parameterstxt.patch

