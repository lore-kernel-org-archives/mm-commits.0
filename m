From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-remove-goto-statement-in-ocfs2_check_dir_for_entry.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:08:24 -0700
Message-ID: <552eb728.1f0q4ol7OXYBnTOj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595AbbDOTIY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:08:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daeseok.youn@gmail.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove goto statement in ocfs2_check_dir_for_entry()
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-goto-statement-in-ocfs2_check_dir_for_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: ocfs2: remove goto statement in ocfs2_check_dir_for_entry()

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN fs/ocfs2/dir.c~ocfs2-remove-goto-statement-in-ocfs2_check_dir_for_entry fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~ocfs2-remove-goto-statement-in-ocfs2_check_dir_for_entry
+++ a/fs/ocfs2/dir.c
@@ -2047,22 +2047,19 @@ int ocfs2_check_dir_for_entry(struct ino
 			      const char *name,
 			      int namelen)
 {
-	int ret;
+	int ret = 0;
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 
 	trace_ocfs2_check_dir_for_entry(
 		(unsigned long long)OCFS2_I(dir)->ip_blkno, namelen, name);
 
-	ret = -EEXIST;
-	if (ocfs2_find_entry(name, namelen, dir, &lookup) == 0)
-		goto bail;
+	if (ocfs2_find_entry(name, namelen, dir, &lookup) == 0) {
+		ret = -EEXIST;
+		mlog_errno(ret);
+	}
 
-	ret = 0;
-bail:
 	ocfs2_free_dir_lookup_result(&lookup);
 
-	if (ret)
-		mlog_errno(ret);
 	return ret;
 }
 
_

Patches currently in -mm which might be from daeseok.youn@gmail.com are

origin.patch

