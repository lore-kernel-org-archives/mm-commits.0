From: akpm@linux-foundation.org
Subject: +
 checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch added to -mm tree
Date: Wed, 01 Apr 2015 13:38:17 -0700
Message-ID: <551c5739.QmmkSb7dl4Lzs/0P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbbDAUiS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2015 16:38:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, corbet@lwn.net, davem@davmloft.net, ipm@chirality.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch, SubmittingPatches: suggest line wrapping commit messages at 75 columns
has been added to the -mm tree.  Its filename is
     checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch

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
Subject: checkpatch, SubmittingPatches: suggest line wrapping commit messages at 75 columns

Commit messages lines are sometimes overly long.

Suggest line wrapping at 75 columns so the default git commit log
indentation of 4 plus the commit message text still fits on an 80 column
screen.

Add a checkpatch test for long commit messages lines too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davmloft.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ian Morris <ipm@chirality.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingPatches |    4 ++--
 scripts/checkpatch.pl           |    9 +++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff -puN Documentation/SubmittingPatches~checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns
+++ a/Documentation/SubmittingPatches
@@ -614,8 +614,8 @@ The canonical patch message body contain
 
   - An empty line.
 
-  - The body of the explanation, which will be copied to the
-    permanent changelog to describe this patch.
+  - The body of the explanation, line wrapped at 75 columns, which will
+    be copied to the permanent changelog to describe this patch.
 
   - The "Signed-off-by:" lines, described above, which will
     also go in the changelog.
diff -puN scripts/checkpatch.pl~checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns
+++ a/scripts/checkpatch.pl
@@ -1898,6 +1898,7 @@ sub process {
 
 	my $in_header_lines = $file ? 0 : 1;
 	my $in_commit_log = 0;		#Scanning lines before patch
+	my $commit_log_long_line = 0;
 	my $reported_maintainer_file = 0;
 	my $non_utf8_charset = 0;
 
@@ -2233,6 +2234,14 @@ sub process {
 			      "Remove Gerrit Change-Id's before submitting upstream.\n" . $herecurr);
 		}
 
+# Check for line lengths > 75 in commit log, warn once
+		if ($in_commit_log && !$commit_log_long_line &&
+		    length($line) > 75) {
+			WARN("COMMIT_LOG_LONG_LINE",
+			     "Possible unwrapped commit description (prefer a maximum 75 chars per line)\n" . $herecurr);
+			$commit_log_long_line = 1;
+		}
+
 # Check for git id commit length and improperly formed commit descriptions
 		if ($in_commit_log && $line =~ /\b(c)ommit\s+([0-9a-f]{5,})/i) {
 			my $init_char = $1;
_

Patches currently in -mm which might be from joe@perches.com are

ocfs2-logging-remove-static-buffer-use-vsprintf-extension-%pv.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
slub-use-bool-function-return-values-of-true-false-not-1-0.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch
maintainers-use-tabs-consistently.patch
maintainers-credits-remove-stefano-brivio-from-b43.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
cris-fasttimer-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
checkpatch-match-more-world-writable-permissions.patch
checkpatch-match-more-world-writable-permissions-fix.patch
checkpatch-improve-return-negative-errno-check.patch
checkpatch-add-test-for-repeated-const-uses.patch
checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch
adfs-returning-correct-return-values.patch
linux-next.patch

