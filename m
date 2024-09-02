Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FD21A3A9C
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 19:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725304902; cv=none; b=eY/RB4zQ60AwPARAQGt2W8wKQDILTsZNzr+IS2XTsVmSE/z5AEW5oyMQxHxnE+SSthULnpNGYXfcPVo4vSaPJy2+JU+2rq/S4qYFAgucOQv7x0KE7TZzXgt1oXU1tRsoQqhXKcjjtPxh1imgXWsbWrkHCEosotcURkk794J0q2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725304902; c=relaxed/simple;
	bh=ZX0SfHB5w31LTmpQbbfU6HKZsd9sNtXZhAcxMV2Lm7s=;
	h=Date:To:From:Subject:Message-Id; b=pw/jyrf72AjSCKuAshtueDL0T9SmZ20IvuLAfsc/H8EajPKT9m4AzZwsgh8kpIhL6M8GaQCGBYov1/BU8g+SYczKgXvv6t272VN+DEb1QQgDmA4JRGvy/zG8MK7dtY/IJ0LQk39OUhn1V9wbeez37NFeq0gIMW0EdSSDJ/Vsvmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tPtM1XOm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tPtM1XOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C20C4CEC7;
	Mon,  2 Sep 2024 19:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725304901;
	bh=ZX0SfHB5w31LTmpQbbfU6HKZsd9sNtXZhAcxMV2Lm7s=;
	h=Date:To:From:Subject:From;
	b=tPtM1XOmgS4p5h2zF4L4yZfaiDwe9iJznJkC9vQOL9Nlfbn2ipp7gZCoLZR2xKEB1
	 u2juIBl1jvyKixI4pxo+Hh+H4PDzGk2V4jkSvGa0gB0EAngLDvgFJ1SmN4Gvd3McCK
	 yQdhEhkEspsR2fcWJq/SWS9oTrdjCNBHn16xU9UM=
Date: Mon, 02 Sep 2024 12:21:40 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks-fix.patch added to mm-unstable branch
Message-Id: <20240902192141.46C20C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks-fix.patch

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
arch_numa-switch-over-to-numa_memblks-fix.patch
arch_numa-switch-over-to-numa_memblks-fix-2.patch
mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks.patch
mm-make-range-to-target_node-lookup-facility-a-part-of-numa_memblks-fix.patch
docs-move-numa=fake-description-to-kernel-parameterstxt.patch

