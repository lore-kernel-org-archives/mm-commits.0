From: akpm@linux-foundation.org
Subject: +
 nilfs2-remove-double-bio_put-in-nilfs_end_bio_write-for-bio_eopnotsupp-error.patch added to -mm tree
Date: Wed, 14 Aug 2013 15:59:15 -0700
Message-ID: <520c0bc3.8H2bU0cMB8pluIol%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933442Ab3HNW7Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 18:59:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp, dan.carpenter@oracle.com, slava@dubeyko.com

Subject: + nilfs2-remove-double-bio_put-in-nilfs_end_bio_write-for-bio_eopnotsupp-error.patch added to -mm tree
To: slava@dubeyko.com,dan.carpenter@oracle.com,konishi.ryusuke@lab.ntt.co.jp
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 15:59:15 -0700


The patch titled
     Subject: nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPNOTSUPP error
has been added to the -mm tree.  Its filename is
     nilfs2-remove-double-bio_put-in-nilfs_end_bio_write-for-bio_eopnotsupp-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-remove-double-bio_put-in-nilfs_end_bio_write-for-bio_eopnotsupp-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-remove-double-bio_put-in-nilfs_end_bio_write-for-bio_eopnotsupp-error.patch

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
Subject: nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPNOTSUPP error

Remove double call of bio_put() in nilfs_end_bio_write() for the case of
BIO_EOPNOTSUPP error detection.  The issue was found by Dan Carpenter and
he suggests first version of the fix too.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segbuf.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/nilfs2/segbuf.c~nilfs2-remove-double-bio_put-in-nilfs_end_bio_write-for-bio_eopnotsupp-error fs/nilfs2/segbuf.c
--- a/fs/nilfs2/segbuf.c~nilfs2-remove-double-bio_put-in-nilfs_end_bio_write-for-bio_eopnotsupp-error
+++ a/fs/nilfs2/segbuf.c
@@ -345,8 +345,7 @@ static void nilfs_end_bio_write(struct b
 
 	if (err == -EOPNOTSUPP) {
 		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
-		bio_put(bio);
-		/* to be detected by submit_seg_bio() */
+		/* to be detected by nilfs_segbuf_submit_bio() */
 	}
 
 	if (!uptodate)
_

Patches currently in -mm which might be from slava@dubeyko.com are

nilfs2-remove-double-bio_put-in-nilfs_end_bio_write-for-bio_eopnotsupp-error.patch
hfsplus-add-necessary-declarations-for-posix-acls-support.patch
hfsplus-implement-posix-acls-support.patch
hfsplus-integrate-posix-acls-support-into-driver.patch

