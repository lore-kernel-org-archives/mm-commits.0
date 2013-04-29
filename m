From: akpm@linux-foundation.org
Subject: [folded-merged] mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:50:50 -0700
Message-ID: <20130429215050.AA1C45A4034@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:49789 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758419Ab3D2Vuv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:50:51 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so109934vbe.0
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:50:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, agshew@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes-fix
has been removed from the -mm tree.  Its filename was
     mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes-fix.patch

This patch was dropped because it was folded into mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed.patch

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes-fix

make init_reserve_notifier() static

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andrew Shewmaker <agshew@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes-fix mm/mmap.c
--- a/mm/mmap.c~mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes-fix
+++ a/mm/mmap.c
@@ -3205,7 +3205,7 @@ static struct notifier_block reserve_mem
 	.notifier_call = reserve_mem_notifier,
 };
 
-int __meminit init_reserve_notifier(void)
+static int __meminit init_reserve_notifier(void)
 {
 	if (register_hotmemory_notifier(&reserve_mem_nb))
 		printk("Failed registering memory add/remove notifier for admin reserve");
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
hwpoison-check-dirty-flag-to-match-against-clean-page.patch
sparse-vmemmap-specify-vmemmap-population-range-in-bytes.patch
x86-64-use-vmemmap_populate_basepages-for-pse-setups.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed.patch
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix.patch

