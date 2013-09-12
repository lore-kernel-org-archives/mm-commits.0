From: akpm@linux-foundation.org
Subject: [merged] mm-hwpoison-add-to-madvise_hwpoison.patch removed from
 -mm tree
Date: Thu, 12 Sep 2013 12:45:33 -0700
Message-ID: <523219dd.d+dSX8oJK/sHQmQ5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab3ILTpe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-hwpoison-add-to-madvise_hwpoison.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,andi@firstfloor.org,n-horiguchi@ah.jp.nec.com,tony.luck@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:33 -0700


The patch titled
     Subject: mm/hwpoison: add '#' to madvise_hwpoison
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-add-to-madvise_hwpoison.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/hwpoison: add '#' to madvise_hwpoison

Add '#' to madvise_hwpoison.

Before patch:

[   95.892866] Injecting memory failure for page 19d0 at b7786000
[   95.893151] MCE 0x19d0: non LRU page recovery: Ignored

After patch:

[   95.892866] Injecting memory failure for page 0x19d0 at 0xb7786000
[   95.893151] MCE 0x19d0: non LRU page recovery: Ignored

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/madvise.c~mm-hwpoison-add-to-madvise_hwpoison mm/madvise.c
--- a/mm/madvise.c~mm-hwpoison-add-to-madvise_hwpoison
+++ a/mm/madvise.c
@@ -353,14 +353,14 @@ static int madvise_hwpoison(int bhv, uns
 		if (ret != 1)
 			return ret;
 		if (bhv == MADV_SOFT_OFFLINE) {
-			printk(KERN_INFO "Soft offlining page %lx at %lx\n",
+			pr_info("Soft offlining page %#lx at %#lx\n",
 				page_to_pfn(p), start);
 			ret = soft_offline_page(p, MF_COUNT_INCREASED);
 			if (ret)
 				break;
 			continue;
 		}
-		printk(KERN_INFO "Injecting memory failure for page %lx at %lx\n",
+		pr_info("Injecting memory failure for page %#lx at %#lx\n",
 		       page_to_pfn(p), start);
 		/* Ignore return value for now */
 		memory_failure(page_to_pfn(p), 0, MF_COUNT_INCREASED);
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

