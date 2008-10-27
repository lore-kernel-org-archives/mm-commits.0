From: akpm@linux-foundation.org
Subject: + lis3lv02dx-accelerometer-driver-fix.patch added to -mm tree
Date: Sun, 26 Oct 2008 23:39:12 -0700
Message-ID: <200810270639.m9R6dChV025558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751568AbYJ0GjX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 02:39:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.piel@tremplin-utc.net, burman.yan@gmail.com, mhoffman@lightlink.com, pavel@suse.cz


The patch titled
     LIS3LV02D: Conform to the new ACPI API
has been added to the -mm tree.  Its filename is
     lis3lv02dx-accelerometer-driver-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: LIS3LV02D: Conform to the new ACPI API
From: Eric Piel <eric.piel@tremplin-utc.net>

ACPI API has been updated to allow 64bit return values in
acpi_evaluate_integer(). Update also the lis3lv02d driver so that it
works with 2.6.28-rc1.

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Yan Burman <burman.yan@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/hwmon/lis3lv02d.c~lis3lv02dx-accelerometer-driver-fix drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3lv02dx-accelerometer-driver-fix
+++ a/drivers/hwmon/lis3lv02d.c
@@ -112,7 +112,7 @@ static acpi_status lis3lv02d_acpi_read(a
 {
 	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
 	struct acpi_object_list args = { 1, &arg0 };
-	unsigned long lret;
+	unsigned long long lret;
 	acpi_status status;
 
 	arg0.integer.value = reg;
@@ -132,7 +132,7 @@ static acpi_status lis3lv02d_acpi_read(a
  */
 static acpi_status lis3lv02d_acpi_write(acpi_handle handle, int reg, u8 val)
 {
-	unsigned long ret; /* Not used when writting */
+	unsigned long long ret; /* Not used when writting */
 	union acpi_object in_obj[2];
 	struct acpi_object_list args = { 2, in_obj };
 
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net are

leds-driver-for-hp-harddisk-protection-led-fix-fix-2.patch
lis3lv02dx-accelerometer-driver.patch
lis3lv02dx-accelerometer-driver-fix.patch

