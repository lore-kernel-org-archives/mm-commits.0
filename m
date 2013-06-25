From: akpm@linux-foundation.org
Subject: +
 ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch added to -mm tree
Date: Tue, 25 Jun 2013 16:23:43 -0700
Message-ID: <51ca267f.luCKSoeqXcKDp6P2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3FYXXo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 19:23:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, younger.liu@huawei.com

Subject: + ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch added to -mm tree
To: younger.liu@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 16:23:43 -0700


The patch titled
     Subject: ocfs2: should call ocfs2_journal_access_di() before ocfs2_delete_entry() in ocfs2_orphan_del()
has been added to the -mm tree.  Its filename is
     ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Younger Liu <younger.liu@huawei.com>
Subject: ocfs2: should call ocfs2_journal_access_di() before ocfs2_delete_entry() in ocfs2_orphan_del()

While deleting a file into orphan dir in ocfs2_orphan_del(), it calls
ocfs2_delete_entry() before ocfs2_journal_access_di().  If
ocfs2_delete_entry() succeeded and ocfs2_journal_access_di() failed, there
would be a inconsistency: the file is deleted from orphan dir, but orphan
dir dinode is not updated.

So we need to call ocfs2_journal_access_di() before ocfs2_orphan_del().

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Cc: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del
+++ a/fs/ocfs2/namei.c
@@ -2095,17 +2095,17 @@ int ocfs2_orphan_del(struct ocfs2_super
 		goto leave;
 	}
 
-	/* remove it from the orphan directory */
-	status = ocfs2_delete_entry(handle, orphan_dir_inode, &lookup);
+	status = ocfs2_journal_access_di(handle,
+					 INODE_CACHE(orphan_dir_inode),
+					 orphan_dir_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
 	}
 
-	status = ocfs2_journal_access_di(handle,
-					 INODE_CACHE(orphan_dir_inode),
-					 orphan_dir_bh,
-					 OCFS2_JOURNAL_ACCESS_WRITE);
+	/* remove it from the orphan directory */
+	status = ocfs2_delete_entry(handle, orphan_dir_inode, &lookup);
 	if (status < 0) {
 		mlog_errno(status);
 		goto leave;
_

Patches currently in -mm which might be from younger.liu@huawei.com are

linux-next.patch
fs-ocfs2-cluster-tcpc-free-sc-sc_page-in-sc_kref_release.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch

