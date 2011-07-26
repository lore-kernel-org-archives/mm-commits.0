From: akpm@linux-foundation.org
Subject: [merged] checkpatch-make-utf-8-test-strict.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:56:11 -0700
Message-ID: <201107260755.p6Q7tELt003440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753081Ab1GZH4D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:56:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: make utf-8 test --strict
has been removed from the -mm tree.  Its filename was
     checkpatch-make-utf-8-test-strict.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: make utf-8 test --strict
From: Joe Perches <joe@perches.com>

Some patches are sent in using ISO-8859 or even Windows codepage 1252.

Make checkpatch accept these by default and only emit the "Invalid UTF-8"
message when using --strict.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-make-utf-8-test-strict scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-make-utf-8-test-strict
+++ a/scripts/checkpatch.pl
@@ -1609,8 +1609,8 @@ sub process {
 			my $ptr = substr($blank, 0, length($utf8_prefix)) . "^";
 			my $hereptr = "$hereline$ptr\n";
 
-			ERROR("INVALID_UTF8",
-			      "Invalid UTF-8, patch and commit message should be encoded in UTF-8\n" . $hereptr);
+			CHK("INVALID_UTF8",
+			    "Invalid UTF-8, patch and commit message should be encoded in UTF-8\n" . $hereptr);
 		}
 
 # ignore non-hunk lines and lines being removed
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-orphan-framerelay-dlci.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
ramoops-add-new-line-to-each-print.patch

