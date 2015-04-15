From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-one-function-call-less-in-ocfs2_merge_rec_right-after-error-detection.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:07:58 -0700
Message-ID: <552eb70e.flewhU/nxszCSrS5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbbDOTH7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:07:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elfring@users.sourceforge.net, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: one function call less in ocfs2_merge_rec_right() after error detection
has been removed from the -mm tree.  Its filename was
     ocfs2-one-function-call-less-in-ocfs2_merge_rec_right-after-error-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Markus Elfring <elfring@users.sourceforge.net>
Subject: ocfs2: one function call less in ocfs2_merge_rec_right() after error detection

ocfs2_free_path() was called by ocfs2_merge_rec_right() even if a call of
the ocfs2_get_right_path() function failed.

Return from this implementation directly after corresponding
exception handling.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-one-function-call-less-in-ocfs2_merge_rec_right-after-error-detection fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-one-function-call-less-in-ocfs2_merge_rec_right-after-error-detection
+++ a/fs/ocfs2/alloc.c
@@ -3370,7 +3370,7 @@ static int ocfs2_merge_rec_right(struct
 		ret = ocfs2_get_right_path(et, left_path, &right_path);
 		if (ret) {
 			mlog_errno(ret);
-			goto out;
+			return ret;
 		}
 
 		right_el = path_leaf_el(right_path);
_

Patches currently in -mm which might be from elfring@users.sourceforge.net are

origin.patch
linux-next.patch

