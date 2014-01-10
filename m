From: akpm@linux-foundation.org
Subject: + ipc-delete-seq_max-field-in-struct-ipc_ids.patch added to -mm
 tree
Date: Fri, 10 Jan 2014 15:19:34 -0800
Message-ID: <52d08006.yXJhwsQ+wO0Sy+KQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaAJXTf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jan 2014 18:19:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, manfred@colorfullife.com, jgonzalez@linets.cl, aswin@hp.com, davidlohr@hp.com

Subject: + ipc-delete-seq_max-field-in-struct-ipc_ids.patch added to -mm tree
To: davidlohr@hp.com,aswin@hp.com,jgonzalez@linets.cl,manfred@colorfullife.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 10 Jan 2014 15:19:34 -0800


The patch titled
     Subject: ipc: delete seq_max field in struct ipc_ids
has been added to the -mm tree.  Its filename is
     ipc-delete-seq_max-field-in-struct-ipc_ids.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-delete-seq_max-field-in-struct-ipc_ids.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-delete-seq_max-field-in-struct-ipc_ids.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Manfred Spraul <manfred@colorfullife.com>
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

x86-mm-account-for-tlb-flushes-only-when-debugging.patch
x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch
x86-mm-eliminate-redundant-page-table-walk-during-tlb-range-flushing.patch
x86-mm-change-tlb_flushall_shift-for-ivybridge.patch
mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge.patch
mm-mmapc-add-mlock_future_check-helper.patch
mm-mlock-prepare-params-outside-critical-region.patch
partitions-efi-complete-documentation-of-gpt-kernel-param-purpose.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix-2.patch
ipc-introduce-ipc_valid_object-helper-to-sort-out-ipc_rmid-races.patch
ipc-change-kern_ipc_permdeleted-type-to-bool.patch
ipc-whitespace-cleanup.patch
ipc-standardize-code-comments.patch
ipc-remove-braces-for-single-statements.patch
ipc-remove-useless-return-statement.patch
ipc-simplify-sysvipc_proc_open-return.patch
ipc-delete-seq_max-field-in-struct-ipc_ids.patch
ipc-share-ids-rwsem-when-possible-in-ipcget_public.patch
ipcmsg-document-barriers.patch

