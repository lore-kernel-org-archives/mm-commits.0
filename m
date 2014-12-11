From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-test-for-consecutive-string-fragments.patch removed from -mm tree
Date: Thu, 11 Dec 2014 11:05:41 -0800
Message-ID: <5489eb05.Wu7NQIC3VU2tqkTu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45695 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbaLKTFm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:05:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add test for consecutive string fragments
has been removed from the -mm tree.  Its filename was
     checkpatch-add-test-for-consecutive-string-fragments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add test for consecutive string fragments

Emit a warning when single line string coalescing occurs.

Code that uses compiler string concatenation on a single line like:
	printk("foo" "bar");
is generally better to read concatenated like:
	printk("foobar");

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-test-for-consecutive-string-fragments scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-test-for-consecutive-string-fragments
+++ a/scripts/checkpatch.pl
@@ -4464,6 +4464,12 @@ sub process {
 			    "Concatenated strings should use spaces between elements\n" . $herecurr);
 		}
 
+# uncoalesced string fragments
+		if ($line =~ /"X*"\s*"/) {
+			WARN("STRING_FRAGMENTS",
+			     "Consecutive strings are generally better as a single string\n" . $herecurr);
+		}
+
 # warn about #if 0
 		if ($line =~ /^.\s*\#\s*if\s+0\b/) {
 			CHK("REDUNDANT_CODE",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

