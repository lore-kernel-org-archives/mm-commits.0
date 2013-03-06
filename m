From: akpm@linux-foundation.org
Subject: + uwb-rename-random32-to-prandom_u32.patch added to -mm tree
Date: Tue, 05 Mar 2013 17:02:13 -0800
Message-ID: <20130306010213.C3E615A41EB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:34633 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab3CFBCO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 20:02:14 -0500
Received: by mail-ye0-f201.google.com with SMTP id m12so809242yen.4
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 17:02:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, greg@kroah.com


The patch titled
     Subject: uwb: rename random32() to prandom_u32()
has been added to the -mm tree.  Its filename is
     uwb-rename-random32-to-prandom_u32.patch

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
Subject: uwb: rename random32() to prandom_u32()

Use preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/uwb/rsv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/uwb/rsv.c~uwb-rename-random32-to-prandom_u32 drivers/uwb/rsv.c
--- a/drivers/uwb/rsv.c~uwb-rename-random32-to-prandom_u32
+++ a/drivers/uwb/rsv.c
@@ -231,7 +231,7 @@ void uwb_rsv_backoff_win_increment(struc
 		return;
 
 	bow->window <<= 1;
-	bow->n = random32() & (bow->window - 1);
+	bow->n = prandom_u32() & (bow->window - 1);
 	dev_dbg(dev, "new_window=%d, n=%d\n: ", bow->window, bow->n);
 
 	/* reset the timer associated variables */
@@ -557,7 +557,7 @@ int uwb_rsv_establish(struct uwb_rsv *rs
 	if (ret)
 		goto out;
 
-	rsv->tiebreaker = random32() & 1;
+	rsv->tiebreaker = prandom_u32() & 1;
 	/* get available mas bitmap */
 	uwb_drp_available(rc, &available);
 
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

