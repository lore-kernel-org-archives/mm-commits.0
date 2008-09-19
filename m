From: akpm@linux-foundation.org
Subject: + serial-set-correct-baud_base-for-oxford-semiconductor-ltd-exsys-ex-41092-dual-16950-serial-adapter.patch added to -mm tree
Date: Fri, 19 Sep 2008 16:12:28 -0700
Message-ID: <200809192312.m8JNCSki011271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333AbYISXMr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Sep 2008 19:12:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: niels.devos@wincor-nixdorf.com, alan@lxorguk.ukuu.org.uk, rmk@arm.linux.org.uk


The patch titled
     serial: set correct baud_base for Oxford Semiconductor Ltd EXSYS EX-41092 Dual 16950 Serial adapter
has been added to the -mm tree.  Its filename is
     serial-set-correct-baud_base-for-oxford-semiconductor-ltd-exsys-ex-41092-dual-16950-serial-adapter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: set correct baud_base for Oxford Semiconductor Ltd EXSYS EX-41092 Dual 16950 Serial adapter
From: "Niels de Vos" <niels.devos@wincor-nixdorf.com>

This card is only usable with other devices (not the same card) after
doing a setserial /dev/ttyS<n> baud_base 115200.  This baud_base should be
default for this card.

This card was the last/only user of pbn_b0_2_1130000, therefore removed.

Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff -puN drivers/serial/8250_pci.c~serial-set-correct-baud_base-for-oxford-semiconductor-ltd-exsys-ex-41092-dual-16950-serial-adapter drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~serial-set-correct-baud_base-for-oxford-semiconductor-ltd-exsys-ex-41092-dual-16950-serial-adapter
+++ a/drivers/serial/8250_pci.c
@@ -1089,8 +1089,6 @@ enum pci_board_num_t {
 	pbn_b0_2_921600,
 	pbn_b0_4_921600,
 
-	pbn_b0_2_1130000,
-
 	pbn_b0_4_1152000,
 
 	pbn_b0_2_1843200,
@@ -1245,13 +1243,6 @@ static struct pciserial_board pci_boards
 		.uart_offset	= 8,
 	},
 
-	[pbn_b0_2_1130000] = {
-		.flags          = FL_BASE0,
-		.num_ports      = 2,
-		.base_baud      = 1130000,
-		.uart_offset    = 8,
-	},
