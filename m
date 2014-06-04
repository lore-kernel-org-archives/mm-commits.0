From: akpm@linux-foundation.org
Subject: [folded-merged]
 checkpatch-improve-missing-blank-line-after-declarations-test.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:54:12 -0700
Message-ID: <538fa394.Q03QlEQq4ABvamnu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaFDWyN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:54:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [folded-merged] checkpatch-improve-missing-blank-line-after-declarations-test.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:54:12 -0700


The patch titled
     Subject: checkpatch: improve missing blank line after declarations test
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-missing-blank-line-after-declarations-test.patch

This patch was dropped because it was folded into checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve missing blank line after declarations test

A couple more modifications to the declarations tests.

o Declarations can also be bitfields so exclude things with a colon
o Make sure the current and previous lines are indented the same
  to avoid matching some macro where a struct type is passed on
  the previous line like:

		next = list_entry(buffer->entry.next,
				  struct binder_buffer, entry);
		if (buffer_start_page(next) == buffer_end_page(buffer))

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-missing-blank-line-after-declarations-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-missing-blank-line-after-declarations-test
+++ a/scripts/checkpatch.pl
@@ -2275,7 +2275,7 @@ sub process {
 # check for missing blank lines after declarations
 		if ($sline =~ /^\+\s+\S/ &&			#Not at char 1
 			# actual declarations
-		    ($prevline =~ /^\+\s+$Declare\s*$Ident\s*[=,;\[]/ ||
+		    ($prevline =~ /^\+\s+$Declare\s*$Ident\s*[=,;:\[]/ ||
 			# foo bar; where foo is some local typedef or #define
 		     $prevline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
 			# known declaration macros
@@ -2287,7 +2287,7 @@ sub process {
 			# not starting a section or a macro "\" extended line
 		      $prevline =~ /(?:\{\s*|\\)$/) &&
 			# looks like a declaration
-		    !($sline =~ /^\+\s+$Declare\s*$Ident\s*[=,;\[]/ ||
+		    !($sline =~ /^\+\s+$Declare\s*$Ident\s*[=,;:\[]/ ||
 			# foo bar; where foo is some local typedef or #define
 		      $sline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
 			# known declaration macros
@@ -2299,7 +2299,9 @@ sub process {
 			# bitfield continuation
 		      $sline =~ /^\+\s+$Ident\s*:\s*\d+\s*[,;]/ ||
 			# other possible extensions of declaration lines
-		      $sline =~ /^\+\s+\(?\s*(?:$Compare|$Assignment|$Operators)/)) {
+		      $sline =~ /^\+\s+\(?\s*(?:$Compare|$Assignment|$Operators)/) &&
+			# indentation of previous and current line are the same
+		    (($prevline =~ /\+(\s+)\S/) && $sline =~ /^\+$1\S/)) {
 			WARN("SPACING",
 			     "Missing a blank line after declarations\n" . $hereprev);
 		}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-add-me-as-the-get_maintainerpl-maintainer.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
documentation-expand-clarify-debug-documentation.patch
printk-use-symbolic-defines-for-console-loglevels.patch
lib-bugc-convert-printk-to-pr_foo.patch
checkpatch-fix-wildcard-dt-compatible-string-checking.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-make-strict-a-default-for-files-in-drivers-net-and-net.patch
checkpatch-warn-on-defines-ending-in-semicolon.patch
checkpatch-add-warning-for-kmalloc-kzalloc-with-multiply.patch
checkpatch-prefer-kstrtofoo-to-sscanfbuf-%lhuidx-bar.patch
checkpatch-warn-on-unnecessary-void-function-return-statements.patch
checkpatch-check-stable-email-address.patch
scripts-checkpatchpl-device_initcall-is-not-the-only-__initcall-substitute.patch
fs-efs-convert-printk-to-pr_foo.patch
fs-efs-add-pr_fmt-use-__func__.patch
fs-efs-convert-printkkern_debug-to-pr_debug.patch
init-mainc-dont-use-pr_debug.patch

