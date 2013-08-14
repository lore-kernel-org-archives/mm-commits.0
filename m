From: akpm@linux-foundation.org
Subject: + mm-remove-unnecessary-variable-idx0-in-__early_ioremap.patch
 added to -mm tree
Date: Wed, 14 Aug 2013 15:51:04 -0700
Message-ID: <520c09d8.P4GVlsukoRCglJKg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149Ab3HNWvE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 18:51:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wujianguo@huawei.com

Subject: + mm-remove-unnecessary-variable-idx0-in-__early_ioremap.patch added to -mm tree
To: wujianguo@huawei.com
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 15:51:04 -0700


The patch titled
     Subject: mm: remove unnecessary variable idx0 in __early_ioremap()
has been added to the -mm tree.  Its filename is
     mm-remove-unnecessary-variable-idx0-in-__early_ioremap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-unnecessary-variable-idx0-in-__early_ioremap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-unnecessary-variable-idx0-in-__early_ioremap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm: remove unnecessary variable idx0 in __early_ioremap()

After 8827247ffcc ("x86: don't define __this_fixmap_does_not_exist()"),
variable idx0 is no longer needed, so just remove it.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/ioremap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/x86/mm/ioremap.c~mm-remove-unnecessary-variable-idx0-in-__early_ioremap arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~mm-remove-unnecessary-variable-idx0-in-__early_ioremap
+++ a/arch/x86/mm/ioremap.c
@@ -487,7 +487,7 @@ __early_ioremap(resource_size_t phys_add
 	unsigned long offset;
 	resource_size_t last_addr;
 	unsigned int nrpages;
-	enum fixed_addresses idx0, idx;
+	enum fixed_addresses idx;
 	int i, slot;
 
 	WARN_ON(system_state != SYSTEM_BOOTING);
@@ -540,8 +540,7 @@ __early_ioremap(resource_size_t phys_add
 	/*
 	 * Ok, go for it..
 	 */
-	idx0 = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
-	idx = idx0;
+	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
 	while (nrpages > 0) {
 		early_set_fixmap(idx, phys_addr, prot);
 		phys_addr += PAGE_SIZE;
_

Patches currently in -mm which might be from wujianguo@huawei.com are

mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
mm-zbud-fix-some-trivial-typos-in-comments.patch
mm-remove-unnecessary-variable-idx0-in-__early_ioremap.patch
linux-next.patch

