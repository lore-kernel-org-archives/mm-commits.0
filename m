From: akpm@linux-foundation.org
Subject: + lguest-rename-random32-to-prandom_u32.patch added to -mm tree
Date: Tue, 05 Mar 2013 17:02:15 -0800
Message-ID: <20130306010215.C25E95A41EB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:49881 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab3CFBCQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 20:02:16 -0500
Received: by mail-qe0-f73.google.com with SMTP id a11so809928qen.0
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 17:02:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, rusty@rustcorp.com.au


The patch titled
     Subject: lguest: rename random32() to prandom_u32()
has been added to the -mm tree.  Its filename is
     lguest-rename-random32-to-prandom_u32.patch

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
Subject: lguest: rename random32() to prandom_u32()

Use preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/page_tables.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/lguest/page_tables.c~lguest-rename-random32-to-prandom_u32 drivers/lguest/page_tables.c
--- a/drivers/lguest/page_tables.c~lguest-rename-random32-to-prandom_u32
+++ a/drivers/lguest/page_tables.c
@@ -686,7 +686,7 @@ static unsigned int new_pgdir(struct lg_
 	 * We pick one entry at random to throw out.  Choosing the Least
 	 * Recently Used might be better, but this is easy.
 	 */
-	next = random32() % ARRAY_SIZE(cpu->lg->pgdirs);
+	next = prandom_u32() % ARRAY_SIZE(cpu->lg->pgdirs);
 	/* If it's never been allocated at all before, try now. */
 	if (!cpu->lg->pgdirs[next].pgdir) {
 		cpu->lg->pgdirs[next].pgdir =
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

