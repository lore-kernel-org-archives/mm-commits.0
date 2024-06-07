Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE36615380A
	for <mm-commits@vger.kernel.org>; Fri,  7 Jun 2024 20:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717793957; cv=none; b=kwq7K5NFwGn/tFgAP5+Rj5dOa+C7hBTcl1re4Xnd0yUrNRFnpdWpsYLe5zC2E+FsUyd4KWr9/VvEj0iCkfX3R7oknCGVTF4HcQXOJVCtIxF6k3DhMGOQp+DrO3g3K9W7Wgu6ox8xdUgPWj5i4kbldo9zDWVHo3rdOfCwGgvjRN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717793957; c=relaxed/simple;
	bh=qitr+rxbJzT3iVsNB71M/j9JlQcx9zL3jRCj6AcGm6Y=;
	h=Date:To:From:Subject:Message-Id; b=qk78duHU/QzdShuewz/a91Rdo8FKMqsuiwCqXM1HN2bBnnd3J04T1so6q8TN3RECmzUHW4hN/xO6psW8kHop3V9gPe1Qbp62ZQ842yPM7TsDEejEkMi1nSuh+8KXdcgiMPREmAe4CMH4SkVAZljpS4A9glXWdfT0mkEon/byj8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qg7+7huM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qg7+7huM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A168C32781;
	Fri,  7 Jun 2024 20:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717793956;
	bh=qitr+rxbJzT3iVsNB71M/j9JlQcx9zL3jRCj6AcGm6Y=;
	h=Date:To:From:Subject:From;
	b=qg7+7huMXWqKKNEc6QWKstPqzQ6Gr45JMoSQZIaOSyZBquyEnvrTfGhXvhkNQG15A
	 QG+/SSsNWqlKiz+MFhJxkft/CR/+5oGb79P47c44BxqyGNpYeWi7kHyUceeaGFTAJX
	 JS8crOTYJzXh3McgBFJWsEButbsgMnp2G3K6ZaLo=
Date: Fri, 07 Jun 2024 13:59:15 -0700
To: mm-commits@vger.kernel.org,kirill.shutemov@linux.intel.com,ioworker0@gmail.com,corbet@lwn.net,adobriyan@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-indicate-pm_file-for-pmd-mapped-file-thp.patch added to mm-unstable branch
Message-Id: <20240607205916.4A168C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: indicate PM_FILE for PMD-mapped file THP
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-indicate-pm_file-for-pmd-mapped-file-thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-indicate-pm_file-for-pmd-mapped-file-thp.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: fs/proc/task_mmu: indicate PM_FILE for PMD-mapped file THP
Date: Fri, 7 Jun 2024 14:23:52 +0200

Patch series "fs/proc: move page_mapcount() to fs/proc/internal.h".

With all other page_mapcount() users in the tree gone, move
page_mapcount() to fs/proc/internal.h, rename it and extend the
documentation to prevent future (ab)use.

... of course, I find some issues while working on that code that I sort
first ;)

We'll now only end up calling page_mapcount() [now
folio_precise_page_mapcount()] on pages mapped via present page table
entries.  Except for /proc/kpagecount, that still does questionable
things, but we'll leave that legacy interface as is for now.

Did a quick sanity check.  Likely we would want some better selfestest for
/proc/$/pagemap + smaps.  I'll see if I can find some time to write some
more.


This patch (of 6):

Looks like we never taught pagemap_pmd_range() about the existence of
PMD-mapped file THPs.  Seems to date back to the times when we first added
support for non-anon THPs in the form of shmem THP.

Link: https://lkml.kernel.org/r/20240607122357.115423-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240607122357.115423-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Lance Yang <ioworker0@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-indicate-pm_file-for-pmd-mapped-file-thp
+++ a/fs/proc/task_mmu.c
@@ -1522,6 +1522,8 @@ static int pagemap_pmd_range(pmd_t *pmdp
 		}
 #endif
 
+		if (page && !PageAnon(page))
+			flags |= PM_FILE;
 		if (page && !migration && page_mapcount(page) == 1)
 			flags |= PM_MMAP_EXCLUSIVE;
 
_

Patches currently in -mm which might be from david@redhat.com are

revert-mm-init_mlocked_on_free_v3.patch
mm-memory-move-page_count-check-into-validate_page_before_insert.patch
mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch
mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch
mm-update-_mapcount-and-page_type-documentation.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch
mm-zsmalloc-use-a-proper-page-type.patch
mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch
mm-filemap-reinitialize-folio-_mapcount-directly.patch
mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch
fs-proc-task_mmu-indicate-pm_file-for-pmd-mapped-file-thp.patch
fs-proc-task_mmu-dont-indicate-pm_mmap_exclusive-without-pm_present.patch
fs-proc-task_mmu-properly-detect-pm_mmap_exclusive-per-page-of-pmd-mapped-thps.patch
fs-proc-task_mmu-account-non-present-entries-as-maybe-shared-but-no-idea-how-often.patch
fs-proc-move-page_mapcount-to-fs-proc-internalh.patch
documentation-admin-guide-mm-pagemaprst-drop-using-pagemap-to-do-something-useful.patch

