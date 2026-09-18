Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34EC37BE71
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 17:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789753654; cv=none; b=OcCaoi7dY+UVIxXUajvgquSBoOwSacAlMBQcmo4cUlYSz8gXqKISRuMn0Zd3FsVCFf9Mwn0/Cjwpp8Eebb42r+eHoCb+j2IIvbIWtCQrOsjEdjisYKZ8Q4GrLYC/Jt7QxSUpaQmHHbYHFG3SEmRITRWuIVyLfqokNTQ22YPx+9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789753654; c=relaxed/simple;
	bh=JqWoZkUHD58ymXEHZC93/EN8N6yiV3TrnNp+Q9Il82Y=;
	h=Date:To:From:Subject:Message-Id; b=FcN1UR1ukd2Smm70D/uhfFCtWzX7XlScRyaWnd0wommp9APMeHys2CUOgAvux0wjMCnPam+rsrXRKGRVRQ5LJYlLhm/RAPd3EhBr3KpGi+d0+4o5/vvF/FIJeMDrK7V/9EVBH59dHcwDJmMWzrruu9/92tG8E+TU666J5TgOLLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VGT1QMlO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VGT1QMlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B591F000FF;
	Fri, 18 Sep 2026 17:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789753641;
	bh=MenqbVTAy2zmO+4R/m5TzR/BpkYFq12L8LcbGYiaMSc=;
	h=Date:To:From:Subject;
	b=VGT1QMlOifhIwGcV7uZl3IqkVWUKZIUFBqOllIdpBcAofViInkHogct1YOAsLa6nO
	 3c6Uf72NHjwIorrJ1iCCWtr1+THlYkBvFWIp38/dItXcJ/VwWC0K/e9yhkEQub8YKN
	 omJV/KpL6MjxUPH2gwaZ6b7R624VPZuTA5BOj19Q=
Date: Fri, 18 Sep 2026 10:47:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,rakie.kim@sk.com,mhocko@suse.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,gourry@gourry.net,byungchul@sk.com,apopple@nvidia.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-split-up-memory-management-memory-policy-and-migration.patch added to mm-hotfixes-unstable branch
Message-Id: <20260918174721.86B591F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: split up MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-split-up-memory-management-memory-policy-and-migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-split-up-memory-management-memory-policy-and-migration.patch

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
Subject: MAINTAINERS: split up MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
Date: Fri, 18 Sep 2026 18:34:24 +0200

Patch series "MAINTAINERS: rework MEMORY MANAGEMENT - MEMORY POLICY".

Let's rework MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION.

As I can use some maintenance help in that area, add Gregory as a new
co-maintainer for the split out MEMORY MANAGEMENT - NUMA PLACEMENT
section.


This patch (of 3):

Let's split it up into MIGRATION and NUMA PLACEMENT.  The latter is a
better fitting description for mempolicy.c.

Make a best guess about which pieces existing reviewers are interested in.
Move the split sections to keep alphabetical order.

Link: https://lore.kernel.org/20260918-maintainers-mempolicy-v1-1-9a94cac6d135@kernel.org
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

 MAINTAINERS |   62 +++++++++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 25 deletions(-)

--- a/MAINTAINERS~maintainers-split-up-memory-management-memory-policy-and-migration
+++ a/MAINTAINERS
@@ -17206,31 +17206,6 @@ F:	include/trace/events/ksm.h
 F:	mm/ksm.c
 F:	mm/mm_slot.h
 
-MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
-M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@kernel.org>
-R:	Zi Yan <ziy@nvidia.com>
-R:	Matthew Brost <matthew.brost@intel.com>
-R:	Joshua Hahn <joshua.hahnjy@gmail.com>
-R:	Rakie Kim <rakie.kim@sk.com>
-R:	Byungchul Park <byungchul@sk.com>
-R:	Gregory Price <gourry@gourry.net>
-R:	Ying Huang <ying.huang@linux.alibaba.com>
-R:	Alistair Popple <apopple@nvidia.com>
-L:	linux-mm@kvack.org
-S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
-F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
-F:	include/linux/mempolicy.h
-F:	include/uapi/linux/mempolicy.h
-F:	include/linux/migrate.h
-F:	include/linux/migrate_mode.h
-F:	mm/mempolicy.c
-F:	mm/migrate.c
-F:	mm/migrate_device.c
-
 MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Kairui Song <kasong@tencent.com>
@@ -17253,6 +17228,25 @@ F:	include/linux/mmzone.h
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
+MEMORY MANAGEMENT - MIGRATION
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@kernel.org>
+R:	Zi Yan <ziy@nvidia.com>
+R:	Matthew Brost <matthew.brost@intel.com>
+R:	Joshua Hahn <joshua.hahnjy@gmail.com>
+R:	Byungchul Park <byungchul@sk.com>
+R:	Gregory Price <gourry@gourry.net>
+R:	Ying Huang <ying.huang@linux.alibaba.com>
+R:	Alistair Popple <apopple@nvidia.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/linux/migrate.h
+F:	include/linux/migrate_mode.h
+F:	mm/migrate.c
+F:	mm/migrate_device.c
+
 MEMORY MANAGEMENT - MISC
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
@@ -17305,6 +17299,24 @@ F:	mm/numa.c
 F:	mm/numa_emulation.c
 F:	mm/numa_memblks.c
 
+MEMORY MANAGEMENT - NUMA PLACEMENT
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@kernel.org>
+R:	Zi Yan <ziy@nvidia.com>
+R:	Joshua Hahn <joshua.hahnjy@gmail.com>
+R:	Rakie Kim <rakie.kim@sk.com>
+R:	Gregory Price <gourry@gourry.net>
+R:	Ying Huang <ying.huang@linux.alibaba.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
+F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
+F:	include/linux/mempolicy.h
+F:	include/uapi/linux/mempolicy.h
+F:	mm/mempolicy.c
+
 MEMORY MANAGEMENT - OOM KILLER
 M:	Michal Hocko <mhocko@suse.com>
 R:	David Rientjes <rientjes@google.com>
_

Patches currently in -mm which might be from david@kernel.org are

maintainers-split-up-memory-management-memory-policy-and-migration.patch
maintainers-move-memory-tiering-under-memory-management-numa-placement.patch
maintainers-make-gregory-a-co-maintainer-of-memory-management-numa-placement.patch
selftests-mm-khugepaged-remove-str_dup-usage.patch

