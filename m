From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:08:51 -0700
Message-ID: <53e3dcd3.vZanxc8soZKSMPUx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:56722 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbaHGUIw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:08:52 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so837993oig.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:08:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add test for blank lines after function/struct/union/enum
has been removed from the -mm tree.  Its filename was
     checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add test for blank lines after function/struct/union/enum

Add a --strict test asking for a blank line after
function/struct/union/enum declarations.

Allow exceptions for several attributes and macro uses.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-test-for-blank-lines-after-function-struct-union-enum scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-test-for-blank-lines-after-function-struct-union-enum
+++ a/scripts/checkpatch.pl
@@ -2292,6 +2292,22 @@ sub process {
 			     "networking block comments put the trailing */ on a separate line\n" . $herecurr);
 		}
 
+# check for missing blank lines after struct/union declarations
+# with exceptions for various attributes and macros
+		if ($prevline =~ /^[\+ ]};?\s*$/ &&
+		    $line =~ /^\+/ &&
+		    !($line =~ /^\+\s*$/ ||
+		      $line =~ /^\+\s*EXPORT_SYMBOL/ ||
+		      $line =~ /^\+\s*MODULE_/i ||
+		      $line =~ /^\+\s*\#\s*(?:end|elif|else)/ ||
+		      $line =~ /^\+[a-z_]*init/ ||
+		      $line =~ /^\+\s*(?:static\s+)?[A-Z_]*ATTR/ ||
+		      $line =~ /^\+\s*DECLARE/ ||
+		      $line =~ /^\+\s*__setup/)) {
+			CHK("LINE_SPACING",
+			    "Please use a blank line after function/struct/union/enum declarations\n" . $hereprev);
+		}
+
 # check for missing blank lines after declarations
 		if ($sline =~ /^\+\s+\S/ &&			#Not at char 1
 			# actual declarations
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

