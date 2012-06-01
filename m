From: akpm@linux-foundation.org
Subject: [merged] mqueue-revert-bump-up-dflt_max.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:34:43 -0700
Message-ID: <20120601193443.ECB81A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:41153 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804Ab2FATep (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:34:45 -0400
Received: by mail-ee0-f74.google.com with SMTP id t10so140727eei.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:34:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, amwang@redhat.com, dledford@redhat.com, haveblue@us.ibm.com, joe.korty@ccur.com, jslaby@suse.cz, manfred@colorfullife.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mqueue: revert bump up DFLT_*MAX
has been removed from the -mm tree.  Its filename was
     mqueue-revert-bump-up-dflt_max.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mqueue: revert bump up DFLT_*MAX

Mqueue limitation is slightly naieve parameter likes other ipcs because
unprivileged user can consume kernel memory by using ipcs.

Thus, too aggressive raise bring us security issue.  Example, current
setting allow evil unprivileged user use 256GB (= 256 * 1024 * 1024*1024)
and it's enough large to system will belome unresponsive.  Don't do that.

Instead, every admin should adjust the knobs for their own systems.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Doug Ledford <dledford@redhat.com>
Acked-by: Joe Korty <joe.korty@ccur.com>
Cc: Amerigo Wang <amwang@redhat.com>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/ipc_namespace.h~mqueue-revert-bump-up-dflt_max include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~mqueue-revert-bump-up-dflt_max
+++ a/include/linux/ipc_namespace.h
@@ -118,12 +118,12 @@ extern int mq_init_ns(struct ipc_namespa
 #define DFLT_QUEUESMAX		      256
 #define HARD_QUEUESMAX		     1024
 #define MIN_MSGMAX			1
-#define DFLT_MSG		       64U
-#define DFLT_MSGMAX		     1024
+#define DFLT_MSG		       10U
+#define DFLT_MSGMAX		       10
 #define HARD_MSGMAX		    65536
 #define MIN_MSGSIZEMAX		      128
 #define DFLT_MSGSIZE		     8192U
-#define DFLT_MSGSIZEMAX	       (1024*1024)
+#define DFLT_MSGSIZEMAX		     8192
 #define HARD_MSGSIZEMAX	    (16*1024*1024)
 #else
 static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mqueue-dont-use-kmalloc-with-kmalloc_max_size.patch
mqueue-separate-mqueue-default-value-from-maximum-value-v2.patch
selftests-add-mq_open_tests.patch
ipc-mqueue-improve-performance-of-send-recv.patch
ipc-mqueue-correct-mq_attr_ok-test.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation.patch
tools-selftests-add-mq_perf_tests.patch
ipc-mqueue-add-rbtree-node-caching-support.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

