From: akpm@linux-foundation.org
Subject: + char-cyclades-fix-deadlock.patch added to -mm tree
Date: Fri, 18 May 2007 11:08:36 -0700
Message-ID: <200705181808.l4II8a6s020394@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43204 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758549AbXERSJw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 14:09:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, fix deadlock
has been added to the -mm tree.  Its filename is
     char-cyclades-fix-deadlock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, fix deadlock
From: Jiri Slaby <jirislaby@gmail.com>

An omitted unlock.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/char/cyclades.c~char-cyclades-fix-deadlock drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-fix-deadlock
+++ a/drivers/char/cyclades.c
@@ -1061,6 +1061,7 @@ static void cyy_intr_chip(struct cyclade
 
 				if (data & info->ignore_status_mask) {
 					info->icount.rx++;
+					spin_unlock(&cinfo->card_lock);
 					return;
 				}
 				if (tty_buffer_request_room(tty, 1)) {
_

Patches currently in -mm which might be from jirislaby@gmail.com are

cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
char-cyclades-fix-deadlock.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
shrink_slab-handle-bad-shrinkers.patch
