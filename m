Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3AE6FDC
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141598; cv=none; b=pi/5AT7WcEjITsVkTpsgwASEkQehTkf3vqHMpCUOr7IsfJRaGX4hy+CC8wco5Zx/kY6dHN9X22mPMLJR2b/klesvlktMqx2oASbOlW9cUjBBg631Pxy8s3Y4zD4UCzzaDMpD52Q70g2N0pb8L0ZSQimbWREPdXH0Osq9SAwc3xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141598; c=relaxed/simple;
	bh=skuZj99fi7AwCvA9gOO6nSyJeX9XgGY4g5ofiX69iJk=;
	h=Date:To:From:Subject:Message-Id; b=fY5f+459W8eDfC0aqxHIkAhT3NhXgkWgtnisBPdtsJ5Lf7xgf0s7hofi9jDxksuMa4naX7GVZcyI9RrnsyQWW5TrTheBbFxbuU1svXcptnicSKWvdNS0tm7BvpijwS0VBxJMA4LIZfm5ep8K3fTY30JLS9EqYIuT+gygKE97QDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vvho2p35; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vvho2p35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3113C4AF07;
	Fri,  5 Jul 2024 01:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141598;
	bh=skuZj99fi7AwCvA9gOO6nSyJeX9XgGY4g5ofiX69iJk=;
	h=Date:To:From:Subject:From;
	b=Vvho2p35S81FCE66ZJmwEOfNaYhWmEA2CUrYOek0yNGAeEK0TY9Oc+0tWvdB4NrEY
	 g9SkwlFX10SARvf7M+ndJLsCBizCIyGz3HGBgO+02WPIzCi4qXRc6UybuhthpEKSZ3
	 p3xpV8ycZaBnHIWRigrYMAWFZOembk5eERsMVKHU=
Date: Thu, 04 Jul 2024 18:06:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-introduce-memcontrol-v1c.patch removed from -mm tree
Message-Id: <20240705010637.F3113C4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: introduce memcontrol-v1.c
has been removed from the -mm tree.  Its filename was
     mm-memcg-introduce-memcontrol-v1c.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: introduce memcontrol-v1.c
Date: Mon, 24 Jun 2024 17:58:53 -0700

Patch series "mm: memcg: separate legacy cgroup v1 code and put under
config option", v2.

Cgroups v2 have been around for a while and many users have fully adopted
them, so they never use cgroups v1 features and functionality.  Yet they
have to "pay" for the cgroup v1 support anyway:
1) the kernel binary contains an unused cgroup v1 code,
2) some code paths have additional checks which are not needed,
3) some common structures like task_struct and mem_cgroup contain unused
   cgroup v1-specific members.

Cgroup v1's memory controller has a number of features that are not
supported by cgroup v2 and their implementation is pretty much self
contained.  Most notably, these features are: soft limit reclaim, oom
handling in userspace, complicated event notification system, charge
migration.  Cgroup v1-specific code in memcontrol.c is close to 4k lines
in size and it's intervened with generic and cgroup v2-specific code. 
It's a burden on developers and maintainers.

This patchset aims to solve these problems by:
1) moving cgroup v1-specific memcg code to the new mm/memcontrol-v1.c file,
2) putting definitions shared by memcontrol.c and memcontrol-v1.c into the
   mm/memcontrol-v1.h header,
3) introducing the CONFIG_MEMCG_V1 config option, turned off by default,
4) making memcontrol-v1.c to compile only if CONFIG_MEMCG_V1 is set.

If CONFIG_MEMCG_V1 is not set, cgroup v1 memory controller is still available
for mounting, however no memory-specific control knobs are present.

This patch (of 14):


This patch introduces the mm/memcontrol-v1.c source file which will be
used for all legacy (cgroup v1) memory cgroup code.  It also introduces
mm/memcontrol-v1.h to keep declarations shared between mm/memcontrol.c and
mm/memcontrol-v1.c.

As of now, let's compile it if CONFIG_MEMCG is set, similar to
mm/memcontrol.c.  Later on it can be switched to use a separate config
option, so that the legacy code won't be compiled if not required.

Link: https://lkml.kernel.org/r/20240625005906.106920-1-roman.gushchin@linux.dev
Link: https://lkml.kernel.org/r/20240625005906.106920-2-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Makefile        |    3 ++-
 mm/memcontrol-v1.c |    3 +++
 mm/memcontrol-v1.h |    7 +++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

--- a/mm/Makefile~mm-memcg-introduce-memcontrol-v1c
+++ a/mm/Makefile
@@ -26,6 +26,7 @@ KCOV_INSTRUMENT_page_alloc.o := n
 KCOV_INSTRUMENT_debug-pagealloc.o := n
 KCOV_INSTRUMENT_kmemleak.o := n
 KCOV_INSTRUMENT_memcontrol.o := n
+KCOV_INSTRUMENT_memcontrol-v1.o := n
 KCOV_INSTRUMENT_mmzone.o := n
 KCOV_INSTRUMENT_vmstat.o := n
 KCOV_INSTRUMENT_failslab.o := n
@@ -95,7 +96,7 @@ obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
-obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
+obj-$(CONFIG_MEMCG) += memcontrol.o memcontrol-v1.o vmpressure.o
 ifdef CONFIG_SWAP
 obj-$(CONFIG_MEMCG) += swap_cgroup.o
 endif
--- /dev/null
+++ a/mm/memcontrol-v1.c
@@ -0,0 +1,3 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include "memcontrol-v1.h"
--- /dev/null
+++ a/mm/memcontrol-v1.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef __MM_MEMCONTROL_V1_H
+#define __MM_MEMCONTROL_V1_H
+
+
+#endif	/* __MM_MEMCONTROL_V1_H */
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch
mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

