From: akpm@linux-foundation.org
Subject: + mm-add-restriction-when-memory_hotplug-config-enable.patch
 added to -mm tree
Date: Mon, 01 Aug 2016 12:56:04 -0700
Message-ID: <579fa954.J7M+9eRW6G9BFAVw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbcHAT4F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 15:56:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: disable CONFIG_MEMORY_HOTPLUG when KASAN is enabled
has been added to the -mm tree.  Its filename is
     mm-add-restriction-when-memory_hotplug-config-enable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-restriction-when-memory_hotplug-config-enable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-restriction-when-memory_hotplug-config-enable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-add-restriction-when-memory_hotplug-config-enable.patch
mm-page_owner-align-with-pageblock_nr-pages.patch
mm-walk-the-zone-in-pageblock_nr_pages-steps.patch
kexec-add-restriction-on-kexec_load-segment-sizes.patch

