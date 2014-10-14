From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-strict-test-for-concatenated-string-elements.patch removed
 from -mm tree
Date: Tue, 14 Oct 2014 11:19:43 -0700
Message-ID: <543d693f.PE6+58l/N4FA4eje%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbaJNSTl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --strict test for concatenated string elements
has been removed from the -mm tree.  Its filename was
     checkpatch-add-strict-test-for-concatenated-string-elements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add --strict test for concatenated string elements

Using a space between concatenated string elements is easier for a human
to read.

ie:
	"String"FOO"bar"

is easier to read as:

	"String" FOO "bar"

So suggest this style with a --strict command line option.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-strict-test-for-concatenated-string-elements scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-strict-test-for-concatenated-string-elements
+++ a/scripts/checkpatch.pl
@@ -4344,6 +4344,12 @@ sub process {
 			     "Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt\n" . $herecurr);
 		}
 
+# concatenated string without spaces between elements
+		if ($line =~ /"X+"[A-Z_]+/ || $line =~ /[A-Z_]+"X+"/) {
+			CHK("CONCATENATED_STRING",
+			    "Concatenated strings should use spaces between elements\n" . $herecurr);
+		}
+
 # warn about #if 0
 		if ($line =~ /^.\s*\#\s*if\s+0\b/) {
 			CHK("REDUNDANT_CODE",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

