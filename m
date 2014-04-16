From: akpm@linux-foundation.org
Subject: + ipc-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
 added to -mm tree
Date: Wed, 16 Apr 2014 15:09:00 -0700
Message-ID: <534eff7c.lMyjESL2GxSXfH9v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641AbaDPWJB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 18:09:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + ipc-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 15:09:00 -0700


The patch titled
     Subject: ipc: convert use of typedef ctl_table to struct ctl_table
has been added to the -mm tree.  Its filename is
     ipc-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ipc: convert use of typedef ctl_table to struct ctl_table

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/ipc_sysctl.c |   14 +++++++-------
 ipc/mq_sysctl.c  |   12 ++++++------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff -puN ipc/ipc_sysctl.c~ipc-convert-use-of-typedef-ctl_table-to-struct-ctl_table ipc/ipc_sysctl.c
--- a/ipc/ipc_sysctl.c~ipc-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/ipc/ipc_sysctl.c
@@ -18,7 +18,7 @@
 #include <linux/msg.h>
 #include "util.h"
 
-static void *get_ipc(ctl_table *table)
+static void *get_ipc(struct ctl_table *table)
 {
 	char *which = table->data;
 	struct ipc_namespace *ipc_ns = current->nsproxy->ipc_ns;
@@ -27,7 +27,7 @@ static void *get_ipc(ctl_table *table)
 }
 
 #ifdef CONFIG_PROC_SYSCTL
-static int proc_ipc_dointvec(ctl_table *table, int write,
+static int proc_ipc_dointvec(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
@@ -38,7 +38,7 @@ static int proc_ipc_dointvec(ctl_table *
 	return proc_dointvec(&ipc_table, write, buffer, lenp, ppos);
 }
 
-static int proc_ipc_dointvec_minmax(ctl_table *table, int write,
+static int proc_ipc_dointvec_minmax(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
@@ -49,7 +49,7 @@ static int proc_ipc_dointvec_minmax(ctl_
 	return proc_dointvec_minmax(&ipc_table, write, buffer, lenp, ppos);
 }
 
-static int proc_ipc_dointvec_minmax_orphans(ctl_table *table, int write,
+static int proc_ipc_dointvec_minmax_orphans(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ipc_namespace *ns = current->nsproxy->ipc_ns;
@@ -62,7 +62,7 @@ static int proc_ipc_dointvec_minmax_orph
 	return err;
 }
 
-static int proc_ipc_callback_dointvec_minmax(ctl_table *table, int write,
+static int proc_ipc_callback_dointvec_minmax(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
@@ -85,7 +85,7 @@ static int proc_ipc_callback_dointvec_mi
 	return rc;
 }
 
-static int proc_ipc_doulongvec_minmax(ctl_table *table, int write,
+static int proc_ipc_doulongvec_minmax(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
@@ -119,7 +119,7 @@ static void ipc_auto_callback(int val)
 	}
 }
 
-static int proc_ipcauto_dointvec_minmax(ctl_table *table, int write,
+static int proc_ipcauto_dointvec_minmax(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
diff -puN ipc/mq_sysctl.c~ipc-convert-use-of-typedef-ctl_table-to-struct-ctl_table ipc/mq_sysctl.c
--- a/ipc/mq_sysctl.c~ipc-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/ipc/mq_sysctl.c
@@ -14,7 +14,7 @@
 #include <linux/sysctl.h>
 
 #ifdef CONFIG_PROC_SYSCTL
-static void *get_mq(ctl_table *table)
+static void *get_mq(struct ctl_table *table)
 {
 	char *which = table->data;
 	struct ipc_namespace *ipc_ns = current->nsproxy->ipc_ns;
@@ -22,7 +22,7 @@ static void *get_mq(ctl_table *table)
 	return which;
 }
 
-static int proc_mq_dointvec(ctl_table *table, int write,
+static int proc_mq_dointvec(struct ctl_table *table, int write,
 			    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table mq_table;
@@ -32,7 +32,7 @@ static int proc_mq_dointvec(ctl_table *t
 	return proc_dointvec(&mq_table, write, buffer, lenp, ppos);
 }
 
-static int proc_mq_dointvec_minmax(ctl_table *table, int write,
+static int proc_mq_dointvec_minmax(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table mq_table;
@@ -53,7 +53,7 @@ static int msg_max_limit_max = HARD_MSGM
 static int msg_maxsize_limit_min = MIN_MSGSIZEMAX;
 static int msg_maxsize_limit_max = HARD_MSGSIZEMAX;
 
-static ctl_table mq_sysctls[] = {
+static struct ctl_table mq_sysctls[] = {
 	{
 		.procname	= "queues_max",
 		.data		= &init_ipc_ns.mq_queues_max,
@@ -100,7 +100,7 @@ static ctl_table mq_sysctls[] = {
 	{}
 };
 
-static ctl_table mq_sysctl_dir[] = {
+static struct ctl_table mq_sysctl_dir[] = {
 	{
 		.procname	= "mqueue",
 		.mode		= 0555,
@@ -109,7 +109,7 @@ static ctl_table mq_sysctl_dir[] = {
 	{}
 };
 
-static ctl_table mq_sysctl_root[] = {
+static struct ctl_table mq_sysctl_root[] = {
 	{
 		.procname	= "fs",
 		.mode		= 0555,
_

Patches currently in -mm which might be from joe@perches.com are

arm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ia64-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
tile-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
cdrom-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
random-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
parport-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
scsi-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
coda-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
fscache-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
lockd-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
nfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
inotify-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ntfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
key-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ipc-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
sysctl-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
mm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
security-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
mm-utilc-add-kstrimdup.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch
init-mainc-dont-use-pr_debug.patch
linux-next.patch

