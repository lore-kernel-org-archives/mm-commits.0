From: akpm@linux-foundation.org
Subject: + mm-initialize-pages-on-demand-during-boot-fix.patch added to
 -mm tree
Date: Fri, 09 Feb 2018 12:36:29 -0800
Message-ID: <5a7e064d.zseIL4wxfLh8/tTw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56866 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752190AbeBIUhC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Feb 2018 15:37:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, pasha.tatashin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-initialize-pages-on-demand-during-boot-fix
has been added to the -mm tree.  Its filename is
     mm-initialize-pages-on-demand-during-boot-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-initialize-pages-on-demand-during-boot-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-initialize-pages-on-demand-during-boot-fix.patch

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
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-initialize-pages-on-demand-during-boot-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

