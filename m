From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-mount-shared-volume-without-ha-stack.patch added
 to -mm tree
Date: Thu, 23 Apr 2020 16:35:13 -0700
Message-ID: <20200423233513.KgKk_aoZ1%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbgDWXfP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 19:35:15 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gechangwei@live.cn, ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com


The patch titled
     Subject: ocfs2: mount shared volume without ha stack
has been added to the -mm tree.  Its filename is
     ocfs2-mount-shared-volume-without-ha-stack.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-mount-shared-volume-without-ha-stack.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-mount-shared-volume-without-ha-stack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2: mount shared volume without ha stack

Usually we create and use a ocfs2 shared volume on the top of ha stack. 
For pcmk based ha stack, which includes DLM, corosync and pacemaker
services.

The customers complained they could not mount existent ocfs2 volume in the
single node without ha stack, e.g.  single node backup/restore scenario.

Like this case, the customers just want to access the data from the
existent ocfs2 volume quickly, but do not want to restart or setup ha
stack.

Then, I'd like to add a mount option "nocluster", if the users use this
option to mount a ocfs2 shared volume, the whole mount will not depend on
the ha related services.  the command will mount the existent ocfs2 volume
directly (like local mount), for avoiding setup the ha stack.

Link: http://lkml.kernel.org/r/20200423053300.22661-1-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2.h    |    4 ++-
 fs/ocfs2/slot_map.c |   46 ++++++++++++++++++++++++------------------
 fs/ocfs2/super.c    |   21 +++++++++++++++++++
 3 files changed, 51 insertions(+), 20 deletions(-)

--- a/fs/ocfs2/ocfs2.h~ocfs2-mount-shared-volume-without-ha-stack
+++ a/fs/ocfs2/ocfs2.h
@@ -279,6 +279,7 @@ enum ocfs2_mount_options
 	OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT = 1 << 15,  /* Journal Async Commit */
 	OCFS2_MOUNT_ERRORS_CONT = 1 << 16, /* Return EIO to the calling process on error */
 	OCFS2_MOUNT_ERRORS_ROFS = 1 << 17, /* Change filesystem to read-only on error */
+	OCFS2_MOUNT_NOCLUSTER = 1 << 18, /* No cluster aware filesystem mount */
 };
 
 #define OCFS2_OSB_SOFT_RO	0x0001
@@ -673,7 +674,8 @@ static inline int ocfs2_cluster_o2cb_glo
 
 static inline int ocfs2_mount_local(struct ocfs2_super *osb)
 {
-	return (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT);
+	return ((osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT)
+		|| (osb->s_mount_opt & OCFS2_MOUNT_NOCLUSTER));
 }
 
 static inline int ocfs2_uses_extended_slot_map(struct ocfs2_super *osb)
