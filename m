From: akpm@linux-foundation.org
Subject: + drivers-char-nozomic-fix-unused-variable-compiler-warning.patch added to -mm tree
Date: Mon, 08 Nov 2010 13:59:24 -0800
Message-ID: <201011082159.oA8LxOpi011914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755690Ab0KHV71 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 16:59:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arun@bhanu.net, greg@kroah.com


The patch titled
     drivers/char/nozomi.c: fix unused variable compiler warning
has been added to the -mm tree.  Its filename is
     drivers-char-nozomic-fix-unused-variable-compiler-warning.patch

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
Subject: drivers/char/nozomi.c: fix unused variable compiler warning
From: Arun Bhanu <arun@bhanu.net>

drivers/char/nozomi.c: In function `ntty_ioctl':
drivers/char/nozomi.c:1831:8: warning: unused variable `argp'

Signed-off-by: Arun Bhanu <arun@bhanu.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/nozomi.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/nozomi.c~drivers-char-nozomic-fix-unused-variable-compiler-warning drivers/char/nozomi.c
--- a/drivers/char/nozomi.c~drivers-char-nozomic-fix-unused-variable-compiler-warning
+++ a/drivers/char/nozomi.c
@@ -1828,7 +1828,6 @@ static int ntty_ioctl(struct tty_struct 
 		      unsigned int cmd, unsigned long arg)
 {
 	struct port *port = tty->driver_data;
-	void __user *argp = (void __user *)arg;
 	int rval = -ENOIOCTLCMD;
 
 	DBG1("******** IOCTL, cmd: %d", cmd);
_

Patches currently in -mm which might be from arun@bhanu.net are

drivers-char-nozomic-fix-unused-variable-compiler-warning.patch

