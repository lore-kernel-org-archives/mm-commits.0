From: akpm@linux-foundation.org
Subject: + mqueue-dont-use-kmalloc-with-kmalloc_max_size.patch added to -mm tree
Date: Tue, 17 Apr 2012 15:18:02 -0700
Message-ID: <20120417221802.E4154A038B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:53082 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753762Ab2DQWSG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Apr 2012 18:18:06 -0400
Received: by laai8 with SMTP id i8so323968laa.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Apr 2012 15:18:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, amwang@redhat.com, dledford@redhat.com, joe.korty@ccur.com, jslaby@suse.cz, manfred@colorfullife.com, mkosaki@jp.fujitsu.com, serue@us.ibm.com


The patch titled
     Subject: mqueue: don't use kmalloc with KMALLOC_MAX_SIZE
has been added to the -mm tree.  Its filename is
     mqueue-dont-use-kmalloc-with-kmalloc_max_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -150,7 +150,7 @@ static struct inode *mqueue_get_inode(st
 			info->attr.mq_msgsize = attr->mq_msgsize;
 		}
 		mq_msg_tblsz = info->attr.mq_maxmsg * sizeof(struct msg_msg *);
-		if (mq_msg_tblsz > KMALLOC_MAX_SIZE)
+		if (mq_msg_tblsz > PAGE_SIZE)
 			info->messages = vmalloc(mq_msg_tblsz);
 		else
 			info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
@@ -263,7 +263,7 @@ static void mqueue_evict_inode(struct in
 	spin_lock(&info->lock);
 	for (i = 0; i < info->attr.mq_curmsgs; i++)
 		free_msg(info->messages[i]);
-	if (info->attr.mq_maxmsg * sizeof(struct msg_msg *) > KMALLOC_MAX_SIZE)
+	if (is_vmalloc_addr(info->messages))
 		vfree(info->messages);
 	else
 		kfree(info->messages);
_
Subject: Subject: mqueue: don't use kmalloc with KMALLOC_MAX_SIZE

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mm-remove-swap-token-code.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch
ipc-mqueue-cleanup-definition-names-and-locations.patch
ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch
ipc-mqueue-enforce-hard-limits.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch
mqueue-revert-bump-up-dflt_max.patch
mqueue-dont-use-kmalloc-with-kmalloc_max_size.patch
mqueue-separate-mqueue-default-value-from-maximum-value-v2.patch
selftests-add-mq_open_tests.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch

