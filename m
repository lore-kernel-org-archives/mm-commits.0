From: akpm@linux-foundation.org
Subject: + fs-bioc-remove-nr_segs-unused-function-parameter.patch added to -mm tree
Date: Tue, 22 Apr 2014 12:54:39 -0700
Message-ID: <5356c8ff.QWdVyLPEeuGUaoqi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874AbaDVTyk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Apr 2014 15:54:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, axboe@kernel.dk, fabf@skynet.be

Subject: + fs-bioc-remove-nr_segs-unused-function-parameter.patch added to -mm tree
To: fabf@skynet.be,axboe@kernel.dk
From: akpm@linux-foundation.org
Date: Tue, 22 Apr 2014 12:54:39 -0700


The patch titled
     Subject: fs/bio.c: remove nr_segs (unused function parameter)
has been added to the -mm tree.  Its filename is
     fs-bioc-remove-nr_segs-unused-function-parameter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-bioc-remove-nr_segs-unused-function-parameter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-bioc-remove-nr_segs-unused-function-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1011,8 +1011,7 @@ static void bio_set_map_data(struct bio_
 	bio->bi_private = bmd;
 }
 
-static struct bio_map_data *bio_alloc_map_data(int nr_segs,
-					       unsigned int iov_count,
+static struct bio_map_data *bio_alloc_map_data(unsigned int iov_count,
 					       gfp_t gfp_mask)
 {
 	if (iov_count > UIO_MAXIOV)
@@ -1154,7 +1153,7 @@ struct bio *bio_copy_user_iov(struct req
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
fs-bio-remove-bs-paramater-in-biovec_create_pool.patch
fs-bioc-remove-nr_segs-unused-function-parameter.patch
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

