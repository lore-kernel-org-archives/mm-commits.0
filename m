From: akpm@linux-foundation.org
Subject: + memtest-cleanup-log-messages-fix.patch added to -mm tree
Date: Thu, 23 Jul 2015 13:00:36 -0700
Message-ID: <55b147e4.qroLmqUIrdERMSrZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbbGWUAh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jul 2015 16:00:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir.murzin@arm.com, leon@leon.nu, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memtest-cleanup-log-messages-fix
has been added to the -mm tree.  Its filename is
     memtest-cleanup-log-messages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memtest-cleanup-log-messages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memtest-cleanup-log-messages-fix.patch

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
Subject: memtest-cleanup-log-messages-fix

Cc: Leon Romanovsky <leon@leon.nu>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memtest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memtest.c~memtest-cleanup-log-messages-fix mm/memtest.c
--- a/mm/memtest.c~memtest-cleanup-log-messages-fix
+++ a/mm/memtest.c
@@ -31,7 +31,7 @@ static u64 patterns[] __initdata = {
 
 static void __init reserve_bad_mem(u64 pattern, phys_addr_t start_bad, phys_addr_t end_bad)
 {
-	pr_info("%016llx bad mem addr %pa - %pa reserved\n",
+	pr_info("  %016llx bad mem addr %pa - %pa reserved\n",
 		cpu_to_be64(pattern), &start_bad, &end_bad);
 	memblock_reserve(start_bad, end_bad - start_bad);
 }
_

Patches currently in -mm which might be from vladimir.murzin@arm.com are

memtest-use-kstrtouint-instead-of-simple_strtoul.patch
memtest-cleanup-log-messages.patch
memtest-cleanup-log-messages-fix.patch
memtest-remove-unused-header-files.patch
memblock-make-memblock_overlaps_region-return-bool.patch
mem-hotplug-handle-node-hole-when-initializing-numa_meminfo.patch

