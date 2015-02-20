From: akpm@linux-foundation.org
Subject: +
 checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch added to
 -mm tree
Date: Fri, 20 Feb 2015 13:26:24 -0800
Message-ID: <54e7a680.q0AlIJR0Ny0XANiJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbbBTV0Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Feb 2015 16:26:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mareklindner@neomailbox.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve "no space is necessary after a cast" test
has been added to the -mm tree.  Its filename is
     checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch

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
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
linux-next.patch

