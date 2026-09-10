Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AEE381EA4
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 23:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789082830; cv=none; b=AWMrefGC89QNbpXZiUlkz7794rcSBMnXsu2KhAiFCvpQZdfYzdlegeAwBzVQuVbZZhJb6will/sdh07sNKbkzZV/xDxUPWbpF7xzaV6jLZ8GAcAp0nHCcJXPDd4EFePome1tC4Z18V6FvwiF4yk6PNuZNouJXWTDkCBKgiOJtqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789082830; c=relaxed/simple;
	bh=yTUBbKbECUtITOVl4fwF6a0nBM2XBRe7igLwz2uO1ng=;
	h=Date:To:From:Subject:Message-Id; b=m6+8RELQthNKeWTdRUyQ9ymXq4FGL7Amg0HuZ72mjtFWWMRkHNO2IJN0rONkiZjkmhhiNOO5Y+Rf+/E5E8tqfuFKINV7qxU29w68Vu+hQUjKc3a3ajfYJuLiHes89uBs1ZjpceKOg+8KctRBnEBl5uCzb3M5rEc8JZLIkKgisX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zsLAmEHl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zsLAmEHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D46A1F000FF;
	Thu, 10 Sep 2026 23:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789082828;
	bh=wKWnqVof2C5/HVeeoLvg8R75blypeoOXOfn9A/k4ztc=;
	h=Date:To:From:Subject;
	b=zsLAmEHlf7Fjx8S8Bx+kq7yehPEwUg/TE79Ne6rddRpZUp37ojDl4phvXCfJAAMk6
	 h2WYHMKLFzr6YXzQGlLDW38q9RMX33cysdWZOoTE4iqLe/tDou5vbTKJyEz7Fewtrn
	 mkRo/kxvRHnKBXLn3OHGVXLxq1ruW5WDhc8SHfr0=
Date: Thu, 10 Sep 2026 16:27:07 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,shy828301@gmail.com,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,hughd@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,jthoughton@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-never-install-pmds-in-uffd-minor-registered-vmas.patch added to mm-new branch
Message-Id: <20260910232708.4D46A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: never install PMDs in uffd-minor-registered VMAs
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-never-install-pmds-in-uffd-minor-registered-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-never-install-pmds-in-uffd-minor-registered-vmas.patch

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
Subject: mm/khugepaged: never install PMDs in uffd-minor-registered VMAs
Date: Thu, 10 Sep 2026 02:34:10 +0000

Userfaultfd minor faults provides userspace with the ability to manually
install PTEs with UFFDIO_CONTINUE.  Right now, MADV_COLLAPSE can map holes
in the VMA when a naturally-aligned THP is present.  This is not true for
khugepaged collapse: the PTEs will be retracted, but a PMD will not be
installed.

When MADV_COLLAPSE installs a PMD that mapped holes in the VMA, userspace
is likely to expect UFFDIO_CONTINUE to succeed on the should-be holes. 
UFFDIO_CONTINUE will fail and return EEXIST.

This is not inherently a problem, as MADV_COLLAPSE is an explicit
userspace action.  But, especially because MADV_COLLAPSE can be invoked by
an external process via process_madvise(), a rogue caller could break a
userfaultfd-minor resolver thread.  If khugepaged is later updated to
install PMDs for khugepaged collapsing, that would be a genuine problem.

Userspace cannot generally use MADV_COLLAPSE to resolve userfault minor
faults, as MADV_COLLAPSE will only resolve such faults if a
naturally-aligned THP is present.

The naturally-aligned THP case is the only case where this quirk exists. 
Collapsing otherwise requires all PTEs to be present for
userfaultfd-registered VMAs (i.e., max none PTEs is 0), which is correct. 
This check is essentially bypassed for naturally-aligned THPs.

khugepaged doesn't actually install PMDs, so it is impossible for the
kernel to silently install mappings that userspace didn't ask for. 
Therefore this patch does not need to be backported.

Link: https://lore.kernel.org/20260910023411.514987-1-jthoughton@google.com
Suggested-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: James Houghton <jthoughton@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-never-install-pmds-in-uffd-minor-registered-vmas
+++ a/mm/khugepaged.c
@@ -1834,6 +1834,13 @@ static enum scan_result try_collapse_pte
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

mm-khugepaged-never-install-pmds-in-uffd-minor-registered-vmas.patch
mm-selftests-adjust-the-madv_collapse-uffd-minor-selftests.patch

