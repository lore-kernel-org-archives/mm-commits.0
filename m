From: akpm@linux-foundation.org
Subject: +
 checkpatch-emit-fewer-kmalloc_array-kcalloc-conversion-warnings.patch added to -mm tree
Date: Tue, 01 Jul 2014 14:36:40 -0700
Message-ID: <53b329e8.MsyQsa9rKgTFIGmv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:43523 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbaGAVgl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2014 17:36:41 -0400
Received: by mail-ve0-f202.google.com with SMTP id oy12so1110218veb.5
        for <mm-commits@vger.kernel.org>; Tue, 01 Jul 2014 14:36:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, fabf@skynet.be, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: emit fewer kmalloc_array/kcalloc conversion warnings
has been added to the -mm tree.  Its filename is
     checkpatch-emit-fewer-kmalloc_array-kcalloc-conversion-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-emit-fewer-kmalloc_array-kcalloc-conversion-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-emit-fewer-kmalloc_array-kcalloc-conversion-warnings.patch

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
Subject: checkpatch: emit fewer kmalloc_array/kcalloc conversion warnings

Avoid matching allocs that appear to be known small multiplications of a
sizeof with a constant because gcc as of 4.8 cannot optimize the code in a
calloc() exactly the same way as an alloc().

Look for numeric constants or what appear to be upper case only macro
#defines.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Theodore Ts'o <tytso@mit.edu>
Original-patch-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-emit-fewer-kmalloc_array-kcalloc-conversion-warnings scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-emit-fewer-kmalloc_array-kcalloc-conversion-warnings
+++ a/scripts/checkpatch.pl
@@ -4495,22 +4495,23 @@ sub process {
 
 # check for k[mz]alloc with multiplies that could be kmalloc_array/kcalloc
 		if ($^V && $^V ge 5.10.0 &&
-		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/) {
+		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)\s*,/) {
 			my $oldfunc = $3;
 			my $a1 = $4;
 			my $a2 = $10;
 			my $newfunc = "kmalloc_array";
 			$newfunc = "kcalloc" if ($oldfunc eq "kzalloc");
-			if ($a1 =~ /^sizeof\s*\S/ || $a2 =~ /^sizeof\s*\S/) {
+			my $r1 = $a1;
+			my $r2 = $a2;
+			if ($a1 =~ /^sizeof\s*\S/) {
+				$r1 = $a2;
+				$r2 = $a1;
+			}
+			if ($r1 !~ /^sizeof\b/ && $r2 =~ /^sizeof\s*\S/ &&
+			    !($r1 =~ /^$Constant$/ || $r1 =~ /^[A-Z_][A-Z0-9_]*$/)) {
 				if (WARN("ALLOC_WITH_MULTIPLY",
 					 "Prefer $newfunc over $oldfunc with multiply\n" . $herecurr) &&
 				    $fix) {
-					my $r1 = $a1;
-					my $r2 = $a2;
-					if ($a1 =~ /^sizeof\s*\S/) {
-						$r1 = $a2;
-						$r2 = $a1;
-					}
 					$fixed[$linenr - 1] =~ s/\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/$1 . ' = ' . "$newfunc(" . trim($r1) . ', ' . trim($r2)/e;
 
 				}
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-check-git-commit-descriptions.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-asus_atk0110-fix-define_simple_attribute-semicolon-definition-and-use.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
printk-tweak-do_syslog-to-match-comments.patch
maintainers-remove-two-ancient-eata-sections.patch
mm-utilc-add-kstrimdup.patch
kernelh-remove-deprecated-pack_hex_byte.patch
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

