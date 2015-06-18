From: akpm@linux-foundation.org
Subject: + ocfs2-mark-local-functions-as-static.patch added to -mm tree
Date: Thu, 18 Jun 2015 11:32:15 -0700
Message-ID: <55830eaf.8wrZGtXw7q7OdWl3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbbFRScQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Jun 2015 14:32:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: mark local functions as static
has been added to the -mm tree.  Its filename is
     ocfs2-mark-local-functions-as-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-mark-local-functions-as-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-mark-local-functions-as-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: mark local functions as static

Some functions are only used locally, so mark them as static.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |   10 +++++-----
 fs/ocfs2/xattr.c   |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/journal.c~ocfs2-mark-local-functions-as-static fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-mark-local-functions-as-static
+++ a/fs/ocfs2/journal.c
@@ -108,7 +108,7 @@ struct ocfs2_replay_map {
 	unsigned char rm_replay_slots[0];
 };
 
-void ocfs2_replay_map_set_state(struct ocfs2_super *osb, int state)
+static void ocfs2_replay_map_set_state(struct ocfs2_super *osb, int state)
 {
 	if (!osb->replay_map)
 		return;
@@ -153,7 +153,7 @@ int ocfs2_compute_replay_slots(struct oc
 	return 0;
 }
 
-void ocfs2_queue_replay_slots(struct ocfs2_super *osb,
+static void ocfs2_queue_replay_slots(struct ocfs2_super *osb,
 		enum ocfs2_orphan_reco_type orphan_reco_type)
 {
 	struct ocfs2_replay_map *replay_map = osb->replay_map;
@@ -173,7 +173,7 @@ void ocfs2_queue_replay_slots(struct ocf
 	replay_map->rm_state = REPLAY_DONE;
 }
 
-void ocfs2_free_replay_slots(struct ocfs2_super *osb)
+static void ocfs2_free_replay_slots(struct ocfs2_super *osb)
 {
 	struct ocfs2_replay_map *replay_map = osb->replay_map;
 
@@ -1895,7 +1895,7 @@ static inline unsigned long ocfs2_orphan
  * hasn't happened.  The node queues a scan and increments the
  * sequence number in the LVB.
  */
-void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
+static void ocfs2_queue_orphan_scan(struct ocfs2_super *osb)
 {
 	struct ocfs2_orphan_scan *os;
 	int status, i;
@@ -1944,7 +1944,7 @@ out:
 }
 
 /* Worker task that gets fired every ORPHAN_SCAN_SCHEDULE_TIMEOUT millsec */
-void ocfs2_orphan_scan_work(struct work_struct *work)
+static void ocfs2_orphan_scan_work(struct work_struct *work)
 {
 	struct ocfs2_orphan_scan *os;
 	struct ocfs2_super *osb;
diff -puN fs/ocfs2/xattr.c~ocfs2-mark-local-functions-as-static fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-mark-local-functions-as-static
+++ a/fs/ocfs2/xattr.c
@@ -7271,7 +7271,7 @@ static int ocfs2_xattr_security_set(stru
 			       name, value, size, flags);
 }
 
-int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+static int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
 		     void *fs_info)
 {
 	const struct xattr *xattr;
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work.patch
ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2.patch
ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry.patch
ocfs2-use-retval-instead-of-status-for-checking-error.patch
ocfs2-dlm-cleanup-unused-function-__dlm_wait_on_lockres_flags_set.patch
ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails.patch
ocfs2-do-not-bug-if-jbd2_journal_dirty_metadata-fails-v3.patch
ocfs2-o2net-should-remove-debugfs-in-o2net_init-out-branch.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix.patch
ocfs2-fix-wrong-check-in-ocfs2_direct_io_get_blocks.patch
ocfs2-mark-local-functions-as-static.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch
ocfs2-fix-race-between-crashed-dio-and-rm.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
linux-next.patch

