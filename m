Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E4A7E105
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 21:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758663046; cv=none; b=KU8GWUUQBYDW6dhhvn8JcM6RwRf6HIl+GFOxMqgfWk4JVRQ7sA4NZ5hMK/4nqvRBgvhwDhHB3ihbRWXb/AZbrBPHusvVvME5DHmMX4HwinEnkLJQv3gnmQs4vuAYM0lPslOY8Pj1NNMLxR1Dol8qO2iJ0CwcaLHMCy10mabtxAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758663046; c=relaxed/simple;
	bh=gYiiQKbjJvK470VTvs/ItpxyYwJCYGIDMMu1F+BsPtw=;
	h=Date:To:From:Subject:Message-Id; b=r3VTpWaLKz2VR9zNAD+exuTIVmceG9BQMXNpowEpkGIhDtuVDWfGLQTCxvzcOvBfSdjQQVXkTSEgAvmC288esrv20ZkYvRSNch7O1c18uMzJqpgOiriJ34eFhm2rNhf0A3kK7/xKgOWfgCjNZQUO/f/Qmp/pU5PpFRigVNHIN+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tpKAGeMP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tpKAGeMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4A1C4CEF5;
	Tue, 23 Sep 2025 21:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758663046;
	bh=gYiiQKbjJvK470VTvs/ItpxyYwJCYGIDMMu1F+BsPtw=;
	h=Date:To:From:Subject:From;
	b=tpKAGeMPMUQwOpGQ98L5msxpSRRqI8M8hGCg9qafaW7NDm6zXLZbQTLqPCeaU2av4
	 HIUTOpvK+IDosm2Gp5UuoWJJSDP6klqNY8LTkSJpR/h8Z88MNWzJo0zhknMXrYS1M0
	 WNUW88jeUJelbEM1NlsXNooOpH3gJJa5ayYq1txo=
Date: Tue, 23 Sep 2025 14:30:45 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fault-try-to-map-the-entire-file-folio-in-finish_fault.patch added to mm-unstable branch
Message-Id: <20250923213045.ED4A1C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/fault: try to map the entire file folio in finish_fault()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fault-try-to-map-the-entire-file-folio-in-finish_fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fault-try-to-map-the-entire-file-folio-in-finish_fault.patch

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
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm/fault: try to map the entire file folio in finish_fault()
Date: Tue, 23 Sep 2025 12:07:09 +0100

finish_fault() uses per-page fault for file folios.  This only occurs for
file folios smaller than PMD_SIZE.

The comment suggests that this approach prevents RSS inflation.  However,
it only prevents RSS accounting.  The folio is still mapped to the
process, and the fact that it is mapped by a single PTE does not affect
memory pressure.  Additionally, the kernel's ability to map large folios
as PMD if they are large enough does not support this argument.

When possible, map large folios in one shot.  This reduces the number of
minor page faults and allows for TLB coalescing.

Mapping large folios at once will allow the rmap code to mlock it on add,
as it will recognize that it is fully mapped and mlocking is safe.

Link: https://lkml.kernel.org/r/20250923110711.690639-5-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/memory.c~mm-fault-try-to-map-the-entire-file-folio-in-finish_fault
+++ a/mm/memory.c
@@ -5560,13 +5560,8 @@ fallback:
 
 	nr_pages = folio_nr_pages(folio);
 
-	/*
-	 * Using per-page fault to maintain the uffd semantics, and same
-	 * approach also applies to non shmem/tmpfs faults to avoid
-	 * inflating the RSS of the process.
-	 */
-	if (!vma_is_shmem(vma) || unlikely(userfaultfd_armed(vma)) ||
-	    unlikely(needs_fallback)) {
+	/* Using per-page fault to maintain the uffd semantics */
+	if (unlikely(userfaultfd_armed(vma)) || unlikely(needs_fallback)) {
 		nr_pages = 1;
 	} else if (nr_pages > 1) {
 		pgoff_t idx = folio_page_idx(folio, page);
_

Patches currently in -mm which might be from kas@kernel.org are

mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary.patch
mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one.patch
mm-rmap-mlock-large-folios-in-try_to_unmap_one.patch
mm-fault-try-to-map-the-entire-file-folio-in-finish_fault.patch
mm-filemap-map-entire-large-folio-faultaround.patch
mm-rmap-improve-mlock-tracking-for-large-folios.patch

