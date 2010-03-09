From: akpm@linux-foundation.org
Subject: [merged] checkversion-perl-cleanup.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:11:41 -0800
Message-ID: <201003091911.o29JBfje031756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755633Ab0CITWd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@vyatta.com, amwang@redhat.com, mmarek@suse.cz, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     checkversion: perl cleanup
has been removed from the -mm tree.  Its filename was
     checkversion-perl-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkversion: perl cleanup
From: Stephen Hemminger <shemminger@vyatta.com>

Turn on strict checking.
Use three arguement open
Standard practice in perl is to use undef not zero for false

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkversion.pl |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN scripts/checkversion.pl~checkversion-perl-cleanup scripts/checkversion.pl
--- a/scripts/checkversion.pl~checkversion-perl-cleanup
+++ a/scripts/checkversion.pl
@@ -5,23 +5,22 @@
 # including <linux/version.h> that don't need it.
 # Copyright (C) 2003, Randy Dunlap <rdunlap@xenotime.net>
 
+use strict;
+
 $| = 1;
 
-my $debugging = 0;
+my $debugging;
 
-foreach $file (@ARGV)
-{
+foreach my $file (@ARGV) {
     # Open this file.
-    open(FILE, $file) || die "Can't open $file: $!\n";
+    open( my $f, '<', $file )
+      or die "Can't open $file: $!\n";
 
     # Initialize variables.
-    my $fInComment   = 0;
-    my $fInString    = 0;
-    my $fUseVersion   = 0;
+    my ($fInComment, $fInString, $fUseVersion);
     my $iLinuxVersion = 0;
 
-    LINE: while ( <FILE> )
-    {
+    while (<$f>) {
 	# Strip comments.
 	$fInComment && (s+^.*?\*/+ +o ? ($fInComment = 0) : next);
 	m+/\*+o && (s+/\*.*?\*/+ +go, (s+/\*.*$+ +o && ($fInComment = 1)));
@@ -43,8 +42,8 @@ foreach $file (@ARGV)
 	# Look for uses: LINUX_VERSION_CODE, KERNEL_VERSION, UTS_RELEASE
 	if (($_ =~ /LINUX_VERSION_CODE/) || ($_ =~ /\WKERNEL_VERSION/)) {
 	    $fUseVersion = 1;
-	    last LINE if $iLinuxVersion;
-	}
+            last if $iLinuxVersion;
+        }
     }
 
     # Report used version IDs without include?
@@ -67,5 +66,5 @@ foreach $file (@ARGV)
         }
     }
 
-    close(FILE);
+    close($f);
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

