Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA55237163
	for <mm-commits@vger.kernel.org>; Wed, 19 Nov 2025 23:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763593353; cv=none; b=jlMVVOUGJeJ5znpZaOjva55KrLHGi1/62R9hRpRjRQVIbBAT8cS5Bgw+hYVGcXcuMFN5bxJOa/NfFXNtpDCAayybRisjd0ThsH3SQQP7NUUB3bG/15RNHV5UaehCzIm/2ht24ULxm3hJc1iZINzkCzOuivYXTkC44d1AB8Gd+N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763593353; c=relaxed/simple;
	bh=Kb/SHgG09BUZjt4XH30IITzEdCEfTaheTs4+rvMlGP0=;
	h=Date:To:From:Subject:Message-Id; b=H3YKUKlaqqmy1K9pLEbbpjgWwqVL+HMkvytUvnRJP86rYV08bJ5mW1BqWKVtVAqwzvL862ejOl53DFCyrUffmawzllsB8r6iQgH78L+ZnzISW0VduiDqIfGXvpaeKAo8kd6nicwpX0YoMOsbiH/09xpV0aD3xnhx6wihBZ20YC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lktm9u29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lktm9u29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BC3C4CEF5;
	Wed, 19 Nov 2025 23:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763593353;
	bh=Kb/SHgG09BUZjt4XH30IITzEdCEfTaheTs4+rvMlGP0=;
	h=Date:To:From:Subject:From;
	b=lktm9u29WOuUBqbiYiLOPZ5L2OXxTxTe45V0ctZYjl5PP1QvncrUI8bEKuYKTlpAQ
	 9Uhs2whBMLK/RaInqgu9/yO7CNjCF79Ki0YsIrrd4reRsIhsdQzRPbGiI0o9QXNXek
	 aGjx7fHLyFY3R13hXyvpkS3Gdl3DpOf4m+H5T2Bs=
Date: Wed, 19 Nov 2025 15:02:32 -0800
To: mm-commits@vger.kernel.org,linmiaohe@huawei.com,david@kernel.org,bp@alien8.de,xieyuanbin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-remove-the-selection-of-ras.patch added to mm-new branch
Message-Id: <20251119230233.15BC3C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: remove the selection of RAS
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-failure-remove-the-selection-of-ras.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-remove-the-selection-of-ras.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Xie Yuanbin <xieyuanbin1@huawei.com>
Subject: mm/memory-failure: remove the selection of RAS
Date: Wed, 19 Nov 2025 17:59:43 +0800

