Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1915478B;
	Fri, 12 Apr 2024 22:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712959824; cv=none; b=b4lBWS2+XeDuvFLeuxoGmeypS3njOVtvzr3QrOg45sGQEBk/+gN3nZXBBYoVeCTEX1iVYhBtxNl9e/N2ZduqE1DjXAYWyfFKtBsiW3myh7IY3cjyQEm4cb0bMZoIcNPnUqnoE6tzyJZ004RDEWWMK6gVFaok1z54JzPhbhZl/2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712959824; c=relaxed/simple;
	bh=3l/4hTvGAjGjn9h5aRqsj4iwsws2FIlY5Mdh9FyeSGI=;
	h=Date:To:From:Subject:Message-Id; b=cEnq2mWMxswNbRIRleb/hcPFto7QVnUQaWx0149F26FEq0PkP3au8b5raq44ZvUms/NFh16eaNzERNsSWvYVNoYbXCEckfIuADD+KJTesl4GNRyznO4y3VB9VuwIYzr98GFZlJZ3PXuLrlTenFDyrqZwuuf3vv3doRmeOZJMDO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f8WH2Mya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f8WH2Mya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC20DC113CC;
	Fri, 12 Apr 2024 22:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712959823;
	bh=3l/4hTvGAjGjn9h5aRqsj4iwsws2FIlY5Mdh9FyeSGI=;
	h=Date:To:From:Subject:From;
	b=f8WH2MyawgtjhA8bg/4kMeW3JiquUqS8EbNxXY14wjvBmV36Ad/LissNa1av18R/0
	 XH/FjtYo/3JWAmHb7WavoDR+K6Eb8TcsH6xkf7Szsdv+mmgqsEmomr9kAtd0M3LyvE
	 iq0Cw8GW+HA4ZcgERzR71+der3RZJU1LBuDy/npk=
Date: Fri, 12 Apr 2024 15:10:22 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@linux.ibm.com,mhiramat@kernel.org,qiang4.zhang@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] bootconfig-use-memblock_free_late-to-free-xbc-memory-to-buddy.patch removed from -mm tree
Message-Id: <20240412221023.BC20DC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bootconfig: use memblock_free_late to free xbc memory to buddy
has been removed from the -mm tree.  Its filename was
     bootconfig-use-memblock_free_late-to-free-xbc-memory-to-buddy.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Qiang Zhang <qiang4.zhang@intel.com>
Subject: bootconfig: use memblock_free_late to free xbc memory to buddy
Date: Fri, 12 Apr 2024 10:41:04 +0800

At the time to free xbc memory, memblock has handed over memory to buddy
allocator.  So it doesn't make sense to free memory back to memblock. 
memblock_free() called by xbc_exit() even causes UAF bugs on architectures
with CONFIG_ARCH_KEEP_MEMBLOCK disabled like x86.  Following KASAN logs
shows this case.

[    9.410890] ==================================================================
[    9.418962] BUG: KASAN: use-after-free in memblock_isolate_range+0x12d/0x260
[    9.426850] Read of size 8 at addr ffff88845dd30000 by task swapper/0/1

[    9.435901] CPU: 9 PID: 1 Comm: swapper/0 Tainted: G     U             6.9.0-rc3-00208-g586b5dfb51b9 #5
[    9.446403] Hardware name: Intel Corporation RPLP LP5 (CPU:RaptorLake)/RPLP LP5 (ID:13), BIOS IRPPN02.01.01.00.00.19.015.D-00000000 Dec 28 2023
[    9.460789] Call Trace:
[    9.463518]  <TASK>
[    9.465859]  dump_stack_lvl+0x53/0x70
[    9.469949]  print_report+0xce/0x610
[    9.473944]  ? __virt_addr_valid+0xf5/0x1b0
[    9.478619]  ? memblock_isolate_range+0x12d/0x260
[    9.483877]  kasan_report+0xc6/0x100
[    9.487870]  ? memblock_isolate_range+0x12d/0x260
[    9.493125]  memblock_isolate_range+0x12d/0x260
[    9.498187]  memblock_phys_free+0xb4/0x160
[    9.502762]  ? __pfx_memblock_phys_free+0x10/0x10
[    9.508021]  ? mutex_unlock+0x7e/0xd0
[    9.512111]  ? __pfx_mutex_unlock+0x10/0x10
[    9.516786]  ? kernel_init_freeable+0x2d4/0x430
[    9.521850]  ? __pfx_kernel_init+0x10/0x10
[    9.526426]  xbc_exit+0x17/0x70
[    9.529935]  kernel_init+0x38/0x1e0
[    9.533829]  ? _raw_spin_unlock_irq+0xd/0x30
[    9.538601]  ret_from_fork+0x2c/0x50
[    9.542596]  ? __pfx_kernel_init+0x10/0x10
[    9.547170]  ret_from_fork_asm+0x1a/0x30
[    9.551552]  </TASK>

[    9.555649] The buggy address belongs to the physical page:
[    9.561875] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x1 pfn:0x45dd30
[    9.570821] flags: 0x200000000000000(node=0|zone=2)
[    9.576271] page_type: 0xffffffff()
[    9.580167] raw: 0200000000000000 ffffea0011774c48 ffffea0012ba1848 0000000000000000
[    9.588823] raw: 0000000000000001 0000000000000000 00000000ffffffff 0000000000000000
[    9.597476] page dumped because: kasan: bad access detected

[    9.605362] Memory state around the buggy address:
[    9.610714]  ffff88845dd2ff00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    9.618786]  ffff88845dd2ff80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    9.626857] >ffff88845dd30000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.634930]                    ^
[    9.638534]  ffff88845dd30080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.646605]  ffff88845dd30100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.654675] ==================================================================

Link: https://lkml.kernel.org/r/20240412024103.3078378-1-qiang4.zhang@linux.intel.com
Signed-off-by: Qiang Zhang <qiang4.zhang@intel.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bootconfig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bootconfig.c~bootconfig-use-memblock_free_late-to-free-xbc-memory-to-buddy
+++ a/lib/bootconfig.c
@@ -63,7 +63,7 @@ static inline void * __init xbc_alloc_me
 
 static inline void __init xbc_free_mem(void *addr, size_t size)
 {
-	memblock_free(addr, size);
+	memblock_free_late(__pa(addr), size);
 }
 
 #else /* !__KERNEL__ */
_

Patches currently in -mm which might be from qiang4.zhang@intel.com are


