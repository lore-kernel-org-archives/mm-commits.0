From: akpm@linux-foundation.org
Subject: [merged] wmi-use-generic-uuid-library.patch removed from -mm tree
Date: Mon, 23 May 2016 12:49:06 -0700
Message-ID: <57435eb2.7nPd+UzyybUxoNiK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088AbcEWTtH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:49:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, dvhart@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/platform/x86/wmi.c: use generic UUID library
has been removed from the -mm tree.  Its filename was
     wmi-use-generic-uuid-library.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: drivers/platform/x86/wmi.c: use generic UUID library

Instead of opencoding let's use generic UUID library functions here.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/wmi.c |  104 ++++-------------------------------
 1 file changed, 13 insertions(+), 91 deletions(-)

diff -puN drivers/platform/x86/wmi.c~wmi-use-generic-uuid-library drivers/platform/x86/wmi.c
--- a/drivers/platform/x86/wmi.c~wmi-use-generic-uuid-library
+++ a/drivers/platform/x86/wmi.c
@@ -37,6 +37,7 @@
 #include <linux/acpi.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/uuid.h>
 
 ACPI_MODULE_NAME("wmi");
 MODULE_AUTHOR("Carlos Corbacho");
@@ -115,100 +116,21 @@ static struct acpi_driver acpi_wmi_drive
  * GUID parsing functions
  */
 
-/**
- * wmi_parse_hexbyte - Convert a ASCII hex number to a byte
- * @src:  Pointer to at least 2 characters to convert.
- *
- * Convert a two character ASCII hex string to a number.
- *
- * Return:  0-255  Success, the byte was parsed correctly
- *          -1     Error, an invalid character was supplied
- */
-static int wmi_parse_hexbyte(const u8 *src)
-{
-	int h;
-	int value;
-
-	/* high part */
-	h = value = hex_to_bin(src[0]);
-	if (value < 0)
-		return -1;
-
-	/* low part */
-	value = hex_to_bin(src[1]);
-	if (value >= 0)
-		return (h << 4) | value;
-	return -1;
-}
-
-/**
- * wmi_swap_bytes - Rearrange GUID bytes to match GUID binary
- * @src:   Memory block holding binary GUID (16 bytes)
- * @dest:  Memory block to hold byte swapped binary GUID (16 bytes)
- *
- * Byte swap a binary GUID to match it's real GUID value
- */
-static void wmi_swap_bytes(u8 *src, u8 *dest)
-{
-	int i;
-
-	for (i = 0; i <= 3; i++)
-		memcpy(dest + i, src + (3 - i), 1);
-
-	for (i = 0; i <= 1; i++)
-		memcpy(dest + 4 + i, src + (5 - i), 1);
-
-	for (i = 0; i <= 1; i++)
-		memcpy(dest + 6 + i, src + (7 - i), 1);
-
-	memcpy(dest + 8, src + 8, 8);
-}
-
-/**
- * wmi_parse_guid - Convert GUID from ASCII to binary
- * @src:   36 char string of the form fa50ff2b-f2e8-45de-83fa-65417f2f49ba
- * @dest:  Memory block to hold binary GUID (16 bytes)
- *
- * N.B. The GUID need not be NULL terminated.
- *
- * Return:  'true'   @dest contains binary GUID
- *          'false'  @dest contents are undefined
- */
-static bool wmi_parse_guid(const u8 *src, u8 *dest)
-{
-	static const int size[] = { 4, 2, 2, 2, 6 };
-	int i, j, v;
-
-	if (src[8]  != '-' || src[13] != '-' ||
-		src[18] != '-' || src[23] != '-')
-		return false;
-
-	for (j = 0; j < 5; j++, src++) {
-		for (i = 0; i < size[j]; i++, src += 2, *dest++ = v) {
-			v = wmi_parse_hexbyte(src);
-			if (v < 0)
-				return false;
-		}
-	}
-
-	return true;
-}
-
 static bool find_guid(const char *guid_string, struct wmi_block **out)
 {
-	char tmp[16], guid_input[16];
+	uuid_le guid_input;
 	struct wmi_block *wblock;
 	struct guid_block *block;
 	struct list_head *p;
 
-	wmi_parse_guid(guid_string, tmp);
-	wmi_swap_bytes(tmp, guid_input);
+	if (uuid_le_to_bin(guid_string, &guid_input))
+		return false;
 
 	list_for_each(p, &wmi_block_list) {
 		wblock = list_entry(p, struct wmi_block, list);
 		block = &wblock->gblock;
 
-		if (memcmp(block->guid, guid_input, 16) == 0) {
+		if (memcmp(block->guid, &guid_input, 16) == 0) {
 			if (out)
 				*out = wblock;
 			return true;
@@ -498,20 +420,20 @@ wmi_notify_handler handler, void *data)
 {
 	struct wmi_block *block;
 	acpi_status status = AE_NOT_EXIST;
-	char tmp[16], guid_input[16];
+	uuid_le guid_input;
 	struct list_head *p;
 
 	if (!guid || !handler)
 		return AE_BAD_PARAMETER;
 
-	wmi_parse_guid(guid, tmp);
-	wmi_swap_bytes(tmp, guid_input);
+	if (uuid_le_to_bin(guid, &guid_input))
+		return AE_BAD_PARAMETER;
 
 	list_for_each(p, &wmi_block_list) {
 		acpi_status wmi_status;
 		block = list_entry(p, struct wmi_block, list);
 
-		if (memcmp(block->gblock.guid, guid_input, 16) == 0) {
+		if (memcmp(block->gblock.guid, &guid_input, 16) == 0) {
 			if (block->handler &&
 			    block->handler != wmi_notify_debug)
 				return AE_ALREADY_ACQUIRED;
@@ -539,20 +461,20 @@ acpi_status wmi_remove_notify_handler(co
 {
 	struct wmi_block *block;
 	acpi_status status = AE_NOT_EXIST;
-	char tmp[16], guid_input[16];
+	uuid_le guid_input;
 	struct list_head *p;
 
 	if (!guid)
 		return AE_BAD_PARAMETER;
 
-	wmi_parse_guid(guid, tmp);
-	wmi_swap_bytes(tmp, guid_input);
+	if (uuid_le_to_bin(guid, &guid_input))
+		return AE_BAD_PARAMETER;
 
 	list_for_each(p, &wmi_block_list) {
 		acpi_status wmi_status;
 		block = list_entry(p, struct wmi_block, list);
 
-		if (memcmp(block->gblock.guid, guid_input, 16) == 0) {
+		if (memcmp(block->gblock.guid, &guid_input, 16) == 0) {
 			if (!block->handler ||
 			    block->handler == wmi_notify_debug)
 				return AE_NULL_ENTRY;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


