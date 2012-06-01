From: akpm@linux-foundation.org
Subject: [merged] mqueue-dont-use-kmalloc-with-kmalloc_max_size.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:34:46 -0700
Message-ID: <20120601193446.7AA49A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:41524 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804Ab2FATes (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:34:48 -0400
Received: by bkty5 with SMTP id y5so138700bkt.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:34:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, amwang@redhat.com, dledford@redhat.com, joe.korty@ccur.com, jslaby@suse.cz, manfred@colorfullife.com, mkosaki@jp.fujitsu.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mqueue: don't use kmalloc with KMALLOC_MAX_SIZE
has been removed from the -mm tree.  Its filename was
     mqueue-dont-use-kmalloc-with-kmalloc_max_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mqueue: don't use kmalloc with KMALLOC_MAX_SIZE

KMALLOC_MAX_SIZE is not a good threshold.  It is extremely high and
problematic.  Unfortunately, some silly drivers depend on this and we
can't change it.  But any new code needn't use such extreme ugly high
order allocations.  It brings us awful fragmentation issues and system
slowdown.

Signed-off-by: KOSAKI Motohiro <mkosaki@jp.fujitsu.com>
Acked-by: Doug Ledford <dledford@redhat.com>
Acked-by: Joe Korty <joe.korty@ccur.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Joe Korty <joe.korty@ccur.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/mqueue.c~mqueue-dont-use-kmalloc-with-kmalloc_max_size ipc/mqueue.c
--- a/ipc/mqueue.c~mqueue-dont-use-kmalloc-with-kmalloc_max_size
+++ a/ipc/mqueue.c
@@ -153,7 +153,7 @@ static struct inode *mqueue_get_inode(st
 			info->attr.mq_msgsize = attr->mq_msgsize;
 		}
 		mq_msg_tblsz = info->attr.mq_maxmsg * sizeof(struct msg_msg *);
-		if (mq_msg_tblsz > KMALLOC_MAX_SIZE)
+		if (mq_msg_tblsz > PAGE_SIZE)
 			info->messages = vmalloc(mq_msg_tblsz);
 		else
 			info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
@@ -266,7 +266,7 @@ static void mqueue_evict_inode(struct in
 	spin_lock(&info->lock);
 	for (i = 0; i < info->attr.mq_curmsgs; i++)
 		free_msg(info->messages[i]);
-	if (info->attr.mq_maxmsg * sizeof(struct msg_msg *) > KMALLOC_MAX_SIZE)
+	if (is_vmalloc_addr(info->messages))
 		vfree(info->messages);
 	else
 		kfree(info->messages);
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mqueue-separate-mqueue-default-value-from-maximum-value-v2.patch
selftests-add-mq_open_tests.patch
ipc-mqueue-improve-performance-of-send-recv.patch
ipc-mqueue-correct-mq_attr_ok-test.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation.patch
tools-selftests-add-mq_perf_tests.patch
ipc-mqueue-add-rbtree-node-caching-support.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

