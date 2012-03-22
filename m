From: akpm@linux-foundation.org
Subject: + checkpatch-check-for-quoted-strings-broken-across-lines.patch added to -mm tree
Date: Thu, 22 Mar 2012 14:07:20 -0700
Message-ID: <20120322210721.0991BA001B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:42691 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756892Ab2CVVH2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2012 17:07:28 -0400
Received: by laai8 with SMTP id i8so135501laa.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 14:07:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josh@joshtriplett.org, apw@canonical.com, joe@perches.com


The patch titled
     Subject: checkpatch: check for quoted strings broken across lines
has been added to the -mm tree.  Its filename is
     checkpatch-check-for-quoted-strings-broken-across-lines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: checkpatch: check for quoted strings broken across lines

checkpatch already makes an exception to the 80-column rule for quoted
strings, and Documentation/CodingStyle recommends not splitting quoted
strings across lines, because it breaks the ability to grep for the
string.  Rather than just permitting this, actively warn about quoted
strings split across lines.

Test case:

void context(void)
{
	struct { unsigned magic; const char *strdata; } foo[] = {
		{ 42, "these strings"
		      "do not produce warnings" },
		{ 256, "though perhaps"
		       "they should" },
	};
	pr_err("this string"
	       " should produce a warning\n");
	pr_err("this multi-line string\n"
	       "should not produce a warning\n");
	asm ("this asm\n\t"
	     "should not produce a warning");
}

Results of checkpatch on that test case:

WARNING: quoted string split across lines
+	       " should produce a warning\n");

total: 0 errors, 1 warnings, 15 lines checked

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-check-for-quoted-strings-broken-across-lines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-for-quoted-strings-broken-across-lines
+++ a/scripts/checkpatch.pl
@@ -1772,6 +1772,21 @@ sub process {
 			     "line over 80 characters\n" . $herecurr);
 		}
 
+# Check for user-visible strings broken across lines, which breaks the ability
+# to grep for the string.  Limited to strings used as parameters (those
+# following an open parenthesis), which almost completely eliminates false
+# positives, as well as warning only once per parameter rather than once per
+# line of the string.  Make an exception when the previous string ends in a
+# newline (multiple lines in one string constant) or \n\t (common in inline
+# assembly to indent the instruction on the following line).
+		if ($line =~ /^\+\s*"/ &&
+		    $prevline =~ /"\s*$/ &&
+		    $prevline =~ /\(/ &&
+		    $prevrawline !~ /\\n(?:\\t)*"\s*$/) {
+			WARN("SPLIT_STRING",
+			     "quoted string split across lines\n" . $hereprev);
+		}
+
 # check for spaces before a quoted newline
 		if ($rawline =~ /^.*\".*\s\\n/) {
 			WARN("QUOTED_WHITESPACE_BEFORE_NEWLINE",
_
Subject: Subject: checkpatch: check for quoted strings broken across lines

Patches currently in -mm which might be from josh@joshtriplett.org are

origin.patch
linux-next.patch
checkpatch-check-for-quoted-strings-broken-across-lines.patch

