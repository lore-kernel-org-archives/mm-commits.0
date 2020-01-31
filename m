From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 013/118] ocfs2: make local header paths relative
 to C files
Date: Thu, 30 Jan 2020 22:11:40 -0800
Message-ID: <20200131061140.sbmg7mOav%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGLm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:11:42 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com, masahiroy@kernel.org, mm-commits@vger.kernel.org, piaojun@huawei.com, torvalds@linux-foundation.org

From: Masahiro Yamada <masahiroy@kernel.org>
Subject: ocfs2: make local header paths relative to C files

Gang He reports the failure of building fs/ocfs2/ as an external module of
the kernel installed on the system:

 $ cd fs/ocfs2
 $ make -C /lib/modules/`uname -r`/build M=`pwd` modules

If you want to make it work reliably, I'd recommend to remove ccflags-y
from the Makefiles, and to make header paths relative to the C files.
I think this is the correct usage of the #include "..." directive.

Link: http://lkml.kernel.org/r/20191227022950.14804-1-ghe@suse.com
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Gang He <ghe@suse.com>
Reported-by: Gang He <ghe@suse.com>
Reviewed-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/Makefile      |    2 --
 fs/ocfs2/dlm/dlmast.c      |    8 ++++----
 fs/ocfs2/dlm/dlmconvert.c  |    8 ++++----
 fs/ocfs2/dlm/dlmdebug.c    |    8 ++++----
 fs/ocfs2/dlm/dlmdomain.c   |    8 ++++----
 fs/ocfs2/dlm/dlmlock.c     |    8 ++++----
 fs/ocfs2/dlm/dlmmaster.c   |    8 ++++----
 fs/ocfs2/dlm/dlmrecovery.c |    8 ++++----
 fs/ocfs2/dlm/dlmthread.c   |    8 ++++----
 fs/ocfs2/dlm/dlmunlock.c   |    8 ++++----
 fs/ocfs2/dlmfs/Makefile    |    2 --
 fs/ocfs2/dlmfs/dlmfs.c     |    4 ++--
 fs/ocfs2/dlmfs/userdlm.c   |    6 +++---
 13 files changed, 41 insertions(+), 45 deletions(-)

--- a/fs/ocfs2/dlm/dlmast.c~ocfs2-make-local-header-paths-relative-to-c-files
+++ a/fs/ocfs2/dlm/dlmast.c
@@ -23,15 +23,15 @@
 #include <linux/spinlock.h>
 
 
-#include "cluster/heartbeat.h"
-#include "cluster/nodemanager.h"
-#include "cluster/tcp.h"
+#include "../cluster/heartbeat.h"
+#include "../cluster/nodemanager.h"
+#include "../cluster/tcp.h"
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
 
 #define MLOG_MASK_PREFIX ML_DLM
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 static void dlm_update_lvb(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
 			   struct dlm_lock *lock);
--- a/fs/ocfs2/dlm/dlmconvert.c~ocfs2-make-local-header-paths-relative-to-c-files
+++ a/fs/ocfs2/dlm/dlmconvert.c
@@ -23,9 +23,9 @@
 #include <linux/spinlock.h>
 
 
