From: akpm@linux-foundation.org
Subject: - integrity-ima-cleanup.patch removed from -mm tree
Date: Tue, 22 May 2007 14:24:43 -0700
Message-ID: <200705222124.l4MLOhNG010124@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33063 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757726AbXEVV0x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 17:26:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, kjhall@us.ibm.com, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     integrity: ima cleanup
has been removed from the -mm tree.  Its filename was
     integrity-ima-cleanup.patch

This patch was dropped because this work seems to be stalled

------------------------------------------------------
Subject: integrity: ima cleanup
From: Mimi Zohar <zohar@linux.vnet.ibm.com>

This patch cleanups the few Lindent and sparse msgs

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Kylene Hall <kjhall@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/evm/ima/ima.h    |    6 +++---
 security/evm/ima/ima_fs.c |   12 ++++--------
 2 files changed, 7 insertions(+), 11 deletions(-)

diff -puN security/evm/ima/ima.h~integrity-ima-cleanup security/evm/ima/ima.h
--- a/security/evm/ima/ima.h~integrity-ima-cleanup
+++ a/security/evm/ima/ima.h
@@ -52,7 +52,7 @@ struct ima_measure_entry {
 
 struct ima_queue_entry {
 	struct hlist_node hnext;	/* place in hash collision list */
-	struct list_head later;	/* place in ima_measurements list */
+	struct list_head later;		/* place in ima_measurements list */
 	struct ima_measure_entry *entry;
 };
 
@@ -72,7 +72,7 @@ struct ima_queue_entry *ima_lookup_diges
 extern spinlock_t ima_queue_lock;
 
 struct ima_h_table {
-	atomic_t len;	/* number of stored measurements in the list */
+	atomic_t len;		/* number of stored measurements in the list */
 	atomic_t violations;
 	unsigned int max_htable_size;
 	struct hlist_head queue[IMA_MEASURE_HTABLE_SIZE];
@@ -82,7 +82,7 @@ extern struct ima_h_table ima_htable;
 
 /* TPM "Glue" definitions */
 
-#define IMA_TPM ((TPM_ANY_TYPE<<16)| TPM_ANY_NUM)
+#define IMA_TPM ((((u32)TPM_ANY_TYPE)<<16)| (u32)TPM_ANY_NUM)
 static inline void ima_extend(const u8 * hash)
 {
 	if (!ima_used_chip)
diff -puN security/evm/ima/ima_fs.c~integrity-ima-cleanup security/evm/ima/ima_fs.c
--- a/security/evm/ima/ima_fs.c~integrity-ima-cleanup
+++ a/security/evm/ima/ima_fs.c
@@ -69,12 +69,11 @@ static void *ima_measurements_start(stru
 	return NULL;
 }
 
-static void *ima_measurements_next(struct seq_file *m, void *v,
-				   loff_t * pos)
+static void *ima_measurements_next(struct seq_file *m, void *v, loff_t * pos)
 {
 	/* lock protects when reading beyond last element
 	 * against concurrent list-extension */
-	struct list_head *lpos = (struct list_head *) v;
+	struct list_head *lpos = (struct list_head *)v;
 
 	rcu_read_lock();
 	lpos = rcu_dereference(lpos->next);
@@ -88,7 +87,6 @@ static void ima_measurements_stop(struct
 {
 }
 
-
 /* print format:
  *       32bit-le=pcr#
  *       32bit-le=type# << flag
@@ -207,8 +205,7 @@ static struct seq_operations ima_ascii_m
 	.show = ima_ascii_measurements_show
 };
 
-static int ima_ascii_measurements_open(struct inode *inode,
-				       struct file *file)
+static int ima_ascii_measurements_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &ima_ascii_measurements_seqops);
 }
@@ -255,8 +252,7 @@ int ima_fs_init(void)
 
 	violations =
 	    securityfs_create_file("violations", S_IRUSR | S_IRGRP,
-				   ima_dir, NULL,
-				   &ima_htable_violations_ops);
+				   ima_dir, NULL, &ima_htable_violations_ops);
 	if (!violations || IS_ERR(violations))
 		goto out;
 	return 0;
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

integrity-ima-cleanup.patch
integrity-tpm-internal-kernel-interface.patch
ibac-patch.patch
