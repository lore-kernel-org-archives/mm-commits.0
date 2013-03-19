From: akpm@linux-foundation.org
Subject: + mqueue-sys_mq_open-do-not-call-mnt_drop_write-if-read-only.patch added to -mm tree
Date: Tue, 19 Mar 2013 14:10:14 -0700
Message-ID: <20130319211014.7DE8E5A4225@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:57393 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3CSVKQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 17:10:16 -0400
Received: by mail-qe0-f74.google.com with SMTP id 9so92803qea.1
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 14:10:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vdavydov@parallels.com, dledford@redhat.com, ebiederm@xmission.com, kosaki.motohiro@jp.fujitsu.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: mqueue: sys_mq_open: do not call mnt_drop_write() if read-only
has been added to the -mm tree.  Its filename is
     mqueue-sys_mq_open-do-not-call-mnt_drop_write-if-read-only.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: mqueue: sys_mq_open: do not call mnt_drop_write() if read-only

mnt_drop_write() must be called only if mnt_want_write() succeeded,
otherwise the mnt_writers counter will diverge.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
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

mqueue-sys_mq_open-do-not-call-mnt_drop_write-if-read-only.patch

