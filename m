From: akpm@linux-foundation.org
Subject: + rtc-ds1742c-should-use-resource_size_t-for-base-address.patch added to -mm tree
Date: Fri, 14 Sep 2007 19:05:07 -0700
Message-ID: <200709150205.l8F257NA002323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33688 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754961AbXIOCFb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 22:05:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@gibson.dropbear.id.au, a.zummo@towertech.it, anemo@mba.ocn.ne.jp, david-b@pacbell.net


The patch titled
     rtc-ds1742.c should use resource_size_t for base address
has been added to the -mm tree.  Its filename is
     rtc-ds1742c-should-use-resource_size_t-for-base-address.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc-ds1742.c should use resource_size_t for base address
From: David Gibson <david@gibson.dropbear.id.au>

Currently the rtc driver, rtc-ds1742.c uses an unsigned long to store the
base mmio address of the NVRAM/RTC.  This breaks on systems like PowerPC
440, which is a 32-bit core with 36-bit physical addresses: IO on the
system, including the RTC, is typically above the 4GB point, and cannot fit
into an unsigned long.

This patch fixes the problem by replacing the unsigned long with a
resource_size_t.  Tested on Ebony (PPC440) (with additional patches to
instantiate the ds1742 platform device appropriately).

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Acked-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1742.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1742.c~rtc-ds1742c-should-use-resource_size_t-for-base-address drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~rtc-ds1742c-should-use-resource_size_t-for-base-address
+++ a/drivers/rtc/rtc-ds1742.c
@@ -55,7 +55,7 @@ struct rtc_plat_data {
 	void __iomem *ioaddr_rtc;
 	size_t size_nvram;
 	size_t size;
-	unsigned long baseaddr;
+	resource_size_t baseaddr;
 	unsigned long last_jiffies;
 };
 
_

Patches currently in -mm which might be from david@gibson.dropbear.id.au are

rtc-ds1742c-should-use-resource_size_t-for-base-address.patch
git-powerpc.patch
ppc-remove-apus-support.patch
hugetlb-allow-extending-ftruncate-on-hugetlbfs.patch
