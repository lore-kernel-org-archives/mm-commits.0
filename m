From: akpm@linux-foundation.org
Subject: [merged]
 x86-memblock-set-current-limit-to-max-low-memory-address.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:13:44 -0800
Message-ID: <52e02678.ViZINQrnatiffR72%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54646 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109AbaAVUNr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:13:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tony@atomide.com, tj@kernel.org, rjw@sisk.pl, pavel@ucw.cz, paul@pwsan.com, mhocko@suse.cz, linux@arm.linux.org.uk, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, grygorii.strashko@ti.com, gregkh@linuxfoundation.org, cl@linux-foundation.org, arnd@arndb.de, santosh.shilimkar@ti.com

Subject: [merged] x86-memblock-set-current-limit-to-max-low-memory-address.patch removed from -mm tree
To: santosh.shilimkar@ti.com,arnd@arndb.de,cl@linux-foundation.org,gregkh@linuxfoundation.org,grygorii.strashko@ti.com,hannes@cmpxchg.org,hpa@zytor.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,linux@arm.linux.org.uk,mhocko@suse.cz,paul@pwsan.com,pavel@ucw.cz,rjw@sisk.pl,tj@kernel.org,tony@atomide.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:13:44 -0800


The patch titled
     Subject: x86: memblock: set current limit to max low memory address
has been removed from the -mm tree.  Its filename was
     x86-memblock-set-current-limit-to-max-low-memory-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: x86: memblock: set current limit to max low memory address

The memblock current limit value is used to limit early boot
memory allocations below max low memory address by default, as
the kernel can access only to the low memory.

Hence, set memblock current limit value to the max mapped low
memory address instead of max mapped memory address.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/page_types.h |    4 ++--
 arch/x86/kernel/setup.c           |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/include/asm/page_types.h~x86-memblock-set-current-limit-to-max-low-memory-address arch/x86/include/asm/page_types.h
--- a/arch/x86/include/asm/page_types.h~x86-memblock-set-current-limit-to-max-low-memory-address
+++ a/arch/x86/include/asm/page_types.h
@@ -51,9 +51,9 @@ extern int devmem_is_allowed(unsigned lo
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
 
-static inline phys_addr_t get_max_mapped(void)
+static inline phys_addr_t get_max_low_mapped(void)
 {
-	return (phys_addr_t)max_pfn_mapped << PAGE_SHIFT;
+	return (phys_addr_t)max_low_pfn_mapped << PAGE_SHIFT;
 }
 
 bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn);
diff -puN arch/x86/kernel/setup.c~x86-memblock-set-current-limit-to-max-low-memory-address arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~x86-memblock-set-current-limit-to-max-low-memory-address
+++ a/arch/x86/kernel/setup.c
@@ -1119,7 +1119,7 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_real_mode();
 
-	memblock_set_current_limit(get_max_mapped());
+	memblock_set_current_limit(get_max_low_mapped());
 	dma_contiguous_reserve(0);
 
 	/*
_

Patches currently in -mm which might be from santosh.shilimkar@ti.com are

origin.patch
mm-nobootmem-free_all_bootmem-again.patch
linux-next.patch

