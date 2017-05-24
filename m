From: akpm@linux-foundation.org
Subject: + ocfs2-fix-some-small-problems.patch added to -mm tree
Date: Wed, 24 May 2017 15:46:59 -0700
Message-ID: <59260d63.DIdLmE4NUgpd1qBR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48854 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161122AbdEXWrA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 May 2017 18:47:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix some small problems
has been added to the -mm tree.  Its filename is
     ocfs2-fix-some-small-problems.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-some-small-problems.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-some-small-problems.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2: fix some small problems

First, move setting fe_done = 1 in spin lock, avoid bring any potential
race condition.

Second, tune mlog message level from ERROR to NOTICE, since the message
should not belong to error message.

Third, tune errno to -EAGAIN when file check queue is full, this errno is
more appropriate in the case.

Link: http://lkml.kernel.org/r/1495611866-27360-3-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/filecheck.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/filecheck.c~ocfs2-fix-some-small-problems fs/ocfs2/filecheck.c
--- a/fs/ocfs2/filecheck.c~ocfs2-fix-some-small-problems
+++ a/fs/ocfs2/filecheck.c
@@ -288,7 +288,7 @@ ocfs2_filecheck_adjust_max(struct ocfs2_
 
 	spin_lock(&ent->fs_fcheck->fc_lock);
 	if (len < (ent->fs_fcheck->fc_size - ent->fs_fcheck->fc_done)) {
-		mlog(ML_ERROR,
+		mlog(ML_NOTICE,
 		"Cannot set online file check maximum entry number "
 		"to %u due to too many pending entries(%u)\n",
 		len, ent->fs_fcheck->fc_size - ent->fs_fcheck->fc_done);
@@ -462,8 +462,8 @@ static void
 ocfs2_filecheck_done_entry(struct ocfs2_filecheck_sysfs_entry *ent,
 			   struct ocfs2_filecheck_entry *entry)
 {
-	entry->fe_done = 1;
 	spin_lock(&ent->fs_fcheck->fc_lock);
+	entry->fe_done = 1;
 	ent->fs_fcheck->fc_done++;
 	spin_unlock(&ent->fs_fcheck->fc_lock);
 }
@@ -545,11 +545,11 @@ static ssize_t ocfs2_filecheck_store(str
 	spin_lock(&ent->fs_fcheck->fc_lock);
 	if ((ent->fs_fcheck->fc_size >= ent->fs_fcheck->fc_max) &&
 	    (ent->fs_fcheck->fc_done == 0)) {
-		mlog(ML_ERROR,
+		mlog(ML_NOTICE,
 		"Cannot do more file check "
 		"since file check queue(%u) is full now\n",
 		ent->fs_fcheck->fc_max);
-		ret = -EBUSY;
+		ret = -EAGAIN;
 		kfree(entry);
 	} else {
 		if ((ent->fs_fcheck->fc_size >= ent->fs_fcheck->fc_max) &&
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-fix-a-static-checker-warning.patch
ocfs2-get-rid-of-ocfs2_is_o2cb_active-function.patch
ocfs2-give-an-obvious-tip-for-dismatch-cluster-names.patch
ocfs2-give-an-obvious-tip-for-dismatch-cluster-names-v2.patch
ocfs2-move-some-definitions-to-header-file.patch
ocfs2-fix-some-small-problems.patch
ocfs2-add-kobject-for-online-file-check.patch
ocfs2-add-duplicative-ino-number-check.patch

