From: akpm@linux-foundation.org
Subject: [merged] rapidio-fix-kernel-doc-warnings.patch removed from -mm tree
Date: Mon, 19 Nov 2012 12:21:46 -0800
Message-ID: <20121119202147.8D9A920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:33344 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab2KSUVu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Nov 2012 15:21:50 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so351914eei.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Nov 2012 12:21:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, alexandre.bounine@idt.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: fix kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     rapidio-fix-kernel-doc-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: rapidio: fix kernel-doc warnings

Fix rapidio kernel-doc warnings:

Warning(drivers/rapidio/rio.c:415): No description found for parameter 'local'
Warning(drivers/rapidio/rio.c:415): Excess function parameter 'lstart' description in 'rio_map_inb_region'
Warning(include/linux/rio.h:290): No description found for parameter 'switches'
Warning(include/linux/rio.h:290): No description found for parameter 'destid_table'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |    2 +-
 include/linux/rio.h   |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/rapidio/rio.c~rapidio-fix-kernel-doc-warnings drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-fix-kernel-doc-warnings
+++ a/drivers/rapidio/rio.c
@@ -401,7 +401,7 @@ EXPORT_SYMBOL_GPL(rio_release_inb_pwrite
 /**
  * rio_map_inb_region -- Map inbound memory region.
  * @mport: Master port.
- * @lstart: physical address of memory region to be mapped
+ * @local: physical address of memory region to be mapped
  * @rbase: RIO base address assigned to this window
  * @size: Size of the memory region
  * @rflags: Flags for mapping.
diff -puN include/linux/rio.h~rapidio-fix-kernel-doc-warnings include/linux/rio.h
--- a/include/linux/rio.h~rapidio-fix-kernel-doc-warnings
+++ a/include/linux/rio.h
@@ -275,9 +275,11 @@ struct rio_id_table {
  * struct rio_net - RIO network info
  * @node: Node in global list of RIO networks
  * @devices: List of devices in this network
+ * @switches: List of switches in this netowrk
  * @mports: List of master ports accessing this network
  * @hport: Default port for accessing this network
  * @id: RIO network ID
+ * @destid_table: destID allocation table
  */
 struct rio_net {
 	struct list_head node;	/* node in list of networks */
_

Patches currently in -mm which might be from rdunlap@infradead.org are

linux-next.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix.patch
mm-fix-slabc-kernel-doc-warnings.patch
printk-boot_delay-should-only-affect-output.patch

