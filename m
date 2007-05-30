From: akpm@linux-foundation.org
Subject: + console-more-buf-for-index-parsing.patch added to -mm tree
Date: Wed, 30 May 2007 11:59:30 -0700
Message-ID: <200705301859.l4UIxUYL002203@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754664AbXE3S7r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 14:59:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, bjorn.helgaas@hp.com, kraxel@suse.de, rmk@arm.linux.org.uk, yinghai.lu@Sun.COM


The patch titled
     console: more buf for index parsing
has been added to the -mm tree.  Its filename is
     console-more-buf-for-index-parsing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: console: more buf for index parsing
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

change name to buf according to the usage as name + index

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Gerd Hoffmann <kraxel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

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

console-more-buf-for-index-parsing.patch
console-console-handover-to-preferred-console.patch
serial-convert-early_uart-to-earlycon-for-8250.patch
serial-set-dtr-in-uart-for-kernel-serial-console.patch
