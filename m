From: akpm@linux-foundation.org
Subject: [merged] drivers-serial-remove-baud_table_size-macro.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:32:31 -0800
Message-ID: <200912292132.nBTLWVuq008633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752769AbZL2Vcl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:32:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tfransosi@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     drivers/serial/68328serial.c: remove BAUD_TABLE_SIZE macro
has been removed from the -mm tree.  Its filename was
     drivers-serial-remove-baud_table_size-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/serial/68328serial.c: remove BAUD_TABLE_SIZE macro
From: Thiago Farina <tfransosi@gmail.com>

This macro is a duplicate of ARRAY_SIZE defined in kernel api, so just use
that instead.

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/68328serial.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/serial/68328serial.c~drivers-serial-remove-baud_table_size-macro drivers/serial/68328serial.c
--- a/drivers/serial/68328serial.c~drivers-serial-remove-baud_table_size-macro
+++ a/drivers/serial/68328serial.c
@@ -153,8 +153,6 @@ static int baud_table[] = {
 	0, 50, 75, 110, 134, 150, 200, 300, 600, 1200, 1800, 2400, 4800,
 	9600, 19200, 38400, 57600, 115200, 0 };
 
-#define BAUD_TABLE_SIZE (sizeof(baud_table)/sizeof(baud_table[0]))
-
 /* Sets or clears DTR/RTS on the requested line */
 static inline void m68k_rtsdtr(struct m68k_serial *ss, int set)
 {
@@ -1406,10 +1404,10 @@ static void m68328_set_baud(void)
 	USTCNT = ustcnt & ~USTCNT_TXEN;
 
 again:
-	for (i = 0; i < sizeof(baud_table) / sizeof(baud_table[0]); i++)
+	for (i = 0; i < ARRAY_SIZE(baud_table); i++)
 		if (baud_table[i] == m68328_console_baud)
 			break;
-	if (i >= sizeof(baud_table) / sizeof(baud_table[0])) {
+	if (i >= ARRAY_SIZE(baud_table)) {
 		m68328_console_baud = 9600;
 		goto again;
 	}
@@ -1435,7 +1433,7 @@ int m68328_console_setup(struct console 
 	if (arg)
 		n = simple_strtoul(arg,NULL,0);
 
-	for (i = 0; i < BAUD_TABLE_SIZE; i++)
+	for (i = 0; i < ARRAY_SIZE(baud_table); i++)
 		if (baud_table[i] == n)
 			break;
 	if (i < BAUD_TABLE_SIZE) {
_

Patches currently in -mm which might be from tfransosi@gmail.com are

linux-next.patch

