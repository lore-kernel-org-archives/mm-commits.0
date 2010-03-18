From: akpm@linux-foundation.org
Subject: + drivers-char-ppdevc-use-kasprintf.patch added to -mm tree
Date: Thu, 18 Mar 2010 16:27:14 -0700
Message-ID: <201003182327.o2INREGE021939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751712Ab0CRX1Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 19:27:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, mb@bu3sch.de


The patch titled
     drivers/char/ppdev.c: use kasprintf
has been added to the -mm tree.  Its filename is
     drivers-char-ppdevc-use-kasprintf.patch

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
Subject: drivers/char/ppdev.c: use kasprintf
From: Julia Lawall <julia@diku.dk>

kasprintf combines kmalloc and sprintf, and takes care of the size
calculation itself.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression a,flag;
expression list args;
statement S;
@@

  a =
-  \(kmalloc\|kzalloc\)(...,flag)
+  kasprintf(flag,args)
  <... when != a
  if (a == NULL || ...) S
  ...>
- sprintf(a,args);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ppdev.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/char/ppdev.c~drivers-char-ppdevc-use-kasprintf drivers/char/ppdev.c
--- a/drivers/char/ppdev.c~drivers-char-ppdevc-use-kasprintf
+++ a/drivers/char/ppdev.c
@@ -286,12 +286,10 @@ static int register_device (int minor, s
 	char *name;
 	int fl;
 
-	name = kmalloc (strlen (CHRDEV) + 3, GFP_KERNEL);
+	name = kasprintf(GFP_KERNEL, CHRDEV "%x", minor);
 	if (name == NULL)
 		return -ENOMEM;
 
-	sprintf (name, CHRDEV "%x", minor);
