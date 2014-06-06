From: akpm@linux-foundation.org
Subject: [folded-merged]
 rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
 removed from -mm tree
Date: Fri, 06 Jun 2014 14:03:17 -0700
Message-ID: <53922c95.whh4MZFVQpUnHADn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaFFVDS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2014 17:03:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ralf@linux-mips.org, macro@linux-mips.org, a.zummo@towertech.it, akpm@linux-foundation.org

Subject: [folded-merged] rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,a.zummo@towertech.it,macro@linux-mips.org,ralf@linux-mips.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 06 Jun 2014 14:03:17 -0700


The patch titled
     Subject: rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix
has been removed from the -mm tree.  Its filename was
     rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch

This patch was dropped because it was folded into rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix

fix weird code layout

Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix
+++ a/drivers/rtc/rtc-cmos.c
@@ -662,11 +662,11 @@ cmos_do_probe(struct device *dev, struct
 	 * (needing ioremap etc), not i/o space resources like this ...
 	 */
 	if (RTC_IOMAPPED)
-		ports = request_region
-			(ports->start, resource_size(ports), driver_name);
+		ports = request_region(ports->start, resource_size(ports),
+				       driver_name);
 	else
-		ports = request_mem_region
-			(ports->start, resource_size(ports), driver_name);
+		ports = request_mem_region(ports->start, resource_size(ports),
+					   driver_name);
 	if (!ports) {
 		dev_dbg(dev, "i/o registers already in use\n");
 		return -EBUSY;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support.patch
rtc-da9063-rtc-driver-fix.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix-2.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-2.patch
sysctl-allow-for-strict-write-position-handling-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-3.patch
fs-pstore-logging-clean-up-fix.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch

