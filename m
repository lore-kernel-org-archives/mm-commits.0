From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 007/155] ocfs2: remove unused macros
Date: Wed, 01 Apr 2020 21:03:25 -0700
Message-ID: <20200402040325.HjgkTBd0-%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBED0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:03:26 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.shi@linux.alibaba.com, cg.chen@huawei.com, gechangwei@live.cn, ghe@suse.com, gregkh@linuxfoundation.org, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com, rfontana@redhat.com, tglx@linutronix.de, torvalds@linux-foundation.org

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
