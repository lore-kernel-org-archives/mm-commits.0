From: akpm@linux-foundation.org
Subject: [merged]
 mm-memblock-drop-warn-and-use-smp_cache_bytes-as-a-default-alignment.patch
 removed from -mm tree
Date: Wed, 22 Jan 2014 12:13:52 -0800
Message-ID: <52e02680.XtoKarFW/UFBHmcI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54703 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbaAVUNx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:13:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tony@atomide.com, tj@kernel.org, santosh.shilimkar@ti.com, rjw@sisk.pl, pavel@ucw.cz, paul@pwsan.com, mhocko@suse.cz, linux@arm.linux.org.uk, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, gregkh@linuxfoundation.org, cl@linux-foundation.org, arnd@arndb.de, grygorii.strashko@ti.com

Subject: [merged] mm-memblock-drop-warn-and-use-smp_cache_bytes-as-a-default-alignment.patch removed from -mm tree
To: grygorii.strashko@ti.com,arnd@arndb.de,cl@linux-foundation.org,gregkh@linuxfoundation.org,hannes@cmpxchg.org,hpa@zytor.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,linux@arm.linux.org.uk,mhocko@suse.cz,paul@pwsan.com,pavel@ucw.cz,rjw@sisk.pl,santosh.shilimkar@ti.com,tj@kernel.org,tony@atomide.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:13:52 -0800


The patch titled
     Subject: mm/memblock: drop WARN and use SMP_CACHE_BYTES as a default alignment
has been removed from the -mm tree.  Its filename was
     mm-memblock-drop-warn-and-use-smp_cache_bytes-as-a-default-alignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Grygorii Strashko <grygorii.strashko@ti.com>
Subject: mm/memblock: drop WARN and use SMP_CACHE_BYTES as a default alignment

Don't produce warning and interpret 0 as "default align" equal to
SMP_CACHE_BYTES in case if caller of memblock_alloc_base_nid() doesn't
specify alignment for the block (align == 0).

This is done in preparation of introducing common memblock alloc interface
to make code behavior consistent.  More details are in below thread :

	https://lkml.org/lkml/2013/10/13/117.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
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

 mm/memblock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memblock.c~mm-memblock-drop-warn-and-use-smp_cache_bytes-as-a-default-alignment mm/memblock.c
--- a/mm/memblock.c~mm-memblock-drop-warn-and-use-smp_cache_bytes-as-a-default-alignment
+++ a/mm/memblock.c
@@ -969,8 +969,8 @@ static phys_addr_t __init memblock_alloc
 {
 	phys_addr_t found;
 
-	if (WARN_ON(!align))
-		align = __alignof__(long long);
+	if (!align)
+		align = SMP_CACHE_BYTES;
 
 	/* align @size to avoid excessive fragmentation on reserved array */
 	size = round_up(size, align);
_

Patches currently in -mm which might be from grygorii.strashko@ti.com are

origin.patch
mm-nobootmem-free_all_bootmem-again.patch
rtc-rtc-twl-use-devm_-functions.patch
rtc-rtc-vr41xx-use-devm_-functions.patch
linux-next.patch

