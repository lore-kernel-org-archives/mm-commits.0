Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC17F507
	for <mm-commits@vger.kernel.org>; Fri, 17 Jul 2026 00:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784246581; cv=none; b=XiVob8Ux6PjOwGeniDGTuOxJbnsFjtCIvPmEtOMvxCYBphagZI2uPrtbHesONiSIkgv0HDxcB4zmP/cwiUQx+UXNMfHv+PECH8+tI+c7lmmDaJ1tqxWi3Nd3w4GVybt8ja52XWq1TFGt7B3d7x6VuZlL6Y9CPIy2DQbkNpHi95Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784246581; c=relaxed/simple;
	bh=Ao01bNadSzJnCz1bmWv42KqsL/qCMDSTGr7Z0vMBc+U=;
	h=Date:To:From:Subject:Message-Id; b=bQAmDTK1fA0si8IdCk+aKf83t1NthJajmf3cVWAuaraD6YltDri/1WM2PWR/lqKcuc0mu7XVyov+eW8zv2rjyc1FfqNialFwCcBMC+0virtoug52ycEZHSmReOoU6Ef0bNaUq5UJECxsTshR0XviLQYFLGWGEdyW5RnJDyeH2QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TTYsprP7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TTYsprP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90F01F000E9;
	Fri, 17 Jul 2026 00:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784246580;
	bh=AdZH8IieERWroURtX30A7gGBSvLBWhrMA9gW66/Pz0E=;
	h=Date:To:From:Subject;
	b=TTYsprP71gTsqQuI7nCS+SpjGgvSGto6YzIDe+2Vt7FYXWMiGzatlaFu1vxqqU6+J
	 svgbUBDABlEBvx42KHJd0dW94fm80qoieFvjlULJAdYyMb5elaJ1dLOZq35GWpguum
	 Nhdlu8MLpjT0UYz2I5DESpQjncmla5PmMCtBnpnU=
Date: Thu, 16 Jul 2026 17:02:59 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch added to mm-unstable branch
Message-Id: <20260717000259.D90F01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390/mm: use free_reserved_pages() in vmem_free_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: s390/mm: use free_reserved_pages() in vmem_free_pages()
Date: Thu, 16 Jul 2026 16:51:02 +0200

Let's use our new generic helper.

Link: https://lore.kernel.org/20260716-bootmem_info_part2-v2-3-4afc76c73d61@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/vmem.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/s390/mm/vmem.c~s390-mm-use-free_reserved_pages-in-vmem_free_pages
+++ a/arch/s390/mm/vmem.c
@@ -39,7 +39,6 @@ static void __ref *vmem_alloc_pages(unsi
 
 static void vmem_free_pages(unsigned long addr, int order, struct vmem_altmap *altmap)
 {
-	unsigned int nr_pages = 1 << order;
 	struct page *page;
 
 	if (altmap) {
@@ -49,8 +48,7 @@ static void vmem_free_pages(unsigned lon
 	page = virt_to_page((void *)addr);
 	if (PageReserved(page)) {
 		/* allocated from memblock */
-		while (nr_pages--)
-			free_reserved_page(page++);
+		free_reserved_pages(page, order);
 	} else {
 		free_pages(addr, order);
 	}
_

Patches currently in -mm which might be from david@kernel.org are

sparc-mm-drop-custom-pte_clear_not_present_full.patch
mm-drop-pte_clear_not_present_full.patch
mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes.patch
x86-mm-drop-order-parameter-from-free_pagetable.patch
mm-provide-free_reserved_pages-removing-x86-variant.patch
s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch
mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch
x86-mm-stop-marking-vmemmap-as-section_info.patch
x86-mm-stop-marking-page-tables-as-mix_section_info.patch
x86-mm-remove-config_have_bootmem_info_node.patch
mm-hugetlb_vmemmap-remove-bootmem_info-leftovers.patch
mm-sparse-remove-bootmem_infoh-include.patch
mm-bootmem_info-remove-config_have_bootmem_info_node.patch
mm-standardize-printing-for-pgtable-entries.patch

