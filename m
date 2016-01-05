From: akpm@linux-foundation.org
Subject: [failures]
 mm-calculate-zone_start_pfn-at-zone_spanned_pages_in_node-fix.patch removed from -mm tree
Date: Tue, 05 Jan 2016 12:59:28 -0800
Message-ID: <568c2eb0.tGeO5TgGsMptpBbG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbcAEU73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jan 2016 15:59:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, izumi.taku@jp.fujitsu.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: set a zone_start_pfn value in zone_spanned_pages_in_node
has been removed from the -mm tree.  Its filename was
     mm-calculate-zone_start_pfn-at-zone_spanned_pages_in_node-fix.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/page_alloc.c: set a zone_start_pfn value in zone_spanned_pages_in_node

We got a new build warning in linux-next:

mm/page_alloc.c: In function 'free_area_init_node':
mm/page_alloc.c:5278:25: warning: 'zone_start_pfn' may be used uninitialized in this function [-Wmaybe-uninitialized]
    zone->zone_start_pfn = zone_start_pfn;
mm/page_alloc.c:5265:17: note: 'zone_start_pfn' was declared here
   unsigned long zone_start_pfn, zone_end_pfn;

The code indeed looks wrong, but this is just a guess of what the
fix might be: I have not looked it in detail, so please treat this
as a bug report.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/page_alloc.c~mm-calculate-zone_start_pfn-at-zone_spanned_pages_in_node-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-calculate-zone_start_pfn-at-zone_spanned_pages_in_node-fix
+++ a/mm/page_alloc.c
@@ -5013,6 +5013,8 @@ static inline unsigned long __meminit zo
 					unsigned long *zone_end_pfn,
 					unsigned long *zones_size)
 {
+	*zone_start_pfn = node_start_pfn;
+	*zone_end_pfn = node_end_pfn;
 	return zones_size[zone_type];
 }
 
_

Patches currently in -mm which might be from arnd@arndb.de are

include-define-__phys_to_pfn-as-phys_pfn-fix-2.patch
mm-introduce-kernelcore=mirror-option-fix-2.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch
mm-printk-introduce-new-format-string-for-flags-fix.patch
printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix.patch
memstick-use-sector_div-instead-of-do_div.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem-fix.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix-2.patch

