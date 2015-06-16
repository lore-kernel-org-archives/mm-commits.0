From: akpm@linux-foundation.org
Subject: + ocfs2-use-swap-in-ocfs2_double_lock.patch added to -mm tree
Date: Tue, 16 Jun 2015 13:42:39 -0700
Message-ID: <55808a3f.vhpDd7PDItaJo7hr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbbFPUmk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jun 2015 16:42:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jlbec@evilplan.org, julia.lawall@lip6.fr, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use swap() in ocfs2_double_lock()
has been added to the -mm tree.  Its filename is
     ocfs2-use-swap-in-ocfs2_double_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-use-swap-in-ocfs2_double_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-use-swap-in-ocfs2_double_lock.patch

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
Subject: ocfs2: use swap() in ocfs2_double_lock()

Use kernel.h macro definition.

Thanks to Julia Lawall for Coccinelle scripting support.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-use-swap-in-ocfs2_double_lock fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-use-swap-in-ocfs2_double_lock
+++ a/fs/ocfs2/namei.c
@@ -1116,8 +1116,6 @@ static int ocfs2_double_lock(struct ocfs
 	int inode1_is_ancestor, inode2_is_ancestor;
 	struct ocfs2_inode_info *oi1 = OCFS2_I(inode1);
 	struct ocfs2_inode_info *oi2 = OCFS2_I(inode2);
-	struct buffer_head **tmpbh;
-	struct inode *tmpinode;
 
 	trace_ocfs2_double_lock((unsigned long long)oi1->ip_blkno,
 				(unsigned long long)oi2->ip_blkno);
@@ -1148,13 +1146,8 @@ static int ocfs2_double_lock(struct ocfs
 				(oi1->ip_blkno < oi2->ip_blkno &&
 				inode2_is_ancestor == 0)) {
 			/* switch id1 and id2 around */
-			tmpbh = bh2;
-			bh2 = bh1;
-			bh1 = tmpbh;
-
-			tmpinode = inode2;
-			inode2 = inode1;
-			inode1 = tmpinode;
+			swap(bh2, bh1);
+			swap(inode2, inode1);
 		}
 		/* lock id2 */
 		status = ocfs2_inode_lock_nested(inode2, bh2, 1,
_

Patches currently in -mm which might be from fabf@skynet.be are

configfs-unexport-make-static-config_item_init.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-use-swap-in-dx_leaf_sort_swap.patch
ocfs2-use-swap-in-swap_refcount_rec.patch
ocfs2-use-swap-in-ocfs2_double_lock.patch
fs-befs-btreec-remove-unneeded-initializations.patch
fs-affs-inodec-remove-unneeded-initialization.patch
fs-affs-amigaffsc-remove-unneeded-initialization.patch
fs-affs-symlinkc-remove-unneeded-err-variable.patch
w1-masters-omap_hdq-add-support-for-1-wire-mode.patch
linux-next.patch
mm-provide-new-get_vaddr_frames-helper.patch
media-omap_vout-convert-omap_vout_uservirt_to_phys-to-use-get_vaddr_pfns.patch
vb2-provide-helpers-for-mapping-virtual-addresses.patch
media-vb2-convert-vb2_dma_sg_get_userptr-to-use-frame-vector.patch
media-vb2-convert-vb2_vmalloc_get_userptr-to-use-frame-vector.patch
media-vb2-convert-vb2_dc_get_userptr-to-use-frame-vector.patch
media-vb2-remove-unused-functions.patch
drm-exynos-convert-g2d_userptr_get_dma_addr-to-use-get_vaddr_frames.patch
mm-move-get_vaddr_frames-behind-a-config-option.patch

