From: akpm@linux-foundation.org
Subject: + ipc-mqueue-strengthen-checks-on-mqueue-creation.patch added to -mm tree
Date: Tue, 01 May 2012 12:36:52 -0700
Message-ID: <20120501193653.05047A0444@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:42629 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758384Ab2EATgy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2012 15:36:54 -0400
Received: by vcbfk26 with SMTP id fk26so504992vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 01 May 2012 12:36:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dledford@redhat.com, manfred@colorfullife.com, sfr@canb.auug.org.au


The patch titled
     Subject: ipc/mqueue: strengthen checks on mqueue creation
has been added to the -mm tree.  Its filename is
     ipc-mqueue-strengthen-checks-on-mqueue-creation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Doug Ledford <dledford@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff -puN ipc/mqueue.c~ipc-mqueue-strengthen-checks-on-mqueue-creation ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-strengthen-checks-on-mqueue-creation
+++ a/ipc/mqueue.c
@@ -675,26 +675,26 @@ static int mq_attr_ok(struct ipc_namespa
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
+		return -ENOMEM;
 	mq_treesize = attr->mq_maxmsg * sizeof(struct msg_msg) +
 		min_t(unsigned int, attr->mq_maxmsg, MQ_PRIO_MAX) *
 		sizeof(struct posix_msg_tree_node);
 	total_size = attr->mq_maxmsg * attr->mq_msgsize;
 	if (total_size + mq_treesize < total_size)
-		return 0;
-	return 1;
+		return -ENOMEM;
+	return 0;
 }
 
 /*
@@ -709,12 +709,21 @@ static struct file *do_create(struct ipc
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
Subject: Subject: ipc/mqueue: strengthen checks on mqueue creation

Patches currently in -mm which might be from dledford@redhat.com are

ipc-mqueue-cleanup-definition-names-and-locations.patch
ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch
ipc-mqueue-enforce-hard-limits.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix.patch
mqueue-revert-bump-up-dflt_max.patch
mqueue-dont-use-kmalloc-with-kmalloc_max_size.patch
mqueue-separate-mqueue-default-value-from-maximum-value-v2.patch
selftests-add-mq_open_tests.patch
ipc-mqueue-improve-performance-of-send-recv.patch
ipc-mqueue-improve-performance-of-send-recv-fix.patch
ipc-mqueue-correct-mq_attr_ok-test.patch
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation.patch
tools-selftests-add-mq_perf_tests.patch

