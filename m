From: akpm@linux-foundation.org
Subject: [patch 016/123] ocfs2: use time64_t to represent orphan scan
 times
Date: Mon, 12 Dec 2016 16:41:23 -0800
Message-ID: <584f43b3.f/C6GFNSyNaNTJ0g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40486 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753137AbcLMAlY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:41:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, deepa.kernel@gmail.com, arnd@arndb.de, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com

From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: ocfs2: use time64_t to represent orphan scan times

struct timespec is not y2038 safe.  Use time64_t which is y2038 safe to
represent orphan scan times.  time64_t is sufficient here as only the
seconds delta times are relevant.

Also use appropriate time functions that return time in time64_t format. 
Time functions now return monotonic time instead of real time as only
delta scan times are relevant and these values are not persistent across
reboots.

The format string for the debug print is still using long as this is only
the time elapsed since the last scan and long is sufficient to represent
this value.

Link: http://lkml.kernel.org/r/1475365138-20567-1-git-send-email-deepa.kernel@gmail.com
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |    4 ++--
 fs/ocfs2/ocfs2.h   |    2 +-
 fs/ocfs2/super.c   |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/journal.c~fs-ocfs2-use-time64_t-to-represent-orphan-scan-times fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~fs-ocfs2-use-time64_t-to-represent-orphan-scan-times
+++ a/fs/ocfs2/journal.c
@@ -1947,7 +1947,7 @@ static void ocfs2_queue_orphan_scan(stru
 	 */
 	seqno++;
 	os->os_count++;
-	os->os_scantime = CURRENT_TIME;
+	os->os_scantime = ktime_get_seconds();
 unlock:
 	ocfs2_orphan_scan_unlock(osb, seqno);
 out:
@@ -2004,7 +2004,7 @@ void ocfs2_orphan_scan_start(struct ocfs
 	struct ocfs2_orphan_scan *os;
 
 	os = &osb->osb_orphan_scan;
-	os->os_scantime = CURRENT_TIME;
+	os->os_scantime = ktime_get_seconds();
 	if (ocfs2_is_hard_readonly(osb) || ocfs2_mount_local(osb))
 		atomic_set(&os->os_state, ORPHAN_SCAN_INACTIVE);
 	else {
diff -puN fs/ocfs2/ocfs2.h~fs-ocfs2-use-time64_t-to-represent-orphan-scan-times fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~fs-ocfs2-use-time64_t-to-represent-orphan-scan-times
+++ a/fs/ocfs2/ocfs2.h
@@ -224,7 +224,7 @@ struct ocfs2_orphan_scan {
 	struct ocfs2_super 	*os_osb;
 	struct ocfs2_lock_res 	os_lockres;     /* lock to synchronize scans */
 	struct delayed_work 	os_orphan_scan_work;
-	struct timespec		os_scantime;  /* time this node ran the scan */
+	time64_t		os_scantime;  /* time this node ran the scan */
 	u32			os_count;      /* tracks node specific scans */
 	u32  			os_seqno;       /* tracks cluster wide scans */
 	atomic_t		os_state;              /* ACTIVE or INACTIVE */
diff -puN fs/ocfs2/super.c~fs-ocfs2-use-time64_t-to-represent-orphan-scan-times fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~fs-ocfs2-use-time64_t-to-represent-orphan-scan-times
+++ a/fs/ocfs2/super.c
@@ -337,7 +337,7 @@ static int ocfs2_osb_dump(struct ocfs2_s
 		out += snprintf(buf + out, len - out, "Disabled\n");
 	else
 		out += snprintf(buf + out, len - out, "%lu seconds ago\n",
-				(get_seconds() - os->os_scantime.tv_sec));
+				(unsigned long)(ktime_get_seconds() - os->os_scantime));
 
 	out += snprintf(buf + out, len - out, "%10s => %3s  %10s\n",
 			"Slots", "Num", "RecoGen");
_
