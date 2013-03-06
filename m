From: akpm@linux-foundation.org
Subject: + lib-rename-random32-to-prandom_u32.patch added to -mm tree
Date: Tue, 05 Mar 2013 17:01:57 -0800
Message-ID: <20130306010157.BE2065A41EB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:35173 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab3CFBB6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 20:01:58 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so427900qaj.5
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 17:01:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     Subject: lib/: rename random32() to prandom_u32()
has been added to the -mm tree.  Its filename is
     lib-rename-random32-to-prandom_u32.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
raid6test-use-prandom_bytes.patch
uuid-use-prandom_bytes.patch
x86-pageattr-test-remove-srandom32-call.patch
x86-rename-random32-to-prandom_u32.patch
lib-rename-random32-to-prandom_u32.patch
mm-rename-random32-to-prandom_u32.patch
kernel-rename-random32-to-prandom_u32.patch
drbd-rename-random32-to-prandom_u32.patch
infiniband-rename-random32-to-prandom_u32.patch
mmc-rename-random32-to-prandom_u32.patch
video-uvesafb-rename-random32-to-prandom_u32.patch
xfs-rename-random32-to-prandom_u32.patch
uwb-rename-random32-to-prandom_u32.patch
lguest-rename-random32-to-prandom_u32.patch
scsi-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32.patch
net-sunrpc-rename-random32-to-prandom_u32.patch
net-sched-rename-random32-to-prandom_u32.patch
net-netfilter-rename-random32-to-prandom_u32.patch
net-core-rename-random32-to-prandom_u32.patch
net-core-remove-duplicate-statements-by-do-while-loop.patch
net-rename-random32-to-prandom.patch
remove-unused-random32-and-srandom32.patch

