Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793813537;
	b=GIhD9ISRtV+pHYTJTzsIHWYqW4f4/Y1jKdfRjDRGz7VSKgh8Cg45nRG6wei0IYPQbzLv
	 0jIa/kQ2O05BXxOFL1wVmGDFRyoC71Pbc2raJWMNeS7y7jvdWtilxPiHsc8JypgilKYOm
	 mYDCWNlGxypgi9Tz0cTcKioif0fEvcfP+qDGGqhEMHdse/dCLwqQjNpC4LPoIH/lp41w+
	 GDXO9vR9fln9yGCYAVgRZzy2rOX2wJu9NzQFaPUnJoAgLWvc6QBf3lSc+gmrLJ8Y37IEx
	 6Uy487h8AloGQEHKR3s7ivDlns1oFFsxV6NNpGD95kY7BneqG1bVOeeG2L8RRl4kmhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793813537;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=9v3CCPghi7rW9YiRVdWR8RndDMm02xKtr/Iwb03z+wQ=;
	b=O7ShHVl7IF+LbCqxwvID76yxw8fSxJ39/gu1PN/mxqrGefehEY06xqwluMlSR2yJw6Vs
	 sXgVu2ofDyR4Ta07kEYD3vy6k3V8h3Z1diqpLiqRqdvjuEhTEEh9Q5fe6UKdMTMAF2ZxV
	 OQBms4dj7qxmjLED5rqrJhWgljxNwdD66ssm6oC8pZ3+jmxSPLR+TdLh/SFXwPxMgemEe
	 yaz2ux2IlE8Yqef0sT+OE74O50PFL7iPfOiwJeymY05XexD67QRbc2bQPTFgbe7sR7vf/
	 40Y32KREvMZH+4iYbCfzDSl96Tu/o6uEXmHc8FnUAvVI8iaeRdYyog75w7ulXzUeExA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=o7h9TDfB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AE3606A330
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 17:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=o7h9TDfB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0FF1F00919;
	Wed,  4 Nov 2026 17:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793813536;
	bh=9v3CCPghi7rW9YiRVdWR8RndDMm02xKtr/Iwb03z+wQ=;
	h=Date:To:From:Subject;
	b=o7h9TDfBHjvZOqyiNfwAc9YPrWls9tMh7/JyNxyKef8QOveRsT9sEOSjI+S1etvjk
	 w03hYUhE5spbynCnaIWeyHzJVHJTPUFVPqd/iPWnOySh3iblVPewkGoJRNc/zOiXKJ
	 hSk3HxjWsYxv8/1jbl1AEFnY5OILUv1YFkpQQod0=
Date: Wed, 04 Nov 2026 09:32:15 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,
	xu.xin@linux.dev,weixugc@google.com,vbabka@kernel.org,surenb@google.com,
	shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,qi.zheng@linux.dev,
	osalvador@suse.de,nao.horiguchi@gmail.com,mhocko@suse.com,ljs@kernel.org,
	linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,
	kasong@tencent.com,jannh@google.com,harry@kernel.org,hannes@cmpxchg.org,
	david@kernel.org,chengming.zhou@linux.dev,brendan.jackman@linux.dev,
	baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	axelrasmussen@google.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-split-out-memory-failure-declarations-from-internalh.patch added to mm-new branch
Message-Id: <20261104173216.5D0FF1F00919@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: split out memory-failure declarations from internal.h
has been added to the -mm mm-new branch.  Its filename is
     mm-split-out-memory-failure-declarations-from-internalh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-split-out-memory-failure-declarations-from-internalh.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm: split out memory-failure declarations from internal.h
Date: Wed, 04 Nov 2026 08:45:34 -0800

mm/internal.h carries the memory failure declarations, but only seven of
the 81 .c files that include it use them.

Move memory failure declarations to a new mm/memory-failure.h and include
that from those seven files that need them.

Move the block as is, including take_page_off_buddy(),
put_page_back_buddy() and page_mapped_in_vma(): they live in page_alloc.c
and page_vma_mapped.c, but are built only for CONFIG_MEMORY_FAILURE and
called only from memory-failure.c.

Keep the declarations private to mm/.

No functional change.

Link: https://lore.kernel.org/20261104-memory-failure-split-v1-1-3b0a85f0b7e7@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Link: https://lore.kernel.org/all/aumt-4kfGGtoXuh-@kernel.org/
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Xu Xin <xu.xin@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
---

 MAINTAINERS          |    1 +
 mm/hwpoison-inject.c |    1 +
 mm/internal.h        |   29 -----------------------------
 mm/ksm.c             |    1 +
 mm/memory-failure.c  |    1 +
 mm/memory-failure.h  |   36 ++++++++++++++++++++++++++++++++++++
 mm/memory_hotplug.c  |    1 +
 mm/page_alloc.c      |    1 +
 mm/page_vma_mapped.c |    1 +
 mm/vmscan.c          |    1 +
 10 files changed, 44 insertions(+), 29 deletions(-)

--- a/MAINTAINERS~mm-split-out-memory-failure-declarations-from-internalh
+++ a/MAINTAINERS
@@ -12415,6 +12415,7 @@ F:	include/linux/memory-failure.h
 F:	include/trace/events/memory-failure.h
 F:	mm/hwpoison-inject.c
 F:	mm/memory-failure.c
+F:	mm/memory-failure.h
 F:	tools/mm/memory-failure/
 F:	tools/testing/selftests/mm/memory-failure.c
 
--- a/mm/hwpoison-inject.c~mm-split-out-memory-failure-declarations-from-internalh
+++ a/mm/hwpoison-inject.c
@@ -10,6 +10,7 @@
 #include <linux/page-flags.h>
 #include <linux/memcontrol.h>
 #include "internal.h"
