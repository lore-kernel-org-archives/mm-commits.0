From: akpm@linux-foundation.org
Subject: + checkpatch-allow-multiple-const-types.patch added to -mm tree
Date: Fri, 27 Jun 2014 12:00:45 -0700
Message-ID: <53adbf5d.XLc6s4yUOQMjGuB6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:34460 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaF0TAq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jun 2014 15:00:46 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so1235331obb.4
        for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2014 12:00:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, HartleyS@visionengravers.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: allow multiple const * types
has been added to the -mm tree.  Its filename is
     checkpatch-allow-multiple-const-types.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-allow-multiple-const-types.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-allow-multiple-const-types.patch

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
Subject: checkpatch: allow multiple const * types

checkpatch's $Type variable does not match declarations
of multiple const * types.

This can produce false positives for things like:

$ ./scripts/checkpatch.pl -f drivers/staging/comedi/comedidev.h
WARNING: Missing a blank line after declarations
#60: FILE: drivers/staging/comedi/comedidev.h:60:
+       const struct comedi_lrange *range_table;
+       const struct comedi_lrange *const *range_table_list;

Fix the $Type variable to support matching multiple "* const" uses.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Hartley Sweeten <HartleyS@visionengravers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-allow-multiple-const-types scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-allow-multiple-const-types
+++ a/scripts/checkpatch.pl
@@ -435,7 +435,7 @@ sub build_types {
 		  }x;
 	$Type	= qr{
 			$NonptrType
-			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*|\[\])+|(?:\s*\[\s*\])+)?
+			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*\s*(?:const\s*)?|\[\])+|(?:\s*\[\s*\])+)?
 			(?:\s+$Inline|\s+$Modifier)*
 		  }x;
 	$Declare	= qr{(?:$Storage\s+(?:$Inline\s+)?)?$Type};
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
checkpatch-check-git-commit-descriptions.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
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
fs-isofs-logging-clean-up.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
adfs-add-__printf-verification-fix-format-argument-mismatches.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
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

