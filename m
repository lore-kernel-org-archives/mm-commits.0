From: akpm@linux-foundation.org
Subject: + checkpatch-better-fix-of-spacing-errors.patch added to -mm tree
Date: Fri, 09 Aug 2013 16:05:54 -0700
Message-ID: <520575d2.Xu5nJ3LMzPTnZQtZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031435Ab3HIXFz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Aug 2013 19:05:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, phil.carmody@partner.samsung.com, apw@canonical.com, joe@perches.com

Subject: + checkpatch-better-fix-of-spacing-errors.patch added to -mm tree
To: joe@perches.com,apw@canonical.com,phil.carmody@partner.samsung.com
From: akpm@linux-foundation.org
Date: Fri, 09 Aug 2013 16:05:54 -0700


The patch titled
     Subject: checkpatch: better --fix of SPACING errors.
has been added to the -mm tree.  Its filename is
     checkpatch-better-fix-of-spacing-errors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-better-fix-of-spacing-errors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-better-fix-of-spacing-errors.patch

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
Subject: checkpatch: better --fix of SPACING errors.

Previous attempt at fixing SPACING errors could make a hash of several
defects.

This patch should make --fix be a lot better at correcting these defects.

Trim left and right sides of these defects appropriately instead of a
somewhat random attempt at it.

