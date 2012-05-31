From: akpm@linux-foundation.org
Subject: [folded] ipc-mqueue-correct-mq_attr_ok-test-fix.patch removed from -mm tree
Date: Thu, 31 May 2012 16:17:38 -0700
Message-ID: <20120531231739.201DAA009B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:61605 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab2EaXRk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 19:17:40 -0400
Received: by vcbfl13 with SMTP id fl13so161661vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 16:17:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dledford@redhat.com, kosaki.motohiro@jp.fujitsu.com, manfred@colorfullife.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-mqueue-correct-mq_attr_ok-test-fix
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-correct-mq_attr_ok-test-fix.patch

This patch was dropped because it was folded into ipc-mqueue-correct-mq_attr_ok-test.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-mqueue-correct-mq_attr_ok-test-fix

add a local to simplify overflow-checking expression

Cc: Doug Ledford <dledford@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN ipc/mqueue.c~ipc-mqueue-correct-mq_attr_ok-test-fix ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-correct-mq_attr_ok-test-fix
+++ a/ipc/mqueue.c
@@ -672,6 +672,7 @@ static void remove_notification(struct m
 static int mq_attr_ok(struct ipc_namespace *ipc_ns, struct mq_attr *attr)
 {
 	int mq_treesize;
+	unsigned long total_size;
 
 	if (attr->mq_maxmsg <= 0 || attr->mq_msgsize <= 0)
 		return 0;
@@ -690,9 +691,8 @@ static int mq_attr_ok(struct ipc_namespa
 	mq_treesize = attr->mq_maxmsg * sizeof(struct msg_msg) +
 		min_t(unsigned int, attr->mq_maxmsg, MQ_PRIO_MAX) *
 		sizeof(struct posix_msg_tree_node);
-	if ((unsigned long)(attr->mq_maxmsg * attr->mq_msgsize +
-			    mq_treesize) <
-	    (unsigned long)(attr->mq_maxmsg * attr->mq_msgsize))
+	total_size = attr->mq_maxmsg * attr->mq_msgsize;
+	if (total_size + mq_treesize < total_size)
 		return 0;
 	return 1;
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
ipc-mqueue-strengthen-checks-on-mqueue-creation-fix.patch
tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch
ipc-mqueue-add-rbtree-node-caching-support-checkpatch-fixes.patch
pidns-make-killed-children-autoreap-checkpatch-fixes.patch
fs-nls-add-apple-nls-fix.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch

