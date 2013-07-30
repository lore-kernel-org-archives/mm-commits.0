From: akpm@linux-foundation.org
Subject: + checkpatch-check-for-duplicate-signatures.patch added to -mm
 tree
Date: Tue, 30 Jul 2013 13:32:38 -0700
Message-ID: <51f822e6.X+uLvJ491eoohhIH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab3G3Uci (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jul 2013 16:32:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-check-for-duplicate-signatures.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 30 Jul 2013 13:32:38 -0700


The patch titled
     Subject: checkpatch: check for duplicate signatures
has been added to the -mm tree.  Its filename is
     checkpatch-check-for-duplicate-signatures.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-check-for-duplicate-signatures.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-check-for-duplicate-signatures.patch

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
Subject: checkpatch: check for duplicate signatures

Emit a warning when a signature is used more than once.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-check-for-duplicate-signatures scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-for-duplicate-signatures
+++ a/scripts/checkpatch.pl
@@ -1544,6 +1544,7 @@ sub process {
 	my %suppress_export;
 	my $suppress_statement = 0;
 
+	my %signatures = ();
 
 	# Pre-scan the patch sanitizing the lines.
 	# Pre-scan the patch looking for any __setup documentation.
@@ -1793,6 +1794,17 @@ sub process {
 					     "email address '$email' might be better as '$suggested_email$comment'\n" . $herecurr);
 				}
 			}
+
+# Check for duplicate signatures
+			my $sig_nospace = $line;
+			$sig_nospace =~ s/\s//g;
+			$sig_nospace = lc($sig_nospace);
+			if (defined $signatures{$sig_nospace}) {
+				WARN("BAD_SIGN_OFF",
+				     "Duplicate signature\n" . $herecurr);
+			} else {
+				$signatures{$sig_nospace} = 1;
+			}
 		}
 
 # Check for wrappage within a valid hunk of the file
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-dynamic-debug-jasons-not-there.patch
printk-move-to-separate-directory-for-easier-modification.patch
printk-move-to-separate-directory-for-easier-modification-fix.patch
printk-add-console_cmdlineh.patch
printk-move-braille-console-support-into-separate-braille-files.patch
printk-use-pointer-for-console_cmdline-indexing.patch
printk-rename-struct-log-to-struct-printk_log.patch
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
checkpatch-add-a-few-more-fix-corrections.patch
checkpatch-check-camelcase-by-word-not-by-lval.patch
checkpatch-enforce-sane-perl-version.patch
checkpatch-check-for-duplicate-signatures.patch
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
linux-next.patch

