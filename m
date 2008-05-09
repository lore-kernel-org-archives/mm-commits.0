From: akpm@linux-foundation.org
Subject: - fix-irq-flags-in-mac80211-code.patch removed from -mm tree
Date: Fri, 09 May 2008 14:46:17 -0700
Message-ID: <200805092146.m49LkHSW027097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755527AbYEIVr3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:47:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, linville@tuxdriver.com, srostedt@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fix irq flags in mac80211 code
has been removed from the -mm tree.  Its filename was
     fix-irq-flags-in-mac80211-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix irq flags in mac80211 code
From: Steven Rostedt <rostedt@goodmis.org>

A file in the net/mac80211 directory uses "int" for flags.  This can cause
hard to find bugs on some architectures.  This patch converts the flags to use
"long" instead.

This bug was discovered by doing an allyesconfig make on the -rt kernel where
checks are done to ensure all flags are of size sizeof(long).

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/rc80211_pid_debugfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN net/mac80211/rc80211_pid_debugfs.c~fix-irq-flags-in-mac80211-code net/mac80211/rc80211_pid_debugfs.c
--- a/net/mac80211/rc80211_pid_debugfs.c~fix-irq-flags-in-mac80211-code
+++ a/net/mac80211/rc80211_pid_debugfs.c
@@ -85,7 +85,7 @@ static int rate_control_pid_events_open(
 	struct rc_pid_sta_info *sinfo = inode->i_private;
 	struct rc_pid_event_buffer *events = &sinfo->events;
 	struct rc_pid_events_file_info *file_info;
-	unsigned int status;
+	unsigned long status;
 
 	/* Allocate a state struct */
 	file_info = kmalloc(sizeof(*file_info), GFP_KERNEL);
@@ -135,7 +135,7 @@ static ssize_t rate_control_pid_events_r
 	char pb[RC_PID_PRINT_BUF_SIZE];
 	int ret;
 	int p;
-	unsigned int status;
+	unsigned long status;
 
 	/* Check if there is something to read. */
 	if (events->next_entry == file_info->next_entry) {
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
linux-next.patch
git-v9fs.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch

