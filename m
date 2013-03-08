From: akpm@linux-foundation.org
Subject: + gfs2-use-memchr_inv.patch added to -mm tree
Date: Fri, 08 Mar 2013 15:02:01 -0800
Message-ID: <20130308230201.76A3431C1BF@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:38954 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933763Ab3CHXCD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Mar 2013 18:02:03 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so157450qcs.5
        for <mm-commits@vger.kernel.org>; Fri, 08 Mar 2013 15:02:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, ccaulfie@redhat.com, swhiteho@redhat.com, teigland@redhat.com


The patch titled
     Subject: gfs2: use memchr_inv()
has been added to the -mm tree.  Its filename is
     gfs2-use-memchr_inv.patch

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
Subject: gfs2: use memchr_inv()

Use memchr_inv() to verify that the specified memory range is cleared.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/lock_dlm.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN fs/gfs2/lock_dlm.c~gfs2-use-memchr_inv fs/gfs2/lock_dlm.c
--- a/fs/gfs2/lock_dlm.c~gfs2-use-memchr_inv
+++ a/fs/gfs2/lock_dlm.c
@@ -483,12 +483,8 @@ static void control_lvb_write(struct lm_
 
 static int all_jid_bits_clear(char *lvb)
 {
-	int i;
-	for (i = JID_BITMAP_OFFSET; i < GDLM_LVB_SIZE; i++) {
-		if (lvb[i])
-			return 0;
-	}
-	return 1;
+	return !memchr_inv(lvb + JID_BITMAP_OFFSET, 0,
+			GDLM_LVB_SIZE - JID_BITMAP_OFFSET);
 }
 
 static void sync_wait_cb(void *arg)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
gfs2-use-memchr_inv.patch
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
drivers-net-rename-random32-to-prandom_u32-fix.patch
net-sunrpc-rename-random32-to-prandom_u32.patch
net-sched-rename-random32-to-prandom_u32.patch
net-netfilter-rename-random32-to-prandom_u32.patch
net-core-rename-random32-to-prandom_u32.patch
net-core-remove-duplicate-statements-by-do-while-loop.patch
net-rename-random32-to-prandom.patch
remove-unused-random32-and-srandom32.patch

