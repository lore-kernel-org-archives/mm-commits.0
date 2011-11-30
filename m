From: akpm@linux-foundation.org
Subject: + checkpatch-check-for-common-memset-parameter-issues-against-statments.patch added to -mm tree
Date: Wed, 30 Nov 2011 14:19:44 -0800
Message-ID: <201111302219.pAUMJiUa019716@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:54481 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab1K3WTs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2011 17:19:48 -0500
Received: by eeuu44 with SMTP id u44so18732eeu.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2011 14:19:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, joe@perches.com


The patch titled
     Subject: checkpatch: check for common memset parameter issues against statments
has been added to the -mm tree.  Its filename is
     checkpatch-check-for-common-memset-parameter-issues-against-statments.patch

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
Subject: checkpatch: check for common memset parameter issues against statments

Move the memset checks over to work against the statement.  Also add
checks for 0 and 1 used as lengths.  Generally these indicate badly
ordered parameters.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-check-for-common-memset-parameter-issues-against-statments scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-for-common-memset-parameter-issues-against-statments
+++ a/scripts/checkpatch.pl
@@ -3120,6 +3120,28 @@ sub process {
 			     "Avoid line continuations in quoted strings\n" . $herecurr);
 		}
 
+# Check for misused memsets
+		if (defined $stat && $stat =~ /\bmemset\s*\((.*)\)/s) {
+			my $args = $1;
+
+			# Flatten any parentheses and braces
+			while ($args =~ s/\([^\(\)]*\)/10/s ||
+			       $args =~ s/\{[^\{\}]*\}/10/s ||
+			       $args =~ s/\[[^\[\]]*\]/10/s)
+			{
+			}
+			# Extract the simplified arguments.
+			my ($ms_addr, $ms_val, $ms_size) =
+						split(/\s*,\s*/, $args);
+			if ($ms_size =~ /^(0x|)0$/i) {
+				ERROR("MEMSET",
+				      "memset size is 3rd argument, not the second.\n" . $herecurr);
+			} elsif ($ms_size =~ /^(0x|)1$/i) {
+				WARN("MEMSET",
+				     "single byte memset is suspicious. Swapped 2nd/3rd argument?\n" . $herecurr);
+			}
+		}
+
 # check for new externs in .c files.
 		if ($realfile =~ /\.c$/ && defined $stat &&
 		    $stat =~ /^.\s*(?:extern\s+)?$Type\s+($Ident)(\s*)\(/s)
@@ -3291,12 +3313,6 @@ sub process {
 			WARN("EXPORTED_WORLD_WRITABLE",
 			     "Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 		}
-
-		# Check for memset with swapped arguments
-		if ($line =~ /memset.*\,(\ |)(0x|)0(\ |0|)\);/) {
-			ERROR("MEMSET",
-			      "memset size is 3rd argument, not the second.\n" . $herecurr);
-		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
_
Subject: Subject: checkpatch: check for common memset parameter issues against statments

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context.patch
checkpatch-check-for-common-memset-parameter-issues-against-statments.patch
checkpatch-improve-memset-and-min-max-with-cast-checking.patch
checkpatch-is-not-a-valid-modifier.patch
checkpatch-optimise-statement-scanner-when-mid-statement.patch
checkpatch-only-apply-kconfig-help-checks-for-options-which-prompt.patch
checkpatch-fix-export_symbol-handling-following-a-function.patch
checkpatch-complex-macro-should-allow-the-empty-do-while-loop.patch
checkpatch-fix-return-is-not-a-function-square-bracket-handling.patch
checkpatch-fix-complex-macros-handling-of-square-brackets.patch
checkpatch-ensure-cast-type-is-unique-in-the-context-parser.patch
checkpatch-typeof-may-have-more-complex-arguments.patch

