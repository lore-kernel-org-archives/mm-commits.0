From: akpm@linux-foundation.org
Subject: +
 checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch added to -mm tree
Date: Wed, 26 Mar 2014 13:44:50 -0700
Message-ID: <53333c42.joYBvpiL4w82Rqy+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbaCZUov (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Mar 2014 16:44:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 26 Mar 2014 13:44:50 -0700


The patch titled
     Subject: checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix
has been added to the -mm tree.  Its filename is
     checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch

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
Subject: checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix

"struct foo *bar" does not match the regex "$Declare\s+$Ident"
$Declare matches "struct foo *" but there is no required space
between the pointer "*" and the $Ident.

Also it ends in a pointer, the $Declare variable also contains all
trailing spaces after the declaration so there is no space between
$Declare and $Ident.

ie:	"struct foo * bar" does not match "$Declare\s+$Ident"

So, change the \s+ to \s* to have this regex match any of
"struct foo bar", "struct foo *bar", and "struct foo * bar"
	
Signed-off-by: Joe Perches <joe@perches.com>	
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix
+++ a/scripts/checkpatch.pl
@@ -2266,7 +2266,7 @@ sub process {
 # check for missing blank lines after declarations
 		if ($sline =~ /^\+\s+\S/ &&			#Not at char 1
 			# actual declarations
-		    ($prevline =~ /^\+\s+$Declare\s+$Ident\s*[=,;\[]/ ||
+		    ($prevline =~ /^\+\s+$Declare\s*$Ident\s*[=,;\[]/ ||
 			# foo bar; where foo is some local typedef or #define
 		     $prevline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
 			# known declaration macros
@@ -2278,7 +2278,7 @@ sub process {
 			# not starting a section or a macro "\" extended line
 		      $prevline =~ /(?:\{\s*|\\)$/) &&
 			# looks like a declaration
-		    !($sline =~ /^\+\s+$Declare/ ||
+		    !($sline =~ /^\+\s+$Declare\s*$Ident\s*[=,;\[]/ ||
 			# foo bar; where foo is some local typedef or #define
 		      $sline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
 			# known declaration macros
_

Patches currently in -mm which might be from joe@perches.com are

ntfs-logging-clean-up.patch
errh-use-bool-for-is_err-and-is_err_or_null.patch
maintainers-wimax-linuxwimaxorg-is-subscribers-only.patch
maintainers-addition-of-dialog-semiconductor-files.patch
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
checkpatch-improve-octal-permissions-test-speed.patch
checkpatch-check-vendor-compatible-with-dashes.patch
checkpatch-fix-spurious-vendor-compatible-warnings.patch
checkpatch-check-compatible-strings-in-c-and-h-too.patch
checkpatch-improve-the-compatible-vendor-match.patch
checkpatch-net-and-drivers-net-warn-on-missing-blank-line-after-variable-declaration.patch
scripts-checkpatchpl-__gfp_nofail-isnt-going-away.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch
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

