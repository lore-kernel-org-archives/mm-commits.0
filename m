From: akpm@linux-foundation.org
Subject: + printk-fix-bounds-checking-for-log_prefix.patch added to -mm tree
Date: Thu, 25 Aug 2011 13:37:36 -0700
Message-ID: <201108252037.p7PKbbsd006610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754024Ab1HYUiH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Aug 2011 16:38:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: william.r.douglas@gmail.com, william.douglas@intel.com


The patch titled
     printk: fix bounds checking for log_prefix
has been added to the -mm tree.  Its filename is
     printk-fix-bounds-checking-for-log_prefix.patch

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
Subject: printk: fix bounds checking for log_prefix
From: William Douglas <william.r.douglas@gmail.com>

Currently log_prefix is testing that the first character of the log level
and facility is less than '0' and greater than '9' (which is always
false).  It should be testing to see if the character less than '0' or
greater than '9' instead.  This patch makes that change.

The code being changed worked because strtoul bombs out (endp isn't
updated) and 0 is returned anyway.

Signed-off-by: William Douglas <william.douglas@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk.c~printk-fix-bounds-checking-for-log_prefix kernel/printk.c
--- a/kernel/printk.c~printk-fix-bounds-checking-for-log_prefix
+++ a/kernel/printk.c
@@ -595,7 +595,7 @@ static size_t log_prefix(const char *p, 
 		/* multi digit including the level and facility number */
 		char *endp = NULL;
 
-		if (p[1] < '0' && p[1] > '9')
+		if (p[1] < '0' || p[1] > '9')
 			return 0;
 
 		lev = (simple_strtoul(&p[1], &endp, 10) & 7);
_

Patches currently in -mm which might be from william.r.douglas@gmail.com are

printk-fix-bounds-checking-for-log_prefix.patch

