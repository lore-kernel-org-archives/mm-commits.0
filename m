From: akpm@linux-foundation.org
Subject: [merged] mmkconfig-add-an-option-to-disable-bounce.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:50:27 -0700
Message-ID: <20130430185027.836AB31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:46421 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758953Ab3D3Su2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:50:28 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so87546qab.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:50:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vinayakm.list@gmail.com, axboe@kernel.dk, rdunlap@infradead.org, rientjes@google.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mmKconfig: add an option to disable bounce
has been removed from the -mm tree.  Its filename was
     mmkconfig-add-an-option-to-disable-bounce.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vinayak Menon <vinayakm.list@gmail.com>
Subject: mmKconfig: add an option to disable bounce

There are times when HIGHMEM is enabled, but we don't prefer CONFIG_BOUNCE
to be enabled.  CONFIG_BOUNCE can reduce the block device throughput, and
this is not ideal for machines where we don't gain much by enabling it. 
So provide an option to deselect CONFIG_BOUNCE.  The observation was made
while measuring eMMC throughput using iozone on an ARM device with 1GB
RAM.

Signed-off-by: Vinayak Menon <vinayakm.list@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/Kconfig~mmkconfig-add-an-option-to-disable-bounce mm/Kconfig
--- a/mm/Kconfig~mmkconfig-add-an-option-to-disable-bounce
+++ a/mm/Kconfig
@@ -263,8 +263,14 @@ config ZONE_DMA_FLAG
 	default "1"
 
 config BOUNCE
-	def_bool y
+	bool "Enable bounce buffers"
+	default y
 	depends on BLOCK && MMU && (ZONE_DMA || HIGHMEM)
+	help
+	  Enable bounce buffers for devices that cannot access
+	  the full range of memory available to the CPU. Enabled
+	  by default when ZONE_DMA or HIGHMEM is selected, but you
+	  may say n to override this.
 
 # On the 'tile' arch, USB OHCI needs the bounce pool since tilegx will often
 # have more than 4GB of memory, but we don't currently use the IOTLB to present
_

Patches currently in -mm which might be from vinayakm.list@gmail.com are

origin.patch