commit 97f0b13452198290799f ("tracing: add trace event for
memory-failure") introduces the selection of RAS in memory-failure.  This
commit is just a tracing feature; in reality, there is no dependency
between memory-failure and RAS.  RAS increases the size of the bzImage
image by 8k, which is very valuable for embedded devices.

Move the memory-failure traceing code from ras_event.h to
memory-failure.h and remove the selection of RAS.

Link: https://lkml.kernel.org/r/20251119095943.67125-1-xieyuanbin1@huawei.com
Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                           |    1 
 include/ras/ras_event.h               |   87 ---------------------
 include/trace/events/memory-failure.h |   98 ++++++++++++++++++++++++
 mm/Kconfig                            |    1 
 mm/memory-failure.c                   |    5 -
 5 files changed, 103 insertions(+), 89 deletions(-)

--- a/include/ras/ras_event.h~mm-memory-failure-remove-the-selection-of-ras
+++ a/include/ras/ras_event.h
@@ -12,7 +12,6 @@
 #include <linux/pci.h>
 #include <linux/aer.h>
 #include <linux/cper.h>
-#include <linux/mm.h>
 
 /*
  * MCE Extended Error Log trace event
@@ -339,92 +338,6 @@ TRACE_EVENT(aer_event,
 			"Not available")
 );
 #endif /* CONFIG_PCIEAER */
-
-/*
- * memory-failure recovery action result event
- *
- * unsigned long pfn -	Page Frame Number of the corrupted page
- * int type	-	Page types of the corrupted page
- * int result	-	Result of recovery action
- */
-
-#ifdef CONFIG_MEMORY_FAILURE
-#define MF_ACTION_RESULT	\
-	EM ( MF_IGNORED, "Ignored" )	\
-	EM ( MF_FAILED,  "Failed" )	\
-	EM ( MF_DELAYED, "Delayed" )	\
-	EMe ( MF_RECOVERED, "Recovered" )
-
-#define MF_PAGE_TYPE		\
-	EM ( MF_MSG_KERNEL, "reserved kernel page" )			\
-	EM ( MF_MSG_KERNEL_HIGH_ORDER, "high-order kernel page" )	\
-	EM ( MF_MSG_HUGE, "huge page" )					\
-	EM ( MF_MSG_FREE_HUGE, "free huge page" )			\
-	EM ( MF_MSG_GET_HWPOISON, "get hwpoison page" )			\
-	EM ( MF_MSG_UNMAP_FAILED, "unmapping failed page" )		\
-	EM ( MF_MSG_DIRTY_SWAPCACHE, "dirty swapcache page" )		\
-	EM ( MF_MSG_CLEAN_SWAPCACHE, "clean swapcache page" )		\
-	EM ( MF_MSG_DIRTY_MLOCKED_LRU, "dirty mlocked LRU page" )	\
-	EM ( MF_MSG_CLEAN_MLOCKED_LRU, "clean mlocked LRU page" )	\
-	EM ( MF_MSG_DIRTY_UNEVICTABLE_LRU, "dirty unevictable LRU page" )	\
-	EM ( MF_MSG_CLEAN_UNEVICTABLE_LRU, "clean unevictable LRU page" )	\
-	EM ( MF_MSG_DIRTY_LRU, "dirty LRU page" )			\
-	EM ( MF_MSG_CLEAN_LRU, "clean LRU page" )			\
-	EM ( MF_MSG_TRUNCATED_LRU, "already truncated LRU page" )	\
-	EM ( MF_MSG_BUDDY, "free buddy page" )				\
-	EM ( MF_MSG_DAX, "dax page" )					\
-	EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )			\
-	EM ( MF_MSG_ALREADY_POISONED, "already poisoned" )		\
-	EM ( MF_MSG_PFN_MAP, "non struct page pfn" )                    \
-	EMe ( MF_MSG_UNKNOWN, "unknown page" )
-
-/*
- * First define the enums in MM_ACTION_RESULT to be exported to userspace
- * via TRACE_DEFINE_ENUM().
- */
-#undef EM
-#undef EMe
-#define EM(a, b) TRACE_DEFINE_ENUM(a);
-#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
-
-MF_ACTION_RESULT
-MF_PAGE_TYPE
-
-/*
- * Now redefine the EM() and EMe() macros to map the enums to the strings
- * that will be printed in the output.
- */
-#undef EM
-#undef EMe
-#define EM(a, b)		{ a, b },
-#define EMe(a, b)	{ a, b }
-
-TRACE_EVENT(memory_failure_event,
-	TP_PROTO(unsigned long pfn,
-		 int type,
-		 int result),
-
-	TP_ARGS(pfn, type, result),
-
-	TP_STRUCT__entry(
-		__field(unsigned long, pfn)
-		__field(int, type)
-		__field(int, result)
-	),
-
-	TP_fast_assign(
-		__entry->pfn	= pfn;
-		__entry->type	= type;
-		__entry->result	= result;
-	),
-
-	TP_printk("pfn %#lx: recovery action for %s: %s",
-		__entry->pfn,
-		__print_symbolic(__entry->type, MF_PAGE_TYPE),
-		__print_symbolic(__entry->result, MF_ACTION_RESULT)
-	)
-);
-#endif /* CONFIG_MEMORY_FAILURE */
 #endif /* _TRACE_HW_EVENT_MC_H */
 
 /* This part must be outside protection */
