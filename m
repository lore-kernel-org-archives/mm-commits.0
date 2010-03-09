From: akpm@linux-foundation.org
Subject: [merged] checkincludes-fix-perlcritic-warnings.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:11:38 -0800
Message-ID: <201003091911.o29JBcsC031753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118Ab0CITMn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:12:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@vyatta.com, amwang@redhat.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     checkincludes: fix perlcritic warnings
has been removed from the -mm tree.  Its filename was
     checkincludes-fix-perlcritic-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkincludes: fix perlcritic warnings
From: Stephen Hemminger <shemminger@vyatta.com>

Turn on strict checking.
Use local file handles.
Use three argument open.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkincludes.pl |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff -puN scripts/checkincludes.pl~checkincludes-fix-perlcritic-warnings scripts/checkincludes.pl
--- a/scripts/checkincludes.pl~checkincludes-fix-perlcritic-warnings
+++ a/scripts/checkincludes.pl
@@ -11,6 +11,8 @@
 # you do have real dups and do not have them under #ifdef's. You
 # could also just review the results.
 
+use strict;
+
 sub usage {
 	print "Usage: checkincludes.pl [-r]\n";
 	print "By default we just warn of duplicates\n";
@@ -35,23 +37,24 @@ if ($#ARGV >= 1) {
 	}
 }
 
-foreach $file (@ARGV) {
-	open(FILE, $file) or die "Cannot open $file: $!.\n";
+foreach my $file (@ARGV) {
+	open(my $f, '<', $file)
+	    or die "Cannot open $file: $!.\n";
 
 	my %includedfiles = ();
 	my @file_lines = ();
 
-	while (<FILE>) {
+	while (<$f>) {
 		if (m/^\s*#\s*include\s*[<"](\S*)[>"]/o) {
 			++$includedfiles{$1};
 		}
 		push(@file_lines, $_);
 	}
 
-	close(FILE);
+	close($f);
 
 	if (!$remove) {
-		foreach $filename (keys %includedfiles) {
+		foreach my $filename (keys %includedfiles) {
 			if ($includedfiles{$filename} > 1) {
 				print "$file: $filename is included more than once.\n";
 			}
@@ -59,27 +62,28 @@ foreach $file (@ARGV) {
 		next;
 	}
 
-	open(FILE,">$file") || die("Cannot write to $file: $!");
+	open($f, '>', $file)
+	    or die("Cannot write to $file: $!");
 
 	my $dups = 0;
 	foreach (@file_lines) {
 		if (m/^\s*#\s*include\s*[<"](\S*)[>"]/o) {
-			foreach $filename (keys %includedfiles) {
+			foreach my $filename (keys %includedfiles) {
 				if ($1 eq $filename) {
 					if ($includedfiles{$filename} > 1) {
 						$includedfiles{$filename}--;
 						$dups++;
 					} else {
-						print FILE $_;
+						print {$f} $_;
 					}
 				}
 			}
 		} else {
-			print FILE $_;
+			print {$f} $_;
 		}
 	}
 	if ($dups > 0) {
 		print "$file: removed $dups duplicate includes\n";
 	}
-	close(FILE);
+	close($f);
 }
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

