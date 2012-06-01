From: akpm@linux-foundation.org
Subject: [merged] ipc-mqueue-correct-mq_attr_ok-test.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:34:56 -0700
Message-ID: <20120601193456.706C3A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:61152 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804Ab2FATe5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:34:57 -0400
Received: by mail-yx0-f202.google.com with SMTP id l3so248324yen.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:34:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dledford@redhat.com, kosaki.motohiro@jp.fujitsu.com, manfred@colorfullife.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/mqueue: correct mq_attr_ok test
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-correct-mq_attr_ok-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Doug Ledford <dledford@redhat.com>
Subject: ipc/mqueue: correct mq_attr_ok test

While working on the other parts of the mqueue stuff, I noticed that the
calculation for overflow in mq_attr_ok didn't actually match reality (this
is especially true since my last patch which changed how we account memory
slightly).

In particular, we used to test for overflow using:
  msgs * msgsize + msgs * sizeof(struct msg_msg *)

That was never really correct because each message we allocate via
load_msg() is actually a struct msg_msg followed by the data for the
message (and if struct msg_msg + data exceeds PAGE_SIZE we end up
allocating struct msg_msgseg structs too, but accounting for them would
get really tedious, so let's ignore those...they're only a pointer in size
anyway).  This patch updates the calculation to be more accurate in
regards to maximum possible memory consumption by the mqueue.

[akpm@linux-foundation.org: add a local to simplify overflow-checking expression]
Signed-off-by: Doug Ledford <dledford@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Manfred Spraul <manfred@colorfullife.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN ipc/mqueue.c~ipc-mqueue-correct-mq_attr_ok-test ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-correct-mq_attr_ok-test
+++ a/ipc/mqueue.c
@@ -676,6 +676,9 @@ static void remove_notification(struct m
 
 static int mq_attr_ok(struct ipc_namespace *ipc_ns, struct mq_attr *attr)
 {
+	int mq_treesize;
+	unsigned long total_size;
+
 	if (attr->mq_maxmsg <= 0 || attr->mq_msgsize <= 0)
 		return 0;
 	if (capable(CAP_SYS_RESOURCE)) {
@@ -690,9 +693,11 @@ static int mq_attr_ok(struct ipc_namespa
 	/* check for overflow */
 	if (attr->mq_msgsize > ULONG_MAX/attr->mq_maxmsg)
 		return 0;
-	if ((unsigned long)(attr->mq_maxmsg * (attr->mq_msgsize
-	    + sizeof (struct msg_msg *))) <
-	    (unsigned long)(attr->mq_maxmsg * attr->mq_msgsize))
+	mq_treesize = attr->mq_maxmsg * sizeof(struct msg_msg) +
+		min_t(unsigned int, attr->mq_maxmsg, MQ_PRIO_MAX) *
+		sizeof(struct posix_msg_tree_node);
+	total_size = attr->mq_maxmsg * attr->mq_msgsize;
+	if (total_size + mq_treesize < total_size)
 		return 0;
 	return 1;
 }
_

Patches currently in -mm which might be from dledford@redhat.com are

origin.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation.patch
tools-selftests-add-mq_perf_tests.patch
ipc-mqueue-add-rbtree-node-caching-support.patch

