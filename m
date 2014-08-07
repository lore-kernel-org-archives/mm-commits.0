From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:08:41 -0700
Message-ID: <53e3dcc9.Z74EWmRkZfKmCwJL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:39444 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaHGUIm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:08:42 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so879097igd.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:08:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: attempt to find unnecessary 'out of memory' messages
has been removed from the -mm tree.  Its filename was
     checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: attempt to find unnecessary 'out of memory' messages

Logging messages that show some type of "out of memory" error
are generally unnecessary as there is a generic message and
a stack dump done by the memory subsystem.

These messages generally increase kernel size without much
added value.

Emit a warning on these types of messages.

This test looks for any inserted message function, then looks
at the previous line for an "if (!foo)" or "if (foo == NULL)"
test and then looks at the preceding statement for an allocation
function like "foo = kmalloc()"

ie: this code matches:

	foo = kmalloc();
	if (foo == NULL) {
		printk("Out of memory\n");
		return -ENOMEM;
	}

This test is very crude and incomplete.

This test can miss quite a lot of of OOM messages that do not
have this specific form.

ie: this code does not match:

	foo = kmalloc();
	if (!foo) {
		rtn = -ENOMEM;
		printk("Out of memory!\n");
		goto out;
	}

This test could also be a false positive when the logging
message itself does not specify anything about memory, but
I did not find any false positives in my limited testing.

spatch could be a better solution but correctness seems
non-trivial for that tool too.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-attempt-to-find-unnecessary-out-of-memory-messages scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-attempt-to-find-unnecessary-out-of-memory-messages
+++ a/scripts/checkpatch.pl
@@ -4014,6 +4014,23 @@ sub process {
 			}
 		}
 
+# check for unnecessary "Out of Memory" messages
+		if ($line =~ /^\+.*\b$logFunctions\s*\(/ &&
+		    $prevline =~ /^[ \+]\s*if\s*\(\s*(\!\s*|NULL\s*==\s*)?($Lval)(\s*==\s*NULL\s*)?\s*\)/ &&
+		    (defined $1 || defined $3) &&
+		    $linenr > 3) {
+			my $testval = $2;
+			my $testline = $lines[$linenr - 3];
+
+			my ($s, $c) = ctx_statement_block($linenr - 3, $realcnt, 0);
+#			print("line: <$line>\nprevline: <$prevline>\ns: <$s>\nc: <$c>\n\n\n");
+
+			if ($c =~ /(?:^|\n)[ \+]\s*(?:$Type\s*)?\Q$testval\E\s*=\s*(?:\([^\)]*\)\s*)?\s*(?:devm_)?(?:[kv][czm]alloc(?:_node|_array)?\b|kstrdup|(?:dev_)?alloc_skb)/) {
+				WARN("OOM_MESSAGE",
+				     "Possible unnecessary 'out of memory' message\n" . $hereprev);
+			}
+		}
+
 # check for bad placement of section $InitAttribute (e.g.: __initdata)
 		if ($line =~ /(\b$InitAttribute\b)/) {
 			my $attr = $1;
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

