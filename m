Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745B01FCFE7
	for <mm-commits@vger.kernel.org>; Wed, 23 Apr 2025 21:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745445060; cv=none; b=M+rwqDJ6H2DcNh72hmAiP+B+k+keEqitEdeHSKLIT/3zcZS7qm+Sdlv3+dY912Rj29VmiRBP+qU7yBcGK/mH23dEtOgiInLUs1PcXDRgzHAM9A0ZOymWDxl7udntYW3poPLpIKwQM1jWrNWRGsXZvudHSX4wHJN3x1utNVd7K6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745445060; c=relaxed/simple;
	bh=CC1cPgzacmbtaOi4G5c6QrKsFeBzUxQTzkV0LDUvC3U=;
	h=Date:To:From:Subject:Message-Id; b=hg5v6e1ieOlB7Gy5NP/0ysezsCGPJ5sSBjz6l4trqVaG4eN3i/W9sB5oVbbWue7PKVpIzlBEHmoQPbdSHfrgqv1I2WE9oJDVnecQJkBlXO7k34sKE6eGWmoIGYaRjtJ2e0NV2dSbqtn8j5okA1TL+j3wF/ViMhprUDZWRk4i064=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QRxAQga6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QRxAQga6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AD8C4CEE2;
	Wed, 23 Apr 2025 21:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745445060;
	bh=CC1cPgzacmbtaOi4G5c6QrKsFeBzUxQTzkV0LDUvC3U=;
	h=Date:To:From:Subject:From;
	b=QRxAQga6DS+rhbxl2Qu/64uAcl+Y9DUWmk3yHLqRLsPh4IsIqsfFnMLRrrlT1DNDE
	 rn25P3xKCAK2nbMjjqV4Z0Rl/i0GOEOlOnz8voZw0DRJvtpYbJLw03/7MIJHuuqVMa
	 MRVcCFHn8nxCyh6vvYZqMB4E8SbihJ5k8VsnInwk=
Date: Wed, 23 Apr 2025 14:50:59 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,Liam.Howlett@oracle.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-core-mm-section.patch added to mm-hotfixes-unstable branch
Message-Id: <20250423215100.31AD8C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add core mm section
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-core-mm-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-core-mm-section.patch

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
Subject: MAINTAINERS: add core mm section
Date: Wed, 23 Apr 2025 13:30:42 +0100

In furtherance of ongoing efforts to ensure people are aware of who
de-facto maintains/has an interest in specific parts of mm, as well trying
to avoid get_maintainers.pl listing only Andrew and the mailing list for
mm files - establish a 'core' memory management section establishing David
as co-maintainer alongside Andrew (thanks David for volunteering!) along
with a number of relevant reviewers.

We try to keep things as fine-grained as possible, so we place only
obviously 'general' mm things here.  For files which are specific to a
particular part of mm, we prefer new entries.

Link: https://lkml.kernel.org/r/20250423123042.59082-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/MAINTAINERS~maintainers-add-core-mm-section
+++ a/MAINTAINERS
@@ -15480,14 +15480,11 @@ F:	Documentation/mm/
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
 F:	include/linux/memfd.h
-F:	include/linux/memory.h
 F:	include/linux/memory_hotplug.h
 F:	include/linux/memory-tiers.h
 F:	include/linux/mempolicy.h
 F:	include/linux/mempool.h
 F:	include/linux/memremap.h
-F:	include/linux/mm.h
-F:	include/linux/mm_*.h
 F:	include/linux/mmzone.h
 F:	include/linux/mmu_notifier.h
 F:	include/linux/pagewalk.h
@@ -15497,6 +15494,31 @@ F:	tools/mm/
 F:	tools/testing/selftests/mm/
 N:	include/linux/page[-_]*
 
+MEMORY MANAGEMENT - CORE
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@redhat.com>
+R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Mike Rapoport <rppt@kernel.org>
+R:	Suren Baghdasaryan <surenb@google.com>
+R:	Michal Hocko <mhocko@suse.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/linux/memory.h
+F:	include/linux/mm.h
+F:	include/linux/mm_*.h
+F:	include/linux/mmdebug.h
+F:	include/linux/pagewalk.h
+F:	mm/Kconfig
+F:	mm/debug.c
+F:	mm/init-mm.c
+F:	mm/memory.c
+F:	mm/pagewalk.c
+F:	mm/util.c
+
 MEMORY MANAGEMENT - EXECMEM
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-reverse-mapping-section.patch
maintainers-add-core-mm-section.patch
mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch
mm-move-mmap-vma-locking-logic-into-specific-files.patch

