From: akpm@linux-foundation.org
Subject: [merged] get_maintainer-fix-perlcritic-warnings.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:06:59 -0800
Message-ID: <201003091906.o29J6xBM031292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755942Ab0CITWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@vyatta.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     get_maintainer: fix perlcritic warnings
has been removed from the -mm tree.  Its filename was
     get_maintainer-fix-perlcritic-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: get_maintainer: fix perlcritic warnings
From: Stephen Hemminger <shemminger@vyatta.com>

perlcritic is a standard checker for Perl Best Practices.  This patch
fixes most of the warnings in the get_maintainer script.  If kernel
programmers are going to have checkpatch they should write clean scripts
as well...

Bareword file handle opened at line 176, column 1.  See pages 202,204 of PBP.  (Severity: 5)
Two-argument "open" used at line 176, column 1.  See page 207 of PBP.  (Severity: 5)
Bareword file handle opened at line 207, column 5.  See pages 202,204 of PBP.  (Severity: 5)
Two-argument "open" used at line 207, column 5.  See page 207 of PBP.  (Severity: 5)
Bareword file handle opened at line 246, column 6.  See pages 202,204 of PBP.  (Severity: 5)
Two-argument "open" used at line 246, column 6.  See page 207 of PBP.  (Severity: 5)
Bareword file handle opened at line 258, column 2.  See pages 202,204 of PBP.  (Severity: 5)
Two-argument "open" used at line 258, column 2.  See page 207 of PBP.  (Severity: 5)
Expression form of "eval" at line 983, column 17.  See page 161 of PBP.  (Severity: 5)
Expression form of "eval" at line 985, column 17.  See page 161 of PBP.  (Severity: 5)
Subroutine prototypes used at line 1186, column 1.  See page 194 of PBP.  (Severity: 5)
Subroutine prototypes used at line 1206, column 1.  See page 194 of PBP.  (Severity: 5)

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff -puN scripts/get_maintainer.pl~get_maintainer-fix-perlcritic-warnings scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-fix-perlcritic-warnings
+++ a/scripts/get_maintainer.pl
@@ -185,8 +185,9 @@ if (!top_of_kernel_tree($lk_path)) {
 my @typevalue = ();
 my %keyword_hash;
 
-open(MAINT, "<${lk_path}MAINTAINERS") || die "$P: Can't open MAINTAINERS\n";
-while (<MAINT>) {
+open (my $maint, '<', "${lk_path}MAINTAINERS")
+    or die "$P: Can't open MAINTAINERS: $!\n";
+while (<$maint>) {
     my $line = $_;
 
     if ($line =~ m/^(\C):\s*(.*)/) {
@@ -211,13 +212,14 @@ while (<MAINT>) {
 	push(@typevalue, $line);
     }
 }
-close(MAINT);
+close($maint);
 
 my %mailmap;
 
 if ($email_remove_duplicates) {
-    open(MAILMAP, "<${lk_path}.mailmap") || warn "$P: Can't open .mailmap\n";
-    while (<MAILMAP>) {
+    open(my $mailmap, '<', "${lk_path}.mailmap")
+	or warn "$P: Can't open .mailmap: $!\n";
+    while (<$mailmap>) {
 	my $line = $_;
 
 	next if ($line =~ m/^\s*#/);
@@ -236,7 +238,7 @@ if ($email_remove_duplicates) {
 	    $mailmap{$name} = \@arr;
 	}
     }
-    close(MAILMAP);
+    close($mailmap);
 }
 
 ## use the filenames on the command line or find the filenames in the patchfiles
@@ -262,9 +264,10 @@ foreach my $file (@ARGV) {
     if ($from_filename) {
 	push(@files, $file);
 	if (-f $file && ($keywords || $file_emails)) {
-	    open(FILE, "<$file") or die "$P: Can't open ${file}\n";
-	    my $text = do { local($/) ; <FILE> };
-	    close(FILE);
+	    open(my $f, '<', $file)
+		or die "$P: Can't open $file: $!\n";
+	    my $text = do { local($/) ; <$f> };
+	    close($f);
 	    if ($keywords) {
 		foreach my $line (keys %keyword_hash) {
 		    if ($text =~ m/$keyword_hash{$line}/x) {
@@ -280,8 +283,10 @@ foreach my $file (@ARGV) {
     } else {
 	my $file_cnt = @files;
 	my $lastfile;
-	open(PATCH, "<$file") or die "$P: Can't open ${file}\n";
-	while (<PATCH>) {
+
+	open(my $patch, '<', $file)
+	    or die "$P: Can't open $file: $!\n";
+	while (<$patch>) {
 	    my $patch_line = $_;
 	    if (m/^\+\+\+\s+(\S+)/) {
 		my $filename = $1;
@@ -301,7 +306,8 @@ foreach my $file (@ARGV) {
 		}
 	    }
 	}
-	close(PATCH);
+	close($patch);
+
 	if ($file_cnt == @files) {
 	    warn "$P: file '${file}' doesn't appear to be a patch.  "
 		. "Add -f to options?\n";
@@ -1286,7 +1292,7 @@ sub rfc822_strip_comments {
 
 #   valid: returns true if the parameter is an RFC822 valid address
 #
-sub rfc822_valid ($) {
+sub rfc822_valid {
     my $s = rfc822_strip_comments(shift);
 
     if (!$rfc822re) {
@@ -1306,7 +1312,7 @@ sub rfc822_valid ($) {
 #              from success with no addresses found, because an empty string is
 #              a valid list.
 
-sub rfc822_validlist ($) {
+sub rfc822_validlist {
     my $s = rfc822_strip_comments(shift);
 
     if (!$rfc822re) {
_

Patches currently in -mm which might be from shemminger@vyatta.com are

linux-next.patch
markup_oops-fix-perlcritic-warnings.patch
headerdep-perlcritic-warning.patch
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

