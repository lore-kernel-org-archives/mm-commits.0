From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters-fix.patch removed from -mm tree
Date: Fri, 31 Jan 2014 13:53:35 -0800
Message-ID: <52ec1b5f.XRFXKPgwrjBLPar4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbaAaVxg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 16:53:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wangzongxun@huawei.com, mfasheh@suse.com, lizefan@huawei.com, joseph.qi@huawei.com, jlbec@evilplan.org, akpm@linux-foundation.org

Subject: [folded-merged] ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,jlbec@evilplan.org,joseph.qi@huawei.com,lizefan@huawei.com,mfasheh@suse.com,wangzongxun@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 13:53:35 -0800


The patch titled
     Subject: ocfs2: correctly update i_used in ocfs2_free_local_alloc_bits
has been removed from the -mm tree.  Its filename was
     ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters-fix.patch

This patch was dropped because it was folded into ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters.patch

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
ocfs2-free-allocated-clusters-if-error-occurs-after-ocfs2_claim_clusters.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

