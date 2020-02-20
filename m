From: akpm@linux-foundation.org
Subject: + ocfs2-remove-unused-macros.patch added to -mm tree
Date: Wed, 19 Feb 2020 16:07:30 -0800
Message-ID: <20200220000730.HUICS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbgBTAHc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 19:07:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rfontana@redhat.com, piaojun@huawei.com, mark@fasheh.com, junxiao.bi@oracle.com, jlbec@evilplan.org, jiangqi903@gmail.com, gregkh@linuxfoundation.org, ghe@suse.com, gechangwei@live.cn, cg.chen@huawei.com, alex.shi@linux.alibaba.com


The patch titled
     Subject: ocfs2: remove unused macros
has been added to the -mm tree.  Its filename is
     ocfs2-remove-unused-macros.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-unused-macros.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-unused-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: ocfs2: remove unused macros

O2HB_DEFAULT_BLOCK_BITS/DLM_THREAD_MAX_ASTS/DLM_MIGRATION_RETRY_MS and
OCFS2_MAX_RESV_WINDOW_BITS/OCFS2_MIN_RESV_WINDOW_BITS have been unused
since commit 66effd3c6812 ("ocfs2/dlm: Do not migrate resource to a node
that is leaving the domain").

Link: http://lkml.kernel.org/r/1579577827-251796-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ChenGang <cg.chen@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Fontana <rfontana@redhat.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    2 --
 fs/ocfs2/dlm/dlmmaster.c     |    2 --
 fs/ocfs2/dlm/dlmthread.c     |    1 -
 fs/ocfs2/reservations.c      |    3 ---
 4 files changed, 8 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-remove-unused-macros
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -101,8 +101,6 @@ static struct o2hb_callback {
 
 static struct o2hb_callback *hbcall_from_type(enum o2hb_callback_type type);
 
-#define O2HB_DEFAULT_BLOCK_BITS       9
-
 enum o2hb_heartbeat_modes {
 	O2HB_HEARTBEAT_LOCAL		= 0,
 	O2HB_HEARTBEAT_GLOBAL,
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-remove-unused-macros
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2749,8 +2749,6 @@ leave:
 	return ret;
 }
 
-#define DLM_MIGRATION_RETRY_MS  100
-
 /*
  * Should be called only after beginning the domain leave process.
  * There should not be any remaining locks on nonlocal lock resources,
--- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-remove-unused-macros
+++ a/fs/ocfs2/dlm/dlmthread.c
@@ -680,7 +680,6 @@ static void dlm_flush_asts(struct dlm_ct
 
 #define DLM_THREAD_TIMEOUT_MS (4 * 1000)
 #define DLM_THREAD_MAX_DIRTY  100
-#define DLM_THREAD_MAX_ASTS   10
 
 static int dlm_thread(void *data)
 {
--- a/fs/ocfs2/reservations.c~ocfs2-remove-unused-macros
+++ a/fs/ocfs2/reservations.c
@@ -33,9 +33,6 @@
 
 static DEFINE_SPINLOCK(resv_lock);
 
-#define	OCFS2_MIN_RESV_WINDOW_BITS	8
-#define	OCFS2_MAX_RESV_WINDOW_BITS	1024
