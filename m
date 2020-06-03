From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 122/131] sparc32: register memory occupied by
 kernel as memblock.memory
Date: Wed, 03 Jun 2020 16:03:31 -0700
Message-ID: <20200603230331.HEuAJFoN5%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbgFCXIj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:08:39 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, linux-mm@kvack.org, linux@roeck-us.net, mm-commits@vger.kernel.org, rppt@linux.ibm.com, torvalds@linux-foundation.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: sparc32: register memory occupied by kernel as memblock.memory

sparc32 never registered the memory occupied by the kernel image with
memblock_add() and it only reserved this memory with meblock_reserve().

With openbios as system firmware, the memory occupied by the kernel is
reserved in openbios and removed from mem.available.  The prom setup code
in the kernel uses mem.available to set up the memory banks and
essentially there is a hole for the memory occupied by the kernel image.

Later in bootmem_init() this memory is memblock_reserve()d.

Up until recently, memmap initialization would call __init_single_page()
for the pages in that hole, the free_low_memory_core_early() would mark
them as reserved and everything would be Ok.

After the change in memmap initialization introduced by the commit "mm:
memmap_init: iterate over memblock regions rather that check each PFN",
the hole is skipped and the page structs for it are not initialized.  And
when they are passed from memblock to page allocator as reserved, the
latter gets confused.

Simply registering the memory occupied by the kernel with memblock_add()
resolves this issue.

Tested on qemu-system-sparc with Debian Etch [1] userspace.

[1] https://people.debian.org/~aurel32/qemu/sparc/debian_etch_sparc_small.qcow2

Link: https://lkml.kernel.org/r/20200517000050.GA87467@roeck-us.nlllllet/
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/init_32.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sparc/mm/init_32.c~sparc32-register-memory-occupied-by-kernel-as-memblockmemory
+++ a/arch/sparc/mm/init_32.c
@@ -193,6 +193,7 @@ unsigned long __init bootmem_init(unsign
 	/* Reserve the kernel text/data/bss. */
 	size = (start_pfn << PAGE_SHIFT) - phys_base;
 	memblock_reserve(phys_base, size);
+	memblock_add(phys_base, size);
 
 	size = memblock_phys_mem_size() - memblock_reserved_size();
 	*pages_avail = (size >> PAGE_SHIFT) - high_pages;
_
