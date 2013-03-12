From: akpm@linux-foundation.org
Subject: [merged] gfs2-use-memchr_inv.patch removed from -mm tree
Date: Tue, 12 Mar 2013 12:09:55 -0700
Message-ID: <20130312190955.76F6D31C214@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:61216 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933241Ab3CLTJ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 15:09:56 -0400
Received: by mail-yh0-f74.google.com with SMTP id z6so22516yhz.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 12:09:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, ccaulfie@redhat.com, swhiteho@redhat.com, teigland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: gfs2: use memchr_inv()
has been removed from the -mm tree.  Its filename was
     gfs2-use-memchr_inv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
uwb-rename-random32-to-prandom_u32.patch
lguest-rename-random32-to-prandom_u32.patch
scsi-rename-random32-to-prandom_u32.patch
scsi-rename-random32-to-prandom_u32-fix.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
net-sunrpc-rename-random32-to-prandom_u32.patch
net-sched-rename-random32-to-prandom_u32.patch
net-netfilter-rename-random32-to-prandom_u32.patch
net-core-rename-random32-to-prandom_u32.patch
net-core-remove-duplicate-statements-by-do-while-loop.patch
net-rename-random32-to-prandom.patch
remove-unused-random32-and-srandom32.patch

