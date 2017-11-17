From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-test-module-for-find__bit-functions-fix-2.patch removed from -mm tree
Date: Fri, 17 Nov 2017 15:16:13 -0800
Message-ID: <5a0f6dbd.+BmC+BrqELwOvc2z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53792 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030387AbdKQXQP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:16:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, courbet@google.com, rdunlap@infradead.org, ynorov@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: use correct format string for find-bit tests
has been removed from the -mm tree.  Its filename was
     lib-test-module-for-find__bit-functions-fix-2.patch

This patch was dropped because it was folded into lib-test-module-for-find__bit-functions.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: lib: use correct format string for find-bit tests

The cycles_t definition is architecture specific, which causes a link
error on all architectures that use a 'long long' or 'int' type for it:

lib/test_find_bit.c: In function 'test_find_last_bit':
include/linux/kern_levels.h:5:18: error: format '%ld' expects argument of type 'long int', but argument 2 has type 'cycles_t {aka long long unsigned int}' [-Werror=format=]

This adds an explicit cast to 'u64' for it, which lets us use
'%llu' everywhere.

Link: http://lkml.kernel.org/r/20171113135605.3166307-1-arnd@arndb.de
Fixes: 09588b1f1d58 ("lib: test module for find_*_bit() functions")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Yury Norov <ynorov@caviumnetworks.com>
Cc: Clement Courbet <courbet@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_find_bit.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN lib/test_find_bit.c~lib-test-module-for-find__bit-functions-fix-2 lib/test_find_bit.c
--- a/lib/test_find_bit.c~lib-test-module-for-find__bit-functions-fix-2
+++ a/lib/test_find_bit.c
@@ -51,7 +51,8 @@ static int __init test_find_first_bit(vo
 		__clear_bit(i, bitmap);
 	}
 	cycles = get_cycles() - cycles;
-	pr_err("find_first_bit:\t\t%ld cycles,\t%ld iterations\n", cycles, cnt);
+	pr_err("find_first_bit:\t\t%llu cycles,\t%ld iterations\n",
+	       (u64)cycles, cnt);
 
 	return 0;
 }
@@ -65,7 +66,8 @@ static int __init test_find_next_bit(con
 	for (cnt = i = 0; i < BITMAP_LEN; cnt++)
 		i = find_next_bit(bitmap, BITMAP_LEN, i) + 1;
 	cycles = get_cycles() - cycles;
-	pr_err("find_next_bit:\t\t%ld cycles,\t%ld iterations\n", cycles, cnt);
+	pr_err("find_next_bit:\t\t%llu cycles,\t%ld iterations\n",
+	       (u64)cycles, cnt);
 
 	return 0;
 }
@@ -79,8 +81,8 @@ static int __init test_find_next_zero_bi
 	for (cnt = i = 0; i < BITMAP_LEN; cnt++)
 		i = find_next_zero_bit(bitmap, len, i) + 1;
 	cycles = get_cycles() - cycles;
-	pr_err("find_next_zero_bit:\t%ld cycles,\t%ld iterations\n",
-								cycles, cnt);
+	pr_err("find_next_zero_bit:\t%llu cycles,\t%ld iterations\n",
+	       (u64)cycles, cnt);
 
 	return 0;
 }
@@ -99,7 +101,8 @@ static int __init test_find_last_bit(con
 		len = l;
 	} while (len);
 	cycles = get_cycles() - cycles;
-	pr_err("find_last_bit:\t\t%ld cycles,\t%ld iterations\n", cycles, cnt);
+	pr_err("find_last_bit:\t\t%llu cycles,\t%ld iterations\n",
+	       (u64)cycles, cnt);
 
 	return 0;
 }
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-fix-nodemask-printing.patch
iopoll-avoid-wint-in-bool-context-warning.patch
lib-test-module-for-find__bit-functions.patch
initramfs-use-time64_t-timestamps.patch
pcmcia-badge4-avoid-unused-function-warning.patch

