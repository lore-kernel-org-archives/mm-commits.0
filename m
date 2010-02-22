From: akpm@linux-foundation.org
Subject: + scripts-improve-checkstack.patch added to -mm tree
Date: Mon, 22 Feb 2010 15:17:09 -0800
Message-ID: <201002222317.o1MNH97H029582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754920Ab0BVXRj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Feb 2010 18:17:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@vyatta.com, amwang@redhat.com, arjan@infradead.org, mmarek@suse.cz, rostedt@goodmis.org


The patch titled
     scripts: improve checkstack
has been added to the -mm tree.  Its filename is
     scripts-improve-checkstack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts: improve checkstack
From: Stephen Hemminger <shemminger@vyatta.com>

Cleanup checkstack script:
  * Turn on strict checking
  * Fix resulting error message because the declaration syntax
    was incorrect.
  * Remove incorrect and misleading use of prototype
     - prototype not required for this type of sort function
       because $a and $b are being used in this contex
     - if prototype was being used it should be for both arguments
  * Use closure for sort function

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Cong Wang <amwang@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkstack.pl |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN scripts/checkstack.pl~scripts-improve-checkstack scripts/checkstack.pl
--- a/scripts/checkstack.pl~scripts-improve-checkstack
+++ a/scripts/checkstack.pl
@@ -21,6 +21,8 @@
 #
 #	TODO :	Port to all architectures (one regex per arch)
 
+use strict;
+
 # check for arch
 #
 # $re is used for two matches:
@@ -104,19 +106,11 @@ my (@stack, $re, $dre, $x, $xs);
 	}
 }
 
-sub bysize($) {
-	my ($asize, $bsize);
-	($asize = $a) =~ s/.*:	*(.*)$/$1/;
-	($bsize = $b) =~ s/.*:	*(.*)$/$1/;
-	$bsize <=> $asize
-}
-
 #
 # main()
 #
 my $funcre = qr/^$x* <(.*)>:$/;
-my $func;
-my $file, $lastslash;
+my ($func, $file, $lastslash);
 
 while (my $line = <STDIN>) {
 	if ($line =~ m/$funcre/) {
@@ -173,4 +167,6 @@ while (my $line = <STDIN>) {
 	}
 }
 
-print sort bysize @stack;
+# Sort output by size (last field)
+print sort { ($b =~ /:\t*(\d+)$/)[0] <=> ($a =~ /:\t*(\d+)$/)[0] } @stack;
+
_

Patches currently in -mm which might be from shemminger@vyatta.com are

origin.patch
linux-next.patch
scripts-improve-checkstack.patch
checkincludes-fix-perlcritic-warnings.patch
checkversion-perl-cleanup.patch
namespace-perlcritic-warnings.patch
profile2linkerlist-fix-perl-warnings.patch
export_report-fix-perl-warnings.patch
headers_check-fix-perl-warnings.patch
headers_install-use-local-file-handles.patch
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
get_maintainer-fix-perlcritic-warnings.patch
get_maintainer-quote-email-address-with-period.patch

