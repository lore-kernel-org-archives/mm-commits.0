From: akpm@linux-foundation.org
Subject: [merged] mqueue-sys_mq_open-do-not-call-mnt_drop_write-if-read-only.patch removed from -mm tree
Date: Mon, 25 Mar 2013 12:45:28 -0700
Message-ID: <20130325194528.87FE231C1B3__1864.16644505716$1364240765$gmane$org@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:51943 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933Ab3CYTp3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 15:45:29 -0400
Received: by mail-ve0-f201.google.com with SMTP id 14so653157vea.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 12:45:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, dledford@redhat.com, ebiederm@xmission.com, kosaki.motohiro@jp.fujitsu.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mqueue: sys_mq_open: do not call mnt_drop_write() if read-only
has been removed from the -mm tree.  Its filename was
     mqueue-sys_mq_open-do-not-call-mnt_drop_write-if-read-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: mqueue: sys_mq_open: do not call mnt_drop_write() if read-only

mnt_drop_write() must be called only if mnt_want_write() succeeded,
otherwise the mnt_writers counter will diverge.

mnt_writers counters are used to check if remounting FS as read-only is
OK, so after an extra mnt_drop_write() call, it would be impossible to
remount mqueue FS as read-only.  Besides, on umount a warning would be
printed like this one:

[  194.714880] =====================================
[  194.719680] [ BUG: bad unlock balance detected! ]
[  194.724488] 3.9.0-rc3 #5 Not tainted
[  194.728159] -------------------------------------
[  194.732958] a.out/12486 is trying to release lock (sb_writers) at:
[  194.739355] [<ffffffff811b177f>] mnt_drop_write+0x1f/0x30
[  194.744851] but there are no more locks to release!


Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN ipc/mqueue.c~mqueue-sys_mq_open-do-not-call-mnt_drop_write-if-read-only ipc/mqueue.c
--- a/ipc/mqueue.c~mqueue-sys_mq_open-do-not-call-mnt_drop_write-if-read-only
+++ a/ipc/mqueue.c
@@ -840,7 +840,8 @@ out_putfd:
 		fd = error;
 	}
 	mutex_unlock(&root->d_inode->i_mutex);
-	mnt_drop_write(mnt);
+	if (!ro)
+		mnt_drop_write(mnt);
 out_putname:
 	putname(name);
 	return fd;
_

Patches currently in -mm which might be from vdavydov@parallels.com are


