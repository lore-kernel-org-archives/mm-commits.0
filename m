From: akpm@linux-foundation.org
Subject: + memtest-cleanup-log-messages.patch added to -mm tree
Date: Tue, 14 Jul 2015 12:16:41 -0700
Message-ID: <55a56019.8Jzi5Ydy9VafDcq5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbbGNTQm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 15:16:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir.murzin@arm.com, leon@leon.nu, mm-commits@vger.kernel.org


The patch titled
     Subject: memtest: cleanup log messages
has been added to the -mm tree.  Its filename is
     memtest-cleanup-log-messages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memtest-cleanup-log-messages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memtest-cleanup-log-messages.patch

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
Subject: memtest: cleanup log messages

- prefer pr_info(...  to printk(KERN_INFO ...
- use %pa for phys_addr_t
- use cpu_to_be64 while printing pattern in reserve_bad_mem()

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Leon Romanovsky <leon@leon.nu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memtest.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN mm/memtest.c~memtest-cleanup-log-messages mm/memtest.c
--- a/mm/memtest.c~memtest-cleanup-log-messages
+++ a/mm/memtest.c
@@ -31,10 +31,8 @@ static u64 patterns[] __initdata = {
 
 static void __init reserve_bad_mem(u64 pattern, phys_addr_t start_bad, phys_addr_t end_bad)
 {
-	printk(KERN_INFO "  %016llx bad mem addr %010llx - %010llx reserved\n",
-	       (unsigned long long) pattern,
-	       (unsigned long long) start_bad,
-	       (unsigned long long) end_bad);
+	pr_info("%016llx bad mem addr %pa - %pa reserved\n",
+		cpu_to_be64(pattern), &start_bad, &end_bad);
 	memblock_reserve(start_bad, end_bad - start_bad);
 }
 
@@ -79,10 +77,8 @@ static void __init do_one_pass(u64 patte
 		this_start = clamp(this_start, start, end);
 		this_end = clamp(this_end, start, end);
 		if (this_start < this_end) {
-			printk(KERN_INFO "  %010llx - %010llx pattern %016llx\n",
-			       (unsigned long long)this_start,
-			       (unsigned long long)this_end,
-			       (unsigned long long)cpu_to_be64(pattern));
+			pr_info("  %pa - %pa pattern %016llx\n",
+				&this_start, &this_end, cpu_to_be64(pattern));
 			memtest(pattern, this_start, this_end - this_start);
 		}
 	}
@@ -113,7 +109,7 @@ void __init early_memtest(phys_addr_t st
 	if (!memtest_pattern)
 		return;
 
-	printk(KERN_INFO "early_memtest: # of tests: %d\n", memtest_pattern);
+	pr_info("early_memtest: # of tests: %u\n", memtest_pattern);
 	for (i = memtest_pattern-1; i < UINT_MAX; --i) {
 		idx = i % ARRAY_SIZE(patterns);
 		do_one_pass(patterns[idx], start, end);
_

Patches currently in -mm which might be from vladimir.murzin@arm.com are

memtest-use-kstrtouint-instead-of-simple_strtoul.patch
memtest-cleanup-log-messages.patch
memtest-remove-unused-header-files.patch

