From: akpm@linux-foundation.org
Subject: [failures] scripts-checkpatchpl-dramatically-improve-define-parse-times.patch removed from -mm tree
Date: Mon, 08 Feb 2010 15:15:58 -0800
Message-ID: <201002082315.o18NFwlb009180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800Ab0BHXQK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2010 18:16:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     scripts/checkpatch.pl: dramatically improve #define parse times
has been removed from the -mm tree.  Its filename was
     scripts-checkpatchpl-dramatically-improve-define-parse-times.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/checkpatch.pl: dramatically improve #define parse times
From: Joe Perches <joe@perches.com>

#define macros currently take a _very_ long time to parse because the
macro is being searched for multiple statements and unnecessary searching
is being done when comments are replaced with unprintable characters.

For instance:

Without this patch:
$ time perl ./scripts/checkpatch.pl -f include/linux/mfd/wm831x/irq.h > /dev/null

real	3m43.229s
user	3m42.254s
sys	0m0.332s

With this patch:
$ time perl ./scripts/checkpatch.pl -f include/linux/mfd/wm831x/irq.h > /dev/null

real	0m1.372s
user	0m1.348s
sys	0m0.020s

A 160:1 improvement.

I don't know if this is correct, but it seems to work for me.

Maybe there's some reason why C comments aren't replaced with spaces but
get unprintable characters.

Changes:

