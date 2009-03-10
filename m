From: akpm@linux-foundation.org
Subject: [merged] unifdefc-change-getline-to-get_line-to-avoid-c-library-confusion.patch removed from -mm tree
Date: Tue, 10 Mar 2009 11:26:42 -0700
Message-ID: <200903101826.n2AIQgLs022662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755107AbZCJS22 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Mar 2009 14:28:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: justinmattock@gmail.com, fweisbec@gmail.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     unifdef.c: change "getline" to "get_line" to avoid C  library confusion.
has been removed from the -mm tree.  Its filename was
     unifdefc-change-getline-to-get_line-to-avoid-c-library-confusion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

