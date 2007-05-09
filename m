From: akpm@linux-foundation.org
Subject: - jsm-driver-fix-for-linuxpps-support.patch removed from -mm tree
Date: Tue, 08 May 2007 19:46:48 -0700
Message-ID: <200705090246.l492km1r008901@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755312AbXEICq7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:46:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lsorense@csclub.uwaterloo.ca, Scott_Kilau@digi.com, wendyx@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     jsm driver fix for linuxpps support
has been removed from the -mm tree.  Its filename was
     jsm-driver-fix-for-linuxpps-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: jsm driver fix for linuxpps support
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

origin.patch