+#include "memory-failure.h"
 
 static u32 hwpoison_filter_enable;
 static u32 hwpoison_filter_dev_major = ~0U;
--- a/mm/internal.h~mm-split-out-memory-failure-declarations-from-internalh
+++ a/mm/internal.h
@@ -1168,35 +1168,6 @@ static inline bool node_reclaim_enabled(
 	return node_reclaim_mode & (RECLAIM_ZONE|RECLAIM_WRITE|RECLAIM_UNMAP);
 }
 
-/*
- * mm/memory-failure.c
- */
-#ifdef CONFIG_MEMORY_FAILURE
-int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill);
-void shake_folio(struct folio *folio);
-typedef int hwpoison_filter_func_t(struct page *p);
-void hwpoison_filter_register(hwpoison_filter_func_t *filter);
-void hwpoison_filter_unregister(void);
-
-#define MAGIC_HWPOISON	0x48575053U	/* HWPS */
-void SetPageHWPoisonTakenOff(struct page *page);
-void ClearPageHWPoisonTakenOff(struct page *page);
-bool take_page_off_buddy(struct page *page);
-bool put_page_back_buddy(struct page *page);
-struct task_struct *task_early_kill(struct task_struct *tsk, int force_early);
-void add_to_kill_ksm(struct task_struct *tsk, const struct page *p,
-		     struct vm_area_struct *vma, struct list_head *to_kill,
-		     unsigned long ksm_addr);
-unsigned long page_mapped_in_vma(const struct page *page,
-		struct vm_area_struct *vma);
-
-#else
-static inline int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill)
-{
-	return -EBUSY;
-}
-#endif
-
 extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
--- a/mm/ksm.c~mm-split-out-memory-failure-declarations-from-internalh
+++ a/mm/ksm.c
@@ -44,6 +44,7 @@
 
 #include <asm/tlbflush.h>
 #include "internal.h"
+#include "memory-failure.h"
 #include "mm_slot.h"
 
 #define CREATE_TRACE_POINTS
--- a/mm/memory-failure.c~mm-split-out-memory-failure-declarations-from-internalh
+++ a/mm/memory-failure.c
@@ -68,6 +68,7 @@
 #include "swap.h"
 #include "page_alloc.h"
 #include "internal.h"
+#include "memory-failure.h"
 
 static int sysctl_memory_failure_early_kill __read_mostly;
 
diff --git a/mm/memory-failure.h a/mm/memory-failure.h
new file mode 100644
--- /dev/null
+++ a/mm/memory-failure.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * mm/ internal memory failure declarations
+ */
+#ifndef __MM_MEMORY_FAILURE_H
+#define __MM_MEMORY_FAILURE_H
+
+#include <linux/mm.h>
+
+#ifdef CONFIG_MEMORY_FAILURE
+int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill);
+void shake_folio(struct folio *folio);
+typedef int hwpoison_filter_func_t(struct page *p);
+void hwpoison_filter_register(hwpoison_filter_func_t *filter);
+void hwpoison_filter_unregister(void);
+
+#define MAGIC_HWPOISON	0x48575053U	/* HWPS */
+void SetPageHWPoisonTakenOff(struct page *page);
+void ClearPageHWPoisonTakenOff(struct page *page);
+bool take_page_off_buddy(struct page *page);
+bool put_page_back_buddy(struct page *page);
+struct task_struct *task_early_kill(struct task_struct *tsk, int force_early);
+void add_to_kill_ksm(struct task_struct *tsk, const struct page *p,
+		     struct vm_area_struct *vma, struct list_head *to_kill,
+		     unsigned long ksm_addr);
+unsigned long page_mapped_in_vma(const struct page *page,
+		struct vm_area_struct *vma);
+
+#else
+static inline int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill)
+{
+	return -EBUSY;
+}
+#endif
+
+#endif /* __MM_MEMORY_FAILURE_H */
--- a/mm/memory_hotplug.c~mm-split-out-memory-failure-declarations-from-internalh
+++ a/mm/memory_hotplug.c
@@ -40,6 +40,7 @@
 #include <asm/tlbflush.h>
 
 #include "internal.h"
+#include "memory-failure.h"
 #include "mm_init.h"
 #include "page_alloc.h"
 #include "shuffle.h"
--- a/mm/page_alloc.c~mm-split-out-memory-failure-declarations-from-internalh
+++ a/mm/page_alloc.c
@@ -57,6 +57,7 @@
 #include <linux/pgalloc_tag.h>
 #include <asm/div64.h>
 #include "internal.h"
+#include "memory-failure.h"
 #include "mm_init.h"
 #include "page_alloc.h"
 #include "shuffle.h"
--- a/mm/page_vma_mapped.c~mm-split-out-memory-failure-declarations-from-internalh
+++ a/mm/page_vma_mapped.c
@@ -6,6 +6,7 @@
 #include <linux/leafops.h>
 
 #include "internal.h"
+#include "memory-failure.h"
 
 static inline bool not_found(struct page_vma_mapped_walk *pvmw)
 {
--- a/mm/vmscan.c~mm-split-out-memory-failure-declarations-from-internalh
+++ a/mm/vmscan.c
@@ -67,6 +67,7 @@
 #include <linux/sched/sysctl.h>
 
 #include "internal.h"
+#include "memory-failure.h"
 #include "page_alloc.h"
 #include "swap.h"
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-scan-modified-objects-as-soon-as-they-are-grayed.patch
tools-mm-add-hwpoison-panic-tool.patch
mm-split-out-memory-failure-declarations-from-internalh.patch

