From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-remove-double-bio_put-in-nilfs_end_bio_write-for-bio_eopnotsupp-error.patch removed from -mm tree
Date: Fri, 23 Aug 2013 12:06:15 -0700
Message-ID: <5217b2a7.HuYz0TEz2JBGICTX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59586 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab3HWTGQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Aug 2013 15:06:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp, dan.carpenter@oracle.com, slava@dubeyko.com

Subject: [merged] nilfs2-remove-double-bio_put-in-nilfs_end_bio_write-for-bio_eopnotsupp-error.patch removed from -mm tree
To: slava@dubeyko.com,dan.carpenter@oracle.com,konishi.ryusuke@lab.ntt.co.jp,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 23 Aug 2013 12:06:15 -0700


The patch titled
     Subject: nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPNOTSUPP error
has been removed from the -mm tree.  Its filename was
     nilfs2-remove-double-bio_put-in-nilfs_end_bio_write-for-bio_eopnotsupp-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: <stable@vger.kernel.org>
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

origin.patch
hfsplus-add-necessary-declarations-for-posix-acls-support.patch
hfsplus-implement-posix-acls-support.patch
hfsplus-integrate-posix-acls-support-into-driver.patch

