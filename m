From: akpm@linux-foundation.org
Subject: + tracing-add-trace-event-for-memory-failure-fix.patch added to
 -mm tree
Date: Fri, 22 May 2015 13:12:42 -0700
Message-ID: <555f8dba.8ARl7abolTxKRQa1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393AbbEVUMo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 May 2015 16:12:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiexiuqi@huawei.com, gong.chen@linux.intel.com, jim.epost@gmail.com, n-horiguchi@ah.jp.nec.com, rdunlap@infradead.org, rostedt@goodmis.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tracing: fix build error in mm/memory-failure.c
has been added to the -mm tree.  Its filename is
     tracing-add-trace-event-for-memory-failure-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tracing-add-trace-event-for-memory-failure-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tracing-add-trace-event-for-memory-failure-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memory-failure-export-page_type-and-action-result.patch
memory-failure-change-type-of-action_results-param-3-to-enum.patch
tracing-add-trace-event-for-memory-failure.patch
tracing-add-trace-event-for-memory-failure-fix.patch

