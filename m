From: akpm@linux-foundation.org
Subject: + uuid-use-prandom_bytes.patch added to -mm tree
Date: Tue, 05 Mar 2013 17:01:51 -0800
Message-ID: <20130306010151.C2DCB31C204@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:35125 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab3CFBBw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 20:01:52 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so811333yhz.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 17:01:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, tytso@mit.edu, ying.huang@intel.com


The patch titled
     Subject: uuid: use prandom_bytes()
has been added to the -mm tree.  Its filename is
     uuid-use-prandom_bytes.patch

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
Subject: uuid: use prandom_bytes()

Use prandom_bytes() to generate 16 bytes of pseudo-random bytes.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/uuid.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN lib/uuid.c~uuid-use-prandom_bytes lib/uuid.c
--- a/lib/uuid.c~uuid-use-prandom_bytes
+++ a/lib/uuid.c
@@ -25,13 +25,7 @@
 
 static void __uuid_gen_common(__u8 b[16])
 {
-	int i;
-	u32 r;
-
-	for (i = 0; i < 4; i++) {
-		r = random32();
-		memcpy(b + i * 4, &r, 4);
-	}
+	prandom_bytes(b, 16);
 	/* reversion 0b10 */
 	b[8] = (b[8] & 0x3F) | 0x80;
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

