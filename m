From: akpm@linux-foundation.org
Subject: +
 ipc-mq-do-not-validate-queue-attributes-default-ceiling-value-if-the-user-passed-attr==null.patch added to -mm tree
Date: Wed, 14 Aug 2013 15:45:42 -0700
Message-ID: <520c0896.5zjKYr+YNWOkfYcn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149Ab3HNWpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 18:45:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov@parallels.com, manfred@colorfullife.com, jlayton@redhat.com, dledford@redhat.com, sasikanth.v19@gmail.com

Subject: + ipc-mq-do-not-validate-queue-attributes-default-ceiling-value-if-the-user-passed-attr==null.patch added to -mm tree
To: sasikanth.v19@gmail.com,dledford@redhat.com,jlayton@redhat.com,manfred@colorfullife.com,vdavydov@parallels.com
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 15:45:42 -0700


The patch titled
     Subject: ipc/mq: do not validate queue attributes default/ceiling value if the user passed attr==NULL
has been added to the -mm tree.  Its filename is
     ipc-mq-do-not-validate-queue-attributes-default-ceiling-value-if-the-user-passed-attr==null.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-mq-do-not-validate-queue-attributes-default-ceiling-value-if-the-user-passed-attr==null.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-mq-do-not-validate-queue-attributes-default-ceiling-value-if-the-user-passed-attr==null.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasikantha Babu <sasikanth.v19@gmail.com>
Subject: ipc/mq: do not validate queue attributes default/ceiling value if the user passed attr==NULL

The kernel should not validate queue attributes default/ceiling value
while creating a mqueue, if user passed attr as NULL.  Otherwise in the
worst case if the validation fails then sys_mq_open returns
-EINVAL/-EOVERFLOW which will leave the user clueless about the reason for
the failure.

Signed-off-by: Sasikantha Babu <sasikanth.v19@gmail.com>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Sasikantha Babu <sasikanth.v19@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN ipc/mqueue.c~ipc-mq-do-not-validate-queue-attributes-default-ceiling-value-if-the-user-passed-attr==null ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mq-do-not-validate-queue-attributes-default-ceiling-value-if-the-user-passed-attr==null
+++ a/ipc/mqueue.c
@@ -741,16 +741,6 @@ static struct file *do_create(struct ipc
 			return ERR_PTR(ret);
 		/* store for use during create */
 		path->dentry->d_fsdata = attr;
-	} else {
-		struct mq_attr def_attr;
