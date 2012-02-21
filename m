From: akpm@linux-foundation.org
Subject: + checkpatch-add-some-strict-coding-style-checks.patch added to -mm tree
Date: Tue, 21 Feb 2012 13:10:09 -0800
Message-ID: <20120221211009.A6860A01CB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:60382 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab2BUVKK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Feb 2012 16:10:10 -0500
Received: by yhgm50 with SMTP id m50so885117yhg.1
        for <mm-commits@vger.kernel.org>; Tue, 21 Feb 2012 13:10:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     Subject: checkpatch: Add some --strict coding style checks
has been added to the -mm tree.  Its filename is
     checkpatch-add-some-strict-coding-style-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: Add some --strict coding style checks

Argument alignment across multiple lines should match the open
parenthesis.

Logical continuations should be at the end of the previous line, not the
start of a new line.

These are not required by CodingStyle so make the tests active only when
using --strict.

Tested with:
int foo(void)
{
	if (foo &&
	    bar())
		baz();

	if (foo &&
	     bar())
		baz();

	foo_some_long_function(bar,
			       baz);

	foo_some_long_function(bar,
		baz);

	return 0;
}

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-some-strict-coding-style-checks scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-some-strict-coding-style-checks
+++ a/scripts/checkpatch.pl
@@ -1783,6 +1783,28 @@ sub process {
 			     "please, no space before tabs\n" . $herevet);
 		}
 
+# check for && or || at the start of a line
+		if ($rawline =~ /^\+\s*(&&|\|\|)/) {
+			CHK("LOGICAL_CONTINUATIONS",
+			    "Logical continuations should be on the previous line\n" . $hereprev);
+		}
+
+# check multi-line statement indentation matches previous line
+		if ($prevline =~ /^\+(\t*)(if \(|$Ident\().*(\&\&|\|\||,)\s*$/ && $rawline =~ /^\+([ \t]*)/) {
+			$prevline =~ /^\+(\t*)(if \(|$Ident\().*(\&\&|\|\||,)\s*$/;
+			my $oldindent = $1;
+			my $if_or_func = $2;
+			$rawline =~ /^\+([ \t]*)/;
+			my $newindent = $1;
+			my $goodindent = $oldindent .
+					 "\t" x (length($if_or_func) / 8) .
+					 " "  x (length($if_or_func) % 8);
+			if ($newindent ne "$goodindent") {
+				CHK("PARENTHESIS_ALIGNMENT",
+				    "Alignment should match open parenthesis\n" . $hereprev);
+			}
+		}
+
 # check for spaces at the beginning of a line.
 # Exceptions:
 #  1) within comments
_
Subject: Subject: checkpatch: Add some --strict coding style checks

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
thermal_sys-remove-unnecessary-line-continuations.patch
thermal_sys-remove-obfuscating-used-once-macros.patch
thermal_sys-kernel-style-cleanups.patch
thermal_sys-convert-printks-to-pr_level.patch
maintainers-fix-remoteproc-f-typo.patch
maintainers-update-mca-section.patch
maintainers-update-git-urls-for-26-deletions.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch
checkpatch-add-some-strict-coding-style-checks.patch

