From: akpm@linux-foundation.org
Subject: + jsm-driver-fix-for-linuxpps-support.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:53:35 -0800
Message-ID: <200703151853.l2FIrbCY023430@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36186 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514AbXCOS45 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:56:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lsorense@csclub.uwaterloo.ca, Scott_Kilau@digi.com, wendyx@us.ibm.com


The patch titled
     Subject: jsm driver fix for linuxpps support
has been added to the -mm tree.  Its filename is
     jsm-driver-fix-for-linuxpps-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Subject: jsm driver fix for linuxpps support
From: Len Sorensen <lsorense@csclub.uwaterloo.ca>

The jsm driver doesn't currently use the uart_handle_*_change helper
functions, which are the obvious place for things like linuxpps to tie
into (which it now does of course), and as a result the jsm driver can
not be used with linuxpps and anything else that ties into the
serial_core helper functions.  This patch adds calls to these helper
functions whenever the value they manage changes.  That actual storage
of the state is not modified since the jsm driver caches the current
settings (The 8250 driver reads them everytime a user asks for the
state), and only updates them whenever they change.

Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Scott H Kilau <Scott_Kilau@digi.com>
Cc: Wendy Xiong <wendyx@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/jsm/jsm_neo.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/serial/jsm/jsm_neo.c~jsm-driver-fix-for-linuxpps-support drivers/serial/jsm/jsm_neo.c
--- a/drivers/serial/jsm/jsm_neo.c~jsm-driver-fix-for-linuxpps-support
+++ a/drivers/serial/jsm/jsm_neo.c
@@ -581,8 +581,13 @@ static void neo_parse_modem(struct jsm_c
 		return;
 
 	/* Scrub off lower bits. They signify delta's, which I don't care about */
-	msignals &= 0xf0;
+	/* Keep DDCD and DDSR though */
+	msignals &= 0xf8;
 
+	if (msignals & UART_MSR_DDCD)
+		uart_handle_dcd_change(&ch->uart_port, msignals & UART_MSR_DCD);
+	if (msignals & UART_MSR_DDSR)
+		uart_handle_cts_change(&ch->uart_port, msignals & UART_MSR_CTS);
 	if (msignals & UART_MSR_DCD)
 		ch->ch_mistat |= UART_MSR_DCD;
 	else
_

Patches currently in -mm which might be from lsorense@csclub.uwaterloo.ca are

small-fixes-for-jsm-driver.patch
jsm-driver-fix-for-linuxpps-support.patch