Trim left spaces from any following bit of the modified line when only a
single space is required around an operator.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Phil Carmody <phil.carmody@partner.samsung.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   64 ++++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 22 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-better-fix-of-spacing-errors scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-better-fix-of-spacing-errors
+++ a/scripts/checkpatch.pl
@@ -1472,7 +1472,23 @@ sub check_absolute_file {
 sub trim {
 	my ($string) = @_;
 
-	$string =~ s/(^\s+|\s+$)//g;
+	$string =~ s/^\s+|\s+$//g;
+
+	return $string;
+}
+
+sub ltrim {
+	my ($string) = @_;
+
+	$string =~ s/^\s+//;
+
+	return $string;
+}
+
+sub rtrim {
+	my ($string) = @_;
+
+	$string =~ s/\s+$//;
 
 	return $string;
 }
@@ -2821,6 +2837,7 @@ sub process {
 			$off = 0;
 
 			my $blank = copy_spacing($opline);
+			my $last_after = -1;
 
 			for (my $n = 0; $n < $#elements; $n += 2) {
 
@@ -2886,7 +2903,7 @@ sub process {
 					    $cc !~ /^\\/ && $cc !~ /^;/) {
 						if (ERROR("SPACING",
 							  "space required after that '$op' $at\n" . $hereptr)) {
-							$good = trim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
+							$good = $fix_elements[$n] . trim($fix_elements[$n + 1]) . " ";
 							$line_fixed = 1;
 						}
 					}
@@ -2901,11 +2918,11 @@ sub process {
 					if ($ctx =~ /Wx.|.xW/) {
 						if (ERROR("SPACING",
 							  "spaces prohibited around that '$op' $at\n" . $hereptr)) {
-							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
-							$line_fixed = 1;
+							$good = rtrim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
 							if (defined $fix_elements[$n + 2]) {
 								$fix_elements[$n + 2] =~ s/^\s+//;
 							}
+							$line_fixed = 1;
 						}
 					}
 
@@ -2914,8 +2931,9 @@ sub process {
 					if ($ctx !~ /.x[WEC]/ && $cc !~ /^}/) {
 						if (ERROR("SPACING",
 							  "space required after that '$op' $at\n" . $hereptr)) {
-							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]) . " ";
+							$good = $fix_elements[$n] . trim($fix_elements[$n + 1]) . " ";
 							$line_fixed = 1;
+							$last_after = $n;
 						}
 					}
 
@@ -2932,8 +2950,10 @@ sub process {
 					if ($ctx !~ /[WEBC]x./ && $ca !~ /(?:\)|!|~|\*|-|\&|\||\+\+|\-\-|\{)$/) {
 						if (ERROR("SPACING",
 							  "space required before that '$op' $at\n" . $hereptr)) {
-							$good = trim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]);
-							$line_fixed = 1;
+							if ($n != $last_after + 2) {
+								$good = $fix_elements[$n] . " " . ltrim($fix_elements[$n + 1]);
+								$line_fixed = 1;
+							}
 						}
 					}
 					if ($op eq '*' && $cc =~/\s*$Modifier\b/) {
@@ -2942,12 +2962,11 @@ sub process {
 					} elsif ($ctx =~ /.xW/) {
 						if (ERROR("SPACING",
 							  "space prohibited after that '$op' $at\n" . $hereptr)) {
-							$fixed_line =~ s/\s+$//;
-							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
-							$line_fixed = 1;
+							$good = $fix_elements[$n] . rtrim($fix_elements[$n + 1]);
 							if (defined $fix_elements[$n + 2]) {
 								$fix_elements[$n + 2] =~ s/^\s+//;
 							}
+							$line_fixed = 1;
 						}
 					}
 
@@ -2956,8 +2975,7 @@ sub process {
 					if ($ctx !~ /[WEOBC]x[^W]/ && $ctx !~ /[^W]x[WOBEC]/) {
 						if (ERROR("SPACING",
 							  "space required one side of that '$op' $at\n" . $hereptr)) {
-							$fixed_line =~ s/\s+$//;
-							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]) . " ";
+							$good = $fix_elements[$n] . trim($fix_elements[$n + 1]) . " ";
 							$line_fixed = 1;
 						}
 					}
@@ -2965,20 +2983,18 @@ sub process {
 					    ($ctx =~ /Wx./ && $cc =~ /^;/)) {
 						if (ERROR("SPACING",
 							  "space prohibited before that '$op' $at\n" . $hereptr)) {
-							$fixed_line =~ s/\s+$//;
-							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
+							$good = rtrim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
 							$line_fixed = 1;
 						}
 					}
 					if ($ctx =~ /ExW/) {
 						if (ERROR("SPACING",
 							  "space prohibited after that '$op' $at\n" . $hereptr)) {
-							$fixed_line =~ s/\s+$//;
-							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
-							$line_fixed = 1;
+							$good = $fix_elements[$n] . trim($fix_elements[$n + 1]);
 							if (defined $fix_elements[$n + 2]) {
 								$fix_elements[$n + 2] =~ s/^\s+//;
 							}
+							$line_fixed = 1;
 						}
 					}
 
@@ -2992,8 +3008,10 @@ sub process {
 					if ($ctx =~ /Wx[^WCE]|[^WCE]xW/) {
 						if (ERROR("SPACING",
 							  "need consistent spacing around '$op' $at\n" . $hereptr)) {
-							$fixed_line =~ s/\s+$//;
-							$good = trim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
+							$good = rtrim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
+							if (defined $fix_elements[$n + 2]) {
+								$fix_elements[$n + 2] =~ s/^\s+//;
+							}
 							$line_fixed = 1;
 						}
 					}
@@ -3004,7 +3022,7 @@ sub process {
 					if ($ctx =~ /Wx./) {
 						if (ERROR("SPACING",
 							  "space prohibited before that '$op' $at\n" . $hereptr)) {
-							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
+							$good = rtrim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
 							$line_fixed = 1;
 						}
 					}
@@ -3031,8 +3049,10 @@ sub process {
 					if ($ok == 0) {
 						if (ERROR("SPACING",
 							  "spaces required around that '$op' $at\n" . $hereptr)) {
-							$good = trim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
-							$good = $fix_elements[$n] . " " . trim($fix_elements[$n + 1]) . " ";
+							$good = rtrim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
+							if (defined $fix_elements[$n + 2]) {
+								$fix_elements[$n + 2] =~ s/^\s+//;
+							}
 							$line_fixed = 1;
 						}
 					}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
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

