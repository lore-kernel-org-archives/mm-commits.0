From: akpm@linux-foundation.org
Subject: - asus_acpi-invert-read-of-wled-proc-file-to-show-correct.patch removed from -mm tree
Date: Sat, 28 Apr 2007 20:32:25 -0700
Message-ID: <200704290332.l3T3WPsU007662@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754518AbXD2Dca (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 23:32:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bcollins@ubuntu.com, mm-commits@vger.kernel.org


The patch titled
     asus_acpi: Invert read of wled proc file to show correct state of LED
has been removed from the -mm tree.  Its filename was
     asus_acpi-invert-read-of-wled-proc-file-to-show-correct.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: asus_acpi: Invert read of wled proc file to show correct state of LED
From: Ben Collins <bcollins@ubuntu.com>

User with this equipment stated that writes to this file worked correctly,
but that reads were showing inverted state (1 for off, 0 for on). 
Following the same style for reads, introduced an invert flag to read_led,
and used it for wled.

See http://bugzilla.ubuntu.com/show_bug.cgi?id=10770

Signed-off-by: Ben Collins <bcollins@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/asus_acpi.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/acpi/asus_acpi.c~asus_acpi-invert-read-of-wled-proc-file-to-show-correct drivers/acpi/asus_acpi.c
--- a/drivers/acpi/asus_acpi.c~asus_acpi-invert-read-of-wled-proc-file-to-show-correct
+++ a/drivers/acpi/asus_acpi.c
@@ -558,13 +558,13 @@ proc_read_info(char *page, char **start,
  */
 
 /* Generic LED functions */
-static int read_led(const char *ledname, int ledmask)
+static int read_led(const char *ledname, int ledmask, int invert)
 {
 	if (ledname) {
 		int led_status;
 
 		if (read_acpi_int(NULL, ledname, &led_status))
-			return led_status;
+			return (invert) ? !led_status : led_status;
 		else
 			printk(KERN_WARNING "Asus ACPI: Error reading LED "
 			       "status\n");
@@ -620,7 +620,7 @@ proc_read_mled(char *page, char **start,
 	       void *data)
 {
 	return sprintf(page, "%d\n",
-		       read_led(hotk->methods->mled_status, MLED_ON));
+		       read_led(hotk->methods->mled_status, MLED_ON, 0));
 }
 
 static int
@@ -666,7 +666,7 @@ proc_read_wled(char *page, char **start,
 	       void *data)
 {
 	return sprintf(page, "%d\n",
-		       read_led(hotk->methods->wled_status, WLED_ON));
+		       read_led(hotk->methods->wled_status, WLED_ON, 1));
 }
 
 static int
@@ -683,7 +683,8 @@ static int
 proc_read_bluetooth(char *page, char **start, off_t off, int count, int *eof,
 		    void *data)
 {
-	return sprintf(page, "%d\n", read_led(hotk->methods->bt_status, BT_ON));
+	return sprintf(page, "%d\n",
+		read_led(hotk->methods->bt_status, BT_ON, 0));
 }
 
 static int
@@ -703,7 +704,7 @@ proc_read_tled(char *page, char **start,
 	       void *data)
 {
 	return sprintf(page, "%d\n",
-		       read_led(hotk->methods->tled_status, TLED_ON));
+		       read_led(hotk->methods->tled_status, TLED_ON, 0));
 }
 
 static int
_

Patches currently in -mm which might be from bcollins@ubuntu.com are

asus_acpi-invert-read-of-wled-proc-file-to-show-correct.patch
