From: akpm@linux-foundation.org
Subject: + ocfs2-add-duplicative-ino-number-check.patch added to -mm tree
Date: Wed, 24 May 2017 15:47:04 -0700
Message-ID: <59260d68.OH5pls7JBPmaLkCf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48870 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161122AbdEXWrF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 May 2017 18:47:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: add duplicated ino number check
has been added to the -mm tree.  Its filename is
     ocfs2-add-duplicative-ino-number-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-add-duplicative-ino-number-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-add-duplicative-ino-number-check.patch

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
Subject: ocfs2: add duplicated ino number check

Add duplicated ino number check, to avoid adding a file into the file
check list when this file is being checked.

Link: http://lkml.kernel.org/r/1495611866-27360-5-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/filecheck.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/filecheck.c~ocfs2-add-duplicative-ino-number-check fs/ocfs2/filecheck.c
--- a/fs/ocfs2/filecheck.c~ocfs2-add-duplicative-ino-number-check
+++ a/fs/ocfs2/filecheck.c
@@ -354,6 +354,22 @@ exit:
 }
 
 static inline int
+ocfs2_filecheck_is_dup_entry(struct ocfs2_filecheck_sysfs_entry *ent,
+				unsigned long ino)
+{
+	struct ocfs2_filecheck_entry *p;
+
+	list_for_each_entry(p, &ent->fs_fcheck->fc_head, fe_list) {
+		if (!p->fe_done) {
+			if (p->fe_ino == ino)
+				return 1;
+		}
+	}
+
+	return 0;
+}
+
+static inline int
 ocfs2_filecheck_erase_entry(struct ocfs2_filecheck_sysfs_entry *ent)
 {
 	struct ocfs2_filecheck_entry *p;
@@ -467,7 +483,10 @@ static ssize_t ocfs2_filecheck_attr_stor
 	}
 
 	spin_lock(&ent->fs_fcheck->fc_lock);
-	if ((ent->fs_fcheck->fc_size >= ent->fs_fcheck->fc_max) &&
+	if (ocfs2_filecheck_is_dup_entry(ent, args.fa_ino)) {
+		ret = -EEXIST;
+		kfree(entry);
+	} else if ((ent->fs_fcheck->fc_size >= ent->fs_fcheck->fc_max) &&
 		(ent->fs_fcheck->fc_done == 0)) {
 		mlog(ML_NOTICE,
 		"Cannot do more file check "
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