diff --git a/include/trace/events/memory-failure.h a/include/trace/events/memory-failure.h
new file mode 100644
--- /dev/null
+++ a/include/trace/events/memory-failure.h
@@ -0,0 +1,98 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM memory_failure
+#define TRACE_INCLUDE_FILE memory-failure
+
+#if !defined(_TRACE_MEMORY_FAILURE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_MEMORY_FAILURE_H
+
+#include <linux/tracepoint.h>
+#include <linux/mm.h>
+
+/*
+ * memory-failure recovery action result event
+ *
+ * unsigned long pfn -	Page Frame Number of the corrupted page
+ * int type	-	Page types of the corrupted page
+ * int result	-	Result of recovery action
+ */
+
+#define MF_ACTION_RESULT	\
+	EM ( MF_IGNORED, "Ignored" )	\
+	EM ( MF_FAILED,  "Failed" )	\
+	EM ( MF_DELAYED, "Delayed" )	\
+	EMe ( MF_RECOVERED, "Recovered" )
+
+#define MF_PAGE_TYPE		\
+	EM ( MF_MSG_KERNEL, "reserved kernel page" )			\
+	EM ( MF_MSG_KERNEL_HIGH_ORDER, "high-order kernel page" )	\
+	EM ( MF_MSG_HUGE, "huge page" )					\
+	EM ( MF_MSG_FREE_HUGE, "free huge page" )			\
+	EM ( MF_MSG_GET_HWPOISON, "get hwpoison page" )			\
+	EM ( MF_MSG_UNMAP_FAILED, "unmapping failed page" )		\
+	EM ( MF_MSG_DIRTY_SWAPCACHE, "dirty swapcache page" )		\
+	EM ( MF_MSG_CLEAN_SWAPCACHE, "clean swapcache page" )		\
+	EM ( MF_MSG_DIRTY_MLOCKED_LRU, "dirty mlocked LRU page" )	\
+	EM ( MF_MSG_CLEAN_MLOCKED_LRU, "clean mlocked LRU page" )	\
+	EM ( MF_MSG_DIRTY_UNEVICTABLE_LRU, "dirty unevictable LRU page" )	\
+	EM ( MF_MSG_CLEAN_UNEVICTABLE_LRU, "clean unevictable LRU page" )	\
+	EM ( MF_MSG_DIRTY_LRU, "dirty LRU page" )			\
+	EM ( MF_MSG_CLEAN_LRU, "clean LRU page" )			\
+	EM ( MF_MSG_TRUNCATED_LRU, "already truncated LRU page" )	\
+	EM ( MF_MSG_BUDDY, "free buddy page" )				\
+	EM ( MF_MSG_DAX, "dax page" )					\
+	EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )			\
+	EM ( MF_MSG_ALREADY_POISONED, "already poisoned" )		\
+	EM ( MF_MSG_PFN_MAP, "non struct page pfn" )                    \
+	EMe ( MF_MSG_UNKNOWN, "unknown page" )
+
+/*
+ * First define the enums in MM_ACTION_RESULT to be exported to userspace
+ * via TRACE_DEFINE_ENUM().
+ */
+#undef EM
+#undef EMe
+#define EM(a, b) TRACE_DEFINE_ENUM(a);
+#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
+
+MF_ACTION_RESULT
+MF_PAGE_TYPE
+
+/*
+ * Now redefine the EM() and EMe() macros to map the enums to the strings
+ * that will be printed in the output.
+ */
+#undef EM
+#undef EMe
+#define EM(a, b)		{ a, b },
+#define EMe(a, b)	{ a, b }
+
+TRACE_EVENT(memory_failure_event,
+	TP_PROTO(unsigned long pfn,
+		 int type,
+		 int result),
+
+	TP_ARGS(pfn, type, result),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pfn)
+		__field(int, type)
+		__field(int, result)
+	),
+
+	TP_fast_assign(
+		__entry->pfn	= pfn;
+		__entry->type	= type;
+		__entry->result	= result;
+	),
+
+	TP_printk("pfn %#lx: recovery action for %s: %s",
+		__entry->pfn,
+		__print_symbolic(__entry->type, MF_PAGE_TYPE),
+		__print_symbolic(__entry->result, MF_ACTION_RESULT)
+	)
+);
+#endif /* _TRACE_MEMORY_FAILURE_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
--- a/MAINTAINERS~mm-memory-failure-remove-the-selection-of-ras
+++ a/MAINTAINERS
@@ -11562,6 +11562,7 @@ S:	Maintained
 F:	include/linux/memory-failure.h
 F:	mm/hwpoison-inject.c
 F:	mm/memory-failure.c
+F:	include/trace/events/memory-failure.h
 
 HYCON HY46XX TOUCHSCREEN SUPPORT
 M:	Giulio Benetti <giulio.benetti@benettiengineering.com>
--- a/mm/Kconfig~mm-memory-failure-remove-the-selection-of-ras
+++ a/mm/Kconfig
@@ -740,7 +740,6 @@ config MEMORY_FAILURE
 	depends on MMU
 	depends on ARCH_SUPPORTS_MEMORY_FAILURE
 	bool "Enable recovery from hardware memory errors"
-	select RAS
 	select INTERVAL_TREE
 	help
 	  Enables code to recover from some memory failures on systems
--- a/mm/memory-failure.c~mm-memory-failure-remove-the-selection-of-ras
+++ a/mm/memory-failure.c
@@ -61,9 +61,12 @@
 #include <linux/pagewalk.h>
 #include <linux/shmem_fs.h>
 #include <linux/sysctl.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/memory-failure.h>
+
 #include "swap.h"
 #include "internal.h"
-#include "ras/ras_event.h"
 
 static int sysctl_memory_failure_early_kill __read_mostly;
 
_

Patches currently in -mm which might be from xieyuanbin1@huawei.com are

mm-memory-failure-remove-the-selection-of-ras.patch

