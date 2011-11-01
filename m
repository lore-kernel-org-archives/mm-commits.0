From: akpm@linux-foundation.org
Subject: [merged] mm-thrashc-quiet-sparse-noise.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:11:38 -0700
Message-ID: <201111012111.pA1LBcpx005125@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15896 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVLs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:11:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, hsweeten@visionengravers.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thrash.c: quiet sparse noise
has been removed from the -mm tree.  Its filename was
     mm-thrashc-quiet-sparse-noise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: mm/thrash.c: quiet sparse noise

Quiet the following sparse noise:

warning: symbol 'swap_token_memcg' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/thrash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/thrash.c~mm-thrashc-quiet-sparse-noise mm/thrash.c
--- a/mm/thrash.c~mm-thrashc-quiet-sparse-noise
+++ a/mm/thrash.c
@@ -29,7 +29,7 @@
 
 static DEFINE_SPINLOCK(swap_token_lock);
 struct mm_struct *swap_token_mm;
-struct mem_cgroup *swap_token_memcg;
+static struct mem_cgroup *swap_token_memcg;
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 static struct mem_cgroup *swap_token_memcg_from_mm(struct mm_struct *mm)
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

origin.patch
linux-next.patch
arch-x86-kernel-e820c-quiet-sparse-noise-about-plain-integer-as-null-pointer.patch
arch-x86-kernel-ptracec-quiet-sparse-noise.patch
arch-x86-mm-pageattrc-quiet-sparse-noise-local-functions-should-be-static.patch
ceph-mds_clientc-quiet-sparse-noise.patch
mm-page_cgroupc-quiet-sparse-noise.patch

