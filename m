From: akpm@linux-foundation.org
Subject: + ocfs2-sysfile-interfaces-for-online-file-check-fix-2.patch
 added to -mm tree
Date: Mon, 27 Jul 2015 14:05:21 -0700
Message-ID: <55b69d11.lVVAmybPbzhb3w6r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbbG0VFW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jul 2015 17:05:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, ghe@suse.com, jlbec@evilplan.org, mfasheh@suse.com, rgoldwyn@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: scheduling in atomic in ocfs2_filecheck_store()
has been added to the -mm tree.  Its filename is
     ocfs2-sysfile-interfaces-for-online-file-check-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-sysfile-interfaces-for-online-file-check-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-sysfile-interfaces-for-online-file-check-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ocfs2: scheduling in atomic in ocfs2_filecheck_store()

We're hold "spin_lock(&ent->fs_fcheck->fc_lock)" so move the GFP_NOFS
allocation outside the locked region.

Fixes: e467fe5da718 ('ocfs2: sysfile interfaces for online file check')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Gang He <ghe@suse.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/filecheck.c |   40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff -puN fs/ocfs2/filecheck.c~ocfs2-sysfile-interfaces-for-online-file-check-fix-2 fs/ocfs2/filecheck.c
--- a/fs/ocfs2/filecheck.c~ocfs2-sysfile-interfaces-for-online-file-check-fix-2
+++ a/fs/ocfs2/filecheck.c
@@ -501,7 +501,7 @@ static ssize_t ocfs2_filecheck_store(str
 				const char *buf, size_t count)
 {
 	struct ocfs2_filecheck_args args;
-	struct ocfs2_filecheck_entry *entry = NULL;
+	struct ocfs2_filecheck_entry *entry;
 	struct ocfs2_filecheck_sysfs_entry *ent;
 	ssize_t ret = 0;
 
@@ -527,12 +527,19 @@ static ssize_t ocfs2_filecheck_store(str
 		return (!ret ? count : ret);
 	}
 
+	entry = kmalloc(sizeof(*entry), GFP_NOFS);
+	if (!entry) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	spin_lock(&ent->fs_fcheck->fc_lock);
 	if ((ent->fs_fcheck->fc_size >= ent->fs_fcheck->fc_max) &&
-		(ent->fs_fcheck->fc_done == 0)) {
-		mlog(ML_ERROR,
-		"Online file check queue(%u) is full\n",
-		ent->fs_fcheck->fc_max);
+			(ent->fs_fcheck->fc_done == 0)) {
+		mlog(ML_ERROR, "Online file check queue(%u) is full\n",
+				ent->fs_fcheck->fc_max);
+		kfree(entry);
+		entry = NULL;
 		ret = -EBUSY;
 	} else {
 		if ((ent->fs_fcheck->fc_size >= ent->fs_fcheck->fc_max) &&
@@ -544,26 +551,21 @@ static ssize_t ocfs2_filecheck_store(str
 			BUG_ON(!ocfs2_filecheck_erase_entry(ent));
 		}
 
-		entry = kmalloc(sizeof(struct ocfs2_filecheck_entry), GFP_NOFS);
-		if (entry) {
-			entry->fe_ino = args.fa_ino;
-			entry->fe_type = args.fa_type;
-			entry->fe_done = 0;
-			entry->fe_status = OCFS2_FILECHECK_ERR_INPROGRESS;
-			list_add_tail(&entry->fe_list,
-					&ent->fs_fcheck->fc_head);
-
-			ent->fs_fcheck->fc_size++;
-			ret = count;
-		} else {
-			ret = -ENOMEM;
-		}
+		entry->fe_ino = args.fa_ino;
+		entry->fe_type = args.fa_type;
+		entry->fe_done = 0;
+		entry->fe_status = OCFS2_FILECHECK_ERR_INPROGRESS;
+		list_add_tail(&entry->fe_list, &ent->fs_fcheck->fc_head);
+
+		ent->fs_fcheck->fc_size++;
+		ret = count;
 	}
 	spin_unlock(&ent->fs_fcheck->fc_lock);
 
 	if (entry)
 		ocfs2_filecheck_handle_entry(ent, entry);
 
+out:
 	ocfs2_filecheck_sysfs_put(ent);
 	return ret;
 }
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

ocfs2-sysfile-interfaces-for-online-file-check-fix-2.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization-fix-fix-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix-2.patch
linux-next.patch

