From: akpm@linux-foundation.org
Subject: - dont-send-quota-messages-repeatedly-when-hardlimit-reached.patch removed from -mm tree
Date: Mon, 07 Jan 2008 13:39:08 -0800
Message-ID: <200801072138.m07LcmXo013502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59832 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752891AbYAGViw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 16:38:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Don't send quota messages repeatedly when hardlimit reached
has been removed from the -mm tree.  Its filename was
     dont-send-quota-messages-repeatedly-when-hardlimit-reached.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Don't send quota messages repeatedly when hardlimit reached
From: Jan Kara <jack@suse.cz>

We should send quota message to netlink only once when hardlimit is
reached.  Otherwise user could easily make the system busy by trying to
exceed the hardlimit (and also the messages could be anoying if you cannot
stop writing just now).

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff -puN fs/dquot.c~dont-send-quota-messages-repeatedly-when-hardlimit-reached fs/dquot.c
--- a/fs/dquot.c~dont-send-quota-messages-repeatedly-when-hardlimit-reached
+++ a/fs/dquot.c
@@ -827,6 +827,18 @@ static inline void dquot_decr_space(stru
 	clear_bit(DQ_BLKS_B, &dquot->dq_flags);
 }
 
+static int warning_issued(struct dquot *dquot, const int warntype)
+{
+	int flag = (warntype == QUOTA_NL_BHARDWARN ||
+		warntype == QUOTA_NL_BSOFTLONGWARN) ? DQ_BLKS_B :
+		((warntype == QUOTA_NL_IHARDWARN ||
+		warntype == QUOTA_NL_ISOFTLONGWARN) ? DQ_INODES_B : 0);
+
+	if (!flag)
+		return 0;
+	return test_and_set_bit(flag, &dquot->dq_flags);
+}
+
 #ifdef CONFIG_PRINT_QUOTA_WARNING
 static int flag_print_warnings = 1;
 
@@ -845,16 +857,12 @@ static inline int need_print_warning(str
 }
 
 /* Print warning to user which exceeded quota */
-static void print_warning(struct dquot *dquot, const char warntype)
+static void print_warning(struct dquot *dquot, const int warntype)
 {
 	char *msg = NULL;
 	struct tty_struct *tty;
-	int flag = (warntype == QUOTA_NL_BHARDWARN ||
-		warntype == QUOTA_NL_BSOFTLONGWARN) ? DQ_BLKS_B :
-		((warntype == QUOTA_NL_IHARDWARN ||
-		warntype == QUOTA_NL_ISOFTLONGWARN) ? DQ_INODES_B : 0);
 
-	if (!need_print_warning(dquot) || (flag && test_and_set_bit(flag, &dquot->dq_flags)))
+	if (!need_print_warning(dquot))
 		return;
 
 	mutex_lock(&tty_mutex);
@@ -969,7 +977,8 @@ static inline void flush_warnings(struct
 	int i;
 
 	for (i = 0; i < MAXQUOTAS; i++)
-		if (dquots[i] != NODQUOT && warntype[i] != QUOTA_NL_NOWARN) {
+		if (dquots[i] != NODQUOT && warntype[i] != QUOTA_NL_NOWARN &&
+		    !warning_issued(dquots[i], warntype[i])) {
 #ifdef CONFIG_PRINT_QUOTA_WARNING
 			print_warning(dquots[i], warntype[i]);
 #endif
_

Patches currently in -mm which might be from jack@suse.cz are

git-ocfs2.patch
inotify-send-in_attrib-events-when-link-count-changes.patch
inotify-send-in_attrib-events-when-link-count-changes-fix.patch
quota-improve-inode-list-scanning-in-add_dquot_ref.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
udf-remove-wrong-prototype-of-udf_readdir.patch
udf-improve-readability-of-do_udf_readdir.patch
udf-fix-coding-style-of-dirc.patch
udf-fix-3-signedness-1-unitialized-variable-warnings.patch
udf-fix-signedness-issue.patch
use-pgoff_t-instead-of-unsigned-long.patch
