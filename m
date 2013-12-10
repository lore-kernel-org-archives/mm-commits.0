From: akpm@linux-foundation.org
Subject: + mm-hwpoison-add-to-hwpoison_inject.patch added to -mm tree
Date: Tue, 10 Dec 2013 13:39:28 -0800
Message-ID: <52a78a10.5kDvYANe9mRosfLT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3LJVj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 16:39:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, murzin.v@gmail.com, liwanp@linux.vnet.ibm.com

Subject: + mm-hwpoison-add-to-hwpoison_inject.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,murzin.v@gmail.com,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 13:39:28 -0800


The patch titled
     Subject: mm/hwpoison: add '#' to hwpoison_inject
has been added to the -mm tree.  Its filename is
     mm-hwpoison-add-to-hwpoison_inject.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-add-to-hwpoison_inject.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-add-to-hwpoison_inject.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/hwpoison: add '#' to hwpoison_inject

Add '#' to hwpoison_inject just as done in madvise_hwpoison.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Vladimir Murzin <murzin.v@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hwpoison-inject.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hwpoison-inject.c~mm-hwpoison-add-to-hwpoison_inject mm/hwpoison-inject.c
--- a/mm/hwpoison-inject.c~mm-hwpoison-add-to-hwpoison_inject
+++ a/mm/hwpoison-inject.c
@@ -55,7 +55,7 @@ static int hwpoison_inject(void *data, u
 		return 0;
 
 inject:
-	printk(KERN_INFO "Injecting memory failure at pfn %lx\n", pfn);
+	pr_info("Injecting memory failure at pfn %#lx\n", pfn);
 	return memory_failure(pfn, 18, MF_COUNT_INCREASED);
 }
 
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

x86-get-pg_data_ts-memory-from-other-node.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
mm-hwpoison-add-to-hwpoison_inject.patch

