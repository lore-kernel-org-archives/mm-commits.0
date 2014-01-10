From: akpm@linux-foundation.org
Subject: + ipc-share-ids-rwsem-when-possible-in-ipcget_public.patch added
 to -mm tree
Date: Fri, 10 Jan 2014 15:19:35 -0800
Message-ID: <52d08007.BtydNV+o+BiRv8gM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaAJXTg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jan 2014 18:19:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, manfred@colorfullife.com, aswin@hp.com, davidlohr@hp.com

Subject: + ipc-share-ids-rwsem-when-possible-in-ipcget_public.patch added to -mm tree
To: davidlohr@hp.com,aswin@hp.com,manfred@colorfullife.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 10 Jan 2014 15:19:35 -0800


The patch titled
     Subject: ipc: share ids rwsem when possible in ipcget_public
has been added to the -mm tree.  Its filename is
     ipc-share-ids-rwsem-when-possible-in-ipcget_public.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-share-ids-rwsem-when-possible-in-ipcget_public.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-share-ids-rwsem-when-possible-in-ipcget_public.patch

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
Subject: ipc: share ids rwsem when possible in ipcget_public

...  and rewrite the function.  For scenarios where the key is found and
we end up just doing different routinary checks, we can downgrade the
ids->rwsem and share it among concurrent readers.  These checks include
the following, which are all safe to share the lock:

ops->more_checks() >>  sem_more_checks(), shm_more_checks()
ipc_check_perms()  >>  ipcperms(),ops->associate() >> [lsm]_[ipctype]_associate()

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   58 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

diff -puN ipc/util.c~ipc-share-ids-rwsem-when-possible-in-ipcget_public ipc/util.c
--- a/ipc/util.c~ipc-share-ids-rwsem-when-possible-in-ipcget_public
+++ a/ipc/util.c
@@ -183,7 +183,7 @@ void __init ipc_init_proc_interface(cons
  * ipc_findkey	- find a key in an ipc identifier set
  * @ids: ipc identifier set
  * @key: key to find
- *	
+ *
  * Returns the locked pointer to the ipc structure if found or NULL
  * otherwise. If key is found ipc points to the owning ipc structure
  *
@@ -375,48 +375,54 @@ static int ipc_check_perms(struct ipc_na
  * On success, the ipc id is returned.
  */
 static int ipcget_public(struct ipc_namespace *ns, struct ipc_ids *ids,
-		struct ipc_ops *ops, struct ipc_params *params)
+			 struct ipc_ops *ops, struct ipc_params *params)
 {
 	struct kern_ipc_perm *ipcp;
 	int flg = params->flg;
-	int err;
+	int err = 0;
 
-	/*
-	 * Take the lock as a writer since we are potentially going to add
-	 * a new entry + read locks are not "upgradable"
-	 */
 	down_write(&ids->rwsem);
 	ipcp = ipc_findkey(ids, params->key);
-	if (ipcp == NULL) {
+
+	if (!ipcp) {
 		/* key not used */
 		if (!(flg & IPC_CREAT))
 			err = -ENOENT;
-		else
+		else /* create new ipc object */
 			err = ops->getnew(ns, params);
-	} else {
-		/* ipc object has been locked by ipc_findkey() */
 
-		if (flg & IPC_CREAT && flg & IPC_EXCL)
-			err = -EEXIST;
-		else {
-			err = 0;
-			if (ops->more_checks)
-				err = ops->more_checks(ipcp, params);
-			if (!err)
-				/*
-				 * ipc_check_perms returns the IPC id on
-				 * success
-				 */
-				err = ipc_check_perms(ns, ipcp, ops, params);
-		}
+		goto done_write;
+	}
+
+	if ((flg & IPC_CREAT) && (flg & IPC_EXCL)) {
+		/* ipc object was locked by successful ipc_findkey() lookup */
 		ipc_unlock(ipcp);
+		err = -ENOENT;
+
+		goto done_write;
 	}
-	up_write(&ids->rwsem);
 
+	/*
+	 * The key was found, so we will just perform routinary checks on
+	 * ipc the object. Share the lock among other readers.
+	 */
+	downgrade_write(&ids->rwsem);
+
+	if (ops->more_checks)
+		err = ops->more_checks(ipcp, params);
+	if (!err)
+		/* returns the IPC id on success */
+		err = ipc_check_perms(ns, ipcp, ops, params);
+
+	ipc_unlock(ipcp);
+
+	up_read(&ids->rwsem);
+	return err;
+done_write:
+	up_write(&ids->rwsem);
 	return err;
 }
 
-
 /**
  * ipc_rmid - remove an ipc identifier
  * @ids: ipc identifier set
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

