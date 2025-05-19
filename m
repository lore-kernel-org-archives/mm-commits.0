Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C031EDA3C
	for <mm-commits@vger.kernel.org>; Mon, 19 May 2025 22:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747693762; cv=none; b=CTFxhHmsgk2i5UY6hp1Y4UAq6E0oIYVBK6wYMjvGtYH50a4L3IQNuDawSFBw1apA+gtHN0P2N2SOYyIwP+ohXHTf8PndJN1hhJedeCNm4jJM6SLSg1zabDN+37tvw+hIO0fEaESOZ+b22Tzz6S9u4iiBwOP5y1JAK0tL6ZAr9x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747693762; c=relaxed/simple;
	bh=GrZZdOrydezkR6gNTKk9RGVyZOBH7QLBT9S82+Jarq0=;
	h=Date:To:From:Subject:Message-Id; b=TfkNUw33fbrGHHgUV6PUBp7Rs2wbdUkzXYVEN1LWRlQFqcLul2uFXby5ch30f01YIvkZtR7IOSrzAkmeMrxk2+TjiK+1rgFf3KgBz4pTkjUcCVa9a6XW7NmLGNgkpf4xIC9vf9RnU35tjSioQzLIE0nKcPekvgFGoJDCkdBVCTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1O+w8G+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1O+w8G+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29202C4CEE4;
	Mon, 19 May 2025 22:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747693762;
	bh=GrZZdOrydezkR6gNTKk9RGVyZOBH7QLBT9S82+Jarq0=;
	h=Date:To:From:Subject:From;
	b=1O+w8G+Li95VohWSbLNDZgQWnN7jzw6LhHpIF8yl4PdrtTDpnvJ48/d6nZmGPAtri
	 cwYcGihhZocqQfBqQ6UIQIF5k6ddd1ZINPPsylXXk9DMRwfQJYNXc4PbS+qBBB7ghg
	 KYuMlfkQ1+s4GixOTS5uytBHWhGYz4iXpnT9Bx+M=
Date: Mon, 19 May 2025 15:29:21 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mhocko@kernel.org,mathieu.desnoyers@efficios.com,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-disable-kmem-charging-in-nmi-for-unsupported-arch.patch added to mm-new branch
Message-Id: <20250519222922.29202C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: disable kmem charging in nmi for unsupported arch
has been added to the -mm mm-new branch.  Its filename is
     memcg-disable-kmem-charging-in-nmi-for-unsupported-arch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-disable-kmem-charging-in-nmi-for-unsupported-arch.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: disable kmem charging in nmi for unsupported arch
Date: Sun, 18 May 2025 23:31:38 -0700

Patch series "memcg: nmi-safe kmem charging", v4.

Users can attached their BPF programs at arbitrary execution points in the
kernel and such BPF programs may run in nmi context.  In addition, these
programs can trigger memcg charged kernel allocations in the nmi context. 
However memcg charging infra for kernel memory is not equipped to handle
nmi context for all architectures.

This series removes the hurdles to enable kmem charging in the nmi context
for most of the archs.  For archs without CONFIG_HAVE_NMI, this series is
a noop.  For archs with NMI support and have
CONFIG_ARCH_HAS_NMI_SAFE_THIS_CPU_OPS, the previous work to make memcg
stats re-entrant is sufficient for allowing kmem charging in nmi context. 
For archs with NMI support but without
CONFIG_ARCH_HAS_NMI_SAFE_THIS_CPU_OPS and with ARCH_HAVE_NMI_SAFE_CMPXCHG,
this series added infra to support kmem charging in nmi context.  Lastly
those archs with NMI support but without
CONFIG_ARCH_HAS_NMI_SAFE_THIS_CPU_OPS and ARCH_HAVE_NMI_SAFE_CMPXCHG, kmem
charging in nmi context is not supported at all.

Mostly used archs have support for CONFIG_ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
and this series should be almost a noop (other than making
memcg_rstat_updated nmi safe) for such archs.  


This patch (of 5):

The memcg accounting and stats uses this_cpu* and atomic* ops.  There are
archs which define CONFIG_HAVE_NMI but does not define
CONFIG_ARCH_HAS_NMI_SAFE_THIS_CPU_OPS and ARCH_HAVE_NMI_SAFE_CMPXCHG, so
memcg accounting for such archs in nmi context is not possible to support.
Let's just disable memcg accounting in nmi context for such archs.

Link: https://lkml.kernel.org/r/20250519063142.111219-1-shakeel.butt@linux.dev
Link: https://lkml.kernel.org/r/20250519063142.111219-2-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig    |    7 +++++++
 mm/memcontrol.c |    3 +++
 2 files changed, 10 insertions(+)

--- a/init/Kconfig~memcg-disable-kmem-charging-in-nmi-for-unsupported-arch
+++ a/init/Kconfig
@@ -1006,6 +1006,13 @@ config MEMCG
 	help
 	  Provides control over the memory footprint of tasks in a cgroup.
 
+config MEMCG_NMI_UNSAFE
+	bool
+	depends on MEMCG
+	depends on HAVE_NMI
+	depends on !ARCH_HAS_NMI_SAFE_THIS_CPU_OPS && !ARCH_HAVE_NMI_SAFE_CMPXCHG
+	default y
+
 config MEMCG_V1
 	bool "Legacy cgroup v1 memory controller"
 	depends on MEMCG
--- a/mm/memcontrol.c~memcg-disable-kmem-charging-in-nmi-for-unsupported-arch
+++ a/mm/memcontrol.c
@@ -2652,6 +2652,9 @@ __always_inline struct obj_cgroup *curre
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
 
+	if (IS_ENABLED(CONFIG_MEMCG_NMI_UNSAFE) && in_nmi())
+		return NULL;
+
 	if (in_task()) {
 		memcg = current->active_memcg;
 		if (unlikely(memcg))
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-memcg_rstat_updated-re-entrant-safe-against-irqs.patch
memcg-move-preempt-disable-to-callers-of-memcg_rstat_updated.patch
memcg-make-mod_memcg_state-re-entrant-safe-against-irqs.patch
memcg-make-count_memcg_events-re-entrant-safe-against-irqs.patch
memcg-make-__mod_memcg_lruvec_state-re-entrant-safe-against-irqs.patch
memcg-no-stock-lock-for-cpu-hot-unplug.patch
memcg-objcg-stock-trylock-without-irq-disabling.patch
memcg-disable-kmem-charging-in-nmi-for-unsupported-arch.patch
memcg-nmi-safe-memcg-stats-for-specific-archs.patch
memcg-add-nmi-safe-update-for-memcg_kmem.patch
memcg-nmi-safe-slab-stats-updates.patch
memcg-make-memcg_rstat_updated-nmi-safe.patch

