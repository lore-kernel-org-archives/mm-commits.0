From: akpm@linux-foundation.org
Subject: - mempolicy-support-optional-mode-flags-fix.patch removed from -mm tree
Date: Sun, 27 Apr 2008 23:53:24 -0700
Message-ID: <200804280653.m3S6rPTU012650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758583AbYD1GyM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 02:54:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, Lee.Schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, pj@sgi.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     shmem mpol: fix build warning
has been removed from the -mm tree.  Its filename was
     mempolicy-support-optional-mode-flags-fix.patch

This patch was dropped because it was folded into mempolicy-support-optional-mode-flags.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: shmem mpol: fix build warning
From: Hugh Dickins <hugh@veritas.com>

Fix #ifndef CONFIG_NUMA build warning on shmem_parse_mpol arising from
mempolicy-support-optional-mode-flags.patch

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/shmem.c~mempolicy-support-optional-mode-flags-fix mm/shmem.c
--- a/mm/shmem.c~mempolicy-support-optional-mode-flags-fix
+++ a/mm/shmem.c
@@ -1204,7 +1204,7 @@ static struct page *shmem_alloc_page(gfp
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
 static inline int shmem_parse_mpol(char *value, unsigned short *policy,
-				unsigned short flags, nodemask_t *policy_nodes)
+			unsigned short *mode_flags, nodemask_t *policy_nodes)
 {
 	return 1;
 }
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-try-both-endianess-when-checking-for-endianess.patch
mempolicy-support-optional-mode-flags.patch
mempolicy-support-optional-mode-flags-fix.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
vmallocinfo-add-caller-information.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch

