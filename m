From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:17:01 -0800
Message-ID: <54e2503d.Q5Ly97FGR5Bpoyyf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbbBPURh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: emit an error when using predefined timestamp macros
has been removed from the -mm tree.  Its filename was
     checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: emit an error when using predefined timestamp macros

Since commit fe7c36c7bde1 ("Makefile: Build with -Werror=date-time if
the compiler supports it"), use of __DATE__, __TIME__, and __TIMESTAMP__
has not been allowed.

As this test is gcc version specific (> 4.9), it hasn't prevented a few
new uses from creeping into the kernel sources.

Make checkpatch complain about them.

Signed-off-by: Joe Perches <joe@perches.com>
Original-patch-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-emit-an-error-when-using-predefined-timestamp-macros scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-emit-an-error-when-using-predefined-timestamp-macros
+++ a/scripts/checkpatch.pl
@@ -5089,6 +5089,12 @@ sub process {
 			}
 		}
 
+# check for uses of __DATE__, __TIME__, __TIMESTAMP__
+		while ($line =~ /\b(__(?:DATE|TIME|TIMESTAMP)__)\b/g) {
+			ERROR("DATE_TIME",
+			      "Use of the '$1' macro makes the build non-deterministic\n" . $herecurr);
+		}
+
 # check for use of yield()
 		if ($line =~ /\byield\s*\(\s*\)/) {
 			WARN("YIELD",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

