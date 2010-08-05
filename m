From: akpm@linux-foundation.org
Subject: + scripts-mod-modpostc-fix-memory-leak.patch added to -mm tree
Date: Thu, 05 Aug 2010 15:10:53 -0700
Message-ID: <201008052210.o75MArAR007920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934513Ab0HEWLG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Aug 2010 18:11:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-alexey.fomenko@nokia.com, mmarek@suse.cz, rusty@rustcorp.com.au, tsrk@tsrk.net


The patch titled
     scripts/mod/modpost.c: fix memory leak
has been added to the -mm tree.  Its filename is
     scripts-mod-modpostc-fix-memory-leak.patch

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
Subject: scripts/mod/modpost.c: fix memory leak
From: Alexey Fomenko <ext-alexey.fomenko@nokia.com>

sec2annotation returns malloc'ed buffer directly to printf as an argument.
 Free this buffer after printing.

Signed-off-by: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
Cc: Trevor Keith <tsrk@tsrk.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/modpost.c |   54 +++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 14 deletions(-)

diff -puN scripts/mod/modpost.c~scripts-mod-modpostc-fix-memory-leak scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~scripts-mod-modpostc-fix-memory-leak
+++ a/scripts/mod/modpost.c
@@ -1258,6 +1258,8 @@ static void report_sec_mismatch(const ch
 {
 	const char *from, *from_p;
 	const char *to, *to_p;
+	char *prl_from;
+	char *prl_to;
 
 	switch (from_is_func) {
 	case 0: from = "variable"; from_p = "";   break;
@@ -1281,16 +1283,21 @@ static void report_sec_mismatch(const ch
 
 	switch (mismatch->mismatch) {
 	case TEXT_TO_ANY_INIT:
+		prl_from = sec2annotation(fromsec);
+		prl_to = sec2annotation(tosec);
 		fprintf(stderr,
 		"The function %s%s() references\n"
 		"the %s %s%s%s.\n"
 		"This is often because %s lacks a %s\n"
 		"annotation or the annotation of %s is wrong.\n",
-		sec2annotation(fromsec), fromsym,
-		to, sec2annotation(tosec), tosym, to_p,
-		fromsym, sec2annotation(tosec), tosym);
+		prl_from, fromsym,
+		to, prl_to, tosym, to_p,
+		fromsym, prl_to, tosym);
+		free(prl_from);
+		free(prl_to);
 		break;
 	case DATA_TO_ANY_INIT: {
+		prl_to = sec2annotation(tosec);
 		const char *const *s = mismatch->symbol_white_list;
 		fprintf(stderr,
 		"The variable %s references\n"
@@ -1298,20 +1305,24 @@ static void report_sec_mismatch(const ch
 		"If the reference is valid then annotate the\n"
 		"variable with __init* or __refdata (see linux/init.h) "
 		"or name the variable:\n",
-		fromsym, to, sec2annotation(tosec), tosym, to_p);
+		fromsym, to, prl_to, tosym, to_p);
 		while (*s)
 			fprintf(stderr, "%s, ", *s++);
 		fprintf(stderr, "\n");
+		free(prl_to);
 		break;
 	}
 	case TEXT_TO_ANY_EXIT:
+		prl_to = sec2annotation(tosec);
 		fprintf(stderr,
 		"The function %s() references a %s in an exit section.\n"
 		"Often the %s %s%s has valid usage outside the exit section\n"
 		"and the fix is to remove the %sannotation of %s.\n",
-		fromsym, to, to, tosym, to_p, sec2annotation(tosec), tosym);
+		fromsym, to, to, tosym, to_p, prl_to, tosym);
+		free(prl_to);
 		break;
 	case DATA_TO_ANY_EXIT: {
+		prl_to = sec2annotation(tosec);
 		const char *const *s = mismatch->symbol_white_list;
 		fprintf(stderr,
 		"The variable %s references\n"
@@ -1319,24 +1330,31 @@ static void report_sec_mismatch(const ch
 		"If the reference is valid then annotate the\n"
 		"variable with __exit* (see linux/init.h) or "
 		"name the variable:\n",
-		fromsym, to, sec2annotation(tosec), tosym, to_p);
+		fromsym, to, prl_to, tosym, to_p);
 		while (*s)
 			fprintf(stderr, "%s, ", *s++);
 		fprintf(stderr, "\n");
+		free(prl_to);
 		break;
 	}
 	case XXXINIT_TO_SOME_INIT:
 	case XXXEXIT_TO_SOME_EXIT:
+		prl_from = sec2annotation(fromsec);
+		prl_to = sec2annotation(tosec);
 		fprintf(stderr,
 		"The %s %s%s%s references\n"
 		"a %s %s%s%s.\n"
 		"If %s is only used by %s then\n"
 		"annotate %s with a matching annotation.\n",
-		from, sec2annotation(fromsec), fromsym, from_p,
-		to, sec2annotation(tosec), tosym, to_p,
+		from, prl_from, fromsym, from_p,
+		to, prl_to, tosym, to_p,
 		tosym, fromsym, tosym);
+		free(prl_from);
+		free(prl_to);
 		break;
 	case ANY_INIT_TO_ANY_EXIT:
+		prl_from = sec2annotation(fromsec);
+		prl_to = sec2annotation(tosec);
 		fprintf(stderr,
 		"The %s %s%s%s references\n"
 		"a %s %s%s%s.\n"
@@ -1345,11 +1363,15 @@ static void report_sec_mismatch(const ch
 		"uses functionality in the exit path.\n"
 		"The fix is often to remove the %sannotation of\n"
 		"%s%s so it may be used outside an exit section.\n",
-		from, sec2annotation(fromsec), fromsym, from_p,
-		to, sec2annotation(tosec), tosym, to_p,
+		from, prl_from, fromsym, from_p,
+		to, prl_to, tosym, to_p,
 		sec2annotation(tosec), tosym, to_p);
+		free(prl_from);
+		free(prl_to);
 		break;
 	case ANY_EXIT_TO_ANY_INIT:
+		prl_from = sec2annotation(fromsec);
+		prl_to = sec2annotation(tosec);
 		fprintf(stderr,
 		"The %s %s%s%s references\n"
 		"a %s %s%s%s.\n"
@@ -1358,16 +1380,20 @@ static void report_sec_mismatch(const ch
 		"uses functionality in the init path.\n"
 		"The fix is often to remove the %sannotation of\n"
 		"%s%s so it may be used outside an init section.\n",
-		from, sec2annotation(fromsec), fromsym, from_p,
-		to, sec2annotation(tosec), tosym, to_p,
-		sec2annotation(tosec), tosym, to_p);
+		from, prl_from, fromsym, from_p,
+		to, prl_to, tosym, to_p,
+		prl_to, tosym, to_p);
+		free(prl_from);
+		free(prl_to);
 		break;
 	case EXPORT_TO_INIT_EXIT:
+		prl_to = sec2annotation(tosec);
 		fprintf(stderr,
 		"The symbol %s is exported and annotated %s\n"
 		"Fix this by removing the %sannotation of %s "
 		"or drop the export.\n",
-		tosym, sec2annotation(tosec), sec2annotation(tosec), tosym);
+		tosym, prl_to, prl_to, tosym);
+		free(prl_to);
 		break;
 	}
 	fprintf(stderr, "\n");
_

Patches currently in -mm which might be from ext-alexey.fomenko@nokia.com are

scripts-mod-modpostc-fix-memory-leak.patch

