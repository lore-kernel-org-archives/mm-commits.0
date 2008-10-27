From: akpm@linux-foundation.org
Subject: + autofs4-remove-string-terminator-check.patch added to -mm tree
Date: Mon, 27 Oct 2008 13:33:07 -0700
Message-ID: <200810272033.m9RKX7jk017409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752263AbYJ0UdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 16:33:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, jmoyer@redhat.com


The patch titled
     autofs4: remove string terminator check
has been added to the -mm tree.  Its filename is
     autofs4-remove-string-terminator-check.patch

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
Subject: autofs4: remove string terminator check
From: Ian Kent <raven@themaw.net>

Remove unnecessary string terminator check.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c |   20 --------------------
 1 file changed, 20 deletions(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs4-remove-string-terminator-check fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs4-remove-string-terminator-check
+++ a/fs/autofs4/dev-ioctl.c
@@ -51,18 +51,6 @@ static int check_name(const char *name)
 }
 
 /*
- * Check a string doesn't overrun the chunk of
- * memory we copied from user land.
- */
-static int invalid_str(char *str, void *end)
-{
-	while ((void *) str <= end)
-		if (!*str++)
-			return 0;
-	return -EINVAL;
-}
-
-/*
  * Check that the user compiled against correct version of autofs
  * misc device code.
  *
@@ -143,14 +131,6 @@ static int validate_dev_ioctl(int cmd, s
 				    cmd);
 			goto out;
 		}
