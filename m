From: akpm@linux-foundation.org
Subject: [folded-merged]
 tracing-add-trace-event-for-memory-failure-fix.patch removed from -mm tree
Date: Wed, 24 Jun 2015 16:47:58 -0700
Message-ID: <558b41ae.DWrS7pwVLUQnHHqP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40585 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbbFXXr7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jun 2015 19:47:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiexiuqi@huawei.com, gong.chen@linux.intel.com, jim.epost@gmail.com, n-horiguchi@ah.jp.nec.com, rdunlap@infradead.org, rostedt@goodmis.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tracing: fix build error in mm/memory-failure.c
has been removed from the -mm tree.  Its filename was
     tracing-add-trace-event-for-memory-failure-fix.patch

This patch was dropped because it was folded into tracing-add-trace-event-for-memory-failure.patch

------------------------------------------------------
From: Xie XiuQi <xiexiuqi@huawei.com>
Subject: tracing: fix build error in mm/memory-failure.c

next-20150515 fails to build on i386 with the following error:

mm/built-in.o: In function `action_result':
memory-failure.c:(.text+0x344a5): undefined reference to `__tracepoint_memory_failure_event'
memory-failure.c:(.text+0x344d5): undefined reference to `__tracepoint_memory_failure_event'
memory-failure.c:(.text+0x3450c): undefined reference to `__tracepoint_memory_failure_event'

trace_memory_failure_event depends on CONFIG_RAS,
so add 'select RAS' in mm/Kconfig to avoid this error.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Jim Davis <jim.epost@gmail.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/Kconfig~tracing-add-trace-event-for-memory-failure-fix mm/Kconfig
--- a/mm/Kconfig~tracing-add-trace-event-for-memory-failure-fix
+++ a/mm/Kconfig
@@ -368,6 +368,7 @@ config MEMORY_FAILURE
 	depends on ARCH_SUPPORTS_MEMORY_FAILURE
 	bool "Enable recovery from hardware memory errors"
 	select MEMORY_ISOLATION
+	select RAS
 	help
 	  Enables code to recover from some memory failures on systems
 	  with MCA recovery. This allows a system to continue running
_

Patches currently in -mm which might be from xiexiuqi@huawei.com are

origin.patch
memory-failure-export-page_type-and-action-result.patch
memory-failure-change-type-of-action_results-param-3-to-enum.patch
tracing-add-trace-event-for-memory-failure.patch
mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute.patch
mm-memblock-allocate-boot-time-data-structures-from-mirrored-memory.patch
x86-mirror-x86-enabling-find-mirrored-memory-ranges.patch

