Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393C26FC5
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628211; cv=none; b=MnXxD7FbzIY63s7k7vXwzyRueSPn3nL5ebvFptZk3+UtwupaJWyBHNsli91bpWgSdo9LM7OVZTnU/aBqS9wPMhmrEqsrNf0sV/xXoRlAu6nV+ut4gh7CY7xSTwOh0aR+wcyTw9TNlejCxE5dXUuQQUeszI9c+ZpXmaJc7vfOoH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628211; c=relaxed/simple;
	bh=s2ZxLn0V8nLD02lRVqpmK/cQVVvfLOmLkKA3brhUZdY=;
	h=Date:To:From:Subject:Message-Id; b=AdyQ5B2xnwvH60qP+GhBcb96qZtP+4Cpw2QrISw8gW76qsSY2hEs7WA8LvzIeA5cujVMsFl7rPYBXqkMUfWH8d7u1jdBtefir+NM0rWHR6sKKeaOcYQYNmE67uW9nivyWduJIcAfk/1bjpXGfNI/JUQWcMsGfsswedxpEOUc+n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UOY1/tZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UOY1/tZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5F6C116B1;
	Sat, 29 Jun 2024 02:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628210;
	bh=s2ZxLn0V8nLD02lRVqpmK/cQVVvfLOmLkKA3brhUZdY=;
	h=Date:To:From:Subject:From;
	b=UOY1/tZF33TZHQ7qYyED5Zlok7moW1RE7HmzPHRS18SLDR0av83qflkCLVhiSOT2l
	 9GFO+LW2f2It+MF1oojz81cNShFNuafY5GLdrsblirhnQILQVZSdhZsZ+XJMV8Nk0P
	 zPnTp6cyEdTar3YkQDcHZU9XKGDDrqLW77/qxhx8=
Date: Fri, 28 Jun 2024 19:30:10 -0700
To: mm-commits@vger.kernel.org,xiongwei.song@windriver.com,willy@infradead.org,urezki@gmail.com,shubhang@os.amperecomputing.com,guoren@kernel.org,corbet@lwn.net,cl@linux.com,Shubhang@os.amperecomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmalloc-modify-the-alloc_vmap_area-error-message-for-better-diagnostics.patch removed from -mm tree
Message-Id: <20240629023010.BD5F6C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmalloc: modify the alloc_vmap_area() error message for better diagnostics
has been removed from the -mm tree.  Its filename was
     vmalloc-modify-the-alloc_vmap_area-error-message-for-better-diagnostics.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shubhang Kaushik OS <Shubhang@os.amperecomputing.com>
Subject: vmalloc: modify the alloc_vmap_area() error message for better diagnostics
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

[Shubhang@os.amperecomputing.com: v5]
  Link: https://lkml.kernel.org/r/CH2PR01MB5894B0182EA0B28DF2EFB916F5C72@CH2PR01MB5894.prod.exchangelabs.com
Link: https://lkml.kernel.org/r/MN2PR01MB59025CC02D1D29516527A693F5C62@MN2PR01MB5902.prod.exchangelabs.com
Signed-off-by: Shubhang Kaushik <shubhang@os.amperecomputing.com>
Reviewed-by: Christoph Lameter (Ampere) <cl@linux.com>
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
@@ -7239,9 +7239,12 @@
 
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
+				size, vstart, vend);
 
 	kmem_cache_free(vmap_area_cachep, va);
 	return ERR_PTR(-EBUSY);
_

Patches currently in -mm which might be from Shubhang@os.amperecomputing.com are