Replace comments with spaces.
Do not call ctx_statement_block unless necessary
Add a check to see if the macro could have multiple statements
either with a \ line continuation or a ";".  This doesn't work with
comma separated statements.
Miscellaneous its -> it's typo corrections.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff -puN scripts/checkpatch.pl~scripts-checkpatchpl-dramatically-improve-define-parse-times scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~scripts-checkpatchpl-dramatically-improve-define-parse-times
+++ a/scripts/checkpatch.pl
@@ -384,18 +384,18 @@ sub sanitise_line {
 	for ($off = 1; $off < length($line); $off++) {
 		$c = substr($line, $off, 1);
 
-		# Comments we are wacking completly including the begin
+		# Comments we are whacking completely including the begin
 		# and end, all to $;.
 		if ($sanitise_quote eq '' && substr($line, $off, 2) eq '/*') {
 			$sanitise_quote = '*/';
 
-			substr($res, $off, 2, "$;$;");
+			substr($res, $off, 2, "  ");
 			$off++;
 			next;
 		}
 		if ($sanitise_quote eq '*/' && substr($line, $off, 2) eq '*/') {
 			$sanitise_quote = '';
-			substr($res, $off, 2, "$;$;");
+			substr($res, $off, 2, "  ");
 			$off++;
 			next;
 		}
@@ -428,9 +428,9 @@ sub sanitise_line {
 
 		#print "c<$c> SQ<$sanitise_quote>\n";
 		if ($off != 0 && $sanitise_quote eq '*/' && $c ne "\t") {
-			substr($res, $off, 1, $;);
+			substr($res, $off, 1, ' ');
 		} elsif ($off != 0 && $sanitise_quote eq '//' && $c ne "\t") {
-			substr($res, $off, 1, $;);
+			substr($res, $off, 1, ' ');
 		} elsif ($off != 0 && $sanitise_quote && $c ne "\t") {
 			substr($res, $off, 1, 'X');
 		} else {
@@ -518,7 +518,7 @@ sub ctx_statement_block {
 			last;
 		}
 
-		# An else is really a conditional as long as its not else if
+		# An else is really a conditional as long as it's not else if
 		if ($level == 0 && $coff_set == 0 &&
 				(!defined($p) || $p =~ /(?:\s|\}|\+)/) &&
 				$remainder =~ /^(else)(?:\s|{)/ &&
@@ -1454,7 +1454,9 @@ sub process {
 # Check for potential 'bare' types
 		my ($stat, $cond, $line_nr_next, $remain_next, $off_next,
 		    $realline_next);
-		if ($realcnt && $line =~ /.\s*\S/) {
+		my $test = $line =~ /\+\s*(\S)/;
+		my $firstchar = $1;
+		if ($realcnt && $test && $firstchar ne "\#") {
 			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
 				ctx_statement_block($linenr, $realcnt, 0);
 			$stat =~ s/\n./\n /g;
@@ -1902,7 +1904,7 @@ sub process {
 			# cpp #elif statement condition may start with a (
 			} elsif ($ctx =~ /^.\s*\#\s*elif\s*$/) {
 
-			# If this whole things ends with a type its most
+			# If this whole things ends with a type it's most
 			# likely a typedef for a function.
 			} elsif ($ctx =~ /$Type$/) {
 
@@ -2304,10 +2306,11 @@ sub process {
 		}
 
 # multi-statement macros should be enclosed in a do while loop, grab the
-# first statement and ensure its the whole macro if its not enclosed
+# first statement and ensure it's the whole macro if it's not enclosed
 # in a known good container
 		if ($realfile !~ m@/vmlinux.lds.h$@ &&
-		    $line =~ /^.\s*\#\s*define\s*$Ident(\()?/) {
+		    $line =~ /^.\s*\#\s*define\s*$Ident(\()?/ &&
+		    ($line =~ /;/ || $line =~ /\\$/)) {
 			my $ln = $linenr;
 			my $cnt = $realcnt;
 			my ($off, $dstat, $dcond, $rest);
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
arch-ia64-fix-continuation-line-formats.patch
net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch
fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-remove-uses-of-nipquad-use-%pi4.patch
drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-staging-fix-continuation-line-formats.patch
drivers-block-floppyc-convert-some-include-asm-to-include-linux.patch
drivers-block-floppyc-define-space-and-column-neatening.patch
drivers-block-floppyc-use-pr_level.patch
drivers-block-floppyc-remove-unnecessary-braces.patch
drivers-block-floppyc-remove-used-once-check_ready-macro.patch
drivers-block-floppyc-hoist-assigns-from-ifs-neatening.patch
drivers-block-floppyc-remove-last_out-macro.patch
drivers-block-floppyc-comment-neatening-and-remove-naked.patch
drivers-block-floppyc-remove-clearstruct-macro-use-memset.patch
drivers-block-floppyc-indent-a-comment.patch
drivers-block-floppyc-remove-in-out-macros-indent-switch-case.patch
drivers-block-floppyc-remove-a-few-spaces-from-function-casts.patch
drivers-block-floppyc-remove-macro-lock_fdc.patch
drivers-block-floppyc-add-debug_dcl-macro.patch
drivers-block-floppyc-remove-clearf-setf-and-testf-macros.patch
drivers-block-floppyc-remove-most-uses-of-call-and-ecall-macros.patch
drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros.patch
drivers-block-floppyc-remove-macros-call-wait-and-iwait.patch
drivers-block-floppyc-convert-int-1-0-to-bool-true-false.patch
drivers-block-floppyc-move-leading-and-to-preceding-line.patch
drivers-block-floppyc-remove-define-device_name-floppy.patch
drivers-block-floppyc-convert-int-initialising-to-bool-initialized.patch
drivers-block-floppyc-add-function-is_ready_state.patch
drivers-block-floppyc-remove-unnecessary-return-and-braces.patch
drivers-block-floppyc-remove-repeat-macro.patch
drivers-block-floppyc-unclutter-redo_fd_request-logic.patch
drivers-block-floppyc-remove-unnecessary-argument-from-reschedule_timeout.patch
drivers-block-floppyc-remove-define-floppy_sanity_check.patch
drivers-block-floppyc-dprint-neatening.patch
drivers-block-floppyc-use-__func__-where-appropriate.patch
drivers-block-floppyc-use-%pf-in-logging-messages.patch
drivers-block-floppyc-remove-some-unnecessary-casting.patch
drivers-block-floppyc-convert-raw_cmd_copyin-from-while1-to-label-goto.patch
drivers-block-floppyc-add-__func__-to-debugt.patch
drivers-block-floppyc-remove-obfuscating-code2size-macro.patch
drivers-block-floppyc-remove-misleading-used-once-fd_ioctl_allowed-macro.patch
drivers-block-floppyc-remove-unnecessary-casting-in-fd_ioctl.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses-v2.patch
scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem.patch
scripts-get_maintainerpl-change-sections-to-print-in-the-same-style-as-maintainers.patch
scripts-get_maintainerpl-add-ability-to-read-from-stdin.patch
maintainers-remove-amd-geode-f-arch-x86-kernel-geode_32c.patch
maintainers-remove-hayes-esp-serial-driver.patch
maintainers-update-performance-events-f-patterns.patch
maintainers-starmode-radio-ip-strip-moved-to-staging.patch
maintainers-wavelan-moved-to-staging.patch
maintainers-document-and-add-q-patchwork-queue-entries.patch
lib-stringc-simplify-stricmp.patch
lib-stringc-simplify-strnstr.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
checkpatch-warn-on-unnecessary-spaces-before-quoted-newlines.patch
scripts-checkpatchpl-dramatically-improve-define-parse-times.patch
drivers-hwmon-vt8231c-fix-continuation-line-formats.patch
drivers-video-via-fix-continuation-line-formats.patch

