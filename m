From: akpm@linux-foundation.org
Subject: - riscom8-remove-redundant-null-pointer-test.patch removed from -mm tree
Date: Fri, 04 Jul 2008 00:12:22 -0700
Message-ID: <200807040712.m647CM2e018775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753325AbYGDHNG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jul 2008 03:13:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mail@chrismalley.co.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     riscom8: remove redundant null pointer test
has been removed from the -mm tree.  Its filename was
     riscom8-remove-redundant-null-pointer-test.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: riscom8: remove redundant null pointer test
From: Chris Malley <mail@chrismalley.co.uk>

tty has already been dereferenced at least twice in these functions,
so checking for null here seems a bit unnecessary.

Signed-off-by: Chris Malley <mail@chrismalley.co.uk>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/riscom8.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/riscom8.c~riscom8-remove-redundant-null-pointer-test drivers/char/riscom8.c
--- a/drivers/char/riscom8.c~riscom8-remove-redundant-null-pointer-test
+++ a/drivers/char/riscom8.c
@@ -1108,7 +1108,7 @@ static int rc_write(struct tty_struct *t
 
 	bp = port_Board(port);
 
-	if (!tty || !port->xmit_buf)
+	if (!port->xmit_buf)
 		return 0;
 
 	while (1) {
@@ -1151,7 +1151,7 @@ static int rc_put_char(struct tty_struct
 	if (rc_paranoia_check(port, tty->name, "rc_put_char"))
 		return 0;
 
-	if (!tty || !port->xmit_buf)
+	if (!port->xmit_buf)
 		return 0;
 
 	spin_lock_irqsave(&riscom_lock, flags);
_

Patches currently in -mm which might be from mail@chrismalley.co.uk are

linux-next.patch
riscom8-remove-redundant-null-pointer-test.patch

