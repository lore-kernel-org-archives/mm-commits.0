From: akpm@linux-foundation.org
Subject: + scripts-checkpatchpl-add-warnings-for-static-char-that-could-be-static-const-char.patch added to -mm tree
Date: Fri, 10 Sep 2010 17:12:16 -0700
Message-ID: <201009110012.o8B0CGJl011112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755038Ab0IKAMX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Sep 2010 20:12:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com, vapier.adi@gmail.com


The patch titled
     scripts/checkpatch.pl: add warnings for static char that could be static const char
has been added to the -mm tree.  Its filename is
     scripts-checkpatchpl-add-warnings-for-static-char-that-could-be-static-const-char.patch

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
Subject: scripts/checkpatch.pl: add warnings for static char that could be static const char
From: Joe Perches <joe@perches.com>

Add warnings for possible missing const uses of
	static char foo[] = "bar"
    that could be
	static const char foo[] = "bar"
and
	static const char *foo[] = {"bar", "baz"}
    that could be
	static const char * const foo[] = {"bar", "baz"}

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN scripts/checkpatch.pl~scripts-checkpatchpl-add-warnings-for-static-char-that-could-be-static-const-char scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~scripts-checkpatchpl-add-warnings-for-static-char-that-could-be-static-const-char
+++ a/scripts/checkpatch.pl
@@ -1869,6 +1869,18 @@ sub process {
 				$herecurr);
 		}
 
+# check for static const char * arrays.
+		if ($line =~ /\bstatic\s+const\s+char\s*\*\s*(\w+)\s*\[\s*\]\s*=\s*/) {
+			WARN("static const char * array should probably be static const char * const\n" .
+				$herecurr);
+               }
+
+# check for static char foo[] = "bar" declarations.
+		if ($line =~ /\bstatic\s+char\s+(\w+)\s*\[\s*\]\s*=\s*"/) {
+			WARN("static char array declaration should probably be static const char\n" .
+				$herecurr);
+               }
+
 # check for new typedefs, only function parameters and sparse annotations
 # make sense.
 		if ($line =~ /\btypedef\s/ &&
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
kernelh-add-minmax3-macros.patch
kernelh-add-minmax3-macros-fix.patch
replace-nested-max-min-macros-with-maxmin3-macro.patch
checkpatch-add-check-for-space-after-struct-union-and-enum.patch
checkpatch-add-additional-attribute-defines.patch
scripts-checkpatchpl-add-warnings-for-static-char-that-could-be-static-const-char.patch

