From: akpm@linux-foundation.org
Subject: +
 checkpatch-fix-perl-version-512-and-earlier-incompatibility.patch added to
 -mm tree
Date: Wed, 14 Aug 2013 14:42:22 -0700
Message-ID: <520bf9be.tk/oxtxWyZWBmvzU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933276Ab3HNVmX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 17:42:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, julia.lawall@lip6.fr, joe@perches.com

Subject: + checkpatch-fix-perl-version-512-and-earlier-incompatibility.patch added to -mm tree
To: joe@perches.com,julia.lawall@lip6.fr
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 14:42:22 -0700


The patch titled
     Subject: checkpatch: fix perl version 5.12 and earlier incompatibility
has been added to the -mm tree.  Its filename is
     checkpatch-fix-perl-version-512-and-earlier-incompatibility.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-perl-version-512-and-earlier-incompatibility.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-perl-version-512-and-earlier-incompatibility.patch

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
Subject: checkpatch: fix perl version 5.12 and earlier incompatibility

commit 203489a33 ("checkpatch: add --types option to report only specific
message types") uses a perl syntax introduced in perl version 5.14.

Use the backward compatible perl syntax instead.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-perl-version-512-and-earlier-incompatibility scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-perl-version-512-and-earlier-incompatibility
+++ a/scripts/checkpatch.pl
@@ -174,9 +174,9 @@ sub hash_save_array_words {
 sub hash_show_words {
 	my ($hashRef, $prefix) = @_;
 
-	if ($quiet == 0 && keys $hashRef) {
+	if ($quiet == 0 && keys %$hashRef) {
 		print "NOTE: $prefix message types:";
-		foreach my $word (sort keys $hashRef) {
+		foreach my $word (sort keys %$hashRef) {
 			print " $word";
 		}
 		print "\n\n";
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
checkpatch-fix-perl-version-512-and-earlier-incompatibility.patch
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

