From: akpm@linux-foundation.org
Subject: +
 ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters-fix.patch added to -mm tree
Date: Mon, 27 Jan 2014 15:06:27 -0800
Message-ID: <52e6e673.St0uX4+xxhETT+x6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbaA0XG2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jan 2014 18:06:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wangzongxun@huawei.com, mfasheh@suse.com, lizefan@huawei.com, joseph.qi@huawei.com, jlbec@evilplan.org, akpm@linux-foundation.org

Subject: + ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters-fix.patch added to -mm tree
To: akpm@linux-foundation.org,jlbec@evilplan.org,joseph.qi@huawei.com,lizefan@huawei.com,mfasheh@suse.com,wangzongxun@huawei.com
From: akpm@linux-foundation.org
Date: Mon, 27 Jan 2014 15:06:27 -0800


The patch titled
     Subject: ocfs2: correctly update i_used in ocfs2_free_local_alloc_bits
has been added to the -mm tree.  Its filename is
     ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2: correctly update i_used in ocfs2_free_local_alloc_bits

We should note down num of bits to be freed, so as to update i_used
correspondingly after clearing those bits in bitmap.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Zongxun Wang <wangzongxun@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/localalloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/localalloc.c~ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters-fix fs/ocfs2/localalloc.c
--- a/fs/ocfs2/localalloc.c~ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters-fix
+++ a/fs/ocfs2/localalloc.c
@@ -788,6 +788,7 @@ int ocfs2_free_local_alloc_bits(struct o
 				u32 num_bits)
 {
 	int status, start;
+	u32 clear_bits;
 	struct inode *local_alloc_inode;
 	void *bitmap;
 	struct ocfs2_dinode *alloc;
@@ -801,6 +802,7 @@ int ocfs2_free_local_alloc_bits(struct o
 
 	bitmap = la->la_bitmap;
 	start = bit_off - le32_to_cpu(la->la_bm_off);
+	clear_bits = num_bits;
 
 	status = ocfs2_journal_access_di(handle,
 			INODE_CACHE(local_alloc_inode),
@@ -811,7 +813,7 @@ int ocfs2_free_local_alloc_bits(struct o
 		goto bail;
 	}
 
-	while (num_bits--)
+	while (clear_bits--)
 		ocfs2_clear_bit(start++, bitmap);
 
 	le32_add_cpu(&alloc->id1.bitmap1.i_used, -num_bits);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
arch-unicore32-kernel-early_printkc-setup_early_printk-missing-initialization-fix.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
mm-document-improved-handling-of-swappiness==0-fix.patch
mm-mempolicyc-convert-to-pr_foo.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters-fix.patch
mm.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
ipcmsg-document-barriers-fix.patch
ipcmsg-document-barriers-fix-fix.patch
linux-next.patch
linux-next-git-rejects.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

