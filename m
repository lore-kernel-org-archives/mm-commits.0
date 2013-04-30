From: akpm@linux-foundation.org
Subject: [merged] lib-rename-random32-to-prandom_u32.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:02:29 -0700
Message-ID: <20130430190229.6F5F45A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:54912 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507Ab3D3TCa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:02:30 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so87355yhz.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:02:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/: rename random32() to prandom_u32()
has been removed from the -mm tree.  Its filename was
     lib-rename-random32-to-prandom_u32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: lib/: rename random32() to prandom_u32()

Use preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/fault-inject.c |    2 +-
 lib/list_sort.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/fault-inject.c~lib-rename-random32-to-prandom_u32 lib/fault-inject.c
--- a/lib/fault-inject.c~lib-rename-random32-to-prandom_u32
+++ a/lib/fault-inject.c
@@ -122,7 +122,7 @@ bool should_fail(struct fault_attr *attr
 			return false;
 	}
 
-	if (attr->probability <= random32() % 100)
+	if (attr->probability <= prandom_u32() % 100)
 		return false;
 
 	if (!fail_stacktrace(attr))
diff -puN lib/list_sort.c~lib-rename-random32-to-prandom_u32 lib/list_sort.c
--- a/lib/list_sort.c~lib-rename-random32-to-prandom_u32
+++ a/lib/list_sort.c
@@ -229,7 +229,7 @@ static int __init list_sort_test(void)
 			goto exit;
 		}
 		 /* force some equivalencies */
-		el->value = random32() % (TEST_LIST_LEN/3);
+		el->value = prandom_u32() % (TEST_LIST_LEN / 3);
 		el->serial = i;
 		el->poison1 = TEST_POISON1;
 		el->poison2 = TEST_POISON2;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix-fix.patch
remove-unused-random32-and-srandom32.patch
notifier-error-inject-fix-module-names-in-kconfig.patch

