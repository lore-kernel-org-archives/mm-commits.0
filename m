Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2270E150991
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 19:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718133609; cv=none; b=Q/TiY+uofdGVncXFFjBB4DjitA8O3YRwxOyT3wxYtoPVCc4aTmbOXF7+VL4M+4gb7h2HiRZ4ukZ6ZeY5Bq9Y/YmMMbFUlpdSYx78H0GwUPwVkIXxlrsbIa8RCIHCCDLtFdmaY0GemAlm2jsKRvlZAmxCeKe7jIOR+QWsfuVmQXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718133609; c=relaxed/simple;
	bh=7fBMfXmX71kipOUMi406oAN2p/JEsqUnh7wBHIJLFkU=;
	h=Date:To:From:Subject:Message-Id; b=qcTLD2rWyZRs+3VbMVoeykR57JbdYhv8CamLbmk7j9ljjf/TGxTHU/KNTgWkVAQMldjlvhyZCjhPbTDJXdkfGXvcZVkOxzhAJLLkidZL+Ul6yS3tDyolL/AlzgDoKMp6c5bMPrgTz7VPjq9Vv6IbR6d7q0n6fEEiAMkDgPkpCsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MPzNm949; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MPzNm949"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37C9C2BD10;
	Tue, 11 Jun 2024 19:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718133608;
	bh=7fBMfXmX71kipOUMi406oAN2p/JEsqUnh7wBHIJLFkU=;
	h=Date:To:From:Subject:From;
	b=MPzNm94960WYAbYY3SxeDeRro/iPa0YgKgh7qH3kXbjPRcMxRdMHToaTS30DRgXcp
	 EtTo0IsDm/jE6Pg8X/lhLAVcdDyZWaf25CPAhyfwQ1JEiz9Gk+VyrF/jVopZnJvVA3
	 HzYunru4SkALT+6TDWDLn0UuXDLjy4M9J1lJIXGE=
Date: Tue, 11 Jun 2024 12:20:08 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pass-meminit_context-to-__free_pages_core-fix-2.patch added to mm-unstable branch
Message-Id: <20240611192008.B37C9C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-pass-meminit_context-to-__free_pages_core-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pass-meminit_context-to-__free_pages_core-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pass-meminit_context-to-__free_pages_core-fix-2.patch

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
Subject: mm-pass-meminit_context-to-__free_pages_core-fix-2
Date: Tue, 11 Jun 2024 12:05:09 +0200

fix up the memblock comment, per Oscar

Link: https://lkml.kernel.org/r/2ed64218-7f3b-4302-a5dc-27f060654fe2@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-pass-meminit_context-to-__free_pages_core-fix-2
+++ a/mm/page_alloc.c
@@ -1245,7 +1245,7 @@ void __free_pages_core(struct page *page
 		debug_pagealloc_map_pages(page, nr_pages);
 		adjust_managed_page_count(page, nr_pages);
 	} else {
-		/* memblock adjusts totalram_pages() ahead of time. */
+		/* memblock adjusts totalram_pages() manually. */
 		atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
 	}
 
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
mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix.patch
mm-pass-meminit_context-to-__free_pages_core-fix-2.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-highmem-reimplement-totalhigh_pages-by-walking-zones.patch
mm-highmem-reimplement-totalhigh_pages-by-walking-zones-fix.patch
mm-highmem-make-nr_free_highpages-return-unsigned-long.patch

