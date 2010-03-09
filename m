From: akpm@linux-foundation.org
Subject: [merged] export_report-fix-perl-warnings.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:11:50 -0800
Message-ID: <201003091911.o29JBoGh031768@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945Ab0CITW1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@vyatta.com, amwang@redhat.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     export_report: fix perl warnings
has been removed from the -mm tree.  Its filename was
     export_report-fix-perl-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: export_report: fix perl warnings
From: Stephen Hemminger <shemminger@vyatta.com>

Use local file handles, use three argument open.
Don't modify arguments in perl grep (use sed instead)

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Acked-by: WANG Cong <amwang@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/export_report.pl |   37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff -puN scripts/export_report.pl~export_report-fix-perl-warnings scripts/export_report.pl
--- a/scripts/export_report.pl~export_report-fix-perl-warnings
+++ a/scripts/export_report.pl
@@ -49,10 +49,10 @@ sub usage {
 }
 
 sub collectcfiles {
-        my @file = `cat .tmp_versions/*.mod | grep '.*\.ko\$'`;
-        @file = grep {s/\.ko/.mod.c/} @file;
-	chomp @file;
-        return @file;
+    my @file
+	= `cat .tmp_versions/*.mod | grep '.*\.ko\$' | sed s/\.ko$/.mod.c/`;
+    chomp @file;
+    return @file;
 }
 
 my (%SYMBOL, %MODULE, %opt, @allcfiles);
@@ -71,37 +71,40 @@ if (not defined $opt{'k'}) {
 	$opt{'k'} = "Module.symvers";
 }
 
-unless (open(MODULE_SYMVERS, $opt{'k'})) {
-	die "Sorry, cannot open $opt{'k'}: $!\n";
-}
+open (my $module_symvers, '<', $opt{'k'})
+    or die "Sorry, cannot open $opt{'k'}: $!\n";
 
 if (defined $opt{'o'}) {
-	unless (open(OUTPUT_HANDLE, ">$opt{'o'}")) {
-		die "Sorry, cannot open $opt{'o'} $!\n";
-	}
-	select OUTPUT_HANDLE;
+    open (my $out, '>', $opt{'o'})
+	or die "Sorry, cannot open $opt{'o'} $!\n";
+
+    select $out;
 }
+
 #
 # collect all the symbols and their attributes from the
 # Module.symvers file
 #
-while ( <MODULE_SYMVERS> ) {
+while ( <$module_symvers> ) {
 	chomp;
 	my (undef, $symbol, $module, $gpl) = split;
 	$SYMBOL { $symbol } =  [ $module , "0" , $symbol, $gpl];
 }
-close(MODULE_SYMVERS);
+close($module_symvers);
 
 #
 # collect the usage count of each symbol.
 #
 foreach my $thismod (@allcfiles) {
-	unless (open(MODULE_MODULE, $thismod)) {
-		print "Sorry, cannot open $thismod: $!\n";
+	my $module;
+
+	unless (open ($module, '<', $thismod)) {
+		warn "Sorry, cannot open $thismod: $!\n";
 		next;
 	}
+
 	my $state=0;
-	while ( <MODULE_MODULE> ) {
+	while ( <$module> ) {
 		chomp;
 		if ($state == 0) {
 			$state = 1 if ($_ =~ /static const struct modversion_info/);
@@ -124,7 +127,7 @@ foreach my $thismod (@allcfiles) {
 	if ($state != 2) {
 		print "WARNING:$thismod is not built with CONFIG_MODVERSION enabled\n";
 	}
-	close(MODULE_MODULE);
+	close($module);
 }
 
 print "\tThis file reports the exported symbols usage patterns by in-tree\n",
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

