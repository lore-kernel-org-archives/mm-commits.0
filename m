From: akpm@linux-foundation.org
Subject: [merged] checkpatch-check-for-quoted-strings-broken-across-lines.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:30:34 -0700
Message-ID: <20120326193034.83752A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:55314 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab2CZTaf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:30:35 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so210331wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:30:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@joshtriplett.org, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: check for quoted strings broken across lines
has been removed from the -mm tree.  Its filename was
     checkpatch-check-for-quoted-strings-broken-across-lines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from josh@joshtriplett.org are

origin.patch
linux-next.patch

