Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196274776E
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725421745; cv=none; b=g8HjIiRyOZjXScJVewPdMBGLYU/5HEIpf5ILULU0De9HCYdKhTo16Frajv9XrsMdPGupQ1g/Ghn41GpzdLIcZ/gFFOCxclvju3oDV6XkUN1M2xdhPfsnTepUeTyniQB7xpZZYzEyg4qlwciiSaeMkaAYeLqCsQSgkUqKb2iddZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725421745; c=relaxed/simple;
	bh=ja3KowlOUaixQR53W43MlsBUUGSyHpP1LUF2WKG3YRk=;
	h=Date:To:From:Subject:Message-Id; b=TspqSV0yZ+VonuK0ddAcGFeeRWfk2fR5TFa6YB9d74IokocQWYMAd4kxeeKPqBRAhO9A9fMbhAI9TEy31hkPWbfi3Pwn9xJdnRVSLxF+WfFb1SQZBZ82kY7pDBmzGKC4gNDYouamBMpU5Js5B8tZcz5zzu+2ci9ghhki7gSZ9QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mkZqAYT+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mkZqAYT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7664C4CEC2;
	Wed,  4 Sep 2024 03:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725421744;
	bh=ja3KowlOUaixQR53W43MlsBUUGSyHpP1LUF2WKG3YRk=;
	h=Date:To:From:Subject:From;
	b=mkZqAYT+PU0PNOKVvzQaxrLaq+FmNI8RRmXRLJP5qch86xSHVfK3labEtJoJ3R9Y/
	 SrOAXskPSd/W6yOgaiYzU+d+jl6NXZJabhglg01BbO+6WOakIALaWTvfM1etO2jWBI
	 9+HT3txztoCrZjLVyjwT9WChWLUSciqeSqLBgWxc=
Date: Tue, 03 Sep 2024 20:49:04 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks-fix.patch removed from -mm tree
Message-Id: <20240904034904.D7664C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks-fix
has been removed from the -mm tree.  Its filename was
     mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks-fix.patch

This patch was dropped because it was folded into mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks.patch

------------------------------------------------------
From: Mike Rapoport <rppt@kernel.org>
Subject: mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks-fix
Date: Mon, 2 Sep 2024 09:46:34 +0300

fix build

Link: https://lkml.kernel.org/r/ZtVfSt_zloPdDqVB@kernel.org
Signed-off-by: Mike Rapoport <rppt@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202409020920.5S9U7dww-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/numa_memblks.h |    2 +-
 mm/numa_memblks.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/numa_memblks.h~mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks-fix
+++ a/include/linux/numa_memblks.h
@@ -47,7 +47,7 @@ static inline int numa_emu_cmdline(char
 #endif /* CONFIG_NUMA_EMU */
 
 #ifdef CONFIG_NUMA_KEEP_MEMINFO
-extern int phys_to_target_node(phys_addr_t start);
+extern int phys_to_target_node(u64 start);
 #define phys_to_target_node phys_to_target_node
 extern int memory_add_physaddr_to_nid(u64 start);
 #define memory_add_physaddr_to_nid memory_add_physaddr_to_nid
--- a/mm/numa_memblks.c~mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks-fix
+++ a/mm/numa_memblks.c
@@ -543,7 +543,7 @@ static int meminfo_to_nid(struct numa_me
 	return NUMA_NO_NODE;
 }
 
-int phys_to_target_node(phys_addr_t start)
+int phys_to_target_node(u64 start)
 {
 	int nid = meminfo_to_nid(&numa_meminfo, start);
 
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
docs-move-numa=fake-description-to-kernel-parameterstxt.patch

