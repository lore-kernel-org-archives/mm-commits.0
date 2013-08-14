From: akpm@linux-foundation.org
Subject: +
 nilfs2-fix-issue-with-counting-number-of-bio-requests-for-bio_eopnotsupp-error-detection.patch added to -mm tree
Date: Wed, 14 Aug 2013 16:01:07 -0700
Message-ID: <520c0c33.+f/ve7DyvbvjjxuY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933408Ab3HNXBI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 19:01:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp, dan.carpenter@oracle.com, slava@dubeyko.com

Subject: + nilfs2-fix-issue-with-counting-number-of-bio-requests-for-bio_eopnotsupp-error-detection.patch added to -mm tree
To: slava@dubeyko.com,dan.carpenter@oracle.com,konishi.ryusuke@lab.ntt.co.jp
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 16:01:07 -0700


The patch titled
     Subject: nilfs2: fix issue with counting number of bio requests for BIO_EOPNOTSUPP error detection
has been added to the -mm tree.  Its filename is
     nilfs2-fix-issue-with-counting-number-of-bio-requests-for-bio_eopnotsupp-error-detection.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-fix-issue-with-counting-number-of-bio-requests-for-bio_eopnotsupp-error-detection.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-fix-issue-with-counting-number-of-bio-requests-for-bio_eopnotsupp-error-detection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

nilfs2-remove-double-bio_put-in-nilfs_end_bio_write-for-bio_eopnotsupp-error.patch
nilfs2-fix-issue-with-counting-number-of-bio-requests-for-bio_eopnotsupp-error-detection.patch
hfsplus-add-necessary-declarations-for-posix-acls-support.patch
hfsplus-implement-posix-acls-support.patch
hfsplus-integrate-posix-acls-support-into-driver.patch

