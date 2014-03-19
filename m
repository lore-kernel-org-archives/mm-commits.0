From: akpm@linux-foundation.org
Subject: +
 checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch added to -mm tree
Date: Wed, 19 Mar 2014 15:01:17 -0700
Message-ID: <532a13ad.KmgeFSsM2ln2HD1+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaCSWBS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Mar 2014 18:01:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 19 Mar 2014 15:01:17 -0700


The patch titled
     Subject: checkpatch: reduce false positives for "Missing blank line after declarations" test
has been added to the -mm tree.  Its filename is
     checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch

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
Subject: checkpatch: reduce false positives for "Missing blank line after declarations" test

Reduce the false positives of this test by checking previous lines for
known macros that declare variables.

Add c90 keywords and test those too.

Comment the specific tests done a bit better.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test
+++ a/scripts/checkpatch.pl
@@ -303,6 +303,7 @@ our $Operators	= qr{
 			=>|->|<<|>>|<|>|!|~|
 			&&|\|\||,|\^|\+\+|--|&|\||$Arithmetic
 		  }x;
+our $c90_Keywords = qr{do|for|while|if|else|return|goto|continue|switch|default|case|break}x;
 
 our $NonptrType;
 our $NonptrTypeWithAttr;
@@ -395,6 +396,11 @@ foreach my $entry (@mode_permission_func
 	$mode_perms_search .= $entry->[0];
 }
 
+our $declaration_macros = qr{(?x:
+	(?:$Storage\s+)?(?:DECLARE|DEFINE)_[A-Z]+\s*\(|
+	(?:$Storage\s+)?LIST_HEAD\s*\(
+)};
+
 our $allowed_asm_includes = qr{(?x:
 	irq|
 	memory
@@ -2256,14 +2262,32 @@ sub process {
 		}
 
 # check for missing blank lines after declarations
-		if ($prevline =~ /^\+\s+$Declare\s+$Ident/ &&
-		    !($prevline =~ /(?:$Compare|$Assignment|$Operators)\s*$/ ||
-		      $prevline =~ /(?:\{\s*|\\)$/) &&		#extended lines
-		    $sline =~ /^\+\s+/ &&			#Not at char 1
+		if ($sline =~ /^\+\s+\S/ &&			#Not at char 1
+			# actual declarations
+		    ($prevline =~ /^\+\s+$Declare\s+$Ident\s*[=,;\[]/ ||
+			# foo bar; where foo is some local typedef or #define
+		     $prevline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
+			# known declaration macros
+		     $prevline =~ /^\+\s+$declaration_macros/) &&
+			# for "else if" which can look like "$Ident $Ident"
+		    !($prevline =~ /^\+\s+$c90_Keywords\b/ ||
+			# other possible extensions of declaration lines
+		      $prevline =~ /(?:$Compare|$Assignment|$Operators)\s*$/ ||
+			# not starting a section or a macro "\" extended line
+		      $prevline =~ /(?:\{\s*|\\)$/) &&
+			# looks like a declaration
 		    !($sline =~ /^\+\s+$Declare/ ||
-		      $sline =~ /^\+\s+$Ident\s+$Ident/ ||	#eg: typedef foo
+			# foo bar; where foo is some local typedef or #define
+		      $sline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
+			# known declaration macros
+		      $sline =~ /^\+\s+$declaration_macros/ ||
+			# start of struct or union or enum
 		      $sline =~ /^\+\s+(?:union|struct|enum|typedef)\b/ ||
-		      $sline =~ /^\+\s+(?:$|[\{\}\.\#\"\?\:\(])/ ||
+			# start or end of block or continuation of declaration
+		      $sline =~ /^\+\s+(?:$|[\{\}\.\#\"\?\:\(\[])/ ||
+			# bitfield continuation
+		      $sline =~ /^\+\s+$Ident\s*:\s*\d+\s*[,;]/ ||
+			# other possible extensions of declaration lines
 		      $sline =~ /^\+\s+\(?\s*(?:$Compare|$Assignment|$Operators)/)) {
 			WARN("SPACING",
 			     "Missing a blank line after declarations\n" . $hereprev);
_

Patches currently in -mm which might be from joe@perches.com are

errh-use-bool-for-is_err-and-is_err_or_null.patch
maintainers-wimax-linuxwimaxorg-is-subscribers-only.patch
lib-random32c-minor-cleanups-and-kdoc-fix.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
checkpatch-add-checks-for-constant-non-octal-permissions.patch
checkpatch-warn-on-uses-of-__constant_foo-functions.patch
checkpatch-update-octal-permissions-warning.patch
checkpatch-avoid-sscanf-test-duplicated-messages.patch
checkpatch-fix-jiffies-comparison-and-others.patch
checkpatch-add-test-for-char-arrays-that-could-be-static-const.patch
checkpatch-use-a-more-consistent-function-argument-style.patch
checkpatch-ignore-networking-block-comment-style-first-lines-in-file.patch
checkpatch-make-return-is-not-a-function-test-quieter.patch
checkpatchpl-modify-warning-message-for-printk-usage.patch
checkpatch-net-and-drivers-net-warn-on-missing-blank-line-after-variable-declaration.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-improve-octal-permissions-test-speed.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch
checkpatch-check-vendor-compatible-with-dashes.patch
checkpatch-fix-spurious-vendor-compatible-warnings.patch
checkpatch-check-compatible-strings-in-c-and-h-too.patch
checkpatch-improve-the-compatible-vendor-match.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
befs-logging-clean-up.patch
befs-logging-clean-up-fix.patch
linux-next.patch

