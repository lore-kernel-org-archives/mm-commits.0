From: akpm@linux-foundation.org
Subject: [merged] scripts-get_maintainerpl-add-ability-to-read-from-stdin.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:06:56 -0800
Message-ID: <201003091906.o29J6uPH031289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755749Ab0CITWG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, petkovbb@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     scripts/get_maintainer.pl: add ability to read from STDIN
has been removed from the -mm tree.  Its filename was
     scripts-get_maintainerpl-add-ability-to-read-from-stdin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: add ability to read from STDIN
From: Joe Perches <joe@perches.com>

Doesn't need or accept '-' as a trailing option to read stdin.  Doesn't
print usage() after bad options.  Adds --usage as command line equivalent
of --help

Suggested-by: Borislav Petkov <petkovbb@googlemail.com>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-add-ability-to-read-from-stdin scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-add-ability-to-read-from-stdin
+++ a/scripts/get_maintainer.pl
@@ -126,7 +126,7 @@ if (!GetOptions(
 		'fe|file-emails!' => \$file_emails,
 		'f|file' => \$from_filename,
 		'v|version' => \$version,
-		'h|help' => \$help,
+		'h|help|usage' => \$help,
 		)) {
     die "$P: invalid argument - use --help if necessary\n";
 }
@@ -141,9 +141,9 @@ if ($version != 0) {
     exit 0;
 }
 
-if ($#ARGV < 0) {
-    usage();
-    die "$P: argument missing: patchfile or -f file please\n";
+if (-t STDIN && !@ARGV) {
+    # We're talking to a terminal, but have no command line arguments.
+    die "$P: missing patchfile or -f file - use --help if necessary\n";
 }
 
 if ($output_separator ne ", ") {
@@ -165,7 +165,6 @@ if ($sections) {
 } else {
     my $selections = $email + $scm + $status + $subsystem + $web;
     if ($selections == 0) {
-	usage();
 	die "$P:  Missing required option: email, scm, status, subsystem or web\n";
     }
 }
@@ -173,7 +172,6 @@ if ($sections) {
 if ($email &&
     ($email_maintainer + $email_list + $email_subscriber_list +
      $email_git + $email_git_penguin_chiefs + $email_git_blame) == 0) {
-    usage();
     die "$P: Please select at least 1 email option\n";
 }
 
@@ -248,12 +246,18 @@ my @range = ();
 my @keyword_tvi = ();
 my @file_emails = ();
 
+if (!@ARGV) {
+    push(@ARGV, "&STDIN");
+}
+
 foreach my $file (@ARGV) {
-    ##if $file is a directory and it lacks a trailing slash, add one
-    if ((-d $file)) {
-	$file =~ s@([^/])$@$1/@;
-    } elsif (!(-f $file)) {
-	die "$P: file '${file}' not found\n";
+    if ($file ne "&STDIN") {
+	##if $file is a directory and it lacks a trailing slash, add one
+	if ((-d $file)) {
+	    $file =~ s@([^/])$@$1/@;
+	} elsif (!(-f $file)) {
+	    die "$P: file '${file}' not found\n";
+	}
     }
     if ($from_filename) {
 	push(@files, $file);
_

Patches currently in -mm which might be from joe@perches.com are

fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
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
drivers-video-via-fix-continuation-line-formats.patch

