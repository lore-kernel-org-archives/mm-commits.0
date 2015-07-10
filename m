From: akpm@linux-foundation.org
Subject: + checkpatch-add-warning-on-bug-bug_on-use.patch added to -mm
 tree
Date: Fri, 10 Jul 2015 15:36:26 -0700
Message-ID: <55a048ea.FSt3JEdKJR7nE+7k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbbGJWg1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jul 2015 18:36:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add warning on BUG/BUG_ON use
has been added to the -mm tree.  Its filename is
     checkpatch-add-warning-on-bug-bug_on-use.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-warning-on-bug-bug_on-use.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-warning-on-bug-bug_on-use.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add warning on BUG/BUG_ON use

Using BUG/BUG_ON crashes the kernel and is just unfriendly.

Enable code that emits a warning on BUG/BUG_ON use.

Make the code emit the message at WARNING level when scanning a patch and
at CHECK level when scanning files so that script users don't feel an
obligation to fix code that might be above their pay grade.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-warning-on-bug-bug_on-use scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-warning-on-bug-bug_on-use
+++ a/scripts/checkpatch.pl
@@ -3448,13 +3448,15 @@ sub process {
 			}
 		}
 
-# # no BUG() or BUG_ON()
-# 		if ($line =~ /\b(BUG|BUG_ON)\b/) {
-# 			print "Try to use WARN_ON & Recovery code rather than BUG() or BUG_ON()\n";
-# 			print "$herecurr";
-# 			$clean = 0;
-# 		}
+# avoid BUG() or BUG_ON()
+		if ($line =~ /\b(?:BUG|BUG_ON)\b/) {
+			my $msg_type = \&WARN;
+			$msg_type = \&CHK if ($file);
+			&{$msg_type}("AVOID_BUG",
+				     "Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()\n" . $herecurr);
+		}
 
+# avoid LINUX_VERSION_CODE
 		if ($line =~ /\bLINUX_VERSION_CODE\b/) {
 			WARN("LINUX_VERSION_CODE",
 			     "LINUX_VERSION_CODE should be avoided, code should be for the version to which it is merged\n" . $herecurr);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-fix-long-line-messages-about-patch-context.patch
lindent-handle-missing-indent-gracefully.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
parse_integer-add-checkpatchpl-notice.patch
mm-utilc-add-kstrimdup.patch
checkpatch-warn-on-bare-sha-1-commit-ids-in-commit-logs.patch
checkpatch-add-warning-on-bug-bug_on-use.patch
hfs-fix-b-tree-corruption-after-insertion-at-position-0.patch
seq_file-provide-an-analogue-of-print_hex_dump.patch
crypto-qat-use-seq_hex_dump-to-dump-buffers.patch
parisc-use-seq_hex_dump-to-dump-buffers.patch
zcrypt-use-seq_hex_dump-to-dump-buffers.patch
kmemleak-use-seq_hex_dump-to-dump-buffers.patch
wil6210-use-seq_hex_dump-to-dump-buffers.patch
linux-next.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

