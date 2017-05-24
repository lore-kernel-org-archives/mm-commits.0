From: akpm@linux-foundation.org
Subject: + ocfs2-move-some-definitions-to-header-file.patch added to -mm
 tree
Date: Wed, 24 May 2017 15:46:57 -0700
Message-ID: <59260d61.SQHBxomATRxXCx1A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48838 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031593AbdEXWq6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 May 2017 18:46:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: move some definitions to header file
has been added to the -mm tree.  Its filename is
     ocfs2-move-some-definitions-to-header-file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-move-some-definitions-to-header-file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-move-some-definitions-to-header-file.patch

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
Subject: ocfs2: move some definitions to header file

Patch series "ocfs2: use kobject for online file check", v3.

Use embedded kobject mechanism for online file check feature, this will
avoid to use a global list to save/search per-device online file check
related data.  The changed code is based on Goldwyn Rodrigues's patches
and ext4 fs code, there is not any new features added, except some very
small fixes during this code refactoring.  Second, the code change does
not affect the underlying file check code.  Thank Goldwyn very much.

Compare with second version, add more comments in the patch descriptions,
to make sure each modification is mentioned.  Compare with first version,
split the code change into four patches, make sure each patch will not
bring ocfs2 kernel modules compiling errors.


This patch (of 3):

Move some definitions to header file, which will be referenced by other
source files when kobject mechanism is introduced.

Link: http://lkml.kernel.org/r/1495611866-27360-2-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/filecheck.c |   27 ---------------------------
 fs/ocfs2/filecheck.h |   27 +++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 27 deletions(-)

diff -puN fs/ocfs2/filecheck.c~ocfs2-move-some-definitions-to-header-file fs/ocfs2/filecheck.c
--- a/fs/ocfs2/filecheck.c~ocfs2-move-some-definitions-to-header-file
+++ a/fs/ocfs2/filecheck.c
@@ -56,33 +56,6 @@ static const char * const ocfs2_filechec
 static DEFINE_SPINLOCK(ocfs2_filecheck_sysfs_lock);
 static LIST_HEAD(ocfs2_filecheck_sysfs_list);
 
-struct ocfs2_filecheck {
-	struct list_head fc_head;	/* File check entry list head */
-	spinlock_t fc_lock;
-	unsigned int fc_max;	/* Maximum number of entry in list */
-	unsigned int fc_size;	/* Current entry count in list */
-	unsigned int fc_done;	/* Finished entry count in list */
-};
-
-struct ocfs2_filecheck_sysfs_entry {	/* sysfs entry per mounting */
-	struct list_head fs_list;
-	atomic_t fs_count;
-	struct super_block *fs_sb;
-	struct kset *fs_devicekset;
-	struct kset *fs_fcheckkset;
-	struct ocfs2_filecheck *fs_fcheck;
-};
-
-#define OCFS2_FILECHECK_MAXSIZE		100
-#define OCFS2_FILECHECK_MINSIZE		10
-
-/* File check operation type */
-enum {
-	OCFS2_FILECHECK_TYPE_CHK = 0,	/* Check a file(inode) */
-	OCFS2_FILECHECK_TYPE_FIX,	/* Fix a file(inode) */
-	OCFS2_FILECHECK_TYPE_SET = 100	/* Set entry list maximum size */
-};
-
 struct ocfs2_filecheck_entry {
 	struct list_head fe_list;
 	unsigned long fe_ino;
diff -puN fs/ocfs2/filecheck.h~ocfs2-move-some-definitions-to-header-file fs/ocfs2/filecheck.h
--- a/fs/ocfs2/filecheck.h~ocfs2-move-some-definitions-to-header-file
+++ a/fs/ocfs2/filecheck.h
@@ -43,6 +43,33 @@ enum {
 #define OCFS2_FILECHECK_ERR_START	OCFS2_FILECHECK_ERR_FAILED
 #define OCFS2_FILECHECK_ERR_END		OCFS2_FILECHECK_ERR_UNSUPPORTED
 
+struct ocfs2_filecheck {
+	struct list_head fc_head;	/* File check entry list head */
+	spinlock_t fc_lock;
+	unsigned int fc_max;	/* Maximum number of entry in list */
+	unsigned int fc_size;	/* Current entry count in list */
+	unsigned int fc_done;	/* Finished entry count in list */
+};
+
+struct ocfs2_filecheck_sysfs_entry {	/* sysfs entry per mounting */
+	struct list_head fs_list;
+	atomic_t fs_count;
+	struct super_block *fs_sb;
+	struct kset *fs_devicekset;
+	struct kset *fs_fcheckkset;
+	struct ocfs2_filecheck *fs_fcheck;
+};
+
+#define OCFS2_FILECHECK_MAXSIZE		100
+#define OCFS2_FILECHECK_MINSIZE		10
+
+/* File check operation type */
+enum {
+	OCFS2_FILECHECK_TYPE_CHK = 0,	/* Check a file(inode) */
+	OCFS2_FILECHECK_TYPE_FIX,	/* Fix a file(inode) */
+	OCFS2_FILECHECK_TYPE_SET = 100	/* Set entry list maximum size */
+};
+
 int ocfs2_filecheck_create_sysfs(struct super_block *sb);
 int ocfs2_filecheck_remove_sysfs(struct super_block *sb);
 
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

