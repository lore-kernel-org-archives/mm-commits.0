From: akpm@linux-foundation.org
Subject: + mmkconfig-add-an-option-to-disable-bounce.patch added to -mm tree
Date: Wed, 24 Apr 2013 13:22:47 -0700
Message-ID: <20130424202247.7FCBA5A41D6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:35777 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598Ab3DXUWs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Apr 2013 16:22:48 -0400
Received: by mail-ye0-f202.google.com with SMTP id l8so238897yen.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2013 13:22:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vinayakm.list@gmail.com, axboe@kernel.dk, rdunlap@infradead.org, rientjes@google.com, rmk@arm.linux.org.uk


The patch titled
     Subject: mmKconfig: add an option to disable bounce
has been added to the -mm tree.  Its filename is
     mmkconfig-add-an-option-to-disable-bounce.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

diff -puN mm/Kconfig~mm-add-an-option-to-disable-bounce mm/Kconfig
--- a/mm/Kconfig~mm-add-an-option-to-disable-bounce
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

mmkconfig-add-an-option-to-disable-bounce.patch

