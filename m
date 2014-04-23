From: akpm@linux-foundation.org
Subject: [merged] fs-bioc-remove-nr_segs-unused-function-parameter.patch
 removed from -mm tree
Date: Wed, 23 Apr 2014 10:55:46 -0700
Message-ID: <5357fea2.qFtkq6lfWE9nY7dC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbaDWRzr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Apr 2014 13:55:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, axboe@kernel.dk, fabf@skynet.be

Subject: [merged] fs-bioc-remove-nr_segs-unused-function-parameter.patch removed from -mm tree
To: fabf@skynet.be,axboe@kernel.dk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 23 Apr 2014 10:55:46 -0700


The patch titled
     Subject: fs/bio.c: remove nr_segs (unused function parameter)
has been removed from the -mm tree.  Its filename was
     fs-bioc-remove-nr_segs-unused-function-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/bio.c: remove nr_segs (unused function parameter)

nr_segs is no longer used in bio_alloc_map_data since c8db444820a1e3
("block: Don't save/copy bvec array anymore")

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bio.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/bio.c~fs-bioc-remove-nr_segs-unused-function-parameter fs/bio.c
--- a/fs/bio.c~fs-bioc-remove-nr_segs-unused-function-parameter
+++ a/fs/bio.c
@@ -1014,8 +1014,7 @@ static void bio_set_map_data(struct bio_
 	bio->bi_private = bmd;
 }
 
-static struct bio_map_data *bio_alloc_map_data(int nr_segs,
-					       unsigned int iov_count,
+static struct bio_map_data *bio_alloc_map_data(unsigned int iov_count,
 					       gfp_t gfp_mask)
 {
 	if (iov_count > UIO_MAXIOV)
@@ -1157,7 +1156,7 @@ struct bio *bio_copy_user_iov(struct req
 	if (offset)
 		nr_pages++;
 
-	bmd = bio_alloc_map_data(nr_pages, iov_count, gfp_mask);
+	bmd = bio_alloc_map_data(iov_count, gfp_mask);
 	if (!bmd)
 		return ERR_PTR(-ENOMEM);
 
_

Patches currently in -mm which might be from fabf@skynet.be are

ntfs-remove-null-value-assignments.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch

