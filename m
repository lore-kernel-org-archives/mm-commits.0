From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-fix-option-for-a-couple-open_brace-misuses.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:09:21 -0700
Message-ID: <53e3dcf1./2FqZjt+R/i0b3Xc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:34300 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454AbaHGUJW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:09:22 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so842076obc.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:09:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --fix option for a couple OPEN_BRACE misuses
has been removed from the -mm tree.  Its filename was
     checkpatch-add-fix-option-for-a-couple-open_brace-misuses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add --fix option for a couple OPEN_BRACE misuses

Style misuses of these types are corrected:

typedef struct foo
{
	int bar;
};

int foo(int bar) { return bar+1;
}

int foo(int bar) {
	return bar+1;
}

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-fix-option-for-a-couple-open_brace-misuses scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-fix-option-for-a-couple-open_brace-misuses
+++ a/scripts/checkpatch.pl
@@ -3164,17 +3164,40 @@ sub process {
 
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
-		if (($line=~/$Type\s*$Ident\(.*\).*\s{/) and
+		if (($line=~/$Type\s*$Ident\(.*\).*\s*{/) and
 		    !($line=~/\#\s*define.*do\s{/) and !($line=~/}/)) {
-			ERROR("OPEN_BRACE",
-			      "open brace '{' following function declarations go on the next line\n" . $herecurr);
+			if (ERROR("OPEN_BRACE",
+				  "open brace '{' following function declarations go on the next line\n" . $herecurr) &&
+			    $fix) {
+				fix_delete_line($fixlinenr, $rawline);
+				my $fixed_line = $rawline;
+				$fixed_line =~ /(^..*$Type\s*$Ident\(.*\)\s*){(.*)$/;
+				my $line1 = $1;
+				my $line2 = $2;
+				fix_insert_line($fixlinenr, ltrim($line1));
+				fix_insert_line($fixlinenr, "\+{");
+				if ($line2 !~ /^\s*$/) {
+					fix_insert_line($fixlinenr, "\+\t" . trim($line2));
+				}
+			}
 		}
 
 # open braces for enum, union and struct go on the same line.
 		if ($line =~ /^.\s*{/ &&
 		    $prevline =~ /^.\s*(?:typedef\s+)?(enum|union|struct)(?:\s+$Ident)?\s*$/) {
-			ERROR("OPEN_BRACE",
-			      "open brace '{' following $1 go on the same line\n" . $hereprev);
+			if (ERROR("OPEN_BRACE",
+				  "open brace '{' following $1 go on the same line\n" . $hereprev) &&
+			    $fix && $prevline =~ /^\+/ && $line =~ /^\+/) {
+				fix_delete_line($fixlinenr - 1, $prevrawline);
+				fix_delete_line($fixlinenr, $rawline);
+				my $fixedline = rtrim($prevrawline) . " {";
+				fix_insert_line($fixlinenr, $fixedline);
+				$fixedline = $rawline;
+				$fixedline =~ s/^(.\s*){\s*/$1\t/;
+				if ($fixedline !~ /^\+\s*$/) {
+					fix_insert_line($fixlinenr, $fixedline);
+				}
+			}
 		}
 
 # missing space after union, struct or enum definition
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

