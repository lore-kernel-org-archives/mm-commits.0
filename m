From: akpm@linux-foundation.org
Subject: [merged]
 arch-arm-mach-omap2-omap_hwmodc-use-memblock-apis-for-early-memory-allocations.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:14:28 -0800
Message-ID: <52e026a4.93bPctad7Ar8Uyes%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbaAVUO3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:14:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tony@atomide.com, tj@kernel.org, rjw@sisk.pl, pavel@ucw.cz, paul@pwsan.com, mhocko@suse.cz, linux@arm.linux.org.uk, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, grygorii.strashko@ti.com, gregkh@linuxfoundation.org, cl@linux-foundation.org, arnd@arndb.de, santosh.shilimkar@ti.com

Subject: [merged] arch-arm-mach-omap2-omap_hwmodc-use-memblock-apis-for-early-memory-allocations.patch removed from -mm tree
To: santosh.shilimkar@ti.com,arnd@arndb.de,cl@linux-foundation.org,gregkh@linuxfoundation.org,grygorii.strashko@ti.com,hannes@cmpxchg.org,hpa@zytor.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,linux@arm.linux.org.uk,mhocko@suse.cz,paul@pwsan.com,pavel@ucw.cz,rjw@sisk.pl,tj@kernel.org,tony@atomide.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:14:28 -0800


The patch titled
     Subject: arch/arm/mach-omap2/omap_hwmod.c: use memblock apis for early memory allocations
has been removed from the -mm tree.  Its filename was
     arch-arm-mach-omap2-omap_hwmodc-use-memblock-apis-for-early-memory-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: arch/arm/mach-omap2/omap_hwmod.c: use memblock apis for early memory allocations

Switch to memblock interfaces for early memory allocator instead of
bootmem allocator.  No functional change in beahvior than what it is in
current code from bootmem users points of view.

Archs already converted to NO_BOOTMEM now directly use memblock interfaces
instead of bootmem wrappers build on top of memblock.  And the archs which
still uses bootmem, these new apis just fallback to exiting bootmem APIs.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Yinghai Lu <yinghai@kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/omap_hwmod.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN arch/arm/mach-omap2/omap_hwmod.c~arch-arm-mach-omap2-omap_hwmodc-use-memblock-apis-for-early-memory-allocations arch/arm/mach-omap2/omap_hwmod.c
--- a/arch/arm/mach-omap2/omap_hwmod.c~arch-arm-mach-omap2-omap_hwmodc-use-memblock-apis-for-early-memory-allocations
+++ a/arch/arm/mach-omap2/omap_hwmod.c
@@ -2791,9 +2791,7 @@ static int __init _alloc_links(struct om
 	sz = sizeof(struct omap_hwmod_link) * LINKS_PER_OCP_IF;
 
 	*sl = NULL;
-	*ml = alloc_bootmem(sz);
-
-	memset(*ml, 0, sz);
+	*ml = memblock_virt_alloc(sz, 0);
 
 	*sl = (void *)(*ml) + sizeof(struct omap_hwmod_link);
 
@@ -2912,9 +2910,7 @@ static int __init _alloc_linkspace(struc
 	pr_debug("omap_hwmod: %s: allocating %d byte linkspace (%d links)\n",
 		 __func__, sz, max_ls);
 
-	linkspace = alloc_bootmem(sz);
