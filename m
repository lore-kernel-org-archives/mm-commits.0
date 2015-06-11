From: akpm@linux-foundation.org
Subject: [merged] checkpatch-fix-global_initialisers-test.patch removed
 from -mm tree
Date: Thu, 11 Jun 2015 14:01:27 -0700
Message-ID: <5579f727.k6ZOHRZ2bLhIwkCz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbbFKVB1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Jun 2015 17:01:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bsd@makefile.in, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix "GLOBAL_INITIALISERS" test
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-global_initialisers-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: fix "GLOBAL_INITIALISERS" test

commit d5e616fc1c1d ("checkpatch: add a few more --fix corrections") broke
the GLOBAL_INITIALISERS test with bad parentheses and optional leading
spaces.

Fix it.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Bandan Das <bsd@makefile.in>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-global_initialisers-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-global_initialisers-test
+++ a/scripts/checkpatch.pl
@@ -3169,12 +3169,12 @@ sub process {
 		}
 
 # check for global initialisers.
-		if ($line =~ /^\+(\s*$Type\s*$Ident\s*(?:\s+$Modifier))*\s*=\s*(0|NULL|false)\s*;/) {
+		if ($line =~ /^\+$Type\s*$Ident(?:\s+$Modifier)*\s*=\s*(?:0|NULL|false)\s*;/) {
 			if (ERROR("GLOBAL_INITIALISERS",
 				  "do not initialise globals to 0 or NULL\n" .
 				      $herecurr) &&
 			    $fix) {
-				$fixed[$fixlinenr] =~ s/($Type\s*$Ident\s*(?:\s+$Modifier))*\s*=\s*(0|NULL|false)\s*;/$1;/;
+				$fixed[$fixlinenr] =~ s/(^.$Type\s*$Ident(?:\s+$Modifier)*)\s*=\s*(0|NULL|false)\s*;/$1;/;
 			}
 		}
 # check for static initialisers.
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
compiler-gcch-neatening.patch
compiler-gcc-integrate-the-various-compiler-gcch-files.patch
get_maintainerpl-add-get_maintainerignore-file-capability.patch
maintainers-alsa-devel-alsa-projectorg-is-moderated-for-non-subscribers.patch
lib-string-introduce-strreplace.patch
mm-utilc-add-kstrimdup.patch
checkpatch-check-for-uncommented-waitqueue_active.patch
checkpatch-add-strict-warning-for-c99-fixed-size-typedefs-intsize_t.patch
checkpatch-make-types-found-in-a-source-file-patch-local.patch
checkpatch-use-string-consistently.patch
checkpatch-categorize-some-long-line-length-checks.patch
checkpatch-improve-output-with-multiple-command-line-files.patch
checkpatch-colorize-output-to-terminal.patch
checkpatch-add-showfile-to-allow-input-via-pipe-to-show-filenames.patch
checkpatch-remove-local-from-codespell-path.patch
checkpatch-avoid-not_unified_diff-errors-on-cover-letterpatch-files.patch
checkpatch-suggest-using-ether_addr_equal.patch
checkpatch-fix-processing-of-memset-issues.patch
checkpatch-suggest-using-eth_zero_addr-and-eth_broadcast_addr.patch
checkpatch-add-multi-line-handling-for-prefer_ether_addr_copy.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
maintainers-bcache-kent-overstreet-has-changed-email-address.patch

