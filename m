From: akpm@linux-foundation.org
Subject: [folded] ipc-mqueue-improve-performance-of-send-recv-fix.patch removed from -mm tree
Date: Thu, 31 May 2012 16:16:47 -0700
Message-ID: <20120531231647.E01A2A009B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:64131 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758260Ab2EaXQs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 19:16:48 -0400
Received: by ghbz15 with SMTP id z15so161326ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 16:16:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dledford@redhat.com, kosaki.motohiro@jp.fujitsu.com, manfred@colorfullife.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-mqueue-improve-performance-of-send-recv-fix
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-improve-performance-of-send-recv-fix.patch

This patch was dropped because it was folded into ipc-mqueue-improve-performance-of-send-recv.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-mqueue-improve-performance-of-send-recv-fix

fix typo in comment, remove stray semicolon

Cc: Doug Ledford <dledford@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN ipc/mqueue.c~ipc-mqueue-improve-performance-of-send-recv-fix ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-improve-performance-of-send-recv-fix
+++ a/ipc/mqueue.c
@@ -132,7 +132,7 @@ static int msg_insert(struct msg_msg *ms
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
-	};
+	}
 	leaf = kzalloc(sizeof(struct posix_msg_tree_node), GFP_KERNEL);
 	if (!leaf)
 		return -ENOMEM;
@@ -160,9 +160,9 @@ try_again:
 	while (*p) {
 		parent = *p;
 		/*
-		 * During insert, low priorities fo to the left and high to
-		 * the right.  On receive, we want the highest priorities
-		 * first, so walk all the way to the right.
+		 * During insert, low priorities go to the left and high to the
+		 * right.  On receive, we want the highest priorities first, so
+		 * walk all the way to the right.
 		 */
 		p = &(*p)->rb_right;
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
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation-fix.patch
tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch
ipc-mqueue-add-rbtree-node-caching-support-checkpatch-fixes.patch
pidns-make-killed-children-autoreap-checkpatch-fixes.patch
fs-nls-add-apple-nls-fix.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch

