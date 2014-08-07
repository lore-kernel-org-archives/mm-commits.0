From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-fix-brace-style-misuses-of-else-and-while.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:09:23 -0700
Message-ID: <53e3dcf3.6PFhK7EDcTJ0un5D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:40306 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbaHGUJY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:09:24 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so607442vcb.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:09:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix brace style misuses of else and while
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-brace-style-misuses-of-else-and-while.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mm-utilc-add-kstrimdup.patch
fs-befs-linuxvfsc-check-superblock-before-dump-operation.patch
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
maintainers-remove-two-ancient-eata-sections.patch
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
fsh-remove-unnecessary-extern-prototypes.patch
fsh-whitespace-neatening.patch
fsh-a-few-more-whitespace-neatenings.patch
fsh-add-argument-names-to-struct-file_lock_operations-funcs.patch
fsh-add-member-argument-descriptions-to-lock_manager_operations.patch
dlm-plock-add-argument-descriptions-to-notify.patch
dlm-fs-remove-unused-conf-from-lm_grant.patch
dlm-plock-reduce-indentation-by-rearranging-order.patch
maintainers-update-dma-buffer-sharing-patterns.patch
maintainers-update-usb-gadget-patterns.patch
maintainers-update-nomadik-patterns.patch

