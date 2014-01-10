From: akpm@linux-foundation.org
Subject: + ipc-simplify-sysvipc_proc_open-return.patch added to -mm tree
Date: Fri, 10 Jan 2014 15:19:33 -0800
Message-ID: <52d08005.SXi7g9xZWc+oswpP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaAJXTe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jan 2014 18:19:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, manfred@colorfullife.com, aswin@hp.com, davidlohr@hp.com

Subject: + ipc-simplify-sysvipc_proc_open-return.patch added to -mm tree
To: davidlohr@hp.com,aswin@hp.com,manfred@colorfullife.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 10 Jan 2014 15:19:33 -0800


The patch titled
     Subject: ipc: simplify sysvipc_proc_open() return
has been added to the -mm tree.  Its filename is
     ipc-simplify-sysvipc_proc_open-return.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-simplify-sysvipc_proc_open-return.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-simplify-sysvipc_proc_open-return.patch

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
Subject: ipc: simplify sysvipc_proc_open() return

Get rid of silly/useless label jumping.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN ipc/util.c~ipc-simplify-sysvipc_proc_open-return ipc/util.c
--- a/ipc/util.c~ipc-simplify-sysvipc_proc_open-return
+++ a/ipc/util.c
@@ -911,8 +911,10 @@ static int sysvipc_proc_open(struct inod
 		goto out;
 
 	ret = seq_open(file, &sysvipc_proc_seqops);
-	if (ret)
-		goto out_kfree;
+	if (ret) {
+		kfree(iter);
+		goto out;
+	}
 
 	seq = file->private_data;
 	seq->private = iter;
@@ -921,9 +923,6 @@ static int sysvipc_proc_open(struct inod
 	iter->ns    = get_ipc_ns(current->nsproxy->ipc_ns);
 out:
 	return ret;
-out_kfree:
-	kfree(iter);
-	goto out;
 }
 
 static int sysvipc_proc_release(struct inode *inode, struct file *file)
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

