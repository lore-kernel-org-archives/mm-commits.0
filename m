From: akpm@linux-foundation.org
Subject: + checkpatch-reduce-runtime-cpu-time-used.patch added to -mm tree
Date: Wed, 14 Aug 2013 13:49:42 -0700
Message-ID: <520bed66.l+T+a3u0H9yB4iJR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004Ab3HNUtm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 16:49:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-reduce-runtime-cpu-time-used.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 13:49:42 -0700


The patch titled
     Subject: checkpatch: reduce runtime/cpu time used
has been added to the -mm tree.  Its filename is
     checkpatch-reduce-runtime-cpu-time-used.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-reduce-runtime-cpu-time-used.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-reduce-runtime-cpu-time-used.patch

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
Subject: checkpatch: reduce runtime/cpu time used

There are some cases where checkpatch can take a long time to complete. 
Reduce the likelihood of this long run-time by adding a new test for lines
with and without comments and eliminating checks on lines with only
comments.

This reduces the number of "ctx_statement_block" calls, and also the
number of tests of $stat, which is now undefined for these blank lines.

One test in particular, the "check for switch/default statements without a
break", could take an extremely long time to parse as it tries to skip
interleaving comments within the ctx_statement_block/$stat and that could
be done multiple times unnecessarily.

A small test case taken from cfg80211.h before this patch would take
1000's of seconds to run, now it's just a couple seconds.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-reduce-runtime-cpu-time-used scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-reduce-runtime-cpu-time-used
+++ a/scripts/checkpatch.pl
@@ -1678,6 +1678,8 @@ sub process {
 	$linenr = 0;
 	foreach my $line (@lines) {
 		$linenr++;
+		my $sline = $line;	#copy of $line
+		$sline =~ s/$;/ /g;	#with comments as spaces
 
 		my $rawline = $rawlines[$linenr - 1];
 
@@ -2194,7 +2196,7 @@ sub process {
 		    $realline_next);
 #print "LINE<$line>\n";
 		if ($linenr >= $suppress_statement &&
-		    $realcnt && $line =~ /.\s*\S/) {
+		    $realcnt && $sline =~ /.\s*\S/) {
 			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
 				ctx_statement_block($linenr, $realcnt, 0);
 			$stat =~ s/\n./\n /g;
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-exynos-remove-board-files.patch
maintainers-arm-omap2-3-remove-unused-clockdomain-files.patch
maintainers-omap-powerdomain-update-patterns.patch
maintainers-arm-s3c2410-update-patterns.patch
maintainers-arm-spear-consolidate-sections.patch
maintainers-arm-plat-nomadik-update-patterns.patch
maintainers-arm-s3c24xx-remove-plat-s3c24xx.patch
maintainers-ghes_edac-update-pattern.patch
maintainers-update-siano-drivers.patch
maintainers-si4713-fix-file-pattern.patch
maintainers-update-it913x-patterns.patch
maintainers-update-sirf-patterns.patch
maintainers-update-ssbi-patterns.patch
maintainers-update-file-pattern-for-arc-uart.patch
maintainers-update-usb-ehci-platform-pattern.patch
maintainers-usb-phy-update-patterns.patch
maintainers-update-gre-demux-patterns.patch
maintainers-append-to-directory-patterns.patch
checkpatch-add-a-few-more-fix-corrections.patch
checkpatch-check-camelcase-by-word-not-by-lval.patch
checkpatch-enforce-sane-perl-version.patch
checkpatch-check-for-duplicate-signatures.patch
checkpatch-warn-when-using-extern-with-function-prototypes-in-h-files.patch
checkpatch-fix-networking-kernel-doc-block-comment-defect.patch
checkpatch-add-types-option-to-report-only-specific-message-types.patch
checkpatch-ignore-define-trace_foo-macros.patch
checkpatch-better-fix-of-spacing-errors.patch
checkpatch-reduce-runtime-cpu-time-used.patch
firmware-dmi_scan-drop-obsolete-comment.patch
firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch
firmware-dmi_scan-constify-strings.patch
firmware-dmi_scan-drop-oom-messages.patch
pktcdvd-convert-zone-macro-to-static-function-get_zone.patch
pktcdvd-convert-printk-to-pr_level.patch
pktcdvd-consolidate-dprintk-and-vprintk-macros.patch
pktcdvd-add-struct-pktcdvd_device-to-pkt_dbg.patch
pktcdvd-add-struct-pktcdvd_devicename-to-pr_err-logging-where-possible.patch
pktcdvd-convert-pr_notice-to-pkt_notice.patch
pktcdvd-convert-pr_info-to-pkt_info.patch
pktcdvd-add-struct-pktcdvd_device-to-pkt_dump_sense.patch
pktcdvd-fix-defective-misuses-of-pkt_level.patch
linux-next.patch

