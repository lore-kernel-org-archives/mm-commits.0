From: akpm@linux-foundation.org
Subject: - char-mxser_new-do-not-null-driver_data.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:52:10 -0800
Message-ID: <200702112252.l1BMqAsY015993@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60233 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932782AbXBKWwQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:52:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, osv@javad.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, do not null driver_data
has been removed from the -mm tree.  Its filename was
     char-mxser_new-do-not-null-driver_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, do not null driver_data
From: Jiri Slaby <jirislaby@gmail.com>

driver_data are initialzed to NULL from tty layer, no need to do it in the
driver.  In this case it cases oops, since driver_data may be NULL for a short
while for another closing process.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: <osv@javad.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-do-not-null-driver_data drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-do-not-null-driver_data
+++ a/drivers/char/mxser_new.c
@@ -927,9 +927,6 @@ static int mxser_open(struct tty_struct 
 	struct mxser_port *info;
 	int retval, line;
 
-	/* initialize driver_data in case something fails */
-	tty->driver_data = NULL;
-
 	line = tty->index;
 	if (line == MXSER_PORTS)
 		return 0;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
char-use-more-pci_device-macro.patch
char-cyclades-use-pci_device_id.patch
maintainers-remove-two-dead-e-mail.patch
char-specialix-isr-have-2-params.patch
char-timers-cleanup.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
video-fb-add-true-ref_count-atomicity.patch
video-fb-kzalloc-changes.patch
shrink_slab-handle-bad-shrinkers.patch
