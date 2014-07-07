From: akpm@linux-foundation.org
Subject: + checkpatch-emit-a-warning-on-file-add-move-delete.patch added
 to -mm tree
Date: Mon, 07 Jul 2014 15:59:11 -0700
Message-ID: <53bb263f.EfiWfToPRU9eDz4r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:47058 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaGGW7M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 18:59:12 -0400
Received: by mail-ie0-f201.google.com with SMTP id rl12so667508iec.4
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 15:59:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: emit a warning on file add/move/delete
has been added to the -mm tree.  Its filename is
     checkpatch-emit-a-warning-on-file-add-move-delete.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-emit-a-warning-on-file-add-move-delete.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-emit-a-warning-on-file-add-move-delete.patch

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
Subject: checkpatch: emit a warning on file add/move/delete

Whenever files are added, moved, or deleted, the MAINTAINERS file patterns
can be out of sync or outdated.

To try to keep MAINTAINERS more up-to-date, add a one-time warning
whenever a patch does any of those.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-emit-a-warning-on-file-add-move-delete scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-emit-a-warning-on-file-add-move-delete
+++ a/scripts/checkpatch.pl
@@ -1679,7 +1679,7 @@ sub process {
 
 	my $in_header_lines = $file ? 0 : 1;
 	my $in_commit_log = 0;		#Scanning lines before patch
-
+	my $reported_maintainer_file = 0;
 	my $non_utf8_charset = 0;
 
 	my $last_blank_line = 0;
@@ -2012,6 +2012,17 @@ sub process {
 			      "Please use 12 to 16 chars for the git commit ID like: '${init_char}ommit $id (\"$desc\")'\n" . $herecurr);
 		}
 
+# Check for added, moved or deleted files
+		if (!$reported_maintainer_file && !$in_commit_log &&
+		    ($line =~ /^(?:new|deleted) file mode\s*\d+\s*$/ ||
+		     $line =~ /^rename (?:from|to) [\w\/\.\-]+\s*$/ ||
+		     ($line =~ /\{\s*([\w\/\.\-]*)\s*\=\>\s*([\w\/\.\-]*)\s*\}/ &&
+		      (defined($1) || defined($2))))) {
+			$reported_maintainer_file = 1;
+			WARN("FILE_PATH_CHANGES",
+			     "added, moved or deleted file(s), does MAINTAINERS need updating?\n" . $herecurr);
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

