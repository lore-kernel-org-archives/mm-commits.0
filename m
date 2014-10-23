From: akpm@linux-foundation.org
Subject: + ocfs2-report-error-from-o2hb_do_disk_heartbeat-to-user.patch
 added to -mm tree
Date: Thu, 23 Oct 2014 13:06:40 -0700
Message-ID: <54495fd0.XBQIJiAXW6HmDJvK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbaJWUGk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Oct 2014 16:06:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: report error from o2hb_do_disk_heartbeat() to user
has been added to the -mm tree.  Its filename is
     ocfs2-report-error-from-o2hb_do_disk_heartbeat-to-user.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-report-error-from-o2hb_do_disk_heartbeat-to-user.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-report-error-from-o2hb_do_disk_heartbeat-to-user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
bitmap-fix-undefined-shift-in-__bitmap_shift_leftright.patch
fallocate-create-fan_modify-and-in_modify-events.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-fix-xattr-check-in-ocfs2_get_xattr_nolock.patch
ocfs2-remove-bogus-test-from-ocfs2_read_locked_inode.patch
ocfs2-report-error-from-o2hb_do_disk_heartbeat-to-user.patch
ocfs2-remove-pointless-assignment-in-ocfs2_init.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
ncpfs-return-proper-error-from-ncp_ioc_setroot-ioctl.patch
befs-remove-dead-code.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

