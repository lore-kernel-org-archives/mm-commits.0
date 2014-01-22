From: akpm@linux-foundation.org
Subject: [merged]
 mm-memblock-debug-correct-displaying-of-upper-memory-boundary.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:12:58 -0800
Message-ID: <52e0264a.JOH58KGKf64Xp2Ss%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038AbaAVUM7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:12:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tony@atomide.com, tj@kernel.org, santosh.shilimkar@ti.com, rjw@sisk.pl, pavel@ucw.cz, paul@pwsan.com, mhocko@suse.cz, linux@arm.linux.org.uk, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, gregkh@linuxfoundation.org, cl@linux-foundation.org, arnd@arndb.de, grygorii.strashko@ti.com

Subject: [merged] mm-memblock-debug-correct-displaying-of-upper-memory-boundary.patch removed from -mm tree
To: grygorii.strashko@ti.com,arnd@arndb.de,cl@linux-foundation.org,gregkh@linuxfoundation.org,hannes@cmpxchg.org,hpa@zytor.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,linux@arm.linux.org.uk,mhocko@suse.cz,paul@pwsan.com,pavel@ucw.cz,rjw@sisk.pl,santosh.shilimkar@ti.com,tj@kernel.org,tony@atomide.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:12:58 -0800


The patch titled
     Subject: mm/memblock: debug: correct displaying of upper memory boundary
has been removed from the -mm tree.  Its filename was
     mm-memblock-debug-correct-displaying-of-upper-memory-boundary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Grygorii Strashko <grygorii.strashko@ti.com>
Subject: mm/memblock: debug: correct displaying of upper memory boundary

Current memblock APIs don't work on 32 PAE or LPAE extension arches where
the physical memory start address beyond 4GB.  The problem was discussed
here [3] where Tejun, Yinghai(thanks) proposed a way forward with memblock
interfaces.  Based on the proposal, this series adds necessary memblock
interfaces and convert the core kernel code to use them.  Architectures
already converted to NO_BOOTMEM use these new interfaces and other which
still uses bootmem, these new interfaces just fallback to exiting bootmem
APIs.

So no functional change in behavior.  In long run, once all the
architectures moves to NO_BOOTMEM, we can get rid of bootmem layer
completely.  This is one step to remove the core code dependency with
bootmem and also gives path for architectures to move away from bootmem.

Testing is done on ARM architecture with 32 bit ARM LAPE machines
with normal as well sparse(faked) memory model.



This patch (of 23):

When debugging is enabled (cmdline has "memblock=debug") the memblock will
display upper memory boundary per each allocated/freed memory range
wrongly.  For example:

 memblock_reserve: [0x0000009e7e8000-0x0000009e7ed000] _memblock_early_alloc_try_nid_nopanic+0xfc/0x12c

The 0x0000009e7ed000 is displayed instead of 0x0000009e7ecfff

Hence, correct this by changing formula used to calculate upper memory
boundary to (u64)base + size - 1 instead of  (u64)base + size everywhere
in the debug messages.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memblock.c~mm-memblock-debug-correct-displaying-of-upper-memory-boundary mm/memblock.c
--- a/mm/memblock.c~mm-memblock-debug-correct-displaying-of-upper-memory-boundary
+++ a/mm/memblock.c
@@ -643,7 +643,7 @@ int __init_memblock memblock_free(phys_a
 {
 	memblock_dbg("   memblock_free: [%#016llx-%#016llx] %pF\n",
 		     (unsigned long long)base,
-		     (unsigned long long)base + size,
+		     (unsigned long long)base + size - 1,
 		     (void *)_RET_IP_);
 
 	return __memblock_remove(&memblock.reserved, base, size);
@@ -655,7 +655,7 @@ int __init_memblock memblock_reserve(phy
 
 	memblock_dbg("memblock_reserve: [%#016llx-%#016llx] %pF\n",
 		     (unsigned long long)base,
-		     (unsigned long long)base + size,
+		     (unsigned long long)base + size - 1,
 		     (void *)_RET_IP_);
 
 	return memblock_add_region(_rgn, base, size, MAX_NUMNODES);
_

Patches currently in -mm which might be from grygorii.strashko@ti.com are

origin.patch
mm-nobootmem-free_all_bootmem-again.patch
rtc-rtc-twl-use-devm_-functions.patch
rtc-rtc-vr41xx-use-devm_-functions.patch
linux-next.patch

