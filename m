From: akpm@linux-foundation.org
Subject: + mtd-maps-make-uclinux-mapping-driver-depend-on-mtd_ram-since-it-only-probes-that.patch added to -mm tree
Date: Thu, 21 Aug 2008 12:05:18 -0700
Message-ID: <200808211905.m7LJ5I9D020961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751761AbYHUTGD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 15:06:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, cooloney@kernel.org, dwmw2@infradead.org


The patch titled
     MTD Maps: make uclinux mapping driver depend on MTD_RAM since it only probes that
has been added to the -mm tree.  Its filename is
     mtd-maps-make-uclinux-mapping-driver-depend-on-mtd_ram-since-it-only-probes-that.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MTD Maps: make uclinux mapping driver depend on MTD_RAM since it only probes that
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/maps/Kconfig~mtd-maps-make-uclinux-mapping-driver-depend-on-mtd_ram-since-it-only-probes-that drivers/mtd/maps/Kconfig
--- a/drivers/mtd/maps/Kconfig~mtd-maps-make-uclinux-mapping-driver-depend-on-mtd_ram-since-it-only-probes-that
+++ a/drivers/mtd/maps/Kconfig
@@ -491,7 +491,7 @@ config MTD_BFIN_ASYNC
 
 config MTD_UCLINUX
 	tristate "Generic uClinux RAM/ROM filesystem support"
-	depends on MTD_PARTITIONS && !MMU
+	depends on MTD_PARTITIONS && MTD_RAM && !MMU
 	help
 	  Map driver to support image based filesystems for uClinux.
 
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

linux-next.patch
mtd-maps-make-uclinux-mapping-driver-depend-on-mtd_ram-since-it-only-probes-that.patch

