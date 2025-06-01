Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B9B2DCBE1
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756823; cv=none; b=dsQrHEl1l2U8l+FAmQz7saXDhwRxZYaYTzWE33w7sGHBPc8/M107Meo3AkpBPSN0Vl7CDV7YCiDHmw1kntVxHtBlld6+pJVHzxb8w4yMRRkfC1B54EJJI/mIhcal0RAj+cQC3wFiJqCmDU3kg459WFubrgNeSHjS6eL1FBtmOJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756823; c=relaxed/simple;
	bh=fcbsNx0IZPOFI5YPdzGWKyrdyS+gG2N6agOW+a3BA4M=;
	h=Date:To:From:Subject:Message-Id; b=ZjZ/OAyr0my5M0B9YQJ32NRNo6JEiUKOCW+y+kdpByUlCnIztRcxceQSZbu7hw1oeRgTXDOSv4fmeqTl7PY+ukcFa8MvqhMuHgY+XkkQBGwr+j/mIA1Z+pFToLqv+VVzWzqWOvt1y/OwNgeoutkkb+FHG09k+xVZkufy1cchWQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hU/YvO01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hU/YvO01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520BDC4CEED;
	Sun,  1 Jun 2025 05:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756822;
	bh=fcbsNx0IZPOFI5YPdzGWKyrdyS+gG2N6agOW+a3BA4M=;
	h=Date:To:From:Subject:From;
	b=hU/YvO01AcM8rCf+rK8I3OZgBz4e/abJIjNUFKrewAs+NXb76V4bHd19NYXBaAFgI
	 iSJPQaecXv2DBGQq0LznwuiPCBZLATnk6RB0Ub/8IH7AC4i00kgp4ZGJscHThE+050
	 GCzTi2DRnW14bDmpOPiISCC2XwGM254phNpIASIc=
Date: Sat, 31 May 2025 22:47:01 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mhocko@kernel.org,mathieu.desnoyers@efficios.com,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-disable-kmem-charging-in-nmi-for-unsupported-arch.patch removed from -mm tree
Message-Id: <20250601054702.520BDC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: disable kmem charging in nmi for unsupported arch
has been removed from the -mm tree.  Its filename was
     memcg-disable-kmem-charging-in-nmi-for-unsupported-arch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2650,6 +2650,9 @@ __always_inline struct obj_cgroup *curre
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


