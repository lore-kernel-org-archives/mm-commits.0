From: akpm@linux-foundation.org
Subject: + mqueue-revert-bump-up-dflt_max.patch added to -mm tree
Date: Tue, 17 Apr 2012 15:17:59 -0700
Message-ID: <20120417221759.E38DDA038B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:61558 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab2DQWSA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Apr 2012 18:18:00 -0400
Received: by ghbz15 with SMTP id z15so783480ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Apr 2012 15:18:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, amwang@redhat.com, dledford@redhat.com, joe.korty@ccur.com, jslaby@suse.cz, manfred@colorfullife.com, serue@us.ibm.com


The patch titled
     Subject: mqueue: revert bump up DFLT_*MAX
has been added to the -mm tree.  Its filename is
     mqueue-revert-bump-up-dflt_max.patch

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
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Manfred Spraul <manfred@colorfullife.com>
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
Subject: Subject: mqueue: revert bump up DFLT_*MAX

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

