From: akpm@linux-foundation.org
Subject: [folded] ipc-mqueue-add-rbtree-node-caching-support-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 31 May 2012 16:18:44 -0700
Message-ID: <20120531231844.F3CDFA009B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:51217 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758594Ab2EaXSr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 19:18:47 -0400
Received: by eaao13 with SMTP id o13so55457eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 16:18:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dledford@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-mqueue-add-rbtree-node-caching-support-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-add-rbtree-node-caching-support-checkpatch-fixes.patch

This patch was dropped because it was folded into ipc-mqueue-add-rbtree-node-caching-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-mqueue-add-rbtree-node-caching-support-checkpatch-fixes

WARNING: kfree(NULL) is safe this check is probably not required
#190: FILE: ipc/mqueue.c:1050:
+	} else if (new_leaf) {
+		kfree(new_leaf);

WARNING: kfree(NULL) is safe this check is probably not required
#269: FILE: ipc/mqueue.c:1157:
+	} else if (new_leaf) {
+		kfree(new_leaf);

total: 0 errors, 2 warnings, 194 lines checked

./patches/ipc-mqueue-add-rbtree-node-caching-support.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Doug Ledford <dledford@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/mqueue.c~ipc-mqueue-add-rbtree-node-caching-support-checkpatch-fixes ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-add-rbtree-node-caching-support-checkpatch-fixes
+++ a/ipc/mqueue.c
@@ -1046,7 +1046,7 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqd
 		info->node_cache = new_leaf;
 		info->qsize += sizeof(*new_leaf);
 		new_leaf = NULL;
-	} else if (new_leaf) {
+	} else {
 		kfree(new_leaf);
 	}
 
@@ -1153,7 +1153,7 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, 
 		INIT_LIST_HEAD(&new_leaf->msg_list);
 		info->node_cache = new_leaf;
 		info->qsize += sizeof(*new_leaf);
-	} else if (new_leaf) {
+	} else {
 		kfree(new_leaf);
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
isdn-add-missing-kern_cont.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format.patch
vsprintf-further-optimize-decimal-conversion.patch
proc-clean-up-proc-pid-environ-handling.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
ipc-mqueue-improve-performance-of-send-recv.patch
ipc-mqueue-correct-mq_attr_ok-test.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation.patch
tools-selftests-add-mq_perf_tests.patch
ipc-mqueue-add-rbtree-node-caching-support.patch
pidns-make-killed-children-autoreap-checkpatch-fixes.patch
fs-nls-add-apple-nls-fix.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch

