From: akpm@linux-foundation.org
Subject: + unifdefc-change-getline-to-get_line-to-avoid-c-library-confusion.patch added to -mm tree
Date: Thu, 05 Mar 2009 14:18:37 -0800
Message-ID: <200903052218.n25MIbMY007635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753654AbZCEWTS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 17:19:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: justinmattock@gmail.com, fweisbec@gmail.com, sam@ravnborg.org


The patch titled
     unifdef.c: change "getline" to "get_line" to avoid C  library confusion.
has been added to the -mm tree.  Its filename is
     unifdefc-change-getline-to-get_line-to-avoid-c-library-confusion.patch

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
Subject: unifdef.c: change "getline" to "get_line" to avoid C  library confusion.
From: Justin P. Mattock <justinmattock@gmail.com>

This fixes an error when compiling the kernel.

  CHK     include/linux/version.h
  HOSTCC  scripts/unifdef
scripts/unifdef.c:209: error: conflicting types for 'getline'
/usr/include/stdio.h:651: note: previous declaration of 'getline' was here
make[1]: *** [scripts/unifdef] Error 1
make: *** [__headers] Error 2

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc:  Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/unifdef.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN scripts/unifdef.c~unifdefc-change-getline-to-get_line-to-avoid-c-library-confusion scripts/unifdef.c
--- a/scripts/unifdef.c~unifdefc-change-getline-to-get_line-to-avoid-c-library-confusion
+++ a/scripts/unifdef.c
@@ -206,7 +206,7 @@ static void             done(void);
 static void             error(const char *);
 static int              findsym(const char *);
 static void             flushline(bool);
-static Linetype         getline(void);
+static Linetype         get_line(void);
 static Linetype         ifeval(const char **);
 static void             ignoreoff(void);
 static void             ignoreon(void);
@@ -512,7 +512,7 @@ process(void)
 
 	for (;;) {
 		linenum++;
-		lineval = getline();
+		lineval = get_line();
 		trans_table[ifstate[depth]][lineval]();
 		debug("process %s -> %s depth %d",
 		    linetype_name[lineval],
@@ -526,7 +526,7 @@ process(void)
  * help from skipcomment().
  */
 static Linetype
-getline(void)
+get_line(void)
 {
 	const char *cp;
 	int cursym;
_

Patches currently in -mm which might be from justinmattock@gmail.com are

unifdefc-change-getline-to-get_line-to-avoid-c-library-confusion.patch

