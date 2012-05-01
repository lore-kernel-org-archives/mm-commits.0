From: akpm@linux-foundation.org
Subject: + ipc-mqueue-correct-mq_attr_ok-test.patch added to -mm tree
Date: Tue, 01 May 2012 12:36:49 -0700
Message-ID: <20120501193649.405CCA0444@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:60315 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962Ab2EATgu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2012 15:36:50 -0400
Received: by vbnl22 with SMTP id l22so503503vbn.1
        for <mm-commits@vger.kernel.org>; Tue, 01 May 2012 12:36:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dledford@redhat.com, manfred@colorfullife.com, sfr@canb.auug.org.au


The patch titled
     Subject: ipc/mqueue: correct mq_attr_ok test
has been added to the -mm tree.  Its filename is
     ipc-mqueue-correct-mq_attr_ok-test.patch

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

Signed-off-by: Doug Ledford <dledford@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN ipc/mqueue.c~ipc-mqueue-correct-mq_attr_ok-test ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-correct-mq_attr_ok-test
+++ a/ipc/mqueue.c
@@ -671,6 +671,8 @@ static void remove_notification(struct m
 
 static int mq_attr_ok(struct ipc_namespace *ipc_ns, struct mq_attr *attr)
 {
+	int mq_treesize;
+
 	if (attr->mq_maxmsg <= 0 || attr->mq_msgsize <= 0)
 		return 0;
 	if (capable(CAP_SYS_RESOURCE)) {
@@ -685,8 +687,11 @@ static int mq_attr_ok(struct ipc_namespa
 	/* check for overflow */
 	if (attr->mq_msgsize > ULONG_MAX/attr->mq_maxmsg)
 		return 0;
-	if ((unsigned long)(attr->mq_maxmsg * (attr->mq_msgsize
-	    + sizeof (struct msg_msg *))) <
+	mq_treesize = attr->mq_maxmsg * sizeof(struct msg_msg) +
+		min_t(unsigned int, attr->mq_maxmsg, MQ_PRIO_MAX) *
+		sizeof(struct posix_msg_tree_node);
+	if ((unsigned long)(attr->mq_maxmsg * attr->mq_msgsize +
+			    mq_treesize) <
 	    (unsigned long)(attr->mq_maxmsg * attr->mq_msgsize))
 		return 0;
 	return 1;
_
Subject: Subject: ipc/mqueue: correct mq_attr_ok test

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