-#include "cluster/heartbeat.h"
-#include "cluster/nodemanager.h"
-#include "cluster/tcp.h"
+#include "../cluster/heartbeat.h"
+#include "../cluster/nodemanager.h"
+#include "../cluster/tcp.h"
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
@@ -33,7 +33,7 @@
 #include "dlmconvert.h"
 
 #define MLOG_MASK_PREFIX ML_DLM
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 /* NOTE: __dlmconvert_master is the only function in here that
  * needs a spinlock held on entry (res->spinlock) and it is the
--- a/fs/ocfs2/dlm/dlmdebug.c~ocfs2-make-local-header-paths-relative-to-c-files
+++ a/fs/ocfs2/dlm/dlmdebug.c
@@ -17,9 +17,9 @@
 #include <linux/debugfs.h>
 #include <linux/export.h>
 
-#include "cluster/heartbeat.h"
-#include "cluster/nodemanager.h"
-#include "cluster/tcp.h"
+#include "../cluster/heartbeat.h"
+#include "../cluster/nodemanager.h"
+#include "../cluster/tcp.h"
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
@@ -27,7 +27,7 @@
 #include "dlmdebug.h"
 
 #define MLOG_MASK_PREFIX ML_DLM
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 static int stringify_lockname(const char *lockname, int locklen, char *buf,
 			      int len);
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-make-local-header-paths-relative-to-c-files
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -20,9 +20,9 @@
 #include <linux/debugfs.h>
 #include <linux/sched/signal.h>
 
-#include "cluster/heartbeat.h"
-#include "cluster/nodemanager.h"
-#include "cluster/tcp.h"
+#include "../cluster/heartbeat.h"
+#include "../cluster/nodemanager.h"
+#include "../cluster/tcp.h"
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
@@ -30,7 +30,7 @@
 #include "dlmdebug.h"
 
 #define MLOG_MASK_PREFIX (ML_DLM|ML_DLM_DOMAIN)
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 /*
  * ocfs2 node maps are array of long int, which limits to send them freely
--- a/fs/ocfs2/dlm/dlmlock.c~ocfs2-make-local-header-paths-relative-to-c-files
+++ a/fs/ocfs2/dlm/dlmlock.c
@@ -25,9 +25,9 @@
 #include <linux/delay.h>
 
 
-#include "cluster/heartbeat.h"
-#include "cluster/nodemanager.h"
-#include "cluster/tcp.h"
+#include "../cluster/heartbeat.h"
+#include "../cluster/nodemanager.h"
+#include "../cluster/tcp.h"
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
@@ -35,7 +35,7 @@
 #include "dlmconvert.h"
 
 #define MLOG_MASK_PREFIX ML_DLM
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 static struct kmem_cache *dlm_lock_cache;
 
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-make-local-header-paths-relative-to-c-files
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -25,9 +25,9 @@
 #include <linux/delay.h>
 
 
-#include "cluster/heartbeat.h"
-#include "cluster/nodemanager.h"
-#include "cluster/tcp.h"
+#include "../cluster/heartbeat.h"
+#include "../cluster/nodemanager.h"
+#include "../cluster/tcp.h"
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
@@ -35,7 +35,7 @@
 #include "dlmdebug.h"
 
 #define MLOG_MASK_PREFIX (ML_DLM|ML_DLM_MASTER)
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 static void dlm_mle_node_down(struct dlm_ctxt *dlm,
 			      struct dlm_master_list_entry *mle,
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-make-local-header-paths-relative-to-c-files
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -26,16 +26,16 @@
 #include <linux/delay.h>
 
 
-#include "cluster/heartbeat.h"
-#include "cluster/nodemanager.h"
-#include "cluster/tcp.h"
+#include "../cluster/heartbeat.h"
+#include "../cluster/nodemanager.h"
+#include "../cluster/tcp.h"
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
 #include "dlmdomain.h"
 
 #define MLOG_MASK_PREFIX (ML_DLM|ML_DLM_RECOVERY)
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8 dead_node);
 
--- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-make-local-header-paths-relative-to-c-files
+++ a/fs/ocfs2/dlm/dlmthread.c
@@ -25,16 +25,16 @@
 #include <linux/delay.h>
 
 
-#include "cluster/heartbeat.h"
-#include "cluster/nodemanager.h"
-#include "cluster/tcp.h"
+#include "../cluster/heartbeat.h"
+#include "../cluster/nodemanager.h"
+#include "../cluster/tcp.h"
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
 #include "dlmdomain.h"
 
 #define MLOG_MASK_PREFIX (ML_DLM|ML_DLM_THREAD)
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 static int dlm_thread(void *data);
 static void dlm_flush_asts(struct dlm_ctxt *dlm);
--- a/fs/ocfs2/dlm/dlmunlock.c~ocfs2-make-local-header-paths-relative-to-c-files
+++ a/fs/ocfs2/dlm/dlmunlock.c
@@ -23,15 +23,15 @@
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 
-#include "cluster/heartbeat.h"
-#include "cluster/nodemanager.h"
-#include "cluster/tcp.h"
+#include "../cluster/heartbeat.h"
+#include "../cluster/nodemanager.h"
+#include "../cluster/tcp.h"
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
 
 #define MLOG_MASK_PREFIX ML_DLM
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 #define DLM_UNLOCK_FREE_LOCK           0x00000001
 #define DLM_UNLOCK_CALL_AST            0x00000002
--- a/fs/ocfs2/dlmfs/dlmfs.c~ocfs2-make-local-header-paths-relative-to-c-files
+++ a/fs/ocfs2/dlmfs/dlmfs.c
@@ -33,11 +33,11 @@
 
 #include <linux/uaccess.h>
 
-#include "stackglue.h"
+#include "../stackglue.h"
 #include "userdlm.h"
 
 #define MLOG_MASK_PREFIX ML_DLMFS
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 
 static const struct super_operations dlmfs_ops;
--- a/fs/ocfs2/dlmfs/Makefile~ocfs2-make-local-header-paths-relative-to-c-files
+++ a/fs/ocfs2/dlmfs/Makefile
@@ -1,6 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
-ccflags-y := -I $(srctree)/$(src)/..
-
 obj-$(CONFIG_OCFS2_FS) += ocfs2_dlmfs.o
 
 ocfs2_dlmfs-objs := userdlm.o dlmfs.o
--- a/fs/ocfs2/dlmfs/userdlm.c~ocfs2-make-local-header-paths-relative-to-c-files
+++ a/fs/ocfs2/dlmfs/userdlm.c
@@ -21,12 +21,12 @@
 #include <linux/types.h>
 #include <linux/crc32.h>
 
-#include "ocfs2_lockingver.h"
-#include "stackglue.h"
+#include "../ocfs2_lockingver.h"
+#include "../stackglue.h"
 #include "userdlm.h"
 
 #define MLOG_MASK_PREFIX ML_DLMFS
-#include "cluster/masklog.h"
+#include "../cluster/masklog.h"
 
 
 static inline struct user_lock_res *user_lksb_to_lock_res(struct ocfs2_dlm_lksb *lksb)
--- a/fs/ocfs2/dlm/Makefile~ocfs2-make-local-header-paths-relative-to-c-files
+++ a/fs/ocfs2/dlm/Makefile
@@ -1,6 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
-ccflags-y := -I $(srctree)/$(src)/..
