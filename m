Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D612119
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 03:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723000772; cv=none; b=R1Qk52q6XE7kyERs/emJgUwjbv8kNL5x2CiEhTvjUexy8xGNkDyGYSzR//LT/o/33t1/kyoy7oLmiyF/EQri7Lwf98aS7NOkoY6valrxOTK7i2rWS9FePvzz6tDbM05WTKYFDBtXkyQ2xUALJr5DbtZHge1BFnWCMtJeeuBY0xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723000772; c=relaxed/simple;
	bh=lzcInJfmKlGxZHUpKzmnU7AWqEGtR315In0YYdCjaWw=;
	h=Date:To:From:Subject:Message-Id; b=BZ0ueV6zuRgyjPVFA6CDx7+HAE+DFfjuJeBJQwmGs0rUy0mvmgpMAAsY0L5cKNVB2C9CnFcd7lJ3phlPh/YvfNzf+AII9jkmUmGTYgJ4KD3t8EpMpSqPLOCRbbEEEqx+A8BX3PhRvgmjMAgHOO3/52AkmK0yV1sfoV9YGOzupmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BMSSacVj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BMSSacVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B27C32786;
	Wed,  7 Aug 2024 03:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723000771;
	bh=lzcInJfmKlGxZHUpKzmnU7AWqEGtR315In0YYdCjaWw=;
	h=Date:To:From:Subject:From;
	b=BMSSacVj6lT6U+Zv9i78wk9K+GvxS0z4JVpgTp1UCAOOsMLJ419rdHoRyEGH7ptFC
	 vWfnZsBCfbBuvCiyfFn57NciI5Fall5d2vb36vNue5cP2xJ8oBq4+D6yTj2cP5rTpc
	 YIuM9eIjyAqHVeXJog+Sz30eC4BHOumjVMg0UvBk=
Date: Tue, 06 Aug 2024 20:19:30 -0700
To: mm-commits@vger.kernel.org,yi.zhang@redhat.com,will@kernel.org,tzimmermann@suse.de,tglx@linutronix.de,svens@linux.ibm.com,souravpanda@google.com,ryan.roberts@arm.com,rppt@kernel.org,rientjes@google.com,rdunlap@infradead.org,philmd@linaro.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,osalvador@suse.de,npiggin@gmail.com,naveen@kernel.org,namcao@linutronix.de,muchun.song@linux.dev,mpe@ellerman.id.au,mingo@redhat.com,mcgrof@kernel.org,mark.rutland@arm.com,luto@kernel.org,kernel@xen0n.name,kent.overstreet@linux.dev,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dawei.li@shingroup.cn,david@redhat.com,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,chenjiahao16@huawei.com,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,bjorn@rivosinc.com,bhe@redhat.com,arnd@arndb.de,ardb@kernel.org,aou@eecs.berkeley.edu,alison.schofield@intel.com,alexghiti@rivosinc.com,agordeev@linux.ibm.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-the-memmap-stat-before-page-is-freed.patch added to mm-hotfixes-unstable branch
Message-Id: <20240807031931.76B27C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: update the memmap stat before page is freed
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-update-the-memmap-stat-before-page-is-freed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-update-the-memmap-stat-before-page-is-freed.patch

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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm: update the memmap stat before page is freed
Date: Tue, 6 Aug 2024 22:14:53 +0000

It is more logical to update the stat before the page is freed, to avoid
use after free scenarios.

Link: https://lkml.kernel.org/r/20240806221454.1971755-1-pasha.tatashin@soleen.com
Fixes: 15995a352474 ("mm: report per-page metadata information")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Björn Töpel <bjorn@rivosinc.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Jiahao <chenjiahao16@huawei.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dawei Li <dawei.li@shingroup.cn>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nam Cao <namcao@linutronix.de>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Philippe Mathieu-Daudé <philmd@linaro.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Cc: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    4 ++--
 mm/page_ext.c        |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-update-the-memmap-stat-before-page-is-freed
+++ a/mm/hugetlb_vmemmap.c
@@ -185,11 +185,11 @@ static int vmemmap_remap_range(unsigned
 static inline void free_vmemmap_page(struct page *page)
 {
 	if (PageReserved(page)) {
-		free_bootmem_page(page);
 		mod_node_page_state(page_pgdat(page), NR_MEMMAP_BOOT, -1);
+		free_bootmem_page(page);
 	} else {
-		__free_page(page);
 		mod_node_page_state(page_pgdat(page), NR_MEMMAP, -1);
+		__free_page(page);
 	}
 }
 
--- a/mm/page_ext.c~mm-update-the-memmap-stat-before-page-is-freed
+++ a/mm/page_ext.c
@@ -330,18 +330,18 @@ static void free_page_ext(void *addr)
 	if (is_vmalloc_addr(addr)) {
 		page = vmalloc_to_page(addr);
 		pgdat = page_pgdat(page);
+		mod_node_page_state(pgdat, NR_MEMMAP,
+				    -1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
 		vfree(addr);
 	} else {
 		page = virt_to_page(addr);
 		pgdat = page_pgdat(page);
+		mod_node_page_state(pgdat, NR_MEMMAP,
+				    -1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
 		BUG_ON(PageReserved(page));
 		kmemleak_free(addr);
 		free_pages_exact(addr, table_size);
 	}
-
-	mod_node_page_state(pgdat, NR_MEMMAP,
-			    -1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
-
 }
 
 static void __free_page_ext(unsigned long pfn)
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-update-the-memmap-stat-before-page-is-freed.patch
mm-keep-nid-around-during-hot-remove.patch
memcg-increase-the-valid-index-range-for-memcg-stats-v5.patch
vmstat-kernel-stack-usage-histogram.patch
task_stack-uninline-stack_not_used.patch

