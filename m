From: akpm@linux-foundation.org
Subject: + fadump-register-the-memory-reserved-by-fadump.patch added to
 -mm tree
Date: Thu, 04 Aug 2016 14:01:43 -0700
Message-ID: <57a3ad37.D7UX13KfBOctPdj2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50161 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbcHDVDN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Aug 2016 17:03:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srikar@linux.vnet.ibm.com, bsingharora@gmail.com, dave.hansen@intel.com, hbathini@linux.vnet.ibm.com, mahesh@linux.vnet.ibm.com, mgorman@techsingularity.net, mhocko@kernel.org, mpe@ellerman.id.au, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/powerpc/kernel/fadump.c: register the memory reserved by fadump
has been added to the -mm tree.  Its filename is
     fadump-register-the-memory-reserved-by-fadump.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fadump-register-the-memory-reserved-by-fadump.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fadump-register-the-memory-reserved-by-fadump.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: arch/powerpc/kernel/fadump.c: register the memory reserved by fadump

Fadump kernel reserves large chunks of memory even before the pages are
initialized.  This could mean memory that corresponds to several nodes
might fall in memblock reserved regions.

Kernels compiled with CONFIG_DEFERRED_STRUCT_PAGE_INIT will initialize
only certain size memory per node.  The certain size takes into account
the dentry and inode cache sizes.  Currently the cache sizes are
calculated based on the total system memory including the reserved memory.
However such a kernel when booting the same kernel as fadump kernel will
not be able to allocate the required amount of memory to suffice for the
dentry and inode caches.  This results in crashes like the below on large
systems such as 32 TB systems.

Dentry cache hash table entries: 536870912 (order: 16, 4294967296 bytes)
vmalloc: allocation failure, allocated 4097114112 of 17179934720 bytes
swapper/0: page allocation failure: order:0, mode:0x2080020(GFP_ATOMIC)
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.6-master+ #3
Call Trace:
[c00000000108fb10] [c0000000007fac88] dump_stack+0xb0/0xf0 (unreliable)
[c00000000108fb50] [c000000000235264] warn_alloc_failed+0x114/0x160
[c00000000108fbf0] [c000000000281484] __vmalloc_node_range+0x304/0x340
[c00000000108fca0] [c00000000028152c] __vmalloc+0x6c/0x90
[c00000000108fd40] [c000000000aecfb0]
alloc_large_system_hash+0x1b8/0x2c0
[c00000000108fe00] [c000000000af7240] inode_init+0x94/0xe4
[c00000000108fe80] [c000000000af6fec] vfs_caches_init+0x8c/0x13c
[c00000000108ff00] [c000000000ac4014] start_kernel+0x50c/0x578
[c00000000108ff90] [c000000000008c6c] start_here_common+0x20/0xa8

Register the memory reserved by fadump, so that the cache sizes are
calculated based on the free memory (i.e Total memory - reserved memory).

Link: http://lkml.kernel.org/r/1470330729-6273-2-git-send-email-srikar@linux.vnet.ibm.com
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Suggested-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Hari Bathini <hbathini@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/fadump.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/kernel/fadump.c~fadump-register-the-memory-reserved-by-fadump arch/powerpc/kernel/fadump.c
--- a/arch/powerpc/kernel/fadump.c~fadump-register-the-memory-reserved-by-fadump
+++ a/arch/powerpc/kernel/fadump.c
@@ -330,6 +330,7 @@ int __init fadump_reserve_mem(void)
 	}
 	fw_dump.reserve_dump_area_start = base;
 	fw_dump.reserve_dump_area_size = size;
+	set_memory_reserve(size/PAGE_SIZE, true);
 	return 1;
 }
 
_

Patches currently in -mm which might be from srikar@linux.vnet.ibm.com are

mm-page_alloc-replace-set_dma_reserve-to-set_memory_reserve.patch
fadump-register-the-memory-reserved-by-fadump.patch

