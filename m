From: akpm@linux-foundation.org
Subject: [to-be-updated] checkpatch-check-git-commit-descriptions.patch
 removed from -mm tree
Date: Wed, 02 Jul 2014 15:03:16 -0700
Message-ID: <53b481a4.5Axd4fO0Edfb5C25%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:62626 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaGBWDR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2014 18:03:17 -0400
Received: by mail-yh0-f73.google.com with SMTP id f10so1364227yha.4
        for <mm-commits@vger.kernel.org>; Wed, 02 Jul 2014 15:03:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: check git commit descriptions
has been removed from the -mm tree.  Its filename was
     checkpatch-check-git-commit-descriptions.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: check git commit descriptions

On Mon, 2014-06-02 at 13:49 -0700, Andrew Morton wrote:
> On Mon,  2 Jun 2014 19:54:13 +0800 Chen Yucong <slaoub@gmail.com> wrote:
>
> > >From commit ebc2a1a69111, we can find that all SWP_SOLIDSTATE "seek is cheap"(SSD case)
>
> grr.  I spend a lot of time (well, a bit of time) looking up git commit
> IDs and converting them into canonical form
>
> 	ebc2a1a69111 ("swap: make cluster allocation per-cpu")
>
> I wonder if there's a way of teaching checkpatch to do this.  Would
> need some heuristic to detect a hex string, and some way of avoiding
> all the other hex strings which appear in changelogs.
>
> Doesn't sound feasible now I think about it.

Maybe some check like
---
 1 file changed, 8 insertions(+)

index 7774025..e31d0c4 100755

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-check-git-commit-descriptions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-git-commit-descriptions
+++ a/scripts/checkpatch.pl
@@ -1956,6 +1956,14 @@ sub process {
 			      "Remove Gerrit Change-Id's before submitting upstream.\n" . $herecurr);
 		}
 
+# Check for improperly formed commit descriptions
+		if ($in_commit_log &&
+		    $line =~ /\bcommit\s+[0-9a-f]{5,}/i &&
+		    $line !~ /\bcommit [0-9a-f]{12,16} \("/) {
+			ERROR("GIT_COMMIT_ID",
+			      "Please use 12-16 chars for the git commit IDs like 'commit 0123456789ab (\"commit description\"\)'\n" . $herecurr);
+		}
+
 # Check for wrappage within a valid hunk of the file
 		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |\\ No newline|$)}) {
 			ERROR("CORRUPTED_PATCH",
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
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
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

