From: akpm@linux-foundation.org
Subject: + raid6test-use-prandom_bytes.patch added to -mm tree
Date: Tue, 05 Mar 2013 17:01:49 -0800
Message-ID: <20130306010149.C308331C204@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:51154 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab3CFBBu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 20:01:50 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so811225yhr.2
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 17:01:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, djbw@fb.com, vinod.koul@intel.com


The patch titled
     Subject: raid6test: use prandom_bytes()
has been added to the -mm tree.  Its filename is
     raid6test-use-prandom_bytes.patch

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
Subject: raid6test: use prandom_bytes()

Use prandom_bytes() to generate random bytes for test data.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/async_tx/raid6test.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN crypto/async_tx/raid6test.c~raid6test-use-prandom_bytes crypto/async_tx/raid6test.c
--- a/crypto/async_tx/raid6test.c~raid6test-use-prandom_bytes
+++ a/crypto/async_tx/raid6test.c
@@ -46,15 +46,10 @@ static void callback(void *param)
 
 static void makedata(int disks)
 {
-	int i, j;
+	int i;
 
 	for (i = 0; i < disks; i++) {
-		for (j = 0; j < PAGE_SIZE/sizeof(u32); j += sizeof(u32)) {
-			u32 *p = page_address(data[i]) + j;
-
-			*p = random32();
-		}
-
+		prandom_bytes(page_address(data[i]), PAGE_SIZE);
 		dataptrs[i] = data[i];
 	}
 }
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

