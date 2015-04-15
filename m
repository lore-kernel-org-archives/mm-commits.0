From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-use-actual-name-length-when-find-entry-in-ocfs2_orphan_del.patch
 removed from -mm tree
Date: Wed, 15 Apr 2015 12:08:18 -0700
Message-ID: <552eb722.p4bfKuQtk4mASb0L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbbDOTIS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:08:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jiangyiwen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use actual name length when find entry in ocfs2_orphan_del()
has been removed from the -mm tree.  Its filename was
     ocfs2-use-actual-name-length-when-find-entry-in-ocfs2_orphan_del.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: use actual name length when find entry in ocfs2_orphan_del()

If the namelen is 20 and name only has actual length 16, it will fail in
ocfs2_find_entry because of mismatch.  So use actual name length when find
entry.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-use-actual-name-length-when-find-entry-in-ocfs2_orphan_del fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-use-actual-name-length-when-find-entry-in-ocfs2_orphan_del
+++ a/fs/ocfs2/namei.c
@@ -2322,10 +2322,10 @@ int ocfs2_orphan_del(struct ocfs2_super
 
 	trace_ocfs2_orphan_del(
 	     (unsigned long long)OCFS2_I(orphan_dir_inode)->ip_blkno,
-	     name, namelen);
+	     name, strlen(name));
 
 	/* find it's spot in the orphan directory */
-	status = ocfs2_find_entry(name, namelen, orphan_dir_inode,
+	status = ocfs2_find_entry(name, strlen(name), orphan_dir_inode,
 				  &lookup);
 	if (status) {
 		mlog_errno(status);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

