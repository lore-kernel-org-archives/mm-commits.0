Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27B913A258
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724801085; cv=none; b=LfwoZeZMo3n8p6t/0YacVyw4JWgnBQpmqX5eAH5O0hsmZIsG4M0A4zroVP/10HW3oOHslC73Uo9Botf52Mh5PZyI/AAvsVJ9IyEjRnMc0jKvdNxBy4663ZU3dlqup5yD2pW8ylQkiW8pPEbL+W56xCVp9sbTSCslLGQN9KQ6xgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724801085; c=relaxed/simple;
	bh=BB+DHDOHgR+8HNLxtOCpTrFek46q95pNV7G4rJpqWPs=;
	h=Date:To:From:Subject:Message-Id; b=VVL1Cu8RXHkG3fnNqdFe+L23Hb+r+ftxmo2ahdIHrolfgP6z+LeQFKaSvN3UIFrCbyHhqCSxCa8MxLlLvhN+rYlsmx7b4rLL3jY/peRJe+Cz4HztlgMmLi+r2eAy5B8ufBFg7CwEqbqRddNXnAxBjwBF9z8z6ulXyI5pQsgEo70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lpzXE1Bf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lpzXE1Bf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C31C4FE0C;
	Tue, 27 Aug 2024 23:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724801084;
	bh=BB+DHDOHgR+8HNLxtOCpTrFek46q95pNV7G4rJpqWPs=;
	h=Date:To:From:Subject:From;
	b=lpzXE1Bf5+2YaJ7nOXl/8vUxXMJbPy/jTjNTbYT6HXK57p6eZ/8ir5hxOanq9vEsq
	 UVS/Bg4mIZSq2iCOqZmq2s7/7EbU25jhbwkjtgkJtRY7NpdfCGRgXljc2w5kMntxbs
	 FL5JVJflPBv2PuTGpm2Tfj/M5517u9gYBy71B8l4=
Date: Tue, 27 Aug 2024 16:24:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,Jonathan.Cameron@huawei.com,david@redhat.com,dan.j.williams@intel.com,bfaccini@nvidia.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch_numa-switch-over-to-numa_memblks-fix-2.patch added to mm-unstable branch
Message-Id: <20240827232444.87C31C4FE0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch_numa-switch-over-to-numa_memblks-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     arch_numa-switch-over-to-numa_memblks-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch_numa-switch-over-to-numa_memblks-fix-2.patch

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
arch_numa-switch-over-to-numa_memblks-fix.patch
arch_numa-switch-over-to-numa_memblks-fix-2.patch
mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks.patch
docs-move-numa=fake-description-to-kernel-parameterstxt.patch

