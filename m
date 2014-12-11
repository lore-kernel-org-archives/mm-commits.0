From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-report-error-from-o2hb_do_disk_heartbeat-to-user.patch removed from
 -mm tree
Date: Thu, 11 Dec 2014 10:55:14 -0800
Message-ID: <5489e892.AbnEmSR9iuQ2vCVN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045AbaLKSzP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:55:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: report error from o2hb_do_disk_heartbeat() to user
has been removed from the -mm tree.  Its filename was
     ocfs2-report-error-from-o2hb_do_disk_heartbeat-to-user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: report error from o2hb_do_disk_heartbeat() to user

Report return value of o2hb_do_disk_heartbeat() as a part of ML_HEARTBEAT
message so that we know whether a heartbeat actually happened or not. 
This also makes assigned but otherwise unused 'ret' variable used.

Coverity id: 1227053.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-report-error-from-o2hb_do_disk_heartbeat-to-user fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-report-error-from-o2hb_do_disk_heartbeat-to-user
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -1127,10 +1127,10 @@ static int o2hb_thread(void *data)
 		elapsed_msec = o2hb_elapsed_msecs(&before_hb, &after_hb);
 
 		mlog(ML_HEARTBEAT,
-		     "start = %lu.%lu, end = %lu.%lu, msec = %u\n",
+		     "start = %lu.%lu, end = %lu.%lu, msec = %u, ret = %d\n",
 		     before_hb.tv_sec, (unsigned long) before_hb.tv_usec,
 		     after_hb.tv_sec, (unsigned long) after_hb.tv_usec,
-		     elapsed_msec);
+		     elapsed_msec, ret);
 
 		if (!kthread_should_stop() &&
 		    elapsed_msec < reg->hr_timeout_ms) {
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
befs-remove-dead-code.patch
linux-next.patch
fallocate-create-fan_modify-and-in_modify-events.patch
fsnotify-unify-inode-and-mount-marks-handling.patch
fsnotify-remove-destroy_list-from-fsnotify_mark.patch
mm-add-strictlimit-knob-v2.patch

