From: akpm@linux-foundation.org
Subject: [merged] ipc-delete-seq_max-field-in-struct-ipc_ids.patch removed from -mm tree
Date: Tue, 28 Jan 2014 11:09:39 -0800
Message-ID: <52e80073.3Wc5Gq4HIFZq+J2H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557AbaA1TJk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, manfred@colorfullife.com, jgonzalez@linets.cl, aswin@hp.com, davidlohr@hp.com

Subject: [merged] ipc-delete-seq_max-field-in-struct-ipc_ids.patch removed from -mm tree
To: davidlohr@hp.com,aswin@hp.com,jgonzalez@linets.cl,manfred@colorfullife.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:39 -0800


The patch titled
     Subject: ipc: delete seq_max field in struct ipc_ids
has been removed from the -mm tree.  Its filename was
     ipc-delete-seq_max-field-in-struct-ipc_ids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: ipc: delete seq_max field in struct ipc_ids

This field is only used to reset the ids seq number if it exceeds the
smaller of INT_MAX/SEQ_MULTIPLIER and USHRT_MAX, and can therefore be
moved out of the structure and into its own macro.  Since each
ipc_namespace contains a table of 3 pointers to struct ipc_ids we can save
space in instruction text:

   text    data     bss     dec     hex filename
  56232    2348      24   58604    e4ec ipc/built-in.o
  56216    2348      24   58588    e4dc ipc/built-in.o-after

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Reviewed-by: Jonathan Gonzalez <jgonzalez@linets.cl>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    1 -
 ipc/util.c                    |   13 ++-----------
 ipc/util.h                    |    1 +
 3 files changed, 3 insertions(+), 12 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipc-delete-seq_max-field-in-struct-ipc_ids include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-delete-seq_max-field-in-struct-ipc_ids
+++ a/include/linux/ipc_namespace.h
@@ -21,7 +21,6 @@ struct user_namespace;
 struct ipc_ids {
 	int in_use;
 	unsigned short seq;
-	unsigned short seq_max;
 	struct rw_semaphore rwsem;
 	struct idr ipcs_idr;
 	int next_id;
diff -puN ipc/util.c~ipc-delete-seq_max-field-in-struct-ipc_ids ipc/util.c
--- a/ipc/util.c~ipc-delete-seq_max-field-in-struct-ipc_ids
+++ a/ipc/util.c
@@ -139,19 +139,10 @@ __initcall(ipc_init);
  */
 void ipc_init_ids(struct ipc_ids *ids)
 {
-	init_rwsem(&ids->rwsem);
-
 	ids->in_use = 0;
 	ids->seq = 0;
 	ids->next_id = -1;
-	{
-		int seq_limit = INT_MAX/SEQ_MULTIPLIER;
-		if (seq_limit > USHRT_MAX)
-			ids->seq_max = USHRT_MAX;
-		 else
-			ids->seq_max = seq_limit;
-	}
-
+	init_rwsem(&ids->rwsem);
 	idr_init(&ids->ipcs_idr);
 }
 
@@ -304,7 +295,7 @@ int ipc_addid(struct ipc_ids *ids, struc
 
 	if (next_id < 0) {
 		new->seq = ids->seq++;
-		if (ids->seq > ids->seq_max)
+		if (ids->seq > IPCID_SEQ_MAX)
 			ids->seq = 0;
 	} else {
 		new->seq = ipcid_to_seqx(next_id);
diff -puN ipc/util.h~ipc-delete-seq_max-field-in-struct-ipc_ids ipc/util.h
--- a/ipc/util.h~ipc-delete-seq_max-field-in-struct-ipc_ids
+++ a/ipc/util.h
@@ -100,6 +100,7 @@ void __init ipc_init_proc_interface(cons
 
 #define ipcid_to_idx(id) ((id) % SEQ_MULTIPLIER)
 #define ipcid_to_seqx(id) ((id) / SEQ_MULTIPLIER)
+#define IPCID_SEQ_MAX min_t(int, INT_MAX/SEQ_MULTIPLIER, USHRT_MAX)
 
 /* must be called with ids->rwsem acquired for writing */
 int ipc_addid(struct ipc_ids *, struct kern_ipc_perm *, int);
_

Patches currently in -mm which might be from davidlohr@hp.com are

origin.patch
linux-next.patch

