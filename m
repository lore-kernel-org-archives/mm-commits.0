From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-fix_insert_line-and-fix_delete_line-helpers.patch added to
 -mm tree
Date: Thu, 10 Jul 2014 14:29:17 -0700
Message-ID: <53bf05ad.G/+M5RknWxXbHAeZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:55275 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaGJV3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Jul 2014 17:29:18 -0400
Received: by mail-vc0-f201.google.com with SMTP id ij19so39012vcb.4
        for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2014 14:29:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add fix_insert_line and fix_delete_line helpers
has been added to the -mm tree.  Its filename is
     checkpatch-add-fix_insert_line-and-fix_delete_line-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-fix_insert_line-and-fix_delete_line-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-fix_insert_line-and-fix_delete_line-helpers.patch

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
Subject: checkpatch: add fix_insert_line and fix_delete_line helpers

Neaten the uses of patch/file line insertions or deletions.  Hide the
mechanism used.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   65 +++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 36 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-fix_insert_line-and-fix_delete_line-helpers scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-fix_insert_line-and-fix_delete_line-helpers
+++ a/scripts/checkpatch.pl
@@ -1593,6 +1593,27 @@ sub fix_inserted_deleted_lines {
 	return @lines;
 }
 
+sub fix_insert_line {
+	my ($linenr, $line) = @_;
+
+	my $inserted = {
+		LINENR => $linenr,
+		LINE => $line,
+	};
+	push(@fixed_inserted, $inserted);
+}
+
+sub fix_delete_line {
+	my ($linenr, $line) = @_;
+
+	my $deleted = {
+		LINENR => $linenr,
+		LINE => $line,
+	};
+
+	push(@fixed_deleted, $deleted);
+}
+
 sub ERROR {
 	my ($type, $msg) = @_;
 
@@ -2447,11 +2468,7 @@ sub process {
 			if (CHK("LINE_SPACING",
 				"Please use a blank line after function/struct/union/enum declarations\n" . $hereprev) &&
 			    $fix) {
-			my $inserted = {
-				LINENR => $fixlinenr,
-				LINE => "\+",
-			};
-			push(@fixed_inserted, $inserted);
+				fix_insert_line($fixlinenr, "\+");
 			}
 		}
 
@@ -2462,11 +2479,7 @@ sub process {
 			if (CHK("LINE_SPACING",
 				"Please don't use multiple blank lines\n" . $hereprev) &&
 			    $fix) {
-			my $deleted = {
-				LINENR => $fixlinenr,
-				LINE => $rawline,
-			};
-			push(@fixed_deleted, $deleted);
+				fix_delete_line($fixlinenr, $rawline);
 			}
 
 			$last_blank_line = $linenr;
@@ -2509,11 +2522,7 @@ sub process {
 			if (WARN("LINE_SPACING",
 				 "Missing a blank line after declarations\n" . $hereprev) &&
 			    $fix) {
-			my $inserted = {
-				LINENR => $fixlinenr,
-				LINE => "\+",
-			};
-			push(@fixed_inserted, $inserted);
+				fix_insert_line($fixlinenr, "\+");
 			}
 		}
 
@@ -2868,31 +2877,15 @@ sub process {
 		    $prevline =~ /(?:^|[^=])=\s*$/) {
 			if (ERROR("OPEN_BRACE",
 				  "that open brace { should be on the previous line\n" . $hereprev) &&
-			    $fix && $prevline =~ /^\+/) {
-				my $deleted = {
-					LINENR => $fixlinenr - 1,
-					LINE => $prevrawline,
-				};
-				push(@fixed_deleted, $deleted);
-				$deleted = {
-					LINENR => $fixlinenr,
-					LINE => $rawline,
-				};
-				push(@fixed_deleted, $deleted);
+			    $fix && $prevline =~ /^\+/ && $line =~ /^\+/) {
+				fix_delete_line($fixlinenr - 1, $prevrawline);
+				fix_delete_line($fixlinenr, $rawline);
 				my $fixedline = $prevrawline;
 				$fixedline =~ s/\s*=\s*$/ = {/;
-				my $inserted = {
-					LINENR => $fixlinenr,
-					LINE => $fixedline,
-				};
-				push(@fixed_inserted, $inserted);
+				fix_insert_line($fixlinenr, $fixedline);
 				$fixedline = $line;
 				$fixedline =~ s/^(.\s*){\s*/$1/;
-				$inserted = {
-					LINENR => $fixlinenr,
-					LINE => $fixedline,
-				};
-				push(@fixed_inserted, $inserted);
+				fix_insert_line($fixlinenr, $fixedline);
 			}
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are

fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-asus_atk0110-fix-define_simple_attribute-semicolon-definition-and-use.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
printk-tweak-do_syslog-to-match-comments.patch
maintainers-remove-two-ancient-eata-sections.patch
kernelh-remove-deprecated-pack_hex_byte.patch
mm-utilc-add-kstrimdup.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
checkpatch-ignore-email-headers-better.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum-declarations.patch
checkpatch-add-a-multiple-blank-lines-test.patch
checkpatch-change-blank-line-after-declaration-type-to-line_spacing.patch
checkpatch-quiet-kconfig-help-message-checking.patch
checkpatch-warn-on-unnecessary-parentheses-around-references-of-foo-bar.patch
checkpatch-allow-multiple-const-types.patch
checkpatch-improve-no-space-after-cast-test.patch
checkpatch-emit-fewer-kmalloc_array-kcalloc-conversion-warnings.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
checkpatch-emit-a-warning-on-file-add-move-delete.patch
checkpatch-warn-on-break-after-goto-or-return-with-same-tab-indentation.patch
checkpatch-add-an-index-variable-for-fixed-lines.patch
checkpatch-add-ability-to-insert-and-delete-lines-to-patch-file.patch
checkpatch-add-fix_insert_line-and-fix_delete_line-helpers.patch
checkpatch-use-the-correct-indentation-for-which.patch
checkpatch-add-fix-option-for-a-couple-open_brace-misuses.patch
checkpatch-fix-brace-style-misuses-of-else-and-while.patch
fs-isofs-logging-clean-up.patch
proc-constify-seq_operations.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
adfs-add-__printf-verification-fix-format-argument-mismatches.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
linux-next.patch
pci-dma-compat-add-pci_zalloc_consistent-helper.patch
atm-use-pci_zalloc_consistent.patch
block-use-pci_zalloc_consistent.patch
crypto-use-pci_zalloc_consistent.patch
infiniband-use-pci_zalloc_consistent.patch
i810-use-pci_zalloc_consistent.patch
media-use-pci_zalloc_consistent.patch
amd-use-pci_zalloc_consistent.patch
atl1e-use-pci_zalloc_consistent.patch
enic-use-pci_zalloc_consistent.patch
sky2-use-pci_zalloc_consistent.patch
micrel-use-pci_zalloc_consistent.patch
qlogic-use-pci_zalloc_consistent.patch
irda-use-pci_zalloc_consistent.patch
ipw2100-use-pci_zalloc_consistent.patch
mwl8k-use-pci_zalloc_consistent.patch
rtl818x-use-pci_zalloc_consistent.patch
rtlwifi-use-pci_zalloc_consistent.patch
scsi-use-pci_zalloc_consistent.patch
staging-use-pci_zalloc_consistent.patch
synclink_gt-use-pci_zalloc_consistent.patch
vme-bridges-use-pci_zalloc_consistent.patch
amd-neaten-and-remove-unnecessary-oom-messages.patch
maintainers-update-microcode-patterns.patch
maintainers-update-cifs-location.patch
maintainers-use-the-correct-efi-stub-location.patch
maintainers-update-clk-sirf-patterns.patch
maintainers-fix-ssbi-pattern.patch
maintainers-use-correct-filename-for-sdhci-bcm-kona.patch
maintainers-fix-pxa3xx-nand-flash-driver-pattern.patch
maintainers-update-picoxcell-patterns.patch
maintainers-remove-section-cirrus-logic-ep93xx-ohci-usb-host-driver.patch
maintainers-remove-metag-imgdafs-pattern.patch
maintainers-remove-unused-radeon-drm-pattern.patch
maintainers-remove-unusd-arm-qualcomm-msm-pattern.patch
maintainers-remove-unused-nfsd-pattern.patch

