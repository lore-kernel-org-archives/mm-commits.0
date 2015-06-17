From: akpm@linux-foundation.org
Subject: +
 checkpatch-emit-note-types-message-only-once-after-multiple-files.patch
 added to -mm tree
Date: Wed, 17 Jun 2015 13:26:39 -0700
Message-ID: <5581d7ff.6gPZJod8MwJd6HPU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbbFQU0k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Jun 2015 16:26:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: emit "NOTE: <types>" message only once after multiple files
has been added to the -mm tree.  Its filename is
     checkpatch-emit-note-types-message-only-once-after-multiple-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-emit-note-types-message-only-once-after-multiple-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-emit-note-types-message-only-once-after-multiple-files.patch

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
Subject: checkpatch: emit "NOTE: <types>" message only once after multiple files

Make this message similar to the "false positives" message and emit it
only once when scanning multiple files instead of after each file scanned.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-emit-note-types-message-only-once-after-multiple-files scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-emit-note-types-message-only-once-after-multiple-files
+++ a/scripts/checkpatch.pl
@@ -203,7 +203,7 @@ sub hash_save_array_words {
 sub hash_show_words {
 	my ($hashRef, $prefix) = @_;
 
-	if ($quiet == 0 && keys %$hashRef) {
+	if (keys %$hashRef) {
 		print "\nNOTE: $prefix message types:";
 		foreach my $word (sort keys %$hashRef) {
 			print " $word";
@@ -770,6 +770,9 @@ for my $filename (@ARGV) {
 }
 
 if (!$quiet) {
+	hash_show_words(\%use_type, "Used");
+	hash_show_words(\%ignore_type, "Ignored");
+
 	if ($^V lt 5.10.0) {
 		print << "EOM"
 
@@ -5707,9 +5710,6 @@ EOM
 		}
 	}
 
-	hash_show_words(\%use_type, "Used");
-	hash_show_words(\%ignore_type, "Ignored");
-
 	if ($clean == 0 && $fix &&
 	    ("@rawlines" ne "@fixed" ||
 	     $#fixed_inserted >= 0 || $#fixed_deleted >= 0)) {
_

Patches currently in -mm which might be from joe@perches.com are

ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
compiler-gcch-neatening.patch
compiler-gcc-integrate-the-various-compiler-gcch-files.patch
get_maintainerpl-add-get_maintainerignore-file-capability.patch
maintainers-alsa-devel-alsa-projectorg-is-moderated-for-non-subscribers.patch
maintainers-add-quotation-marks-around-names-with-periods.patch
maintainers-add-quotation-marks-around-names-with-commas.patch
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
checkpatch-validate-module_license-content.patch
checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog.patch
checkpatch-emit-note-types-message-only-once-after-multiple-files.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
maintainers-bcache-kent-overstreet-has-changed-email-address.patch

