From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-initialize-pages-on-demand-during-boot-fix.patch removed from -mm tree
Date: Wed, 14 Feb 2018 16:16:20 -0800
Message-ID: <5a84d154.4DlvfBnteF8YQXTQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43854 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032127AbeBOAQj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Feb 2018 19:16:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, pasha.tatashin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-initialize-pages-on-demand-during-boot-fix
has been removed from the -mm tree.  Its filename was
     mm-initialize-pages-on-demand-during-boot-fix.patch

This patch was dropped because it was folded into mm-initialize-pages-on-demand-during-boot.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-initialize-pages-on-demand-during-boot-fix

fix typo in comment, make deferred_pages static

Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-initialize-pages-on-demand-during-boot-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-initialize-pages-on-demand-during-boot-fix
+++ a/mm/page_alloc.c
@@ -1568,14 +1568,14 @@ static int __init deferred_init_memmap(v
 }
 
 /*
- * This lock grantees that only one thread at a time is allowed to grow zones
+ * This lock guarantees that only one thread at a time is allowed to grow zones
  * (decrease number of deferred pages).
  * Protects first_deferred_pfn field in all zones during early boot before
  * deferred pages are initialized.  Deferred pages are initialized in
  * page_alloc_init_late() soon after smp_init() is complete.
  */
 static __initdata DEFINE_SPINLOCK(deferred_zone_grow_lock);
-DEFINE_STATIC_KEY_TRUE(deferred_pages);
+static DEFINE_STATIC_KEY_TRUE(deferred_pages);
 
 /*
  * If this zone has deferred pages, try to grow it by initializing enough
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
include-linux-sched-mmh-re-inline-mmdrop.patch
mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc-fix.patch
vmalloc-fix-__gfp_highmem-usage-for-vmalloc_32-on-32b-systems-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
inotify-extend-ioctl-to-allow-to-request-id-of-new-watch-descriptor-fix.patch
mm.patch
mm-initialize-pages-on-demand-during-boot.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

