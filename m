From: akpm@linux-foundation.org
Subject: +
 rtc-add-rtc-abx805-a-driver-for-the-abracon-ab-1805-i2c-rtc-fix.patch added to -mm tree
Date: Mon, 02 Mar 2015 12:44:37 -0800
Message-ID: <54f4cbb5.+gvD5SfgC2vxPGir%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbbCBUoi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 15:44:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, a.zummo@towertech.it, phdm@macqel.be, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: abx805 depends on i2c
has been added to the -mm tree.  Its filename is
     rtc-add-rtc-abx805-a-driver-for-the-abracon-ab-1805-i2c-rtc-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-add-rtc-abx805-a-driver-for-the-abracon-ab-1805-i2c-rtc-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-add-rtc-abx805-a-driver-for-the-abracon-ab-1805-i2c-rtc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
ocfs2-use-64bit-variables-to-track-heartbeat-time.patch
i8k-remove-use-of-seq_printf-return-value.patch
rtc-add-rtc-abx805-a-driver-for-the-abracon-ab-1805-i2c-rtc-fix.patch
linux-next.patch
powerpc-oprofile-reduce-mmap_sem-hold-for-exe_file.patch

