From: akpm@linux-foundation.org
Subject: + checkpatch-prefer-seq_puts-to-seq_printf.patch added to -mm tree
Date: Tue, 19 Mar 2013 13:26:28 -0700
Message-ID: <20130319202628.711F131C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:64840 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944Ab3CSU03 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 16:26:29 -0400
Received: by mail-gg0-f201.google.com with SMTP id l2so87550ggn.4
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 13:26:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bhelgaas@google.com


The patch titled
     Subject: checkpatch: Prefer seq_puts to seq_printf
has been added to the -mm tree.  Its filename is
     checkpatch-prefer-seq_puts-to-seq_printf.patch

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
@@ -3372,6 +3379,15 @@ sub process {
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

linux-next.patch
get_maintainer-use-filename-only-regex-match-for-tegra.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
checkpatch-add-check-for-reuse-of-krealloc-arg.patch
checkpatch-prefer-seq_puts-to-seq_printf.patch
kexec-fix-wrong-types-of-some-local-variables.patch
kexec-use-min_t-to-simplify-logic.patch
kexec-use-min_t-to-simplify-logic-fix.patch

