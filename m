From: akpm@linux-foundation.org
Subject: + checkpatch-improve-seq_print-seq_puts-suggestion.patch added to -mm tree
Date: Mon, 02 Feb 2015 15:21:24 -0800
Message-ID: <54d00674.Nxa9mvvlqytd8OSs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbbBBXVZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2015 18:21:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heba93aamer@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve seq_print->seq_puts suggestion
has been added to the -mm tree.  Its filename is
     checkpatch-improve-seq_print-seq_puts-suggestion.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-seq_print-seq_puts-suggestion.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-seq_print-seq_puts-suggestion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-improve-seq_print-seq_puts-suggestion.patch
linux-next.patch

