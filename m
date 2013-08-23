From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-fix-issue-with-counting-number-of-bio-requests-for-bio_eopnotsupp-error-detection.patch removed from -mm tree
Date: Fri, 23 Aug 2013 12:06:17 -0700
Message-ID: <5217b2a9.U3PmL9tw+wsZZtbq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59591 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab3HWTGS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Aug 2013 15:06:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp, dan.carpenter@oracle.com, slava@dubeyko.com

Subject: [merged] nilfs2-fix-issue-with-counting-number-of-bio-requests-for-bio_eopnotsupp-error-detection.patch removed from -mm tree
To: slava@dubeyko.com,dan.carpenter@oracle.com,konishi.ryusuke@lab.ntt.co.jp,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 23 Aug 2013 12:06:17 -0700


The patch titled
     Subject: nilfs2: fix issue with counting number of bio requests for BIO_EOPNOTSUPP error detection
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-issue-with-counting-number-of-bio-requests-for-bio_eopnotsupp-error-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: nilfs2: fix issue with counting number of bio requests for BIO_EOPNOTSUPP error detection

Fix the issue with improper counting number of flying bio requests for
BIO_EOPNOTSUPP error detection case.

The sb_nbio must be incremented exactly the same number of times as
complete() function was called (or will be called) because
nilfs_segbuf_wait() will call wail_for_completion() for the number of
times set to sb_nbio:

do {
    wait_for_completion(&segbuf->sb_bio_event);
} while (--segbuf->sb_nbio > 0);

Two functions complete() and wait_for_completion() must be called the same
number of times for the same sb_bio_event.  Otherwise,
wait_for_completion() will hang or leak.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segbuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/segbuf.c~nilfs2-fix-issue-with-counting-number-of-bio-requests-for-bio_eopnotsupp-error-detection fs/nilfs2/segbuf.c
--- a/fs/nilfs2/segbuf.c~nilfs2-fix-issue-with-counting-number-of-bio-requests-for-bio_eopnotsupp-error-detection
+++ a/fs/nilfs2/segbuf.c
@@ -376,12 +376,12 @@ static int nilfs_segbuf_submit_bio(struc
 	bio->bi_private = segbuf;
 	bio_get(bio);
 	submit_bio(mode, bio);
+	segbuf->sb_nbio++;
 	if (bio_flagged(bio, BIO_EOPNOTSUPP)) {
 		bio_put(bio);
 		err = -EOPNOTSUPP;
 		goto failed;
 	}
-	segbuf->sb_nbio++;
 	bio_put(bio);
 
 	wi->bio = NULL;
_

Patches currently in -mm which might be from slava@dubeyko.com are

origin.patch
hfsplus-add-necessary-declarations-for-posix-acls-support.patch
hfsplus-implement-posix-acls-support.patch
hfsplus-integrate-posix-acls-support-into-driver.patch

