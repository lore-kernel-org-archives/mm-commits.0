From: akpm@linux-foundation.org
Subject: +
 account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch added to
 -mm tree
Date: Wed, 11 Nov 2015 13:56:17 -0800
Message-ID: <5643b981.88PrikgSTW4BbUqr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbbKKV4S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 16:56:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: account-certain-kmem-allocations-to-memcg-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch

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
Subject: account-certain-kmem-allocations-to-memcg-checkpatch-fixes

CHECK: spaces preferred around that '|' (ctx:VxV)
#130: FILE: drivers/staging/lustre/lustre/llite/super25.c:109:
+					    0, SLAB_HWCACHE_ALIGN|SLAB_ACCOUNT,
 					                         ^

ERROR: code indent should use tabs where possible
#456: FILE: fs/gfs2/main.c:115:
+^I^I^I^I^I          SLAB_MEM_SPREAD|$

CHECK: spaces preferred around that '|' (ctx:VxV)
#1012: FILE: net/sunrpc/rpc_pipe.c:1503:
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 						               ^

total: 1 errors, 0 warnings, 2 checks, 640 lines checked

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/account-certain-kmem-allocations-to-memcg.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/gfs2/main.c~account-certain-kmem-allocations-to-memcg-checkpatch-fixes fs/gfs2/main.c
--- a/fs/gfs2/main.c~account-certain-kmem-allocations-to-memcg-checkpatch-fixes
+++ a/fs/gfs2/main.c
@@ -112,7 +112,7 @@ static int __init init_gfs2_fs(void)
 	gfs2_inode_cachep = kmem_cache_create("gfs2_inode",
 					      sizeof(struct gfs2_inode),
 					      0,  SLAB_RECLAIM_ACCOUNT|
-					          SLAB_MEM_SPREAD|
+						  SLAB_MEM_SPREAD|
 						  SLAB_ACCOUNT,
 					      gfs2_init_inode_once);
 	if (!gfs2_inode_cachep)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
linux-next-git-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

