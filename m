From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-test-for-native-c90-types-in-unusual-order.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:09:31 -0700
Message-ID: <53e3dcfb.W+ca+FbO6X10+Cic%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:36453 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaHGUJc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:09:32 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so1177134pdj.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:09:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add test for native c90 types in unusual order
has been removed from the -mm tree.  Its filename was
     checkpatch-add-test-for-native-c90-types-in-unusual-order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add test for native c90 types in unusual order

c90 section "6.7.2 Type Specifiers" says:
    "type specifiers may occur in any order"

That means that:
    short int is the same as int short
    unsigned short int is the same as int unsigned short
    etc...

checkpatch currently parses only a subset of these allowed types.

For instance: "unsigned short" and "signed short" are found by checkpatch
as a specific type, but none of the or "int short" or "int signed short"
variants are found.

Add another table for the "kernel style misordered" variants.

Add this misordered table to the findable types.

Warn when the misordered style is used.

This improves the "Missing a blank line after declarations" test as it
depends on the correct parsing of the $Declare variable which looks for
"$Type $Ident;" (ie: declarations like "int foo;").

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   44 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-test-for-native-c90-types-in-unusual-order scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-test-for-native-c90-types-in-unusual-order
+++ a/scripts/checkpatch.pl
@@ -309,9 +309,12 @@ our $Operators	= qr{
 our $c90_Keywords = qr{do|for|while|if|else|return|goto|continue|switch|default|case|break}x;
 
 our $NonptrType;
+our $NonptrTypeMisordered;
 our $NonptrTypeWithAttr;
 our $Type;
+our $TypeMisordered;
 our $Declare;
+our $DeclareMisordered;
 
 our $NON_ASCII_UTF8	= qr{
 	[\xC2-\xDF][\x80-\xBF]               # non-overlong 2-byte
@@ -353,6 +356,25 @@ our $signature_tags = qr{(?xi:
 	Cc:
 )};
 
+our @typeListMisordered = (
+	qr{char\s+(?:un)?signed},
+	qr{int\s+(?:(?:un)?signed\s+)?short\s},
+	qr{int\s+short(?:\s+(?:un)?signed)},
+	qr{short\s+int(?:\s+(?:un)?signed)},
+	qr{(?:un)?signed\s+int\s+short},
+	qr{short\s+(?:un)?signed},
+	qr{long\s+int\s+(?:un)?signed},
+	qr{int\s+long\s+(?:un)?signed},
+	qr{long\s+(?:un)?signed\s+int},
+	qr{int\s+(?:un)?signed\s+long},
+	qr{int\s+(?:un)?signed},
+	qr{int\s+long\s+long\s+(?:un)?signed},
+	qr{long\s+long\s+int\s+(?:un)?signed},
+	qr{long\s+long\s+(?:un)?signed\s+int},
+	qr{long\s+long\s+(?:un)?signed},
+	qr{long\s+(?:un)?signed},
+);
+
 our @typeList = (
 	qr{void},
 	qr{(?:(?:un)?signed\s+)?char},
@@ -373,6 +395,7 @@ our @typeList = (
 	qr{${Ident}_t},
 	qr{${Ident}_handler},
 	qr{${Ident}_handler_fn},
+	@typeListMisordered,
 );
 our @typeListWithAttr = (
 	@typeList,
@@ -414,6 +437,7 @@ our $allowed_asm_includes = qr{(?x:
 sub build_types {
 	my $mods = "(?x:  \n" . join("|\n  ", @modifierList) . "\n)";
 	my $all = "(?x:  \n" . join("|\n  ", @typeList) . "\n)";
+	my $Misordered = "(?x:  \n" . join("|\n  ", @typeListMisordered) . "\n)";
 	my $allWithAttr = "(?x:  \n" . join("|\n  ", @typeListWithAttr) . "\n)";
 	$Modifier	= qr{(?:$Attribute|$Sparse|$mods)};
 	$NonptrType	= qr{
@@ -425,6 +449,13 @@ sub build_types {
 			)
 			(?:\s+$Modifier|\s+const)*
 		  }x;
+	$NonptrTypeMisordered	= qr{
+			(?:$Modifier\s+|const\s+)*
+			(?:
+				(?:${Misordered}\b)
+			)
+			(?:\s+$Modifier|\s+const)*
+		  }x;
 	$NonptrTypeWithAttr	= qr{
 			(?:$Modifier\s+|const\s+)*
 			(?:
@@ -439,7 +470,13 @@ sub build_types {
 			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*\s*(?:const\s*)?|\[\])+|(?:\s*\[\s*\])+)?
 			(?:\s+$Inline|\s+$Modifier)*
 		  }x;
+	$TypeMisordered	= qr{
+			$NonptrTypeMisordered
+			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*\s*(?:const\s*)?|\[\])+|(?:\s*\[\s*\])+)?
+			(?:\s+$Inline|\s+$Modifier)*
+		  }x;
 	$Declare	= qr{(?:$Storage\s+(?:$Inline\s+)?)?$Type};
+	$DeclareMisordered	= qr{(?:$Storage\s+(?:$Inline\s+)?)?$TypeMisordered};
 }
 build_types();
 
@@ -2987,6 +3024,13 @@ sub process {
 			}
 		}
 
+# check for misordered declarations of char/short/int/long with signed/unsigned
+		while ($sline =~ m{(\b$TypeMisordered\b)}g) {
+			my $tmp = trim($1);
+			WARN("MISORDERED_TYPE",
+			     "type '$tmp' should be specified in [[un]signed] [short|int|long|long long] order\n" . $herecurr);
+		}
+
 # check for static const char * arrays.
 		if ($line =~ /\bstatic\s+const\s+char\s*\*\s*(\w+)\s*\[\s*\]\s*=\s*/) {
 			WARN("STATIC_CONST_CHAR_ARRAY",
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

