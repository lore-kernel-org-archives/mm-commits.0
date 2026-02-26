Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1A8229B18
	for <mm-commits@vger.kernel.org>; Thu, 26 Feb 2026 21:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772141145; cv=none; b=jUocxtUN0rUPKYC3gMpbDiLHuSxbJ1pD8RW6uL2x/AZDgURnMnPQ6R7OxdUzIYRT+5HNR6c/gGVvzQO74VxaDSOUXLdYZvLpV8j6Lq0yJ4WTBJSmqkjPND3FSMukIaYQb4mivATGOg4mx9OulIUepORGJI8n4rF2pefWVhFt6Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772141145; c=relaxed/simple;
	bh=Zc8ltlDoELM6JdE2T0dImyDl0OmpApFxuKblPUbtgFg=;
	h=Date:To:From:Subject:Message-Id; b=l/OT0dtzxiwjRqF87Qcy5FgYNnciJrGLTrdiXVdiVtriwle/euwHmIEsA91yUZsHB4wBf2105BoV78HV1IjCGTHzdULi24qkNd4kCU20v4FTfgYBrgm8OwjdXabZpXY0HlkYdwFvG4M8kZnvbN+SqsyoYK3l1OCzbYGckl3mF2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dBoqJpZ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dBoqJpZ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB3AC116C6;
	Thu, 26 Feb 2026 21:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772141145;
	bh=Zc8ltlDoELM6JdE2T0dImyDl0OmpApFxuKblPUbtgFg=;
	h=Date:To:From:Subject:From;
	b=dBoqJpZ2mDLZMq1TDUvLPQ0ROh+aLuEl2YxE8QuKR3Hm50cjfNBUazJnN8V+VIoML
	 lZ3RPDjhosfMIIwInb6cS0OfH1IIIkcp1zvhUuVM9NRTXfDPF5QmFgu53xwtsCfKt5
	 VPNYlK10qo4HcCRgJ/N+CTU8nGmSXBkO+Y/upNpU=
Date: Thu, 26 Feb 2026 13:25:44 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,osalvador@suse.de,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,benjamin.cheatham@amd.com,axelrasmussen@google.com,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-zone-lock-wrappers.patch added to mm-new branch
Message-Id: <20260226212545.2EB3AC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce zone lock wrappers
has been added to the -mm mm-new branch.  Its filename is
     mm-introduce-zone-lock-wrappers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-zone-lock-wrappers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: introduce zone lock wrappers
Date: Thu, 26 Feb 2026 18:26:18 +0000

Patch series "mm: zone lock tracepoint instrumentation", v3.

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

Link: https://lkml.kernel.org/r/cover.1772129168.git.d@ilvokhin.com
Link: https://lkml.kernel.org/r/5bcc39cd3a227944d0fbe75ff86cdac92b38d4ca.1772129168.git.d@ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Ben Cheatham <benjamin.cheatham@amd.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS               |    1 
 include/linux/zone_lock.h |   38 ++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/linux/zone_lock.h a/include/linux/zone_lock.h
new file mode 100644
--- /dev/null
+++ a/include/linux/zone_lock.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_ZONE_LOCK_H
+#define _LINUX_ZONE_LOCK_H
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
+#endif /* _LINUX_ZONE_LOCK_H */
--- a/MAINTAINERS~mm-introduce-zone-lock-wrappers
+++ a/MAINTAINERS
@@ -16681,6 +16681,7 @@ F:	include/linux/pgtable.h
 F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
+F:	include/linux/zone_lock.h
 F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
_

Patches currently in -mm which might be from d@ilvokhin.com are

mm-introduce-zone-lock-wrappers.patch
mm-convert-zone-lock-users-to-wrappers.patch
mm-convert-compaction-to-zone-lock-wrappers.patch
mm-rename-zone-lock-to-zone-_lock.patch
mm-add-tracepoints-for-zone-lock.patch

