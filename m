From: akpm@linux-foundation.org
Subject: + mm-zonelist-enumerate-zonelists-array-index-fix.patch added to
 -mm tree
Date: Wed, 18 Nov 2015 14:47:47 -0800
Message-ID: <564d0013.Xv/mWSKabiHAFy5r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbbKRWrs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Nov 2015 17:47:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, baiyaowei@cmss.chinamobile.com, mhocko@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-zonelist-enumerate-zonelists-array-index-fix
has been added to the -mm tree.  Its filename is
     mm-zonelist-enumerate-zonelists-array-index-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zonelist-enumerate-zonelists-array-index-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zonelist-enumerate-zonelists-array-index-fix.patch

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
Subject: mm-zonelist-enumerate-zonelists-array-index-fix

Fix CONFIG_NUMA=n build

include/linux/gfp.h: In function 'gfp_zonelist':
include/linux/gfp.h:388: error: 'ZONELIST_NOFALLBACK' undeclared (first use in this function)

Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/gfp.h~mm-zonelist-enumerate-zonelists-array-index-fix include/linux/gfp.h
--- a/include/linux/gfp.h~mm-zonelist-enumerate-zonelists-array-index-fix
+++ a/include/linux/gfp.h
@@ -384,9 +384,10 @@ static inline enum zone_type gfp_zone(gf
 
 static inline int gfp_zonelist(gfp_t flags)
 {
-	if (IS_ENABLED(CONFIG_NUMA) && unlikely(flags & __GFP_THISNODE))
+#ifdef CONFIG_NUMA
+	if (unlikely(flags & __GFP_THISNODE))
 		return ZONELIST_NOFALLBACK;
-
+#endif
 	return ZONELIST_FALLBACK;
 }
 
diff -puN include/linux/mmzone.h~mm-zonelist-enumerate-zonelists-array-index-fix include/linux/mmzone.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ncpfs-dont-allow-negative-timeouts-fix.patch
writeback-initialize-m_dirty-to-avoid-compile-warning-fix.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

