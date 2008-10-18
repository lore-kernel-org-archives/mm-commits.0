From: akpm@linux-foundation.org
Subject: - checkpatch-suppress-errors-triggered-by-short-patch.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:44 -0700
Message-ID: <200810182313.m9INDibF028248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751453AbYJRXNy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, brunel@diku.dk, mm-commits@vger.kernel.org


The patch titled
     checkpatch: suppress errors triggered by short patch
has been removed from the -mm tree.  Its filename was
     checkpatch-suppress-errors-triggered-by-short-patch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: suppress errors triggered by short patch
From: Andy Whitcroft <apw@shadowen.org>

When the last hunk of a patch is short it will trigger errors from
checkpatch:

    Use of uninitialized value in pattern match (m//)
	    at /usr/local/bin/checkpatch.pl line 394.
    Use of uninitialized value in concatenation (.) or string
	    at /usr/local/bin/checkpatch.pl line 397.
    Use of uninitialized value in pattern match (m//)

Avoid touching beyond the last line.  Reported by Julien Brunel.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Julien Brunel <brunel@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-suppress-errors-triggered-by-short-patch scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-suppress-errors-triggered-by-short-patch
+++ a/scripts/checkpatch.pl
@@ -408,6 +408,7 @@ sub ctx_statement_block {
 		# context.
 		if ($off >= $len) {
 			for (; $remain > 0; $line++) {
+				last if (!defined $lines[$line]);
 				next if ($lines[$line] =~ /^-/);
 				$remain--;
 				$loff = $len;
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

