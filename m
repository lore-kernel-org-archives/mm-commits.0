Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C803F4B1E45
	for <mm-commits@vger.kernel.org>; Sat, 17 May 2025 15:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747495915; cv=none; b=Hy6uD559sgOD1HLISPJ1K7zmvmMimCmswaN8xIscTCMa+cch/oEggtwwPqIYqOkHyLFsTWYuvxVD01Cfye31z98E0uOx2AMjziau8Nn2hpzxwG/59NT0JYLic9C7h1bixwJJkqQ5IKsKCmUQ+/Q7Ccm2RwyJ0xJGCtOHPmma3jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747495915; c=relaxed/simple;
	bh=P7e67ykSSarHATelASyJE9FFa1A4s8B+OTJ7ef10Jjo=;
	h=Date:To:From:Subject:Message-Id; b=SDA0qZPqb8rw0YuwiTCBihcSKTTPdJ3a2dP4cahdw2KXHiQ7VmILjuvd6QakbCApQqFrX8/w0hDCKFTriipdefPLEK9l1EcoQWjnWra+yZEdC3E012Dq0leTOIghHVnDheoj8VTkLILRyqQsM9zpOLCXoGq9/N8nq0WE7IKV1lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TDumCndo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TDumCndo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFF8C4CEE3;
	Sat, 17 May 2025 15:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747495915;
	bh=P7e67ykSSarHATelASyJE9FFa1A4s8B+OTJ7ef10Jjo=;
	h=Date:To:From:Subject:From;
	b=TDumCndoG6aCc8Yn9BPGBftckn0h1N6EWq06YA/FOpvChLchIvyPbHbARYwKi9zFU
	 sKjq+S8EcL16h2oVfORHgaDhbdImptqTfw12cRXiEiAW0leiJvU+/8JOmH+Nf925vY
	 N5y6sykkrK0x/I0jh7+OLRDzdYbx1/1+6yz2IK4k=
Date: Sat, 17 May 2025 08:31:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,apopple@nvidia.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-mm-memory-policy-section.patch added to mm-hotfixes-unstable branch
Message-Id: <20250517153155.0DFF8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add mm memory policy section
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-mm-memory-policy-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-mm-memory-policy-section.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add mm memory policy section
Date: Thu, 15 May 2025 20:13:58 +0100

As part of the ongoing efforts to sub-divide memory management
maintainership and reviewership, establish a section for memory policy and
migration and add appropriate maintainers and reviewers.

Link: https://lkml.kernel.org/r/20250515191358.205684-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Rakie Kim <rakie.kim@sk.com>
Acked-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Huang Ying <ying.huang@linux.alibaba.com>
Acked-by: Byungchul Park <byungchul@sk.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/MAINTAINERS~maintainers-add-mm-memory-policy-section
+++ a/MAINTAINERS
@@ -15577,6 +15577,25 @@ F:	include/linux/ksm.h
 F:	include/trace/events/ksm.h
 F:	mm/ksm.c
 
+MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@redhat.com>
+R:	Zi Yan <ziy@nvidia.com>
+R:	Matthew Brost <matthew.brost@intel.com>
+R:	Joshua Hahn <joshua.hahnjy@gmail.com>
+R:	Rakie Kim <rakie.kim@sk.com>
+R:	Byungchul Park <byungchul@sk.com>
+R:	Gregory Price <gourry@gourry.net>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/linux/mempolicy.h
+F:	include/linux/migrate.h
+F:	mm/mempolicy.c
+F:	mm/migrate.c
+F:	mm/migrate_device.c
+
 MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-update-page-allocator-section.patch
maintainers-add-mm-reclaim-section.patch
maintainers-add-mm-ksm-section.patch
maintainers-add-mm-memory-policy-section.patch
maintainers-add-mm-memory-policy-section-fix.patch
maintainers-add-kernel-forkc-to-relevant-sections.patch
mm-remove-warn_on_once-in-file_has_valid_mmap_hooks.patch
memcg-memcg_rstat_updated-re-entrant-safe-against-irqs-fix.patch

