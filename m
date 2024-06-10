Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CFC1487F1
	for <mm-commits@vger.kernel.org>; Mon, 10 Jun 2024 18:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718042663; cv=none; b=M/xjlhkHV+NVrIEputa3xyQ7EwRukHcLwTe7sphTF4bXOBWATQpptvZ1wB/i8jmucKP3AtjHee/KuYJma7ruC4wZOBFY5gua2ivL+/E9kcc9YHEVSacBvwrMdQXIK0a39zMAvs+9LppvsAFmFmDmCqHnCPIJAu0QeTn5VOO1c0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718042663; c=relaxed/simple;
	bh=iVozXNIzZy3lvNGuqv40M0KPC+VArbRurbFKWtbev+0=;
	h=Date:To:From:Subject:Message-Id; b=Q3ejTSVrJ7xsxwo249tT+iwhKioTzw5OZ2phhbOHs0bQTls/Ieuye7X50BfrSspiEJZh80qMcgfBLpatPzY+nE1UXplyKDtachyd1UBAA94+RQtFYakeRr3zn7r36aCbkYlQVKfPUnzsAZK5N9QhabuDSNl+EpU5nXyl+xC+B6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O4j4i+mY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O4j4i+mY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03258C2BBFC;
	Mon, 10 Jun 2024 18:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718042663;
	bh=iVozXNIzZy3lvNGuqv40M0KPC+VArbRurbFKWtbev+0=;
	h=Date:To:From:Subject:From;
	b=O4j4i+mYbHJFzi0ptDwkk9KVA8nNUtNj++mgv5KBxfKjaqp/+j5b8wsS302/IRV0e
	 NL4JDo//qSP2CTS4c3tv0aWJQz5LUZbPTlRqmMIesnSgsblrF0qhTFzImBsbwrUSIq
	 3/pvDdyVrOIqQKyFrkSw87aGcQ+mrb1PrSHsvN8I=
Date: Mon, 10 Jun 2024 11:04:22 -0700
To: mm-commits@vger.kernel.org,xiongwei.song@windriver.com,willy@infradead.org,urezki@gmail.com,shubhang@os.amperecomputing.com,guoren@kernel.org,corbet@lwn.net,cl@linux.com,Shubhang@os.amperecomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmalloc-modify-the-alloc_vmap_area-error-message-for-better-diagnostics.patch added to mm-unstable branch
Message-Id: <20240610180423.03258C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmalloc: Modify the alloc_vmap_area() error message for better diagnostics
has been added to the -mm mm-unstable branch.  Its filename is
     vmalloc-modify-the-alloc_vmap_area-error-message-for-better-diagnostics.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmalloc-modify-the-alloc_vmap_area-error-message-for-better-diagnostics.patch

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
From: Shubhang Kaushik OS <Shubhang@os.amperecomputing.com>
Subject: vmalloc: Modify the alloc_vmap_area() error message for better diagnostics
Date: Mon, 10 Jun 2024 17:22:58 +0000

'vmap allocation for size %lu failed: use vmalloc=<size> to increase size'
The above warning is seen in the kernel functionality for allocation of
the restricted virtual memory range till exhaustion.

This message is misleading because 'vmalloc=' is supported on arm32, x86
platforms and is not a valid kernel parameter on a number of other
platforms (in particular its not supported on arm64, alpha, loongarch,
arc, csky, hexagon, microblaze, mips, nios2, openrisc, parisc, m64k,
powerpc, riscv, sh, um, xtensa, s390, sparc).  With the update, the output
gets modified to include the function parameters along with the start and
end of the virtual memory range allowed.

The warning message after fix on kernel version 6.10.0-rc1+:

vmalloc_node_range for size 33619968 failed: Address range restricted between 0xffff800082640000 - 0xffff800084650000

Backtrace with the misleading error message:

	vmap allocation for size 33619968 failed: use vmalloc=<size> to increase size
	insmod: vmalloc error: size 33554432, vm_struct allocation failed, mode:0xcc0(GFP_KERNEL), nodemask=(null),cpuset=/,mems_allowed=0
	CPU: 46 PID: 1977 Comm: insmod Tainted: G            E      6.10.0-rc1+ #79
	Hardware name: INGRASYS Yushan Server iSystem TEMP-S000141176+10/Yushan Motherboard, BIOS 2.10.20230517 (SCP: xxx) yyyy/mm/dd
	Call trace:
		dump_backtrace+0xa0/0x128
		show_stack+0x20/0x38
		dump_stack_lvl+0x78/0x90
		dump_stack+0x18/0x28
		warn_alloc+0x12c/0x1b8
		__vmalloc_node_range_noprof+0x28c/0x7e0
		custom_init+0xb4/0xfff8 [test_driver]
		do_one_initcall+0x60/0x290
		do_init_module+0x68/0x250
		load_module+0x236c/0x2428
		init_module_from_file+0x8c/0xd8
		__arm64_sys_finit_module+0x1b4/0x388
		invoke_syscall+0x78/0x108
		el0_svc_common.constprop.0+0x48/0xf0
		do_el0_svc+0x24/0x38
		el0_svc+0x3c/0x130
		el0t_64_sync_handler+0x100/0x130
		el0t_64_sync+0x190/0x198

Link: https://lkml.kernel.org/r/MN2PR01MB59025CC02D1D29516527A693F5C62@MN2PR01MB5902.prod.exchangelabs.com
Reviewed-by: Christoph Lameter (Ampere) <cl@linux.com>
Signed-off-by: Shubhang Kaushik <shubhang@os.amperecomputing.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Xiongwei Song <xiongwei.song@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    9 ++++++---
 mm/vmalloc.c                                    |    4 ++--
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~vmalloc-modify-the-alloc_vmap_area-error-message-for-better-diagnostics
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -7217,9 +7217,12 @@
 
 	vmalloc=nn[KMG]	[KNL,BOOT,EARLY] Forces the vmalloc area to have an
 			exact size of <nn>. This can be used to increase
-			the minimum size (128MB on x86). It can also be
-			used to decrease the size and leave more room
-			for directly mapped kernel RAM.
+			the minimum size (128MB on x86, arm32 platforms).
+			It can also be used to decrease the size and leave more room
+			for directly mapped kernel RAM. Note that this parameter does
+			not exist on many other platforms (including arm64, alpha,
+			loongarch, arc, csky, hexagon, microblaze, mips, nios2, openrisc,
+			parisc, m64k, powerpc, riscv, sh, um, xtensa, s390, sparc).
 
 	vmcp_cma=nn[MG]	[KNL,S390,EARLY]
 			Sets the memory size reserved for contiguous memory
--- a/mm/vmalloc.c~vmalloc-modify-the-alloc_vmap_area-error-message-for-better-diagnostics
+++ a/mm/vmalloc.c
@@ -2056,8 +2056,8 @@ overflow:
 	}
 
 	if (!(gfp_mask & __GFP_NOWARN) && printk_ratelimit())
-		pr_warn("vmap allocation for size %lu failed: use vmalloc=<size> to increase size\n",
-			size);
+		pr_warn("vmalloc_node_range for size %lu failed: Address range restricted to %#lx - %#lx\n",
+				size, addr, addr+size);
 
 	kmem_cache_free(vmap_area_cachep, va);
 	return ERR_PTR(-EBUSY);
_

Patches currently in -mm which might be from Shubhang@os.amperecomputing.com are

vmalloc-modify-the-alloc_vmap_area-error-message-for-better-diagnostics.patch

