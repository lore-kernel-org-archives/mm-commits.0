From: akpm@linux-foundation.org
Subject: [merged] ipc-mqueue-strengthen-checks-on-mqueue-creation.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:34:58 -0700
Message-ID: <20120601193458.69993A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:61152 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804Ab2FATe7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:34:59 -0400
Received: by mail-yx0-f202.google.com with SMTP id l3so248324yen.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:34:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dledford@redhat.com, kosaki.motohiro@jp.fujitsu.com, manfred@colorfullife.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/mqueue: strengthen checks on mqueue creation
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-strengthen-checks-on-mqueue-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Doug Ledford <dledford@redhat.com>
Subject: ipc/mqueue: strengthen checks on mqueue creation

We already check the mq attr struct if it's passed in, but now that the
admin can set system wide defaults separate from maximums, it's actually
possible to set the defaults to something that would overflow.  So, if
there is no attr struct passed in to the open call, check the default
values.

While we are at it, simplify mq_attr_ok() by making it return 0 or an
error condition, so that way if we add more tests to it later, we have the
option of what error should be returned instead of the calling location
having to pick a possibly inaccurate error code.

[akpm@linux-foundation.org: s/ENOMEM/EOVERFLOW/]
Signed-off-by: Doug Ledford <dledford@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Manfred Spraul <manfred@colorfullife.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff -puN ipc/mqueue.c~ipc-mqueue-strengthen-checks-on-mqueue-creation ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-strengthen-checks-on-mqueue-creation
+++ a/ipc/mqueue.c
@@ -680,26 +680,26 @@ static int mq_attr_ok(struct ipc_namespa
 	unsigned long total_size;
 
 	if (attr->mq_maxmsg <= 0 || attr->mq_msgsize <= 0)
-		return 0;
+		return -EINVAL;
 	if (capable(CAP_SYS_RESOURCE)) {
 		if (attr->mq_maxmsg > HARD_MSGMAX ||
 		    attr->mq_msgsize > HARD_MSGSIZEMAX)
-			return 0;
+			return -EINVAL;
 	} else {
 		if (attr->mq_maxmsg > ipc_ns->mq_msg_max ||
 				attr->mq_msgsize > ipc_ns->mq_msgsize_max)
-			return 0;
+			return -EINVAL;
 	}
 	/* check for overflow */
 	if (attr->mq_msgsize > ULONG_MAX/attr->mq_maxmsg)
-		return 0;
+		return -EOVERFLOW;
 	mq_treesize = attr->mq_maxmsg * sizeof(struct msg_msg) +
 		min_t(unsigned int, attr->mq_maxmsg, MQ_PRIO_MAX) *
 		sizeof(struct posix_msg_tree_node);
 	total_size = attr->mq_maxmsg * attr->mq_msgsize;
 	if (total_size + mq_treesize < total_size)
-		return 0;
-	return 1;
+		return -EOVERFLOW;
+	return 0;
 }
 
 /*
@@ -714,12 +714,21 @@ static struct file *do_create(struct ipc
 	int ret;
 
 	if (attr) {
-		if (!mq_attr_ok(ipc_ns, attr)) {
-			ret = -EINVAL;
+		ret = mq_attr_ok(ipc_ns, attr);
+		if (ret)
 			goto out;
-		}
 		/* store for use during create */
 		dentry->d_fsdata = attr;
+	} else {
+		struct mq_attr def_attr;
+
+		def_attr.mq_maxmsg = min(ipc_ns->mq_msg_max,
+					 ipc_ns->mq_msg_default);
+		def_attr.mq_msgsize = min(ipc_ns->mq_msgsize_max,
+					  ipc_ns->mq_msgsize_default);
+		ret = mq_attr_ok(ipc_ns, &def_attr);
+		if (ret)
+			goto out;
 	}
 
 	mode &= ~current_umask();
_

Patches currently in -mm which might be from dledford@redhat.com are

origin.patch
tools-selftests-add-mq_perf_tests.patch
ipc-mqueue-add-rbtree-node-caching-support.patch

