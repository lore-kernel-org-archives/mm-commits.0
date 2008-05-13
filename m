From: akpm@linux-foundation.org
Subject: + riscom8-remove-redundant-null-pointer-test.patch added to -mm tree
Date: Mon, 12 May 2008 17:33:27 -0700
Message-ID: <200805130033.m4D0XRsw016850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754568AbYEMAeL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 20:34:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mail@chrismalley.co.uk, alan@redhat.com


The patch titled
     riscom8: remove redundant null pointer test
has been added to the -mm tree.  Its filename is
     riscom8-remove-redundant-null-pointer-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

riscom8-remove-redundant-null-pointer-test.patch

