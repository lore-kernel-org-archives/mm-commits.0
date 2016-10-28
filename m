From: akpm@linux-foundation.org
Subject: [patch 07/20] ipc: account for kmem usage on mqueue and msg
Date: Thu, 27 Oct 2016 17:46:35 -0700
Message-ID: <58129feb.kUg8gftt8evGq7Ui%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57826 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936219AbcJ1Aqg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2016 20:46:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, arozansk@redhat.com, adobriyan@gmail.com, dave@stgolabs.net, hannes@cmpxchg.org, mhocko@kernel.org, sttts@redhat.com, vdavydov.dev@gmail.com

From: Aristeu Rozanski <arozansk@redhat.com>
Subject: ipc: account for kmem usage on mqueue and msg

When kmem accounting switched from account by default to only account if
flagged by __GFP_ACCOUNT, IPC mqueue and messages was left out.

The production use case at hand is that mqueues should be customizable
via sysctls in Docker containers in a Kubernetes cluster.  This can
only be safely allowed to the users of the cluster (without the risk
that they can cause resource shortage on a node, influencing other
users' containers) if all resources they control are bounded, i.e. 
accounted for.

Link: http://lkml.kernel.org/r/1476806075-1210-1-git-send-email-arozansk@redhat.com
Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
Reported-by: Stefan Schimanski <sttts@redhat.com>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Stefan Schimanski <sttts@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
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
