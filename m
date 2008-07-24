From: akpm@linux-foundation.org
Subject: - checkpatch-add-a-checkpatch-warning-for-new-uses-of-__initcall.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:13 -0700
Message-ID: <200807242326.m6ONQDs3010955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755860AbYGXX00 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael@ellerman.id.au, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: add a checkpatch warning for new uses of __initcall().
has been removed from the -mm tree.  Its filename was
     checkpatch-add-a-checkpatch-warning-for-new-uses-of-__initcall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: add a checkpatch warning for new uses of __initcall().
From: Michael Ellerman <michael@ellerman.id.au>

[apw@shadowen.org: generalise pattern and add tests]
Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-a-checkpatch-warning-for-new-uses-of-__initcall scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-a-checkpatch-warning-for-new-uses-of-__initcall
+++ a/scripts/checkpatch.pl
@@ -2108,6 +2108,10 @@ sub process {
 		if ($line =~ /\bsimple_(strto.*?)\s*\(/) {
 			WARN("consider using strict_$1 in preference to simple_$1\n" . $herecurr);
 		}
+# check for __initcall(), use device_initcall() explicitly please
+		if ($line =~ /^.\s*__initcall\s*\(/) {
+			WARN("please use device_initcall() instead of __initcall()\n" . $herecurr);
+		}
 
 # use of NR_CPUS is usually wrong
 # ignore definitions of NR_CPUS and usage to define arrays as likely right
_

Patches currently in -mm which might be from michael@ellerman.id.au are

origin.patch

