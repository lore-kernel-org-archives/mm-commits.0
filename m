From: akpm@linux-foundation.org
Subject: - char-cyclades-fix-deadlock.patch removed from -mm tree
Date: Tue, 29 May 2007 11:51:56 -0700
Message-ID: <200705291851.l4TIptIT008367@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339AbXE2SwZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:52:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, fix deadlock
has been removed from the -mm tree.  Its filename was
     char-cyclades-fix-deadlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, fix deadlock
From: Jiri Slaby <jirislaby@gmail.com>

An omitted unlock.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: <stable@kernel.org>
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

rocketc-fix-unchecked-mutex_lock_interruptible.patch
char-n_hdlc-allow-restartsys-retval-of-tty-write.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
shrink_slab-handle-bad-shrinkers.patch
