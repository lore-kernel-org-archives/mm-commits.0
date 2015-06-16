From: akpm@linux-foundation.org
Subject: + ocfs2-use-swap-in-dx_leaf_sort_swap.patch added to -mm tree
Date: Tue, 16 Jun 2015 13:41:20 -0700
Message-ID: <558089f0.MsWxpvMIJdrw29ZV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457AbbFPUlV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jun 2015 16:41:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jlbec@evilplan.org, julia.lawall@lip6.fr, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use swap() in dx_leaf_sort_swap()
has been added to the -mm tree.  Its filename is
     ocfs2-use-swap-in-dx_leaf_sort_swap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-use-swap-in-dx_leaf_sort_swap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-use-swap-in-dx_leaf_sort_swap.patch

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
Subject: ocfs2: use swap() in dx_leaf_sort_swap()

Use kernel.h macro definition.

Thanks to Julia Lawall for Coccinelle scripting support.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/ocfs2/dir.c~ocfs2-use-swap-in-dx_leaf_sort_swap fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~ocfs2-use-swap-in-dx_leaf_sort_swap
+++ a/fs/ocfs2/dir.c
@@ -3543,13 +3543,10 @@ static void dx_leaf_sort_swap(void *a, v
 {
 	struct ocfs2_dx_entry *entry1 = a;
 	struct ocfs2_dx_entry *entry2 = b;
-	struct ocfs2_dx_entry tmp;
 
 	BUG_ON(size != sizeof(*entry1));
 
-	tmp = *entry1;
-	*entry1 = *entry2;
-	*entry2 = tmp;
+	swap(*entry1, *entry2);
 }
 
 static int ocfs2_dx_leaf_same_major(struct ocfs2_dx_leaf *dx_leaf)
_

Patches currently in -mm which might be from fabf@skynet.be are

configfs-unexport-make-static-config_item_init.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-use-swap-in-dx_leaf_sort_swap.patch
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

