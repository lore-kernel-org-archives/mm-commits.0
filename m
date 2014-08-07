From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-fix_insert_line-and-fix_delete_line-helpers.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:09:17 -0700
Message-ID: <53e3dced.HgvV6sVv0KuBrxBA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f73.google.com ([209.85.218.73]:38318 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454AbaHGUJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:09:18 -0400
Received: by mail-oi0-f73.google.com with SMTP id u20so838829oif.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:09:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add fix_insert_line and fix_delete_line helpers
has been removed from the -mm tree.  Its filename was
     checkpatch-add-fix_insert_line-and-fix_delete_line-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

