From: akpm@linux-foundation.org
Subject: [merged]
 mm-add-restriction-when-memory_hotplug-config-enable.patch removed from -mm tree
Date: Mon, 08 Aug 2016 13:15:05 -0700
Message-ID: <57a8e849.zrtiakxL0aDtBGi+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37349 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbcHHUPG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Aug 2016 16:15:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: disable CONFIG_MEMORY_HOTPLUG when KASAN is enabled
has been removed from the -mm tree.  Its filename was
     mm-add-restriction-when-memory_hotplug-config-enable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: zhong jiang <zhongjiang@huawei.com>
Subject: mm: disable CONFIG_MEMORY_HOTPLUG when KASAN is enabled

At present it is obvious that memory online and offline will fail when
KASAN is enabled.  So add the condition to limit the memory_hotplug when
KASAN is enabled.

Link: http://lkml.kernel.org/r/1470063651-29519-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/Kconfig~mm-add-restriction-when-memory_hotplug-config-enable mm/Kconfig
--- a/mm/Kconfig~mm-add-restriction-when-memory_hotplug-config-enable
+++ a/mm/Kconfig
@@ -187,6 +187,7 @@ config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
 	depends on SPARSEMEM || X86_64_ACPI_NUMA
 	depends on ARCH_ENABLE_MEMORY_HOTPLUG
+	depends on !KASAN
 
 config MEMORY_HOTPLUG_SPARSE
 	def_bool y
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-page_owner-align-with-pageblock_nr-pages.patch
mm-walk-the-zone-in-pageblock_nr_pages-steps.patch

