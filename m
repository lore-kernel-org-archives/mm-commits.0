From: akpm@linux-foundation.org
Subject: [withdrawn] tty-pty-lookup-retval-fixup.patch removed from -mm tree
Date: Fri, 03 Apr 2009 22:34:09 -0700
Message-ID: <200904040534.n345Y9dD030885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621AbZDDFhU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 4 Apr 2009 01:37:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     tty: pty: lookup retval fixup
has been removed from the -mm tree.  Its filename was
     tty-pty-lookup-retval-fixup.patch

This patch was dropped because it was withdrawn

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

origin.patch
tty-pty-lookup-retval-fixup.patch
linux-next.patch
icom-converting-space-to-tabs.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

