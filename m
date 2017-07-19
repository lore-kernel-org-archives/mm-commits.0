From: akpm@linux-foundation.org
Subject: + x86-intel-mid-fix-a-format-string-overflow-warning.patch added
 to -mm tree
Date: Wed, 19 Jul 2017 14:50:30 -0700
Message-ID: <596fd426.9vN2BahiVdKGo7ah%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34134 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755105AbdGSVub (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 17:50:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: intel-mid: fix a format string overflow warning
has been added to the -mm tree.  Its filename is
     x86-intel-mid-fix-a-format-string-overflow-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-intel-mid-fix-a-format-string-overflow-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-intel-mid-fix-a-format-string-overflow-warning.patch

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
Subject: x86: intel-mid: fix a format string overflow warning

We have space for exactly one character for the index in "max7315_%d_base",
but as gcc points out having more would cause an string overflow:

arch/x86/platform/intel-mid/device_libs/platform_max7315.c: In function 'max7315_platform_data':
arch/x86/platform/intel-mid/device_libs/platform_max7315.c:41:26: error: '%d' directive writing between 1 and 11 bytes into a region of size 9 [-Werror=format-overflow=]
   sprintf(base_pin_name, "max7315_%d_base", nr);
                          ^~~~~~~~~~~~~~~~~
arch/x86/platform/intel-mid/device_libs/platform_max7315.c:41:26: note: directive argument in the range [-2147483647, 2147483647]
arm-soc/arch/x86/platform/intel-mid/device_libs/platform_max7315.c:41:3: note: 'sprintf' output between 15 and 25 bytes into a destination of size 17
   sprintf(base_pin_name, "max7315_%d_base", nr);

This makes it use an snprintf() to truncate the string if that happened
rather than overflowing the stack.

Link: http://lkml.kernel.org/r/20170714120720.906842-17-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/intel-mid/device_libs/platform_max7315.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/x86/platform/intel-mid/device_libs/platform_max7315.c~x86-intel-mid-fix-a-format-string-overflow-warning arch/x86/platform/intel-mid/device_libs/platform_max7315.c
--- a/arch/x86/platform/intel-mid/device_libs/platform_max7315.c~x86-intel-mid-fix-a-format-string-overflow-warning
+++ a/arch/x86/platform/intel-mid/device_libs/platform_max7315.c
@@ -38,8 +38,10 @@ static void __init *max7315_platform_dat
 	 */
 	strcpy(i2c_info->type, "max7315");
 	if (nr++) {
-		sprintf(base_pin_name, "max7315_%d_base", nr);
-		sprintf(intr_pin_name, "max7315_%d_int", nr);
+		snprintf(base_pin_name, sizeof(base_pin_name),
+			 "max7315_%d_base", nr);
+		snprintf(intr_pin_name, sizeof(intr_pin_name),
+			 "max7315_%d_int", nr);
 	} else {
 		strcpy(base_pin_name, "max7315_base");
 		strcpy(intr_pin_name, "max7315_int");
_

Patches currently in -mm which might be from arnd@arndb.de are

kbuild-disable-wformat-truncation-warnings-by-default.patch
scsi-megaraid-fix-format-overflow-warning.patch
scsi-mpt3sas-fix-format-overflow-warning.patch
scsi-fusion-fix-string-overflow-warning.patch
scsi-gdth-avoid-buffer-overflow-warning.patch
scsi-fnic-fix-format-string-overflow-warning.patch
scsi-gdth-increase-the-procfs-event-buffer-size.patch
usbvision-i2c-fix-format-overflow-warning.patch
hwmon-applesmc-fix-format-string-overflow.patch
x86-intel-mid-fix-a-format-string-overflow-warning.patch
platform-x86-alienware-wmi-fix-format-string-overflow-warning.patch
block-dac960-shut-up-format-overflow-warning.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch

