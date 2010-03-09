From: akpm@linux-foundation.org
Subject: [merged] checkpatch-fix-false-positive-on-__initconst.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:09:08 -0800
Message-ID: <201003091909.o29J98cW031500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756017Ab0CITWR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: fix false positive on __initconst
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-false-positive-on-__initconst.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: fix false positive on __initconst
From: Wolfram Sang <w.sang@pengutronix.de>

checkpatch falsely complained about '__initconst' because it thought the
'const' needed a space before.  Fix this by changing the list of
attributes:

- add '__initconst'
- force plain 'init' to contain a word-boundary at the end

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-false-positive-on-__initconst scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-false-positive-on-__initconst
+++ a/scripts/checkpatch.pl
@@ -145,11 +145,14 @@ our $Sparse	= qr{
 			__kprobes|
 			__ref
 		}x;
+
+# Notes to $Attribute:
+# We need \b after 'init' otherwise 'initconst' will cause a false positive in a check
 our $Attribute	= qr{
 			const|
 			__read_mostly|
 			__kprobes|
-			__(?:mem|cpu|dev|)(?:initdata|init)|
+			__(?:mem|cpu|dev|)(?:initdata|initconst|init\b)|
 			____cacheline_aligned|
 			____cacheline_aligned_in_smp|
 			____cacheline_internodealigned_in_smp|
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

linux-next.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch

