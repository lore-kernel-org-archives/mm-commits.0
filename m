From: akpm@linux-foundation.org
Subject: - char-mxser-0-to-null-in-pointer.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:09:56 -0800
Message-ID: <200802080809.m1889bBA014849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58964 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759927AbYBHITZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser, 0 to NULL in pointer
has been removed from the -mm tree.  Its filename was
     char-mxser-0-to-null-in-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: mxser, 0 to NULL in pointer
From: Jiri Slaby <jirislaby@gmail.com>

Don't test a pointer against 0. Use NULL instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Reviewed-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/mxser_new.c~char-mxser-0-to-null-in-pointer drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser-0-to-null-in-pointer
+++ a/drivers/char/mxser_new.c
@@ -2153,7 +2153,7 @@ static void mxser_transmit_chars(struct 
 		return;
 	}
 
-	if (port->xmit_buf == 0)
+	if (port->xmit_buf == NULL)
 		return;
 
 	if ((port->xmit_cnt <= 0) || port->tty->stopped ||
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-watchdog.patch
moxa-first-pass-at-termios-reporting.patch
char-applicom-use-pci_resource_start.patch
char-applicom-use-pci_match_id.patch
char-applicom-use-pci_match_id-fix.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
