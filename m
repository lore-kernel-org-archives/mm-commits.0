From: akpm@linux-foundation.org
Subject: [folded-merged]
 rtc-add-rtc-abx805-a-driver-for-the-abracon-ab-1805-i2c-rtc-fix.patch
 removed from -mm tree
Date: Tue, 03 Mar 2015 14:29:31 -0800
Message-ID: <54f635cb.q/PfKg6FuAxWcC9k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36412 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787AbbCCW3d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2015 17:29:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, a.zummo@towertech.it, phdm@macqel.be, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: abx805 depends on i2c
has been removed from the -mm tree.  Its filename was
     rtc-add-rtc-abx805-a-driver-for-the-abracon-ab-1805-i2c-rtc-fix.patch

This patch was dropped because it was folded into rtc-add-rtc-abx805-a-driver-for-the-abracon-ab-1805-i2c-rtc.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: rtc: abx805 depends on i2c

The recently added X805 rtc driver uses the i2c subsystem, but has no
Kconfig dependency, so it can result in a build error when i2c is
disabled:

drivers/rtc/rtc-abx805.c: In function 'abx805_read_multiple_regs':
drivers/rtc/rtc-abx805.c:55:2: error: implicit declaration of function 'i2c_transfer' [-Werror=implicit-function-declaration]

This adds the obvious dependency.

Fixes: 9033ab8ddd29 ("rtc: add rtc-abx805, a driver for the Abracon AB 1805 i2c rtc")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Philippe De Muyter <phdm@macqel.be>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/Kconfig~rtc-add-rtc-abx805-a-driver-for-the-abracon-ab-1805-i2c-rtc-fix drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-rtc-abx805-a-driver-for-the-abracon-ab-1805-i2c-rtc-fix
+++ a/drivers/rtc/Kconfig
@@ -1083,6 +1083,7 @@ config RTC_DRV_AB8500
 
 config RTC_DRV_ABX805
 	tristate "Abracon AB X805 RTC"
+	depends on I2C
 	help
 	  Select this to enable support for the Abracon AB X805 RTC.
 	  AB X805 is the i2c flavour of the AB 18X5 family of ultra-low-power
_

Patches currently in -mm which might be from arnd@arndb.de are

ocfs2-use-64bit-variables-to-track-heartbeat-time.patch
i8k-remove-use-of-seq_printf-return-value.patch
rtc-add-rtc-abx805-a-driver-for-the-abracon-ab-1805-i2c-rtc.patch
linux-next.patch
powerpc-oprofile-reduce-mmap_sem-hold-for-exe_file.patch

