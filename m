From: akpm@linux-foundation.org
Subject: [merged] checkpatch-prefer-seq_puts-to-seq_printf.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:53:26 -0700
Message-ID: <20130430185326.7367031C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:38900 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133Ab3D3Sx1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:53:27 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so86555vbe.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:53:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bhelgaas@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: Prefer seq_puts to seq_printf
has been removed from the -mm tree.  Its filename was
     checkpatch-prefer-seq_puts-to-seq_printf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: Prefer seq_puts to seq_printf

Add a check for seq_printf use with a constant format without additional
arguments.  Suggest seq_puts instead.

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-prefer-seq_puts-to-seq_printf scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-prefer-seq_puts-to-seq_printf
+++ a/scripts/checkpatch.pl
@@ -628,6 +628,13 @@ sub sanitise_line {
 	return $res;
 }
 
+sub get_quoted_string {
+	my ($line, $rawline) = @_;
+
+	return "" if ($line !~ m/(\"[X]+\")/g);
+	return substr($rawline, $-[0], $+[0] - $-[0]);
+}
+
 sub ctx_statement_block {
 	my ($linenr, $remain, $off) = @_;
 	my $line = $linenr - 1;
@@ -3373,6 +3380,15 @@ sub process {
 			     "struct spinlock should be spinlock_t\n" . $herecurr);
 		}
 
+# check for seq_printf uses that could be seq_puts
+		if ($line =~ /\bseq_printf\s*\(/) {
+			my $fmt = get_quoted_string($line, $rawline);
+			if ($fmt !~ /[^\\]\%/) {
+				WARN("PREFER_SEQ_PUTS",
+				     "Prefer seq_puts to seq_printf\n" . $herecurr);
+			}
+		}
+
 # Check for misused memsets
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-usb-storage-realtek_crc-fix-build.patch
hfs-hfsplus-convert-dprint-to-hfs_dbg.patch
hfs-hfsplus-convert-printks-to-pr_level.patch
kexec-fix-wrong-types-of-some-local-variables.patch
kexec-use-min_t-to-simplify-logic.patch
kexec-use-min_t-to-simplify-logic-fix.patch

