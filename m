Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291D84B04B7
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 18:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786559845; cv=none; b=WbO3IpULTuY6EEukNfPUAL7jPkSozy5GHYUwRaEvFvFvAhz4KTSuvfEyVgZLtQQ4Jgzjay3qjbsMZnxz314k0KfFVcfXi4z4Q10dpKrOQr5llhkXeoTGiW+lc2PHGmylRGcqPgxWksThyq5nSUx0VLUDZzNZBok/A7DLaQqaLgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786559845; c=relaxed/simple;
	bh=21WhS8xSuKf8erp2BaUIHK0AWaJGyD0sJXO4rkM4slA=;
	h=Date:To:From:Subject:Message-Id; b=YK7yqIkVjgM5m0Ibd9tQPfGPvk0T4MBaZkHXa7WrDRrAIYmFNf16MMLuRsnM0TBSiuvnr+zD7UlA/PxSmCpYMYGWImv7gJGfR+rnuJ+EBXvRsR1hKAIiiJfpI+zWEWIYiuw2EiqZNG6Nta012HOC4o0TaXyFbmv3bzTgKQAKfp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h5UE6BaA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h5UE6BaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D097E1F000E9;
	Wed, 12 Aug 2026 18:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786559843;
	bh=2jZYb04mIjBWF/XtY5lLC3s9pFuqWpz53Na+Ep3CwJ0=;
	h=Date:To:From:Subject;
	b=h5UE6BaASpp484jn/zFK2YXYYx5qdbIU/sbntLo0QB0hN4L42n9qre68KG1VZSPrP
	 9iBbcUkoWe7j7QF0MMQKj+FvM80m1gYWlwadszAiY1eQcburx31kLwLdQM+s5pHBSu
	 azfrf/7Gp0uLp1axzMh0egMzRX1V/sK/Gt3B0C14=
Date: Wed, 12 Aug 2026 11:37:23 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam@infradead.org,jannh@google.com,david@kernel.org,arnd@arndb.de,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-drivers-char-memc-to-mm-misc-memory-mapping-sections.patch added to mm-unstable branch
Message-Id: <20260812183723.D097E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add drivers/char/mem.c to mm misc, memory mapping sections
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-drivers-char-memc-to-mm-misc-memory-mapping-sections.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-drivers-char-memc-to-mm-misc-memory-mapping-sections.patch

This patch will later appear in the mm-unstable branch at
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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: MAINTAINERS: add drivers/char/mem.c to mm misc, memory mapping sections
Date: Wed, 12 Aug 2026 08:43:31 +0100

This file is a 'special' driver that implements /dev/zero and /dev/mem
among other things.

As such it makes sense for mm to be cc'd on mails and to have some say in
how things are changed there, so add it to the mm misc section.

Uniquely, it provides the 'old way' of obtaining an anonymous mapping -
MAP_PRIVATE of /dev/zero - so is directly tied to memory mapping,
therefore also add it to the memory mapping section.

scripts/get_maintainer.pl copes perfectly fine with files in multiple
sections so everything should work correctly.

Link: https://lore.kernel.org/20260812-add-drivers-mem-to-mm-maintainers-v1-1-6218b861f4c8@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-drivers-char-memc-to-mm-misc-memory-mapping-sections
+++ a/MAINTAINERS
@@ -17115,6 +17115,7 @@ F:	Documentation/ABI/testing/sysfs-kerne
 F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
 F:	Documentation/admin-guide/mm/
 F:	Documentation/mm/
+F:	drivers/char/mem.c
 F:	include/linux/cma.h
 F:	include/linux/dmapool.h
 F:	include/linux/ioremap.h
@@ -17319,6 +17320,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	drivers/char/mem.c
 F:	include/trace/events/mmap.h
 F:	fs/proc/task_mmu.c
 F:	fs/proc/task_nommu.c
_

Patches currently in -mm which might be from ljs@kernel.org are

x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-vma-introduce-vma-anon-page-offset-field-and-add-helpers.patch
mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch
mm-introduce-linear_anon_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-anon-index-if-appropriate.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-vma-fix-self-merge-check-in-copy_vma.patch
tools-testing-vma-add-tests-for-copy_vma-self-merge.patch
mm-propagate-vma-anonymous-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-pgoff-is-anonymous.patch
mm-clean-up-vma_address_end.patch
mm-huge_memory-update-remove_migration_pmd-to-accept-a-folio.patch
mm-migrate-calculate-large-folio-page-index-using-pfn.patch
mm-rmap-use-anon-pgoff-to-track-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-anon-pgoff.patch
tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch
maintainers-add-drivers-char-memc-to-mm-misc-memory-mapping-sections.patch

