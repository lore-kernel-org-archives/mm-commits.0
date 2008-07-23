From: akpm@linux-foundation.org
Subject: - bootmem-clean-up-alloc_bootmem_core-fix-new-alloc_bootmem_core.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:09:09 -0700
Message-ID: <200807232321.m6NNLktg017379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754281AbYGWXVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:21:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: y-goto@jp.fujitsu.com, hannes@saeurebad.de, mm-commits@vger.kernel.org


The patch titled
     bootmem-clean-up-alloc_bootmem_core: Fix new alloc_bootmem_core
has been removed from the -mm tree.  Its filename was
     bootmem-clean-up-alloc_bootmem_core-fix-new-alloc_bootmem_core.patch

This patch was dropped because it was folded into bootmem-clean-up-alloc_bootmem_core.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem-clean-up-alloc_bootmem_core: Fix new alloc_bootmem_core
From: Yasunori Goto <y-goto@jp.fujitsu.com>

Fix new alloc_bootmem_core() of bootmem-clean-up-alloc_bootmem_core.patch
in 2.6.26-rc5-mm3.

(min < goal) should be checked too.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/bootmem.c~bootmem-clean-up-alloc_bootmem_core-fix-new-alloc_bootmem_core mm/bootmem.c
--- a/mm/bootmem.c~bootmem-clean-up-alloc_bootmem_core-fix-new-alloc_bootmem_core
+++ a/mm/bootmem.c
@@ -462,7 +462,7 @@ static void * __init alloc_bootmem_core(
 
 	step = max(align >> PAGE_SHIFT, 1UL);
 
-	if (goal && goal < max)
+	if (goal && min < goal && goal < max)
 		start = ALIGN(goal, step);
 	else
 		start = ALIGN(min, step);
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

bootmem-clean-up-alloc_bootmem_core.patch
bootmem-clean-up-alloc_bootmem_core-fix-new-alloc_bootmem_core.patch
bootmem-respect-goal-more-likely.patch
bootmem-revisit-alloc_bootmem_section.patch
mm-make-register_page_bootmem_info_section-static.patch
memory-hotplugallocate-usemap-on-the-section-with-pgdat-take-4.patch
memory-hotplug-small-fixes-to-bootmem-freeing-for-memory-hotremove.patch
memory-hotplug-dont-calculate-vm_total_pages-twice-when-rebuilding-zonelists-in-online_pages.patch

