From: akpm@linux-foundation.org
Subject: [merged] mm-document-highmem_is_dirtyable-sysctl.patch
 removed from -mm tree
Date: Tue, 11 Jul 2017 12:27:38 -0700
Message-ID: <20170711192738._tcZ6UPQs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48810 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932836AbdGKT1j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:27:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alkisg@gmail.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: document highmem_is_dirtyable sysctl
has been removed from the -mm tree.  Its filename was
     mm-document-highmem_is_dirtyable-sysctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: document highmem_is_dirtyable sysctl

It seems that there are still people using 32b kernels which a lot of
memory and the IO tend to suck a lot for them by default.  Mostly because
writers are throttled too when the lowmem is used.  We have
highmem_is_dirtyable to work around that issue but it seems we never
bothered to document it.  Let's do it now, finally.

Link: http://lkml.kernel.org/r/20170626093200.18958-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alkis Georgopoulos <alkisg@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN Documentation/sysctl/vm.txt~mm-document-highmem_is_dirtyable-sysctl Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-document-highmem_is_dirtyable-sysctl
+++ a/Documentation/sysctl/vm.txt
@@ -240,6 +240,26 @@ fragmentation index is <= extfrag_thresh
 
 ==============================================================
 
+highmem_is_dirtyable
+
+Available only for systems with CONFIG_HIGHMEM enabled (32b systems).
+
+This parameter controls whether the high memory is considered for dirty
+writers throttling.  This is not the case by default which means that
+only the amount of memory directly visible/usable by the kernel can
+be dirtied. As a result, on systems with a large amount of memory and
+lowmem basically depleted writers might be throttled too early and
+streaming writes can get very slow.
+
+Changing the value to non zero would allow more memory to be dirtied
+and thus allow writers to write more data which can be flushed to the
+storage more effectively. Note this also comes with a risk of pre-mature
+OOM killer because some writers (e.g. direct block device writes) can
+only use the low memory and they can fill it up with dirty data without
+any throttling.
+
+==============================================================
+
 hugepages_treat_as_movable
 
 This parameter controls whether we can allocate hugepages from ZONE_MOVABLE
_

Patches currently in -mm which might be from mhocko@suse.com are

netfilter-use-kvmalloc-xt_alloc_table_info.patch
mips-do-not-use-__gfp_repeat-for-order-0-request.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-2.patch
xfs-map-km_mayfail-to-__gfp_retry_mayfail.patch
mm-kvmalloc-support-__gfp_retry_mayfail-for-all-sizes.patch
drm-i915-use-__gfp_retry_mayfail.patch
mm-migration-do-not-trigger-oom-killer-when-migrating-memory.patch

