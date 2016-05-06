From: akpm@linux-foundation.org
Subject: [merged]
 mm-update-min_free_kbytes-from-khugepaged-after-core-initialization.patch
 removed from -mm tree
Date: Fri, 06 May 2016 14:17:23 -0700
Message-ID: <572d09e3.WPINObwA8sBTxSJY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbcEFVRY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 May 2016 17:17:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@akamai.com, kirill.shutemov@linux.intel.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: update min_free_kbytes from khugepaged after core initialization
has been removed from the -mm tree.  Its filename was
     mm-update-min_free_kbytes-from-khugepaged-after-core-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jason Baron <jbaron@akamai.com>
Subject: mm: update min_free_kbytes from khugepaged after core initialization

Khugepaged attempts to raise min_free_kbytes if its set too low.  However,
on boot khugepaged sets min_free_kbytes first from subsys_initcall(), and
then the mm 'core' over-rides min_free_kbytes after from
init_per_zone_wmark_min(), via a module_init() call.

Khugepaged used to use a late_initcall() to set min_free_kbytes (such that
it occurred after the core initialization), however this was removed when
the initialization of min_free_kbytes was integrated into the starting of
the khugepaged thread.

The fix here is simply to invoke the core initialization using a
core_initcall() instead of module_init(), such that the previous
initialization ordering is restored.  I didn't restore the late_initcall()
since start_stop_khugepaged() already sets min_free_kbytes via
set_recommended_min_free_kbytes().

This was noticed when we had a number of page allocation failures when
moving a workload to a kernel with this new initialization ordering. On an
8GB system this restores min_free_kbytes back to 67584 from 11365 when
CONFIG_TRANSPARENT_HUGEPAGE=y is set and either
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y or
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y.

Fixes: 79553da293d3 ("thp: cleanup khugepaged startup")
Signed-off-by: Jason Baron <jbaron@akamai.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-update-min_free_kbytes-from-khugepaged-after-core-initialization mm/page_alloc.c
--- a/mm/page_alloc.c~mm-update-min_free_kbytes-from-khugepaged-after-core-initialization
+++ a/mm/page_alloc.c
@@ -6485,7 +6485,7 @@ int __meminit init_per_zone_wmark_min(vo
 	setup_per_zone_inactive_ratio();
 	return 0;
 }
-module_init(init_per_zone_wmark_min)
+core_initcall(init_per_zone_wmark_min)
 
 /*
  * min_free_kbytes_sysctl_handler - just a wrapper around proc_dointvec() so
_

Patches currently in -mm which might be from jbaron@akamai.com are


