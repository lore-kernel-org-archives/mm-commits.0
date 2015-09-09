From: akpm@linux-foundation.org
Subject: [merged] memtest-use-kstrtouint-instead-of-simple_strtoul.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:44:01 -0700
Message-ID: <55f08c01.fr5rJPCyv5u+CzW9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbbIIToB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:44:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir.murzin@arm.com, leon@leon.nu, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memtest: use kstrtouint instead of simple_strtoul
has been removed from the -mm tree.  Its filename was
     memtest-use-kstrtouint-instead-of-simple_strtoul.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: memtest: use kstrtouint instead of simple_strtoul

Since simple_strtoul is obsolete and memtest_pattern is type of int, use
kstrtouint instead.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Leon Romanovsky <leon@leon.nu>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memtest.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/memtest.c~memtest-use-kstrtouint-instead-of-simple_strtoul mm/memtest.c
--- a/mm/memtest.c~memtest-use-kstrtouint-instead-of-simple_strtoul
+++ a/mm/memtest.c
@@ -89,16 +89,18 @@ static void __init do_one_pass(u64 patte
 }
 
 /* default is disabled */
-static int memtest_pattern __initdata;
+static unsigned int memtest_pattern __initdata;
 
 static int __init parse_memtest(char *arg)
 {
+	int ret = 0;
+
 	if (arg)
-		memtest_pattern = simple_strtoul(arg, NULL, 0);
+		ret = kstrtouint(arg, 0, &memtest_pattern);
 	else
 		memtest_pattern = ARRAY_SIZE(patterns);
 
-	return 0;
+	return ret;
 }
 
 early_param("memtest", parse_memtest);
_

Patches currently in -mm which might be from vladimir.murzin@arm.com are


