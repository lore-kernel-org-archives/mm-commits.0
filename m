Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D02345BE3
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 20:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719348610; cv=none; b=bvF+cDDlURNBZ5Mt6X0P9W+HWp2EwVCygj3V+2+T5765y+Rj4Ue1oGHjH2LUPiEXB4EckX6iBFGrBCh3TsisC93A+HJ+fRsVR0KE3ZLgf61mkufej6E7nkdB0Q8YIeYMrTiUoBbfFS6KXQjRr8oUH3hZN7xJEAfeqbkmzmwsktI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719348610; c=relaxed/simple;
	bh=SFowsx6x2IntD0vNI9f8ejY/L35rj5pHBTfdNPY7J/k=;
	h=Date:To:From:Subject:Message-Id; b=A2yO181mwBzJS1q60EhIsD8c+jCPyRduC+MhzJMBDI0FRUuDT2nHmJzO5qHTMpW4WdfJPSPg0j9N38cFqasGFP7UyHcrmYFiuvwp8xPYw1qxV3GiMVG7l0oVHCaizrcm9GLXkhUdMGTTLPQ6oQKTomMCI/LlTEUP9cXTXw7nvgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aKbn7GdO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aKbn7GdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB518C32781;
	Tue, 25 Jun 2024 20:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719348609;
	bh=SFowsx6x2IntD0vNI9f8ejY/L35rj5pHBTfdNPY7J/k=;
	h=Date:To:From:Subject:From;
	b=aKbn7GdOd3ugUtZ5b2GJoFiifNokISyDPKV/HpuAMDulazuhf/kLDLx+XaXpqtXEE
	 L+/glVoN55z4fxG5AOpPvtGNcYsdNk2fi252G0U/Jgsc+rdkzy2/d0cvtOtDftSmIo
	 x3qTdIitmasXPnod1FsWYcnEEFca2qy+aVDyLNWI=
Date: Tue, 25 Jun 2024 13:50:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-introduce-memcontrol-v1c.patch added to mm-unstable branch
Message-Id: <20240625205009.AB518C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: introduce memcontrol-v1.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-introduce-memcontrol-v1c.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-introduce-memcontrol-v1c.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-memcg-introduce-memcontrol-v1c.patch
mm-memcg-move-soft-limit-reclaim-code-to-memcontrol-v1c.patch
mm-memcg-rename-soft-limit-reclaim-related-functions.patch
mm-memcg-move-charge-migration-code-to-memcontrol-v1c.patch
mm-memcg-rename-charge-move-related-functions.patch
mm-memcg-move-legacy-memcg-event-code-into-memcontrol-v1c.patch
mm-memcg-rename-memcg_check_events.patch
mm-memcg-move-cgroup-v1-oom-handling-code-into-memcontrol-v1c.patch
mm-memcg-rename-memcg_oom_recover.patch
mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c.patch
mm-memcg-make-memcg1_update_tree-static.patch
mm-memcg-group-cgroup-v1-memcg-related-declarations.patch
mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option.patch
maintainers-add-mm-memcontrol-v1c-h-to-the-list-of-maintained-files.patch

