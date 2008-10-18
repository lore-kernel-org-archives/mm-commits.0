From: akpm@linux-foundation.org
Subject: - checkpatch-check-line-endings-in-text-format-files.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:48 -0700
Message-ID: <200810182313.m9INDmVR028264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471AbYJRXN4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: check line endings in text format files
has been removed from the -mm tree.  Its filename was
     checkpatch-check-line-endings-in-text-format-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: check line endings in text format files
From: Andy Whitcroft <apw@shadowen.org>

Firmware may be included in the kernel as .ihex files.  These are
inherantly text, but not source.  The line ending checks are applicable to
these kinds of file, allow just these checks to apply to all files.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-check-line-endings-in-text-format-files scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-line-endings-in-text-format-files
+++ a/scripts/checkpatch.pl
@@ -1241,9 +1241,6 @@ sub process {
 #ignore lines being removed
 		if ($line=~/^-/) {next;}
 
-# check we are in a valid source file if not then ignore this hunk
-		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
