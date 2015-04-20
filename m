From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch removed
 from -mm tree
Date: Mon, 20 Apr 2015 12:16:49 -0700
Message-ID: <553550a1.nOwxMRSd82H1KftW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbbDTTK2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:10:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mareklindner@neomailbox.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve "no space is necessary after a cast" test
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve "no space is necessary after a cast" test

The "no space is necessary after a cast" sizeof exclusion doesn't work
properly.

The test reports a false positive for code like:

	BUILD_BUG_ON(sizeof(struct batadv_bla_claim_dst) != 6);

Make it work, simplify the exclusions, and add some comments.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-no-space-is-necessary-after-a-cast-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-no-space-is-necessary-after-a-cast-test
+++ a/scripts/checkpatch.pl
@@ -2552,8 +2552,15 @@ sub process {
 			}
 		}
 
-		if ($line =~ /^\+.*(\w+\s*)?\(\s*$Type\s*\)[ \t]+(?!$Assignment|$Arithmetic|[,;:\?\(\{\}\[\<\>]|&&|\|\||\\$)/ &&
-		    (!defined($1) || $1 !~ /sizeof\s*/)) {
+# check for space after cast like "(int) foo" or "(struct foo) bar"
+# avoid checking a few false positives:
+#   "sizeof(<type>)" or "__alignof__(<type>)"
+#   function pointer declarations like "(*foo)(int) = bar;"
+#   structure definitions like "(struct foo) { 0 };"
+#   multiline macros that define functions
+#   known attributes or the __attribute__ keyword
+		if ($line =~ /^\+(.*)\(\s*$Type\s*\)([ \t]++)((?![={]|\\$|$Attribute|__attribute__))/ &&
+		    (!defined($1) || $1 !~ /\b(?:sizeof|__alignof__)\s*$/)) {
 			if (CHK("SPACING",
 				"No space is necessary after a cast\n" . $herecurr) &&
 			    $fix) {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

