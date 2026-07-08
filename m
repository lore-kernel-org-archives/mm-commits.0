Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAB83F9F43
	for <mm-commits@vger.kernel.org>; Wed,  8 Jul 2026 21:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783545932; cv=none; b=DFD/cOph7m/DaywnzBtycWoyykZ3LJ4SyIQ5snB0jcnEssbilY13uOH5gYT6I1j8DNxc7oXNQQwIOmkh7M0InLhH3YtKeok0fBHYwYldF3LEGNXNS5oZYWiSMEZtvDKJr1+MYgCC5KtWB7fUapOtujwSSzUguUwWVtmLhP2KM7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783545932; c=relaxed/simple;
	bh=ZuPBLn9xSwTeDLohTfCRfMIbcQ78WDU1StJ/pMTRlRA=;
	h=Date:To:From:Subject:Message-Id; b=bsJGLYOZVx9pX5ukdikyb7ZbexzJkjmYwCj1ibgs3uCs4ve2BxLmjaipte8E3y4dpKtDKdM+XJ4JUENrjmrisOfSMPYNbyJFd/WF77H1X38NUAHl+Yqv4Rq9wOJxtjvJlV2LSuhrddVRteBQ230Cw4Hp6T4quup9EvPaUf47mSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Deahz09Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Deahz09Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FB51F000E9;
	Wed,  8 Jul 2026 21:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783545930;
	bh=qU/eMccONVyb+LWJvb+aJY4flmQBYu7clYFFcqlUGVI=;
	h=Date:To:From:Subject;
	b=Deahz09Qeyhm+MS0aC2V+6g7MZMBVvakZpUuV5Mwcp9dJ0xI5/KE2hdJ47XZNx6LX
	 hPJpMxPiVNsftaV5yAqugeTaQf3g7+9rDcBodYqAhAl0q/K//8V/caRpEqSwB2C/Za
	 weaXe0y+5FK7CvwtdpgtqrUGCQ1OlAHu48T70cOY=
Date: Wed, 08 Jul 2026 14:25:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hpa@zytor.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,bp@alien8.de,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch added to mm-new branch
Message-Id: <20260708212530.97FB51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390/mm: use free_reserved_pages() in vmem_free_pages()
has been added to the -mm mm-new branch.  Its filename is
     s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: s390/mm: use free_reserved_pages() in vmem_free_pages()
Date: Wed, 08 Jul 2026 16:10:58 +0200

Let's use our new generic helper.

Link: https://lore.kernel.org/20260708-bootmem_info_part2-v1-3-156ce4986598@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
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

