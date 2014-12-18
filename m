From: akpm@linux-foundation.org
Subject: +
 checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch added to -mm tree
Date: Thu, 18 Dec 2014 14:24:44 -0800
Message-ID: <5493542c.MCdt35aXYlzNQWeB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57368 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaLRWYp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Dec 2014 17:24:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: emit an error when using predefined timestamp macros
has been added to the -mm tree.  Its filename is
     checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch

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
mailmap-santosh-shilimkar-has-moved.patch
mm-utilc-add-kstrimdup.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch

