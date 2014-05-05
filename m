From: akpm@linux-foundation.org
Subject: +
 checkpatch-improve-missing-blank-line-after-declarations-test.patch added
 to -mm tree
Date: Mon, 05 May 2014 15:08:22 -0700
Message-ID: <53680bd6.eHfrMRWGrykRsP7t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808AbaEEWIW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 18:08:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-improve-missing-blank-line-after-declarations-test.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 15:08:22 -0700


The patch titled
     Subject: checkpatch: improve missing blank line after declarations test
has been added to the -mm tree.  Its filename is
     checkpatch-improve-missing-blank-line-after-declarations-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-missing-blank-line-after-declarations-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-missing-blank-line-after-declarations-test.patch

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

mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-utilc-add-kstrimdup.patch
checkpatch-fix-wildcard-dt-compatible-string-checking.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch
checkpatch-improve-missing-blank-line-after-declarations-test.patch
init-mainc-dont-use-pr_debug.patch
fs-isofs-logging-clean-up.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
arm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ia64-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
tile-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
cdrom-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
random-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
parport-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
scsi-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
coda-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
fscache-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
lockd-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
nfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
inotify-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ntfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
key-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ipc-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
sysctl-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
mm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

