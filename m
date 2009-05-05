From: akpm@linux-foundation.org
Subject: + sysctlc-remove-unused-variable.patch added to -mm tree
Date: Tue, 05 May 2009 15:21:08 -0700
Message-ID: <200905052221.n45ML8gm019178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309AbZEEWZF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 18:25:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukanto.cse.iitb@gmail.com, jaswinder@kernel.org, jkosina@suse.cz


The patch titled
     sysctl.c: remove unused variable
has been added to the -mm tree.  Its filename is
     sysctlc-remove-unused-variable.patch

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
Subject: sysctl.c: remove unused variable
From: Sukanto Ghosh <sukanto.cse.iitb@gmail.com>

Remoce the unused variable 'val' from __do_proc_dointvec()

The integer has been declared and used as 'val = -val' and there is no
reference to it anywhere.

Signed-off-by: Sukanto Ghosh <sukanto.cse.iitb@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Sukanto Ghosh <sukanto.cse.iitb@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/sysctl.c~sysctlc-remove-unused-variable kernel/sysctl.c
--- a/kernel/sysctl.c~sysctlc-remove-unused-variable
+++ a/kernel/sysctl.c
@@ -2255,7 +2255,7 @@ static int __do_proc_dointvec(void *tbl_
 		  void *data)
 {
 #define TMPBUFLEN 21
-	int *i, vleft, first=1, neg, val;
+	int *i, vleft, first=1, neg;
 	unsigned long lval;
 	size_t left, len;
 	
@@ -2308,8 +2308,6 @@ static int __do_proc_dointvec(void *tbl_
 			len = p-buf;
 			if ((len < left) && *p && !isspace(*p))
 				break;
-			if (neg)
-				val = -val;
 			s += len;
 			left -= len;
 
_

Patches currently in -mm which might be from sukanto.cse.iitb@gmail.com are

sysctlc-remove-unused-variable.patch

