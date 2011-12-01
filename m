From: akpm@linux-foundation.org
Subject: + checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line.patch added to -mm tree
Date: Thu, 01 Dec 2011 12:57:06 -0800
Message-ID: <201112012057.pB1Kv60A011505@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:43073 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab1LAU5I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2011 15:57:08 -0500
Received: by vcbfl11 with SMTP id fl11so304152vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Dec 2011 12:57:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, joe@perches.com


The patch titled
     Subject: checkpatch: catch all occurances of type and cast spacing errors per line
has been added to the -mm tree.  Its filename is
     checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line.patch

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
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: catch all occurances of type and cast spacing errors per line

Fix up type and cast spacing checks such that all occurances on a line are
examined and reported.  For example the line below has a valid cast and a
bad type, but currently we check the cast first which is good and stop:

    u16* bar = (u16 *)baz;

We will also only report one of the errors in this example:

    u16* bar = (u16*)bad;

Move to iterating across all casts and all types, reporting any failure.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line
+++ a/scripts/checkpatch.pl
@@ -2209,8 +2209,9 @@ sub process {
 
 # * goes on variable not on type
 		# (char*[ const])
-		if ($line =~ m{\($NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)\)}) {
-			my ($from, $to) = ($1, $1);
+		while ($line =~ m{(\($NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)\))}g) {
+			#print "AA<$1>\n";
+			my ($from, $to) = ($2, $2);
 
 			# Should start with a space.
 			$to =~ s/^(\S)/ $1/;
@@ -2225,8 +2226,10 @@ sub process {
 				ERROR("POINTER_LOCATION",
 				      "\"(foo$from)\" should be \"(foo$to)\"\n" .  $herecurr);
 			}
-		} elsif ($line =~ m{\b$NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)($Ident)}) {
-			my ($from, $to, $ident) = ($1, $1, $2);
+		} 
+		while ($line =~ m{(\b$NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)($Ident))}g) {
+			#print "BB<$1>\n";
+			my ($from, $to, $ident) = ($2, $2, $3);
 
 			# Should start with a space.
 			$to =~ s/^(\S)/ $1/;
_
Subject: Subject: checkpatch: catch all occurances of type and cast spacing errors per line

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context.patch
checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context-fix.patch
checkpatch-check-for-common-memset-parameter-issues-against-statments.patch
checkpatch-improve-memset-and-min-max-with-cast-checking.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-is-not-a-valid-modifier.patch
checkpatch-optimise-statement-scanner-when-mid-statement.patch
checkpatch-only-apply-kconfig-help-checks-for-options-which-prompt.patch
checkpatch-fix-export_symbol-handling-following-a-function.patch
checkpatch-complex-macro-should-allow-the-empty-do-while-loop.patch
checkpatch-fix-return-is-not-a-function-square-bracket-handling.patch
checkpatch-fix-complex-macros-handling-of-square-brackets.patch
checkpatch-ensure-cast-type-is-unique-in-the-context-parser.patch
checkpatch-typeof-may-have-more-complex-arguments.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line.patch