--- a/fs/ocfs2/slot_map.c~ocfs2-mount-shared-volume-without-ha-stack
+++ a/fs/ocfs2/slot_map.c
@@ -254,14 +254,16 @@ static int __ocfs2_find_empty_slot(struc
 	int i, ret = -ENOSPC;
 
 	if ((preferred >= 0) && (preferred < si->si_num_slots)) {
-		if (!si->si_slots[preferred].sl_valid) {
+		if (!si->si_slots[preferred].sl_valid ||
+		    !si->si_slots[preferred].sl_node_num) {
 			ret = preferred;
 			goto out;
 		}
 	}
 
 	for(i = 0; i < si->si_num_slots; i++) {
-		if (!si->si_slots[i].sl_valid) {
+		if (!si->si_slots[i].sl_valid ||
+		    !si->si_slots[i].sl_node_num) {
 			ret = i;
 			break;
 		}
@@ -456,24 +458,30 @@ int ocfs2_find_slot(struct ocfs2_super *
 	spin_lock(&osb->osb_lock);
 	ocfs2_update_slot_info(si);
 
-	/* search for ourselves first and take the slot if it already
-	 * exists. Perhaps we need to mark this in a variable for our
-	 * own journal recovery? Possibly not, though we certainly
-	 * need to warn to the user */
-	slot = __ocfs2_node_num_to_slot(si, osb->node_num);
-	if (slot < 0) {
-		/* if no slot yet, then just take 1st available
-		 * one. */
-		slot = __ocfs2_find_empty_slot(si, osb->preferred_slot);
+	if (ocfs2_mount_local(osb))
+		/* use slot 0 directly in local mode */
+		slot = 0;
+	else {
+		/* search for ourselves first and take the slot if it already
+		 * exists. Perhaps we need to mark this in a variable for our
+		 * own journal recovery? Possibly not, though we certainly
+		 * need to warn to the user */
+		slot = __ocfs2_node_num_to_slot(si, osb->node_num);
 		if (slot < 0) {
-			spin_unlock(&osb->osb_lock);
-			mlog(ML_ERROR, "no free slots available!\n");
-			status = -EINVAL;
-			goto bail;
-		}
-	} else
-		printk(KERN_INFO "ocfs2: Slot %d on device (%s) was already "
-		       "allocated to this node!\n", slot, osb->dev_str);
+			/* if no slot yet, then just take 1st available
+			 * one. */
+			slot = __ocfs2_find_empty_slot(si, osb->preferred_slot);
+			if (slot < 0) {
+				spin_unlock(&osb->osb_lock);
+				mlog(ML_ERROR, "no free slots available!\n");
+				status = -EINVAL;
+				goto bail;
+			}
+		} else
+			printk(KERN_INFO "ocfs2: Slot %d on device (%s) was "
+			       "already allocated to this node!\n",
+			       slot, osb->dev_str);
+	}
 
 	ocfs2_set_slot(si, slot, osb->node_num);
 	osb->slot_num = slot;
--- a/fs/ocfs2/super.c~ocfs2-mount-shared-volume-without-ha-stack
+++ a/fs/ocfs2/super.c
@@ -175,6 +175,7 @@ enum {
 	Opt_dir_resv_level,
 	Opt_journal_async_commit,
 	Opt_err_cont,
+	Opt_nocluster,
 	Opt_err,
 };
 
@@ -208,6 +209,7 @@ static const match_table_t tokens = {
 	{Opt_dir_resv_level, "dir_resv_level=%u"},
 	{Opt_journal_async_commit, "journal_async_commit"},
 	{Opt_err_cont, "errors=continue"},
+	{Opt_nocluster, "nocluster"},
 	{Opt_err, NULL}
 };
 
@@ -619,6 +621,13 @@ static int ocfs2_remount(struct super_bl
 		goto out;
 	}
 
+	tmp = OCFS2_MOUNT_NOCLUSTER;
+	if ((osb->s_mount_opt & tmp) != (parsed_options.mount_opt & tmp)) {
+		ret = -EINVAL;
+		mlog(ML_ERROR, "Cannot change nocluster option on remount\n");
+		goto out;
+	}
+
 	tmp = OCFS2_MOUNT_HB_LOCAL | OCFS2_MOUNT_HB_GLOBAL |
 		OCFS2_MOUNT_HB_NONE;
 	if ((osb->s_mount_opt & tmp) != (parsed_options.mount_opt & tmp)) {
@@ -859,6 +868,7 @@ static int ocfs2_verify_userspace_stack(
 	}
 
 	if (ocfs2_userspace_stack(osb) &&
+	    !(osb->s_mount_opt & OCFS2_MOUNT_NOCLUSTER) &&
 	    strncmp(osb->osb_cluster_stack, mopt->cluster_stack,
 		    OCFS2_STACK_LABEL_LEN)) {
 		mlog(ML_ERROR,
@@ -1139,6 +1149,11 @@ static int ocfs2_fill_super(struct super
 	       osb->s_mount_opt & OCFS2_MOUNT_DATA_WRITEBACK ? "writeback" :
 	       "ordered");
 
+	if ((osb->s_mount_opt & OCFS2_MOUNT_NOCLUSTER) &&
+	   !(osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT))
+		printk(KERN_NOTICE "ocfs2: The shared device (%s) is mounted "
+		       "without cluster aware mode.\n", osb->dev_str);
+
 	atomic_set(&osb->vol_state, VOLUME_MOUNTED);
 	wake_up(&osb->osb_mount_event);
 
@@ -1445,6 +1460,9 @@ static int ocfs2_parse_options(struct su
 		case Opt_journal_async_commit:
 			mopt->mount_opt |= OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT;
 			break;
+		case Opt_nocluster:
+			mopt->mount_opt |= OCFS2_MOUNT_NOCLUSTER;
+			break;
 		default:
 			mlog(ML_ERROR,
 			     "Unrecognized mount option \"%s\" "
@@ -1556,6 +1574,9 @@ static int ocfs2_show_options(struct seq
 	if (opts & OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT)
 		seq_printf(s, ",journal_async_commit");
 
+	if (opts & OCFS2_MOUNT_NOCLUSTER)
+		seq_printf(s, ",nocluster");
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-mount-shared-volume-without-ha-stack.patch
