From: akpm@linux-foundation.org
Subject: + drivers-tty-serial-pch_uartc-dont-oops-if-dmi_get_system_info-returns-null.patch added to -mm tree
Date: Wed, 08 Jun 2011 14:45:36 -0700
Message-ID: <201106082145.p58LjaKA031008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752510Ab1FHVpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2011 17:45:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexander.stein@systec-electronic.com, gregkh@suse.de, stable@kernel.org


The patch titled
     drivers/tty/serial/pch_uart.c: don't oops if dmi_get_system_info returns NULL
has been added to the -mm tree.  Its filename is
     drivers-tty-serial-pch_uartc-dont-oops-if-dmi_get_system_info-returns-null.patch

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
Subject: drivers/tty/serial/pch_uart.c: don't oops if dmi_get_system_info returns NULL
From: Alexander Stein <alexander.stein@systec-electronic.com>

If dmi_get_system_info() returns NULL, pch_uart_init_port() will
dereferencea zero pointer.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Greg KH <gregkh@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/serial/pch_uart.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/tty/serial/pch_uart.c~drivers-tty-serial-pch_uartc-dont-oops-if-dmi_get_system_info-returns-null drivers/tty/serial/pch_uart.c
--- a/drivers/tty/serial/pch_uart.c~drivers-tty-serial-pch_uartc-dont-oops-if-dmi_get_system_info-returns-null
+++ a/drivers/tty/serial/pch_uart.c
@@ -1396,6 +1396,7 @@ static struct eg20t_port *pch_uart_init_
 	int fifosize, base_baud;
 	int port_type;
 	struct pch_uart_driver_data *board;
+	const char *board_name;
 
 	board = &drv_dat[id->driver_data];
 	port_type = board->port_type;
@@ -1411,7 +1412,8 @@ static struct eg20t_port *pch_uart_init_
 	base_baud = 1843200; /* 1.8432MHz */
 
 	/* quirk for CM-iTC board */
-	if (strstr(dmi_get_system_info(DMI_BOARD_NAME), "CM-iTC"))
+	board_name = dmi_get_system_info(DMI_BOARD_NAME);
+	if (board_name && strstr(board_name, "CM-iTC"))
 		base_baud = 192000000; /* 192.0MHz */
 
 	switch (port_type) {
_

Patches currently in -mm which might be from alexander.stein@systec-electronic.com are

drivers-tty-serial-pch_uartc-dont-oops-if-dmi_get_system_info-returns-null.patch

