From: akpm@linux-foundation.org
Subject: - console-more-buf-for-index-parsing.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:48:28 -0700
Message-ID: <200707162048.l6GKmSb5001040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46931 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758118AbXGPUsr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 16:48:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, bjorn.helgaas@hp.com, kraxel@suse.de, rmk@arm.linux.org.uk, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     console: more buf for index parsing
has been removed from the -mm tree.  Its filename was
     console-more-buf-for-index-parsing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: console: more buf for index parsing
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Change name to buf according to the usage as name + index

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Gerd Hoffmann <kraxel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN kernel/printk.c~console-more-buf-for-index-parsing kernel/printk.c
--- a/kernel/printk.c~console-more-buf-for-index-parsing
+++ a/kernel/printk.c
@@ -654,7 +654,7 @@ static void call_console_drivers(unsigne
  */
 static int __init console_setup(char *str)
 {
-	char name[sizeof(console_cmdline[0].name)];
+	char buf[sizeof(console_cmdline[0].name) + 4]; /* 4 for index */
 	char *s, *options;
 	int idx;
 
@@ -662,27 +662,27 @@ static int __init console_setup(char *st
 	 * Decode str into name, index, options.
 	 */
 	if (str[0] >= '0' && str[0] <= '9') {
-		strcpy(name, "ttyS");
-		strncpy(name + 4, str, sizeof(name) - 5);
+		strcpy(buf, "ttyS");
+		strncpy(buf + 4, str, sizeof(buf) - 5);
 	} else {
-		strncpy(name, str, sizeof(name) - 1);
+		strncpy(buf, str, sizeof(buf) - 1);
 	}
-	name[sizeof(name) - 1] = 0;
+	buf[sizeof(buf) - 1] = 0;
 	if ((options = strchr(str, ',')) != NULL)
 		*(options++) = 0;
 #ifdef __sparc__
 	if (!strcmp(str, "ttya"))
-		strcpy(name, "ttyS0");
+		strcpy(buf, "ttyS0");
 	if (!strcmp(str, "ttyb"))
-		strcpy(name, "ttyS1");
+		strcpy(buf, "ttyS1");
 #endif
-	for (s = name; *s; s++)
+	for (s = buf; *s; s++)
 		if ((*s >= '0' && *s <= '9') || *s == ',')
 			break;
 	idx = simple_strtoul(s, NULL, 10);
 	*s = 0;
 
-	add_preferred_console(name, idx, options);
+	add_preferred_console(buf, idx, options);
 	return 1;
 }
 __setup("console=", console_setup);
@@ -709,7 +709,7 @@ int __init add_preferred_console(char *n
 	 *	See if this tty is not yet registered, and
 	 *	if we have a slot free.
 	 */
-	for(i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
+	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
 		if (strcmp(console_cmdline[i].name, name) == 0 &&
 			  console_cmdline[i].index == idx) {
 				selected_console = i;
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
x86_64-change-_map_single-to-static-in-pci_gartc-etc.patch
x86_64-geode-hw-random-number-generator-depend-on-x86_3.patch
x86_64-get-mp_bus_to_node-as-early.patch
