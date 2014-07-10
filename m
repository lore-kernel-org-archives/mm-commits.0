From: akpm@linux-foundation.org
Subject: + checkpatch-fix-brace-style-misuses-of-else-and-while.patch
 added to -mm tree
Date: Thu, 10 Jul 2014 14:29:20 -0700
Message-ID: <53bf05b0./qubBcqJgwJUeltK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:48566 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaGJV3V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Jul 2014 17:29:21 -0400
Received: by mail-oa0-f74.google.com with SMTP id o6so49104oag.1
        for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2014 14:29:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix brace style misuses of else and while
has been added to the -mm tree.  Its filename is
     checkpatch-fix-brace-style-misuses-of-else-and-while.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-brace-style-misuses-of-else-and-while.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-brace-style-misuses-of-else-and-while.patch

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
Subject: checkpatch: fix brace style misuses of else and while

Add --fix corrections for ELSE_AFTER_BRACE and WHILE_AFTER_BRACE
misuses.

	if (x) {
		...
	}
	else {
		...
	}
is corrected to
	if (x) {
		...
	} else {
		...
	}

and

	do {
		...
	}
	while (x);
is corrected to
	do {
		...
	} while (x);

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-brace-style-misuses-of-else-and-while scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-brace-style-misuses-of-else-and-while
+++ a/scripts/checkpatch.pl
@@ -3885,14 +3885,26 @@ sub process {
 
 		# Check for }<nl>else {, these must be at the same
 		# indent level to be relevant to each other.
-		if ($prevline=~/}\s*$/ and $line=~/^.\s*else\s*/ and
-						$previndent == $indent) {
-			ERROR("ELSE_AFTER_BRACE",
-			      "else should follow close brace '}'\n" . $hereprev);
+		if ($prevline=~/}\s*$/ and $line=~/^.\s*else\s*/ &&
+		    $previndent == $indent) {
+			if (ERROR("ELSE_AFTER_BRACE",
+				  "else should follow close brace '}'\n" . $hereprev) &&
+			    $fix && $prevline =~ /^\+/ && $line =~ /^\+/) {
+				fix_delete_line($fixlinenr - 1, $prevrawline);
+				fix_delete_line($fixlinenr, $rawline);
+				my $fixedline = $prevrawline;
+				$fixedline =~ s/}\s*$//;
+				if ($fixedline !~ /^\+\s*$/) {
+					fix_insert_line($fixlinenr, $fixedline);
+				}
+				$fixedline = $rawline;
+				$fixedline =~ s/^(.\s*)else/$1} else/;
+				fix_insert_line($fixlinenr, $fixedline);
+			}
 		}
 
-		if ($prevline=~/}\s*$/ and $line=~/^.\s*while\s*/ and
-						$previndent == $indent) {
+		if ($prevline=~/}\s*$/ and $line=~/^.\s*while\s*/ &&
+		    $previndent == $indent) {
 			my ($s, $c) = ctx_statement_block($linenr, $realcnt, 0);
 
 			# Find out what is on the end of the line after the
@@ -3901,8 +3913,18 @@ sub process {
 			$s =~ s/\n.*//g;
 
 			if ($s =~ /^\s*;/) {
-				ERROR("WHILE_AFTER_BRACE",
-				      "while should follow close brace '}'\n" . $hereprev);
+				if (ERROR("WHILE_AFTER_BRACE",
+					  "while should follow close brace '}'\n" . $hereprev) &&
+				    $fix && $prevline =~ /^\+/ && $line =~ /^\+/) {
+					fix_delete_line($fixlinenr - 1, $prevrawline);
+					fix_delete_line($fixlinenr, $rawline);
+					my $fixedline = $prevrawline;
+					my $trailing = $rawline;
+					$trailing =~ s/^\+//;
+					$trailing = trim($trailing);
+					$fixedline =~ s/}\s*$/} $trailing/;
+					fix_insert_line($fixlinenr, $fixedline);
+				}
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

