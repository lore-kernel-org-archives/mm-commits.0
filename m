From: akpm@linux-foundation.org
Subject: [merged] headers_check-fix-perl-warnings.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:11:53 -0800
Message-ID: <201003091911.o29JBrhg031773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755993Ab0CITWM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@vyatta.com, amwang@redhat.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     headers_check: fix perl warnings
has been removed from the -mm tree.  Its filename was
     headers_check-fix-perl-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: headers_check: fix perl warnings
From: Stephen Hemminger <shemminger@vyatta.com>

According to PBP; best way practice is to use local reference for file
handle and three argument open. Also perl prototypes are a mistake.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Acked-by: WANG Cong <amwang@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/headers_check.pl |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN scripts/headers_check.pl~headers_check-fix-perl-warnings scripts/headers_check.pl
--- a/scripts/headers_check.pl~headers_check-fix-perl-warnings
+++ a/scripts/headers_check.pl
@@ -28,11 +28,12 @@ my $lineno = 0;
 my $filename;
 
 foreach my $file (@files) {
-	local *FH;
 	$filename = $file;
-	open(FH, "<$filename") or die "$filename: $!\n";
+
+	open(my $fh, '<', $filename)
+		or die "$filename: $!\n";
 	$lineno = 0;
-	while ($line = <FH>) {
+	while ($line = <$fh>) {
 		$lineno++;
 		&check_include();
 		&check_asm_types();
@@ -40,7 +41,7 @@ foreach my $file (@files) {
 		&check_declarations();
 		# Dropped for now. Too much noise &check_config();
 	}
-	close FH;
+	close $fh;
 }
 exit $ret;
 
@@ -78,7 +79,7 @@ sub check_config
 }
 
 my $linux_asm_types;
-sub check_asm_types()
+sub check_asm_types
 {
 	if ($filename =~ /types.h|int-l64.h|int-ll64.h/o) {
 		return;
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

