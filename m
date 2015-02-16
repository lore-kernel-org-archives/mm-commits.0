From: akpm@linux-foundation.org
Subject: [merged] checkpatch-improve-seq_print-seq_puts-suggestion.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:17:27 -0800
Message-ID: <54e25057.YJda4o88KdhA2ddv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbbBPUSD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:18:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heba93aamer@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve seq_print->seq_puts suggestion
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-seq_print-seq_puts-suggestion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heba Aamer <heba93aamer@gmail.com>
Subject: checkpatch: improve seq_print->seq_puts suggestion

Improve the format specifier test by removing any %% before looking for
any remaining % format specifier.

Signed-off-by: Heba Aamer <heba93aamer@gmail.com>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-seq_print-seq_puts-suggestion scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-seq_print-seq_puts-suggestion
+++ a/scripts/checkpatch.pl
@@ -4854,7 +4854,8 @@ sub process {
 # check for seq_printf uses that could be seq_puts
 		if ($sline =~ /\bseq_printf\s*\(.*"\s*\)\s*;\s*$/) {
 			my $fmt = get_quoted_string($line, $rawline);
-			if ($fmt ne "" && $fmt !~ /[^\\]\%/) {
+			$fmt =~ s/%%//g;
+			if ($fmt !~ /%/) {
 				if (WARN("PREFER_SEQ_PUTS",
 					 "Prefer seq_puts to seq_printf\n" . $herecurr) &&
 				    $fix) {
_

Patches currently in -mm which might be from heba93aamer@gmail.com are

origin.patch

