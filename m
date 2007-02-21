From: akpm@linux-foundation.org
Subject: + gfs2-fix-locking-mistake.patch added to -mm tree
Date: Wed, 21 Feb 2007 14:37:59 -0800
Message-ID: <200702212237.l1LMbxF0028615@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53469 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423218AbXBUWjX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 17:39:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jwhiter@redhat.com, stable@kernel.org, swhiteho@redhat.com


The patch titled
     gfs2: fix locking mistake
has been added to the -mm tree.  Its filename is
     gfs2-fix-locking-mistake.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: gfs2: fix locking mistake
From: Josef Whiter <jwhiter@redhat.com>

Fix a locking mistake in the quota code, we do a mutex_lock instead of a
mutex_unlock.

Signed-off-by: Josef Whiter <jwhiter@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/quota.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/gfs2/quota.c~gfs2-fix-locking-mistake fs/gfs2/quota.c
--- a/fs/gfs2/quota.c~gfs2-fix-locking-mistake
+++ a/fs/gfs2/quota.c
@@ -279,7 +279,7 @@ static int bh_get(struct gfs2_quota_data
 		(bh->b_data + sizeof(struct gfs2_meta_header) +
 		 offset * sizeof(struct gfs2_quota_change));
 
-	mutex_lock(&sdp->sd_quota_mutex);
+	mutex_unlock(&sdp->sd_quota_mutex);
 
 	return 0;
 
_

Patches currently in -mm which might be from jwhiter@redhat.com are

gfs2-fix-locking-mistake.patch
