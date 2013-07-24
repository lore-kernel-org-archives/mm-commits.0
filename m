From: akpm@linux-foundation.org
Subject: + ocfs2-lighten-up-allocate-transaction.patch added to -mm tree
Date: Wed, 24 Jul 2013 16:03:57 -0700
Message-ID: <51f05d5d.N9OvEicLnAG/G9by%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab3GXXD6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 19:03:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, younger.liu@huawei.com

Subject: + ocfs2-lighten-up-allocate-transaction.patch added to -mm tree
To: younger.liu@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 16:03:57 -0700


The patch titled
     Subject: ocfs2: lighten up allocate transaction
has been added to the -mm tree.  Its filename is
     ocfs2-lighten-up-allocate-transaction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-lighten-up-allocate-transaction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-lighten-up-allocate-transaction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Younger Liu <younger.liu@huawei.com>
Subject: ocfs2: lighten up allocate transaction

The issue scenario is as following:

When fallocating a very large disk space for a small file,
__ocfs2_extend_allocation attempts to get a very large transaction.  For
some journal sizes, there may be not enough room for this transaction, and
the fallocate will fail.

The patch below extends & restarts the transaction as necessary while
allocating space, and should work with even the smallest journal.  This
patch refers ext4 resize.

Test:
# mkfs.ocfs2 -b 4K -C 32K -T datafiles /dev/sdc
...(jounral size is 32M)
# mount.ocfs2 /dev/sdc /mnt/ocfs2/
# touch /mnt/ocfs2/1.log
# fallocate -o 0 -l 400G /mnt/ocfs2/1.log
fallocate: /mnt/ocfs2/1.log: fallocate failed: Cannot allocate memory
# tail -f /var/log/messages
[ 7372.278591] JBD: fallocate wants too many credits (2051 > 2048)
[ 7372.278597] (fallocate,6438,0):__ocfs2_extend_allocation:709 ERROR: status = -12
[ 7372.278603] (fallocate,6438,0):ocfs2_allocate_unwritten_extents:1504 ERROR: status = -12
[ 7372.278607] (fallocate,6438,0):__ocfs2_change_file_space:1955 ERROR: status = -12
^C
With this patch, the test works well.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Cc: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c        |    6 +-----
 fs/ocfs2/journal.c     |   35 +++++++++++++++++++++++++++++++++++
 fs/ocfs2/journal.h     |   11 +++++++++++
 fs/ocfs2/ocfs2_trace.h |    2 ++
 4 files changed, 49 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/file.c~ocfs2-lighten-up-allocate-transaction fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-lighten-up-allocate-transaction
+++ a/fs/ocfs2/file.c
@@ -666,11 +666,7 @@ restarted_transaction:
 		} else {
 			BUG_ON(why != RESTART_TRANS);
 
-			/* TODO: This can be more intelligent. */
-			credits = ocfs2_calc_extend_credits(osb->sb,
-							    &fe->id2.i_list,
-							    clusters_to_add);
-			status = ocfs2_extend_trans(handle, credits);
+			status = ocfs2_allocate_extend_trans(handle, 1);
 			if (status < 0) {
 				/* handle still has to be committed at
 				 * this point. */
diff -puN fs/ocfs2/journal.c~ocfs2-lighten-up-allocate-transaction fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-lighten-up-allocate-transaction
+++ a/fs/ocfs2/journal.c
@@ -455,6 +455,41 @@ bail:
 	return status;
 }
 
+/*
+ * If we have fewer than thresh credits, extend by OCFS2_MAX_TRANS_DATA.
+ * If that fails, restart the transaction & regain write access for the
+ * buffer head which is used for metadata modifications.
+ * Taken from Ext4: extend_or_restart_transaction()
+ */
+int ocfs2_allocate_extend_trans(handle_t *handle, int thresh)
+{
+	int status, old_nblks;
+
+	BUG_ON(!handle);
+
+	old_nblks = handle->h_buffer_credits;
+	trace_ocfs2_allocate_extend_trans(old_nblks, thresh);
+
+	if (old_nblks < thresh)
+		return 0;
+
+	status = jbd2_journal_extend(handle, OCFS2_MAX_TRANS_DATA);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+
+	if (status > 0) {
+		status = jbd2_journal_restart(handle, OCFS2_MAX_TRANS_DATA);
+		if (status < 0)
+			mlog_errno(status);
+	}
+
+bail:
+	return status;
+}
+
+
 struct ocfs2_triggers {
 	struct jbd2_buffer_trigger_type	ot_triggers;
 	int				ot_offset;
diff -puN fs/ocfs2/journal.h~ocfs2-lighten-up-allocate-transaction fs/ocfs2/journal.h
--- a/fs/ocfs2/journal.h~ocfs2-lighten-up-allocate-transaction
+++ a/fs/ocfs2/journal.h
@@ -258,6 +258,17 @@ handle_t		    *ocfs2_start_trans(struct
 int			     ocfs2_commit_trans(struct ocfs2_super *osb,
 						handle_t *handle);
 int			     ocfs2_extend_trans(handle_t *handle, int nblocks);
+int			     ocfs2_allocate_extend_trans(handle_t *handle,
+						int thresh);
+
+/*
+ * Define an arbitrary limit for the amount of data we will anticipate
+ * writing to any given transaction.  For unbounded transactions such as
+ * fallocate(2) we can write more than this, but we always
+ * start off at the maximum transaction size and grow the transaction
+ * optimistically as we go.
+ */
+#define OCFS2_MAX_TRANS_DATA	64U
 
 /*
  * Create access is for when we get a newly created buffer and we're
diff -puN fs/ocfs2/ocfs2_trace.h~ocfs2-lighten-up-allocate-transaction fs/ocfs2/ocfs2_trace.h
--- a/fs/ocfs2/ocfs2_trace.h~ocfs2-lighten-up-allocate-transaction
+++ a/fs/ocfs2/ocfs2_trace.h
@@ -2579,6 +2579,8 @@ DEFINE_OCFS2_INT_INT_EVENT(ocfs2_extend_
 
 DEFINE_OCFS2_INT_EVENT(ocfs2_extend_trans_restart);
 
+DEFINE_OCFS2_INT_INT_EVENT(ocfs2_allocate_extend_trans);
+
 DEFINE_OCFS2_ULL_ULL_UINT_UINT_EVENT(ocfs2_journal_access);
 
 DEFINE_OCFS2_ULL_EVENT(ocfs2_journal_dirty);
_

Patches currently in -mm which might be from younger.liu@huawei.com are

ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch
ocfs2-update-inode-size-after-zeronig-the-hole.patch
ocfs2-lighten-up-allocate-transaction.patch

