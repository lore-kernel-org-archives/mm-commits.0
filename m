From: akpm@linux-foundation.org
Subject: +
 ocfs2-remove-pointless-assignment-from-ocfs2_calc_refcount_meta_credits.patch added to -mm tree
Date: Thu, 22 Jan 2015 12:03:28 -0800
Message-ID: <54c15790.qfZbYdEEWlD4NARm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbbAVUDq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jan 2015 15:03:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove pointless assignment from ocfs2_calc_refcount_meta_credits()
has been added to the -mm tree.  Its filename is
     ocfs2-remove-pointless-assignment-from-ocfs2_calc_refcount_meta_credits.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-pointless-assignment-from-ocfs2_calc_refcount_meta_credits.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-pointless-assignment-from-ocfs2_calc_refcount_meta_credits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: remove pointless assignment from ocfs2_calc_refcount_meta_credits()

The assigned value is never used.

Coverity-id 1226847.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ocfs2/refcounttree.c~ocfs2-remove-pointless-assignment-from-ocfs2_calc_refcount_meta_credits fs/ocfs2/refcounttree.c
--- a/fs/ocfs2/refcounttree.c~ocfs2-remove-pointless-assignment-from-ocfs2_calc_refcount_meta_credits
+++ a/fs/ocfs2/refcounttree.c
@@ -2428,8 +2428,6 @@ static int ocfs2_calc_refcount_meta_cred
 			get_bh(prev_bh);
 		}
 
-		rb = (struct ocfs2_refcount_block *)ref_leaf_bh->b_data;
-
 		trace_ocfs2_calc_refcount_meta_credits_iterate(
 				recs_add, (unsigned long long)cpos, clusters,
 				(unsigned long long)le64_to_cpu(rec.r_cpos),
_

Patches currently in -mm which might be from jack@suse.cz are

fanotify-only-destroy-mark-when-both-mask-and-ignored_mask-are-cleared.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-remove-pointless-assignment-from-ocfs2_calc_refcount_meta_credits.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
fs-affs-filec-fix-direct-io-writes-beyond-eof.patch
fs-affs-superc-destroy-sbi-mutex-in-affs_kill_sb.patch
linux-next.patch
mm-fix-xip-fault-vs-truncate-race.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
vfsext2-introduce-is_daxinode.patch
daxext2-replace-xip-read-and-write-with-dax-i-o.patch
daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-xip_truncate_page-with-dax_truncate_page.patch
dax-replace-xip-documentation-with-dax-documentation.patch
vfs-remove-get_xip_mem.patch
ext2-remove-ext2_xip_verify_sb.patch
ext2-remove-ext2_use_xip.patch
ext2-remove-xipc-and-xiph.patch
vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax.patch
ext2-remove-ext2_aops_xip.patch
ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch
dax-add-dax_zero_page_range.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality.patch
brd-rename-xip-to-dax.patch
mm-add-strictlimit-knob-v2.patch

