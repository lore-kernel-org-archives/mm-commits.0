Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC5D39BFEC
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 17:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789753654; cv=none; b=dddWLWxHe/bfvcuEL7LY4w9QLNDk7nUs/Dfzf554qkfrV/xzO+i35HReXu4yovLgWTqiqSUehG7fwKkpt945LU0Op+3vOXtpcRTbX6w8Xpyi7viOKiFG2zpsWZk2xWIh4L2ELlXbGU+53Y/SK8eaPr8dypHc6IELntH5kyDeK/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789753654; c=relaxed/simple;
	bh=td0SClWtayk2ZlMhzVZyJSoNFoOSc2Mcyk2fYhCjj2I=;
	h=Date:To:From:Subject:Message-Id; b=vBCFpuy9tDSNZ9CHWm3VYr93DY3a25rS0I6vkqTP4Y29uorxwviVCL0j/e+IRpyHRbdk0f7XoWKUfK3l/PAAeAG1e+AD8K6+xwIYLs5mET9UGw7KHZkO5h4bbukB/uuz/cgwswXwTUCaXyuOJflfxofJs2rh5JDARBjjipHL9ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OlzW5aM0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OlzW5aM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD731F00898;
	Fri, 18 Sep 2026 17:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789753643;
	bh=eJyRNZETaEmzHHJS8Q/qW+ZOQFY/8C32QF3vn4In09s=;
	h=Date:To:From:Subject;
	b=OlzW5aM0z4XaC4Y8ncurZ9PU8f+EbxaksZw4QDJW1lbfBxU4FngMPtn6eAlaiSWLZ
	 mhvqaahIBs1p6b7Y6BcgQXar+z0bQocuDdCDvjLTOxTPwj5zqUEjDZEOkYb2GMkLsv
	 UW7ZzkJB7tv24cezP+mg073ayaz0auG5XQErLuog=
Date: Fri, 18 Sep 2026 10:47:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,rakie.kim@sk.com,mhocko@suse.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,gourry@gourry.net,byungchul@sk.com,apopple@nvidia.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-move-memory-tiering-under-memory-management-numa-placement.patch added to mm-hotfixes-unstable branch
Message-Id: <20260918174723.9DD731F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: move memory tiering under MEMORY MANAGEMENT - NUMA PLACEMENT
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-move-memory-tiering-under-memory-management-numa-placement.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-move-memory-tiering-under-memory-management-numa-placement.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: MAINTAINERS: move memory tiering under MEMORY MANAGEMENT - NUMA PLACEMENT
Date: Fri, 18 Sep 2026 18:34:25 +0200

NUMA PLACEMENT is a better place for memory tiering.

My best guess is that existing MISC reviewers are not that interested in
memory tiering, so don't carry any over.

Link: https://lore.kernel.org/20260918-maintainers-mempolicy-v1-2-9a94cac6d135@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/MAINTAINERS~maintainers-move-memory-tiering-under-memory-management-numa-placement
+++ a/MAINTAINERS
@@ -17262,7 +17262,6 @@ W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	Documentation/ABI/testing/sysfs-kernel-mm
 F:	Documentation/ABI/testing/sysfs-kernel-mm-cma
-F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
 F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
 F:	Documentation/admin-guide/mm/
 F:	Documentation/mm/
@@ -17270,7 +17269,6 @@ F:	drivers/char/mem.c
 F:	include/linux/cma.h
 F:	include/linux/dmapool.h
 F:	include/linux/ioremap.h
-F:	include/linux/memory-tiers.h
 F:	include/linux/page_idle.h
 F:	mm/backing-dev.c
 F:	mm/cma.c
@@ -17282,7 +17280,6 @@ F:	mm/early_ioremap.c
 F:	mm/fadvise.c
 F:	mm/ioremap.c
 F:	mm/mapping_dirty_helpers.c
-F:	mm/memory-tiers.c
 F:	mm/page_idle.c
 F:	mm/pgalloc-track.h
 F:	mm/process_vm_access.c
@@ -17311,10 +17308,13 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
 F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
 F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
+F:	include/linux/memory-tiers.h
 F:	include/linux/mempolicy.h
 F:	include/uapi/linux/mempolicy.h
+F:	mm/memory-tiers.c
 F:	mm/mempolicy.c
 
 MEMORY MANAGEMENT - OOM KILLER
_

Patches currently in -mm which might be from david@kernel.org are

maintainers-split-up-memory-management-memory-policy-and-migration.patch
maintainers-move-memory-tiering-under-memory-management-numa-placement.patch
maintainers-make-gregory-a-co-maintainer-of-memory-management-numa-placement.patch
selftests-mm-khugepaged-remove-str_dup-usage.patch

