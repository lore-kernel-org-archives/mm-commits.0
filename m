Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730A53ED5D1
	for <mm-commits@vger.kernel.org>; Wed, 25 Mar 2026 14:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774450109; cv=none; b=E7SdctdKSy3SuP7lmpFfCuvBQHQkYMGe37KnESjLJtTluyyeFMqtbwg7l1np0PU81ldVpwpzpmjFMtGvMoo2/bVQzzVpgFQO/qPGeVYEAw2y1Qt0XeVUgzOswLfDCrVzsgHOMcn9fHWWi03hMda7Jp8HW8cbtvK6nZ9k0JY39Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774450109; c=relaxed/simple;
	bh=Vv5SDkGuufk+oqyDLuBGG2cNo3xzdkNws3d9RbXw7vc=;
	h=Date:To:From:Subject:Message-Id; b=Wkr952BmPxgj6aIV6/KpPgPYzKzobqb/opxcmFtldoxLQ6sV0ha+EMjOIWPGdmZD0JJUKcuDT23/ybLapDwFNKjcLIBu8Dm1W5JA8Lif4z/TtKTc7nSr569gfeNDPb01NqgVx7Dsvb7fS9MZ+iUqN6w6FBKelKYcOb5D4KmgeH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pYb29f1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pYb29f1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1197FC4CEF7;
	Wed, 25 Mar 2026 14:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774450109;
	bh=Vv5SDkGuufk+oqyDLuBGG2cNo3xzdkNws3d9RbXw7vc=;
	h=Date:To:From:Subject:From;
	b=pYb29f1u+7Ez04Yge6jvcVXROcS8QCQxblq3KmhnLq9R7Ece+NpiL9fvnzc6bAg8z
	 SIJkc4zDPeprmoxBSEFvr/zyZORXBelKpx0x4dg5xHpw4ZTotm/LHgg4nZmI2zf2YM
	 die7sAqtigf039Kj4q+MnLibOfW2BM7IQ8cRX8p0=
Date: Wed, 25 Mar 2026 07:48:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,osalvador@suse.de,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lenb@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-introduce-zone-lock-wrappers.patch removed from -mm tree
Message-Id: <20260325144829.1197FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce zone lock wrappers
has been removed from the -mm tree.  Its filename was
     mm-introduce-zone-lock-wrappers.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: introduce zone lock wrappers
Date: Fri, 27 Feb 2026 16:00:23 +0000

Patch series "mm: zone lock tracepoint instrumentation", v4.

Zone lock contention can significantly impact allocation and reclaim
latency, as it is a central synchronization point in the page allocator
and reclaim paths.  Improved visibility into its behavior is therefore
important for diagnosing performance issues in memory-intensive workloads.

On some production workloads at Meta, we have observed noticeable zone
lock contention.  Deeper analysis of lock holders and waiters is currently
difficult with existing instrumentation.

While generic lock contention_begin/contention_end tracepoints cover the
slow path, they do not provide sufficient visibility into lock hold times.
In particular, the lack of a release-side event makes it difficult to
identify long lock holders and correlate them with waiters.  As a result,
distinguishing between short bursts of contention and pathological long
hold times requires additional instrumentation.

This patch series adds dedicated tracepoint instrumentation to zone lock,
following the existing mmap_lock tracing model.

The goal is to enable detailed holder/waiter analysis and lock hold time
measurements without affecting the fast path when tracing is disabled.

The series is structured as follows:

  1. Introduce zone lock wrappers.
  2. Mechanically convert zone lock users to the wrappers.
  3. Convert compaction to use the wrappers (requires minor
     restructuring of compact_lock_irqsave()).
  4. Rename zone->lock to zone->_lock.
  5. Add zone lock tracepoints.

The tracepoints are added via lightweight inline helpers in the wrappers. 
When tracing is disabled, the fast path remains unchanged.


This patch (of 5):

Add thin wrappers around zone lock acquire/release operations.  This
prepares the code for future tracepoint instrumentation without modifying
individual call sites.

Centralizing zone lock operations behind wrappers allows future
instrumentation or debugging hooks to be added without touching all users.

No functional change intended.  The wrappers are introduced in preparation
for subsequent patches and are not yet used.

Link: https://lkml.kernel.org/r/cover.1772206930.git.d@ilvokhin.com
Link: https://lkml.kernel.org/r/849dee9c47df1e6fba97c9933af0d5a08b8e15d3.1772206930.git.d@ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                 |    1 
 include/linux/mmzone_lock.h |   38 ++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/linux/mmzone_lock.h a/include/linux/mmzone_lock.h
new file mode 100644
--- /dev/null
+++ a/include/linux/mmzone_lock.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_MMZONE_LOCK_H
+#define _LINUX_MMZONE_LOCK_H
+
+#include <linux/mmzone.h>
+#include <linux/spinlock.h>
+
+static inline void zone_lock_init(struct zone *zone)
+{
+	spin_lock_init(&zone->lock);
+}
+
+#define zone_lock_irqsave(zone, flags)				\
+do {								\
+	spin_lock_irqsave(&(zone)->lock, flags);		\
+} while (0)
+
+#define zone_trylock_irqsave(zone, flags)			\
+({								\
+	spin_trylock_irqsave(&(zone)->lock, flags);		\
+})
+
+static inline void zone_unlock_irqrestore(struct zone *zone, unsigned long flags)
+{
+	spin_unlock_irqrestore(&zone->lock, flags);
+}
+
+static inline void zone_lock_irq(struct zone *zone)
+{
+	spin_lock_irq(&zone->lock);
+}
+
+static inline void zone_unlock_irq(struct zone *zone)
+{
+	spin_unlock_irq(&zone->lock);
+}
+
+#endif /* _LINUX_MMZONE_LOCK_H */
--- a/MAINTAINERS~mm-introduce-zone-lock-wrappers
+++ a/MAINTAINERS
@@ -16662,6 +16662,7 @@ F:	include/linux/memory.h
 F:	include/linux/mm.h
 F:	include/linux/mm_*.h
 F:	include/linux/mmzone.h
+F:	include/linux/mmzone_lock.h
 F:	include/linux/mmdebug.h
 F:	include/linux/mmu_notifier.h
 F:	include/linux/pagewalk.h
_

Patches currently in -mm which might be from d@ilvokhin.com are

mm-convert-zone-lock-users-to-wrappers.patch
mm-convert-compaction-to-zone-lock-wrappers.patch
mm-rename-zone-lock-to-zone-_lock.patch
mm-add-tracepoints-for-zone-lock.patch

