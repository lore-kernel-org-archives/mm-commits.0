From: akpm@linux-foundation.org
Subject: [merged] namespace-perlcritic-warnings.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:11:44 -0800
Message-ID: <201003091911.o29JBi2q031760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756009Ab0CITW2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@vyatta.com, amwang@redhat.com, mmarek@suse.cz, teawater@gmail.com, mm-commits@vger.kernel.org


The patch titled
     namespace: perlcritic warnings
has been removed from the -mm tree.  Its filename was
     namespace-perlcritic-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: namespace: perlcritic warnings
From: Stephen Hemminger <shemminger@vyatta.com>

Use local file handle not global.
Make loop and other variables local in scope.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Hui Zhu <teawater@gmail.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/namespace.pl |   65 ++++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff -puN scripts/namespace.pl~namespace-perlcritic-warnings scripts/namespace.pl
--- a/scripts/namespace.pl~namespace-perlcritic-warnings
+++ a/scripts/namespace.pl
@@ -175,12 +175,11 @@ sub do_nm
 	}
 	if (! -e "$source.c" && ! -e "$source.S") {
 		# No obvious source, exclude the object if it is conglomerate
-		if (! open(OBJDUMPDATA, "$objdump $basename|")) {
-			printf STDERR "$objdump $fullname failed $!\n";
-			return;
-		}
+	        open(my $objdumpdata, "$objdump $basename|")
+		    or die "$objdump $fullname failed $!\n";
+
 		my $comment;
-		while (<OBJDUMPDATA>) {
+		while (<$objdumpdata>) {
 			chomp();
 			if (/^In archive/) {
 				# Archives are always conglomerate
@@ -190,18 +189,18 @@ sub do_nm
 			next if (! /^[ 0-9a-f]{5,} /);
 			$comment .= substr($_, 43);
 		}
-		close(OBJDUMPDATA);
+		close($objdumpdata);
+
 		if (!defined($comment) || $comment !~ /GCC\:.*GCC\:/m) {
 			printf STDERR "No source file found for $fullname\n";
 		}
 		return;
 	}
-	if (! open(NMDATA, "$nm $basename|")) {
-		printf STDERR "$nm $fullname failed $!\n";
-		return;
-	}
+	open (my $nmdata, "$nm $basename|")
+	    or die "$nm $fullname failed $!\n";
+
 	my @nmdata;
-	while (<NMDATA>) {
+	while (<$nmdata>) {
 		chop;
 		($type, $name) = (split(/ +/, $_, 3))[1..2];
 		# Expected types
@@ -268,7 +267,8 @@ sub do_nm
 			}
 		}
 	}
-	close(NMDATA);
+	close($nmdata);
+
 	if ($#nmdata < 0) {
 		if (
 			$fullname ne "lib/brlock.o"
@@ -316,8 +316,7 @@ sub drop_def
 
 sub list_multiply_defined
 {
-	my ($name, $module);
-	foreach $name (keys(%def)) {
+	foreach my $name (keys(%def)) {
 		if ($#{$def{$name}} > 0) {
 			# Special case for cond_syscall
 			if ($#{$def{$name}} == 1 && $name =~ /^sys_/ &&
@@ -333,8 +332,9 @@ sub list_multiply_defined
 				&drop_def("arch/x86/kernel/vsyscall-sysenter_32.o", $name);
 				next;
 			}
+
 			printf "$name is multiply defined in :-\n";
-			foreach $module (@{$def{$name}}) {
+			foreach my $module (@{$def{$name}}) {
 				printf "\t$module\n";
 			}
 		}
@@ -343,12 +343,13 @@ sub list_multiply_defined
 
 sub resolve_external_references
 {
-	my ($object, $type, $name, $i, $j, $kstrtab, $ksymtab, $export);
+	my ($kstrtab, $ksymtab, $export);
+
 	printf "\n";
-	foreach $object (keys(%nmdata)) {
+	foreach my $object (keys(%nmdata)) {
 		my $nmdata = $nmdata{$object};
-		for ($i = 0; $i <= $#{$nmdata}; ++$i) {
-			($type, $name) = split(' ', $nmdata->[$i], 2);
+		for (my $i = 0; $i <= $#{$nmdata}; ++$i) {
+			my ($type, $name) = split(' ', $nmdata->[$i], 2);
 			if ($type eq "U" || $type eq "w") {
 				if (exists($def{$name}) || exists($ksymtab{$name})) {
 					# add the owning object to the nmdata
@@ -357,7 +358,7 @@ sub resolve_external_references
 					$kstrtab = "R __kstrtab_$name";
 					$ksymtab = "R __ksymtab_$name";
 					$export = 0;
-					for ($j = 0; $j <= $#{$nmdata}; ++$j) {
+					for (my $j = 0; $j <= $#{$nmdata}; ++$j) {
 						if ($nmdata->[$j] eq $kstrtab ||
 						    $nmdata->[$j] eq $ksymtab) {
 							$export = 1;
@@ -424,11 +425,11 @@ sub resolve_external_references
 sub list_extra_externals
 {
 	my %noref = ();
-	my ($name, @module, $module, $export);
-	foreach $name (keys(%def)) {
+
+	foreach my $name (keys(%def)) {
 		if (! exists($ref{$name})) {
-			@module = @{$def{$name}};
-			foreach $module (@module) {
+			my @module = @{$def{$name}};
+			foreach my $module (@module) {
 				if (! exists($noref{$module})) {
 					$noref{$module} = [];
 				}
@@ -438,16 +439,16 @@ sub list_extra_externals
 	}
 	if (%noref) {
 		printf "\nExternally defined symbols with no external references\n";
-		foreach $module (sort(keys(%noref))) {
+		foreach my $module (sort(keys(%noref))) {
 			printf "  $module\n";
 			foreach (sort(@{$noref{$module}})) {
-				if (exists($export{$_})) {
-					$export = " (export only)";
-				}
-				else {
-					$export = "";
-				}
-				printf "    $_$export\n";
+			    my $export;
+			    if (exists($export{$_})) {
+				$export = " (export only)";
+			    } else {
+				$export = "";
+			    }
+			    printf "    $_$export\n";
 			}
 		}
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

