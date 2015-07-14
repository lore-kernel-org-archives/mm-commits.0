From: akpm@linux-foundation.org
Subject: + memtest-use-kstrtouint-instead-of-simple_strtoul.patch added to -mm tree
Date: Tue, 14 Jul 2015 12:16:39 -0700
Message-ID: <55a56017.FG7kW8VvmyfPOCXL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbbGNTQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 15:16:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir.murzin@arm.com, leon@leon.nu, mm-commits@vger.kernel.org


The patch titled
     Subject: memtest: use kstrtouint instead of simple_strtoul
has been added to the -mm tree.  Its filename is
     memtest-use-kstrtouint-instead-of-simple_strtoul.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memtest-use-kstrtouint-instead-of-simple_strtoul.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memtest-use-kstrtouint-instead-of-simple_strtoul.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: memtest: use kstrtouint instead of simple_strtoul

Since simple_strtoul is obsolete and memtest_pattern is type of int, use
kstrtouint instead.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Leon Romanovsky <leon@leon.nu>
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

memtest-use-kstrtouint-instead-of-simple_strtoul.patch
memtest-cleanup-log-messages.patch
memtest-remove-unused-header-files.patch

