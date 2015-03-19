From: akpm@linux-foundation.org
Subject: + ocfs2-remove-goto-statement-in-ocfs2_check_dir_for_entry.patch
 added to -mm tree
Date: Thu, 19 Mar 2015 15:36:34 -0700
Message-ID: <550b4f72.KOhZTiaKJ3EZG7Ev%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58747 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbbCSWgg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Mar 2015 18:36:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daeseok.youn@gmail.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove goto statement in ocfs2_check_dir_for_entry()
has been added to the -mm tree.  Its filename is
     ocfs2-remove-goto-statement-in-ocfs2_check_dir_for_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-goto-statement-in-ocfs2_check_dir_for_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-goto-statement-in-ocfs2_check_dir_for_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-avoid-a-pointless-delay-in-o2cb_cluster_check.patch
ocfs2-remove-goto-statement-in-ocfs2_check_dir_for_entry.patch

