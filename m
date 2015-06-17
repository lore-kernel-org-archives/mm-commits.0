From: akpm@linux-foundation.org
Subject: + get_maintainer-emit-longer-section-headers.patch added to -mm
 tree
Date: Wed, 17 Jun 2015 13:27:20 -0700
Message-ID: <5581d828.Frh9GRsrRp2FisW3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbbFQU1U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Jun 2015 16:27:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     From: Joe Perches <joe@perches.com>
has been added to the -mm tree.  Its filename is
     get_maintainer-emit-longer-section-headers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/get_maintainer-emit-longer-section-headers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/get_maintainer-emit-longer-section-headers.patch

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
Subject: get_maintainer: emit longer section headers

Section headers can be quite long and some are very long and duplicated
for many initial characters.

The current maximum length emitted for a section header is 20 bytes (or 17
bytes then ...  when the section header length is > 20).

Change that length to 50 so more of the section is shown.

Example new output:
$ ./scripts/get_maintainer.pl -f drivers/net/ethernet/broadcom/bnx2x/
Ariel Elior <ariel.elior@qlogic.com> (supporter:BROADCOM BNX2X 10 GIGABIT ETHERNET DRIVER)
netdev@vger.kernel.org (open list:BROADCOM BNX2X 10 GIGABIT ETHERNET DRIVER)
linux-kernel@vger.kernel.org (open list)

Old:
$ ./scripts/get_maintainer.pl -f drivers/net/ethernet/broadcom/bnx2x/
Ariel Elior <ariel.elior@qlogic.com> (supporter:BROADCOM BNX2X 10...)
netdev@vger.kernel.org (open list:BROADCOM BNX2X 10...)
linux-kernel@vger.kernel.org (open list)

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN scripts/get_maintainer.pl~get_maintainer-emit-longer-section-headers scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-emit-longer-section-headers
+++ a/scripts/get_maintainer.pl
@@ -42,6 +42,7 @@ my $output_multiline = 1;
 my $output_separator = ", ";
 my $output_roles = 0;
 my $output_rolestats = 1;
+my $output_section_maxlen = 50;
 my $scm = 0;
 my $web = 0;
 my $subsystem = 0;
@@ -978,8 +979,8 @@ sub get_maintainer_role {
 
     my $role = "unknown";
     my $subsystem = $typevalue[$start];
-    if (length($subsystem) > 20) {
-	$subsystem = substr($subsystem, 0, 17);
+    if ($output_section_maxlen && length($subsystem) > $output_section_maxlen) {
+	$subsystem = substr($subsystem, 0, $output_section_maxlen - 3);
 	$subsystem =~ s/\s*$//;
 	$subsystem = $subsystem . "...";
     }
@@ -1021,8 +1022,8 @@ sub get_list_role {
     my $end = find_ending_index($index);
 
     my $subsystem = $typevalue[$start];
-    if (length($subsystem) > 20) {
-	$subsystem = substr($subsystem, 0, 17);
+    if ($output_section_maxlen && length($subsystem) > $output_section_maxlen) {
+	$subsystem = substr($subsystem, 0, $output_section_maxlen - 3);
 	$subsystem =~ s/\s*$//;
 	$subsystem = $subsystem . "...";
     }
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
get_maintainer-emit-longer-section-headers.patch
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

