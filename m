From: akpm@linux-foundation.org
Subject: + tty-pty-lookup-retval-fixup.patch added to -mm tree
Date: Tue, 03 Feb 2009 00:37:02 -0800
Message-ID: <200902030837.n138b25g022190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845AbZBCIha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 03:37:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com


The patch titled
     tty: pty: lookup retval fixup
has been added to the -mm tree.  Its filename is
     tty-pty-lookup-retval-fixup.patch

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
Subject: tty: pty: lookup retval fixup
From: Jiri Slaby <jirislaby@gmail.com>

Make sure we fail on NULL return value possibly returned by master tty
lookup.

Convert NULL to ERR_PTR(-ENODEV) in ptm_unix98_lookup, since NULL is not
captured by IS_ERR() in __tty_open.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/pty.c~tty-pty-lookup-retval-fixup drivers/char/pty.c
--- a/drivers/char/pty.c~tty-pty-lookup-retval-fixup
+++ a/drivers/char/pty.c
@@ -508,7 +508,7 @@ static struct tty_struct *ptm_unix98_loo
 	struct tty_struct *tty = devpts_get_tty(ptm_inode, idx);
 	if (tty)
 		tty = tty->link;
-	return tty;
+	return tty ? : ERR_PTR(-ENODEV);
 }
 
 /**
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
tty-pty-lookup-retval-fixup.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

