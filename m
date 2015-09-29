From: akpm@linux-foundation.org
Subject: +
 mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
 added to -mm tree
Date: Tue, 29 Sep 2015 16:09:41 -0700
Message-ID: <560b1a35.CJDbtXnjTNyPiN9/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbbI2XJm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 19:09:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, 00moses.alexander00@gmail.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, vbabka@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix
has been added to the -mm tree.  Its filename is
     mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch

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
Subject: mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix

Make zone_pagecache_reclaimable() return ulong rather than long.  Negative
values are meainingless here and all zone_pagecache_reclaimable() callers
turn its retrun value into ulong anyway.

Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Alexandru Moise <00moses.alexander00@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix
+++ a/mm/vmscan.c
@@ -3693,7 +3693,7 @@ static inline unsigned long zone_unmappe
 }
 
 /* Work out how many page cache pages we can reclaim in this reclaim_mode */
-static long zone_pagecache_reclaimable(struct zone *zone)
+static unsigned long zone_pagecache_reclaimable(struct zone *zone)
 {
 	unsigned long nr_pagecache_reclaimable;
 	unsigned long delta = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
memcg-make-mem_cgroup_read_stat-unsigned-fix.patch
drivers-input-joystick-kconfig-zhenhuac-needs-bitreverse.patch
mm.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

