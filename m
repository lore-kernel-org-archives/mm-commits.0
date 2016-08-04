From: akpm@linux-foundation.org
Subject: [patch 1/7] mm: disable CONFIG_MEMORY_HOTPLUG when KASAN is
 enabled
Date: Thu, 04 Aug 2016 15:31:44 -0700
Message-ID: <57a3c250.CkI2PulANbvNl/ZZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759220AbcHDWbp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Aug 2016 18:31:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, zhongjiang@huawei.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com

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
