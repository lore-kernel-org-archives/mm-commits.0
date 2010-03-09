From: akpm@linux-foundation.org
Subject: [merged] scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:06:51 -0800
Message-ID: <201003091906.o29J6pZr031280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755949Ab0CITWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, gregkh@suse.de, steve.glendinning@smsc.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     scripts/get_maintainer.pl: add --sections, print entire matched subsystem
has been removed from the -mm tree.  Its filename was
     scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: add --sections, print entire matched subsystem
From: Joe Perches <joe@perches.com>

Print the complete contents of the matched subsystems
in pattern match depth order.

Sample output:

$ ./scripts/get_maintainer.pl --sections -f drivers/net/usb/smsc95xx.c
USB SMSC95XX ETHERNET DRIVER
M:Steve Glendinning <steve.glendinning@smsc.com>
L:netdev@vger.kernel.org
S:Supported
F:drivers/net/usb/smsc95xx.*
USB SUBSYSTEM
M:Greg Kroah-Hartman <gregkh@suse.de>
L:linux-usb@vger.kernel.org
W:http://www.linux-usb.org
T:quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
S:Supported
F:Documentation/usb/
F:drivers/net/usb/
F:drivers/usb/
F:include/linux/usb.h
F:include/linux/usb/
NETWORKING DRIVERS
L:netdev@vger.kernel.org
W:http://www.linuxfoundation.org/en/Net
T:git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
S:Odd Fixes
F:drivers/net/
F:include/linux/if_*
F:include/linux/*device.h
THE REST
M:Linus Torvalds <torvalds@linux-foundation.org>
L:linux-kernel@vger.kernel.org
Q:http://patchwork.kernel.org/project/LKML/list/
T:git git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
S:Buried alive in reporters
F:*
F:*/

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem
+++ a/scripts/get_maintainer.pl
@@ -41,6 +41,7 @@ my $web = 0;
 my $subsystem = 0;
 my $status = 0;
 my $keywords = 1;
+my $sections = 0;
 my $file_emails = 0;
 my $from_filename = 0;
 my $pattern_depth = 0;
@@ -121,6 +122,7 @@ if (!GetOptions(
 		'web!' => \$web,
 		'pattern-depth=i' => \$pattern_depth,
 		'k|keywords!' => \$keywords,
+		'sections!' => \$sections,
 		'fe|file-emails!' => \$file_emails,
 		'f|file' => \$from_filename,
 		'v|version' => \$version,
@@ -152,10 +154,20 @@ if ($output_rolestats) {
     $output_roles = 1;
 }
 
-my $selections = $email + $scm + $status + $subsystem + $web;
-if ($selections == 0) {
-    usage();
-    die "$P:  Missing required option: email, scm, status, subsystem or web\n";
+if ($sections) {
+    $email = 0;
+    $email_list = 0;
+    $scm = 0;
+    $status = 0;
+    $subsystem = 0;
+    $web = 0;
+    $keywords = 0;
+} else {
+    my $selections = $email + $scm + $status + $subsystem + $web;
+    if ($selections == 0) {
+	usage();
+	die "$P:  Missing required option: email, scm, status, subsystem or web\n";
+    }
 }
 
 if ($email &&
@@ -357,6 +369,21 @@ foreach my $file (@files) {
 
     foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
 	add_categories($line);
+	    if ($sections) {
+		my $i;
+		my $start = find_starting_index($line);
+		my $end = find_ending_index($line);
+		for ($i = $start; $i < $end; $i++) {
+		    my $line = $typevalue[$i];
+		    if ($line =~ /^[FX]:/) {		##Restore file patterns
+			$line =~ s/([^\\])\.([^\*])/$1\?$2/g;
+			$line =~ s/([^\\])\.$/$1\?/g;	##Convert . back to ?
+			$line =~ s/\\\./\./g;       	##Convert \. to .
+			$line =~ s/\.\*/\*/g;       	##Convert .* to *
+		    }
+		    print("$line\n");
+		}
+	    }
     }
 
     if ($email && $email_git) {
@@ -486,6 +513,7 @@ Output type options:
 Other options:
   --pattern-depth => Number of pattern directory traversals (default: 0 (all))
   --keywords => scan patch for keywords (default: 1 (on))
+  --sections => print the entire subsystem sections with pattern matches
   --version => show version
   --help => show this help information
 
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

