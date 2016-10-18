From: akpm@linux-foundation.org
Subject: + ipc-account-for-kmem-usage-on-mqueue-and-msg.patch added to -mm tree
Date: Tue, 18 Oct 2016 13:34:34 -0700
Message-ID: <5806875a.mIgdNZS9JZobVTWq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56020 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751670AbcJRUeg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2016 16:34:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arozansk@redhat.com, adobriyan@gmail.com, dave@stgolabs.net, hannes@cmpxchg.org, mhocko@kernel.org, sttts@redhat.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: account for kmem usage on mqueue and msg
has been added to the -mm tree.  Its filename is
     ipc-account-for-kmem-usage-on-mqueue-and-msg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-account-for-kmem-usage-on-mqueue-and-msg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-account-for-kmem-usage-on-mqueue-and-msg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Aristeu Rozanski <arozansk@redhat.com>
Subject: ipc: account for kmem usage on mqueue and msg

When kmem accounting switched from account by default to only account if
flagged by __GFP_ACCOUNT, IPC mqueue and messages was left out.

Link: http://lkml.kernel.org/r/1476806075-1210-1-git-send-email-arozansk@redhat.com
Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
Reported-by: Stefan Schimanski <sttts@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Stefan Schimanski <sttts@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msgutil.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/msgutil.c~ipc-account-for-kmem-usage-on-mqueue-and-msg ipc/msgutil.c
--- a/ipc/msgutil.c~ipc-account-for-kmem-usage-on-mqueue-and-msg
+++ a/ipc/msgutil.c
@@ -53,7 +53,7 @@ static struct msg_msg *alloc_msg(size_t
 	size_t alen;
 
 	alen = min(len, DATALEN_MSG);
-	msg = kmalloc(sizeof(*msg) + alen, GFP_KERNEL);
+	msg = kmalloc(sizeof(*msg) + alen, GFP_KERNEL_ACCOUNT);
 	if (msg == NULL)
 		return NULL;
 
@@ -65,7 +65,7 @@ static struct msg_msg *alloc_msg(size_t
 	while (len > 0) {
 		struct msg_msgseg *seg;
 		alen = min(len, DATALEN_SEG);
-		seg = kmalloc(sizeof(*seg) + alen, GFP_KERNEL);
+		seg = kmalloc(sizeof(*seg) + alen, GFP_KERNEL_ACCOUNT);
 		if (seg == NULL)
 			goto out_err;
 		*pseg = seg;
_

Patches currently in -mm which might be from arozansk@redhat.com are

ipc-account-for-kmem-usage-on-mqueue-and-msg.patch

