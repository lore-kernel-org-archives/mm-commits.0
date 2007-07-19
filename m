From: akpm@linux-foundation.org
Subject: - usb-mos7720-mos7840-remove-redundant-urb-check.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:08:06 -0700
Message-ID: <200707192008.l6JK86rU020425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43811 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757045AbXGSUPL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fmalita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     usb: mos7720, mos7840: remove redundant urb check
has been removed from the -mm tree.  Its filename was
     usb-mos7720-mos7840-remove-redundant-urb-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb: mos7720, mos7840: remove redundant urb check
From: Florin Malita <fmalita@gmail.com>

Coverity (1709, 1710, 1711, 1712, 1713) actually flagged these as
REVERSE_INULLs (NULL check performed after dereference). But looking at
the other drivers I can't see any similar tests and the USB core already
makes sure urb is non-null - so might as well get rid of the checks.

Signed-off-by: Florin Malita <fmalita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/mos7720.c |    5 -----
 drivers/usb/serial/mos7840.c |   19 -------------------
 2 files changed, 24 deletions(-)

diff -puN drivers/usb/serial/mos7720.c~usb-mos7720-mos7840-remove-redundant-urb-check drivers/usb/serial/mos7720.c
--- a/drivers/usb/serial/mos7720.c~usb-mos7720-mos7840-remove-redundant-urb-check
+++ a/drivers/usb/serial/mos7720.c
@@ -110,11 +110,6 @@ static void mos7720_interrupt_callback(s
 
 	dbg("%s"," : Entering\n");
 
-	if (!urb) {
-		dbg("%s","Invalid Pointer !!!!:\n");
-		return;
-	}
-
 	switch (status) {
 	case 0:
 		/* success */
diff -puN drivers/usb/serial/mos7840.c~usb-mos7720-mos7840-remove-redundant-urb-check drivers/usb/serial/mos7840.c
--- a/drivers/usb/serial/mos7840.c~usb-mos7720-mos7840-remove-redundant-urb-check
+++ a/drivers/usb/serial/mos7840.c
@@ -436,11 +436,6 @@ static void mos7840_control_callback(str
 	int result = 0;
 	int status = urb->status;
 
-	if (!urb) {
-		dbg("%s", "Invalid Pointer !!!!:\n");
-		return;
-	}
-
 	mos7840_port = (struct moschip_port *)urb->context;
 
 	switch (status) {
@@ -525,10 +520,6 @@ static void mos7840_interrupt_callback(s
 	int status = urb->status;
 
 	dbg("%s", " : Entering\n");
-	if (!urb) {
-		dbg("%s", "Invalid Pointer !!!!:\n");
-		return;
-	}
 
 	switch (status) {
 	case 0:
@@ -676,11 +667,6 @@ static void mos7840_bulk_in_callback(str
 	struct tty_struct *tty;
 	int status = urb->status;
 
-	if (!urb) {
-		dbg("%s", "Invalid Pointer !!!!:\n");
-		return;
-	}
-
 	if (status) {
 		dbg("nonzero read bulk status received: %d", status);
 		return;
@@ -753,11 +739,6 @@ static void mos7840_bulk_out_data_callba
 	int status = urb->status;
 	int i;
 
-	if (!urb) {
-		dbg("%s", "Invalid Pointer !!!!:\n");
-		return;
-	}
-
 	mos7840_port = (struct moschip_port *)urb->context;
 	spin_lock(&mos7840_port->pool_lock);
 	for (i = 0; i < NUM_URBS; i++) {
_

Patches currently in -mm which might be from fmalita@gmail.com are

origin.patch
