Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2D2149DF1;
	Sat, 29 Aug 2026 00:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787963653; cv=none; b=HP4ibvoUMdfILmLWyhCKqA1hL/yEjVVaiN6UNzx/HiyqSrRhRy19Qze2RlY12CDIBekSq3D3JTOVIyVR7fyeMuWFfyuzh84W304Lzp1udPBc3xFV04Uh8Jf4OeU3n6/4OWIdkyBZCUbkAa5LTh1O2GDfolmjlEvnkJPkpbW2GWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787963653; c=relaxed/simple;
	bh=s9wOJv5dJWhnxMAHkHNRmdEP9raMWIH6tvOa9iEKluw=;
	h=Date:To:From:Subject:Message-Id; b=GuaAPytTIziSkWpy4+ijJGWIrwQgW/dbJrzYNLBMyg/IPbbQVS7COecWT7IgfNW7SYD+mkPzpH5Mn/ViLv2+SOQiG9O7s8iMW6/E5nHqID+ixxHmIqV2lSUrd4xBHM5FTGFE+4x8es9HdO/MAsngteJMb9bQ7zvLwUbm9hZkulI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LOXSAE28; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LOXSAE28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014151F000E9;
	Sat, 29 Aug 2026 00:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787963652;
	bh=24Fn+Nqnz50wFBBOOvyTcomEshFsKwXbErgU6etUu2I=;
	h=Date:To:From:Subject;
	b=LOXSAE28qSlJ6SX7ZLCOqzbnn752QOKgh3UiFKbXR9fdb/4lXnM+M4GLNjOCf21DW
	 0NSbl2aos3H/8BnDv5Tk8HhwwD6MiIZ7tvuHoA51n0Mnmw2wzqBtXF81BeaK0akd4F
	 Ph2sTXAPg6ZQKak17tRNoJZgVCeKxrYCGHPghNo4=
Date: Fri, 28 Aug 2026 17:34:11 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,stable@vger.kernel.org,shy828301@gmail.com,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,hughd@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,jthoughton@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-dont-install-pmds-in-uffd-minor-registered-vmas.patch added to mm-new branch
Message-Id: <20260829003412.014151F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: don't install PMDs in uffd-minor-registered VMAs
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-dont-install-pmds-in-uffd-minor-registered-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-dont-install-pmds-in-uffd-minor-registered-vmas.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: James Houghton <jthoughton@google.com>
Subject: mm/khugepaged: don't install PMDs in uffd-minor-registered VMAs
Date: Fri, 28 Aug 2026 22:26:40 +0000

Userfaultfd minor faults provides userspace with the ability to manually
install PTEs with UFFDIO_CONTINUE.  Right now, khugepaged collapse can map
holes in the VMA when a naturally-aligned THP is present without explicit
action from userspace.

This is a problem, as it bypasses userfaultfd minor faults that userspace
is expecting to handle.

If userspace implements post-copy live migration using userfaultfd minor
faults, this situation is currently possible:
1. The VMA for guest memory is userfaultfd-minor-registered and nothing
   is mapped in the page tables.
2. A stale copy of a page is present in a naturally-aligned THP (from
   pre-copy live migration).
3. khugepaged collapses the mapping of the THP, installs a PMD.
4. The VM now has access to the stale contents => VM is broken.
5. After installing the correct contents, userspace attempts to map the
   page with UFFDIO_CONTINUE; it gets EEXIST, indicating that something
   unexpectedly mapped the page.

The naturally-aligned THP case is the only case where this is a problem. 
khugepaged otherwise requires all PTEs to be present for
userfaultfd-registered VMAs (i.e., max none PTEs is 0), which is correct. 
This check is essentially bypassed for naturally-aligned THPs.

No changes are needed for file_backed_vma_is_retractable(), as zapping
PTEs is safe.  Userspace must already handle cases where PTEs are zapped
without explicit action (e.g.  due to reclaim).

Link: https://lore.kernel.org/20260828222640.1638457-1-jthoughton@google.com
Fixes: 58ac9a8993a1 ("mm/khugepaged: attempt to map file/shmem-backed pte-mapped THPs by pmds")
Signed-off-by: James Houghton <jthoughton@google.com>
Suggested-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org> # 6.1
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-dont-install-pmds-in-uffd-minor-registered-vmas
+++ a/mm/khugepaged.c
@@ -1905,6 +1905,13 @@ static enum scan_result try_collapse_pte
 	if (userfaultfd_protected(vma))
 		return SCAN_PTE_UFFD;
 
+	/*
+	 * Userfaultfd-minor-registered VMAs should not be collapsed, as
+	 * userspace is expecting to explicitly install PTEs.
+	 */
+	if (userfaultfd_minor(vma))
+		return SCAN_PTE_UFFD;
+
 	folio = filemap_lock_folio(vma->vm_file->f_mapping,
 			       linear_page_index(vma, haddr));
 	if (IS_ERR(folio))
_

Patches currently in -mm which might be from jthoughton@google.com are

mm-khugepaged-dont-install-pmds-in-uffd-minor-registered-vmas.patch

