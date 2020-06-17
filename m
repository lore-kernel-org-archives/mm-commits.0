From: akpm@linux-foundation.org
Subject: + x86-mm-use-max-memory-block-size-on-bare-metal.patch
 added to -mm tree
Date: Wed, 17 Jun 2020 15:51:01 -0700
Message-ID: <20200617225101.HJO2e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbgFQWvC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 18:51:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, steven.sistare@oracle.com, peterz@infradead.org, pasha.tatashin@soleen.com, mingo@elte.hu, mhocko@kernel.org, luto@kernel.org, hpa@zytor.com, david@redhat.com, dave.hansen@linux.intel.com, daniel.m.jordan@oracle.com


The patch titled
     Subject: x86/mm: use max memory block size on bare metal
has been added to the -mm tree.  Its filename is
     x86-mm-use-max-memory-block-size-on-bare-metal.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-use-max-memory-block-size-on-bare-metal.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-use-max-memory-block-size-on-bare-metal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: x86/mm: use max memory block size on bare metal

Some of our servers spend significant time at kernel boot initializing
memory block sysfs directories and then creating symlinks between them and
the corresponding nodes.  The slowness happens because the machines get
stuck with the smallest supported memory block size on x86 (128M), which
results in 16,288 directories to cover the 2T of installed RAM.  The
search for each memory block is noticeable even with commit 4fb6eabf1037
("drivers/base/memory.c: cache memory blocks in xarray to accelerate
lookup").

Commit 078eb6aa50dc ("x86/mm/memory_hotplug: determine block size based on
the end of boot memory") chooses the block size based on alignment with
memory end.  That addresses hotplug failures in qemu guests, but for bare
metal systems whose memory end isn't aligned to even the smallest size, it
leaves them at 128M.

Make kernels that aren't running on a hypervisor use the largest supported
size (2G) to minimize overhead on big machines.  Kernel boot goes 7%
faster on the aforementioned servers, shaving off half a second.

Link: http://lkml.kernel.org/r/20200609225451.3542648-1-daniel.m.jordan@oracle.com
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/x86/mm/init_64.c~x86-mm-use-max-memory-block-size-on-bare-metal
+++ a/arch/x86/mm/init_64.c
@@ -54,6 +54,7 @@
 #include <asm/uv/uv.h>
 #include <asm/setup.h>
 #include <asm/ftrace.h>
+#include <asm/hypervisor.h>
 
 #include "mm_internal.h"
 
@@ -1406,6 +1407,15 @@ static unsigned long probe_memory_block_
 		goto done;
 	}
 
+	/*
+	 * Use max block size to minimize overhead on bare metal, where
+	 * alignment for memory hotplug isn't a concern.
+	 */
+	if (hypervisor_is_type(X86_HYPER_NATIVE)) {
+		bz = MAX_BLOCK_SIZE;
+		goto done;
+	}
+
 	/* Find the largest allowed block size that aligns to memory end */
 	for (bz = MAX_BLOCK_SIZE; bz > MIN_MEMORY_BLOCK_SIZE; bz >>= 1) {
 		if (IS_ALIGNED(boot_mem_end, bz))
_

Patches currently in -mm which might be from daniel.m.jordan@oracle.com are

x86-mm-use-max-memory-block-size-on-bare-metal.patch
