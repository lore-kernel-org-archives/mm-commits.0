From: akpm@linux-foundation.org
Subject: [folded] memcg-move-charges-of-anonymous-swap-fix-2.patch removed from -mm tree
Date: Wed, 10 Mar 2010 14:54:39 -0800
Message-ID: <201003102254.o2AMsepi008718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757385Ab0CJWyn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 17:54:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg-move-charges-of-anonymous-swap-fix-2
has been removed from the -mm tree.  Its filename was
     memcg-move-charges-of-anonymous-swap-fix-2.patch

This patch was dropped because it was folded into memcg-move-charges-of-anonymous-swap.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-move-charges-of-anonymous-swap-fix-2
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Now, ia64 can't compile page_cgroup.c.
because it include asm/cmpxhg.h but almost arch don't have arch specific
cmpxhg.h. they use asm-generic/cmpxhg.h.

Then, following errror occur.

  CC      mm/page_cgroup.o
  mm/page_cgroup.c:12:25: error: asm/cmpxchg.h: No such file or
  directory
  make[1]: *** [mm/page_cgroup.o] Error 1
  make: *** [mm] Error 2

Fortunately, memcg code don't use low layer cmpxchg directly. thus
this patch remove this include line simply.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/page_cgroup.c~memcg-move-charges-of-anonymous-swap-fix-2 mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-move-charges-of-anonymous-swap-fix-2
+++ a/mm/page_cgroup.c
@@ -9,7 +9,6 @@
 #include <linux/vmalloc.h>
 #include <linux/cgroup.h>
 #include <linux/swapops.h>
-#include <asm/cmpxchg.h>
 
 static void __meminit
 __init_page_cgroup(struct page_cgroup *pc, unsigned long pfn)
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mm-do-not-iterate-over-nr_cpus-in-__zone_pcp_update.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
coredump-plug-a-memory-leak-situation-on-dump_seek.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-move-charges-of-anonymous-swap-fix-2.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists-fix.patch
reiser4.patch

