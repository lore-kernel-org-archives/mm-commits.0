Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288665789D
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597483; cv=none; b=WhmTuU6VVF6sfzotAD1qshNV2aOCmTq4G1Ef2BI54xhfvS7GmNkU/crIDWF1WpKLtlj4aUsn1v2zw/WbcMG9x6ZgHr2jn3bkYoVnTxEIICPdgd8hDI42kg7E8sdDVCiNzx5D7197c5IrMeQrgGBMqQ3OaxUfUZE0zahj29WeM/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597483; c=relaxed/simple;
	bh=jpHd6hkXvddSYkUT4NQCS0z8vjjCbvHXuns0tNWKTRE=;
	h=Date:To:From:Subject:Message-Id; b=S1xTdC81chgQENIcksPlk6rTGoUejpNZgoddVZfo2yS048kQeH0ZweYEl/+iry3HihlBDhGBncq1oe8eEqn6NgKdTfJQiJJo/8XDv4ZYts34fTN//lD/T1BwZYheV3lFfqFeSesCCYjxb+mfonx3Wt6UD7hHAF4xqo4ndagVv6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ncPAa2uV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ncPAa2uV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EF5C4CEF0;
	Tue, 23 Sep 2025 03:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597482;
	bh=jpHd6hkXvddSYkUT4NQCS0z8vjjCbvHXuns0tNWKTRE=;
	h=Date:To:From:Subject:From;
	b=ncPAa2uVnTJMc9KYOINBkV7C9ZcXKFys4vvDcoMgau/wNEmePbNi2VDOyZ/HjMT7b
	 8MKHlAEHtrLoJtxXVR2XJZfBUybFDCR8r7sr1uPLBXZ/ylHKu0a+4Hs9jDGEU8qvq8
	 drS+1Zb5Kho3ELJdT+PpeQX5bv6MEJ5bBf//lJd4=
Date: Mon, 22 Sep 2025 20:18:01 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,viro@zeniv.linux.org.uk,vgoyal@redhat.com,vbabka@suse.cz,urezki@gmail.com,tsbogend@alpha.franken.de,tony.luck@intel.com,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,robin.murphy@arm.com,reinette.chatre@intel.com,pfalcato@suse.de,osalvador@suse.de,nico@fluxnic.net,muchun.song@linux.dev,mhocko@suse.com,liam.howlett@oracle.com,kevin.tian@intel.com,jgg@nvidia.com,jannh@google.com,james.morse@arm.com,jack@suse.cz,hughd@google.com,hca@linux.ibm.com,guoren@kernel.org,gregkh@linuxfoundation.org,gor@linux.ibm.com,dyoung@redhat.com,dvyukov@google.com,david@redhat.com,davem@davemloft.net,dave.martin@arm.com,dave.jiang@intel.com,dan.j.williams@intel.com,corbet@lwn.net,brauner@kernel.org,borntraeger@linux.ibm.com,bhe@redhat.com,baolin.wang@linux.alibaba.com,arnd@arndb.de,andreyknvl@gmail.com,andreas@gaisler.com,almaz.alexandrovich@paragon-software.com,agordeev@linux.ibm.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-abstract-io_remap_pfn_range-based-on-pfn.patch removed from -mm tree
Message-Id: <20250923031802.83EF5C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: abstract io_remap_pfn_range() based on PFN
has been removed from the -mm tree.  Its filename was
     mm-abstract-io_remap_pfn_range-based-on-pfn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: abstract io_remap_pfn_range() based on PFN
Date: Wed, 17 Sep 2025 20:11:09 +0100

The only instances in which we customise this function are ones in which we
customise the PFN used, other than the fact that, when a custom
io_remap_pfn_range() function is provided, the prot value passed is not
filtered through pgprot_decrypted().

Use this fact to simplify the use of io_remap_pfn_range(), by abstracting
the PFN function as io_remap_pfn_range_pfn(), and simply have the
convention that, should a custom handler be specified, we do not utilise
pgprot_decrypted().

If we require in future prot customisation, we can make
io_remap_pfn_range_prot() available for override.

[lorenzo.stoakes@oracle.com: simplify io_remap_pfn_range_pfn definition]
  Link: https://lkml.kernel.org/r/96e4a163-a791-4b08-a006-bdd7ebbecaf9@lucifer.local
Link: https://lkml.kernel.org/r/4f01f4d82300444dee4af4f8d1333e52db402a45.1758135681.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chatre, Reinette <reinette.chatre@intel.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Martin <dave.martin@arm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Robin Murohy <robin.murphy@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/include/asm/pgtable.h     |    3 ---
 arch/mips/alchemy/common/setup.c    |    9 +++++----
 arch/mips/include/asm/pgtable.h     |    5 ++---
 arch/sparc/include/asm/pgtable_32.h |   12 ++++--------
 arch/sparc/include/asm/pgtable_64.h |   12 ++++--------
 include/linux/mm.h                  |   19 ++++++++++++++-----
 6 files changed, 29 insertions(+), 31 deletions(-)

--- a/arch/csky/include/asm/pgtable.h~mm-abstract-io_remap_pfn_range-based-on-pfn
+++ a/arch/csky/include/asm/pgtable.h
@@ -263,7 +263,4 @@ void update_mmu_cache_range(struct vm_fa
 #define update_mmu_cache(vma, addr, ptep) \
 	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
 
-#define io_remap_pfn_range(vma, vaddr, pfn, size, prot) \
-	remap_pfn_range(vma, vaddr, pfn, size, prot)
-
 #endif /* __ASM_CSKY_PGTABLE_H */
--- a/arch/mips/alchemy/common/setup.c~mm-abstract-io_remap_pfn_range-based-on-pfn
+++ a/arch/mips/alchemy/common/setup.c
@@ -94,12 +94,13 @@ phys_addr_t fixup_bigphys_addr(phys_addr
 	return phys_addr;
 }
 
-int io_remap_pfn_range(struct vm_area_struct *vma, unsigned long vaddr,
-		unsigned long pfn, unsigned long size, pgprot_t prot)
+static inline unsigned long io_remap_pfn_range_pfn(unsigned long pfn,
+		unsigned long size)
 {
 	phys_addr_t phys_addr = fixup_bigphys_addr(pfn << PAGE_SHIFT, size);
 
-	return remap_pfn_range(vma, vaddr, phys_addr >> PAGE_SHIFT, size, prot);
+	return phys_addr >> PAGE_SHIFT;
 }
-EXPORT_SYMBOL(io_remap_pfn_range);
+EXPORT_SYMBOL(io_remap_pfn_range_pfn);
+
 #endif /* CONFIG_MIPS_FIXUP_BIGPHYS_ADDR */
--- a/arch/mips/include/asm/pgtable.h~mm-abstract-io_remap_pfn_range-based-on-pfn
+++ a/arch/mips/include/asm/pgtable.h
@@ -604,9 +604,8 @@ static inline void update_mmu_cache_pmd(
  */
 #ifdef CONFIG_MIPS_FIXUP_BIGPHYS_ADDR
 phys_addr_t fixup_bigphys_addr(phys_addr_t addr, phys_addr_t size);
-int io_remap_pfn_range(struct vm_area_struct *vma, unsigned long vaddr,
-		unsigned long pfn, unsigned long size, pgprot_t prot);
-#define io_remap_pfn_range io_remap_pfn_range
+unsigned long io_remap_pfn_range_pfn(unsigned long pfn, unsigned long size);
+#define io_remap_pfn_range_pfn io_remap_pfn_range_pfn
 #else
 #define fixup_bigphys_addr(addr, size)	(addr)
 #endif /* CONFIG_MIPS_FIXUP_BIGPHYS_ADDR */
--- a/arch/sparc/include/asm/pgtable_32.h~mm-abstract-io_remap_pfn_range-based-on-pfn
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -395,12 +395,8 @@ __get_iospace (unsigned long addr)
 #define GET_IOSPACE(pfn)		(pfn >> (BITS_PER_LONG - 4))
 #define GET_PFN(pfn)			(pfn & 0x0fffffffUL)
 
-int remap_pfn_range(struct vm_area_struct *, unsigned long, unsigned long,
-		    unsigned long, pgprot_t);
-
-static inline int io_remap_pfn_range(struct vm_area_struct *vma,
-				     unsigned long from, unsigned long pfn,
-				     unsigned long size, pgprot_t prot)
+static inline unsigned long io_remap_pfn_range_pfn(unsigned long pfn,
+		unsigned long size)
 {
 	unsigned long long offset, space, phys_base;
 
@@ -408,9 +404,9 @@ static inline int io_remap_pfn_range(str
 	space = GET_IOSPACE(pfn);
 	phys_base = offset | (space << 32ULL);
 
-	return remap_pfn_range(vma, from, phys_base >> PAGE_SHIFT, size, prot);
+	return phys_base >> PAGE_SHIFT;
 }
-#define io_remap_pfn_range io_remap_pfn_range
+#define io_remap_pfn_range_pfn io_remap_pfn_range_pfn
 
 #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 #define ptep_set_access_flags(__vma, __address, __ptep, __entry, __dirty) \
--- a/arch/sparc/include/asm/pgtable_64.h~mm-abstract-io_remap_pfn_range-based-on-pfn
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -1048,9 +1048,6 @@ int page_in_phys_avail(unsigned long pad
 #define GET_IOSPACE(pfn)		(pfn >> (BITS_PER_LONG - 4))
 #define GET_PFN(pfn)			(pfn & 0x0fffffffffffffffUL)
 
-int remap_pfn_range(struct vm_area_struct *, unsigned long, unsigned long,
-		    unsigned long, pgprot_t);
-
 void adi_restore_tags(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, pte_t pte);
 
@@ -1084,9 +1081,8 @@ static inline int arch_unmap_one(struct
 	return 0;
 }
 
-static inline int io_remap_pfn_range(struct vm_area_struct *vma,
-				     unsigned long from, unsigned long pfn,
-				     unsigned long size, pgprot_t prot)
+static inline unsigned long io_remap_pfn_range_pfn(unsigned long pfn,
+		unsigned long size)
 {
 	unsigned long offset = GET_PFN(pfn) << PAGE_SHIFT;
 	int space = GET_IOSPACE(pfn);
@@ -1094,9 +1090,9 @@ static inline int io_remap_pfn_range(str
 
 	phys_base = offset | (((unsigned long) space) << 32UL);
 
-	return remap_pfn_range(vma, from, phys_base >> PAGE_SHIFT, size, prot);
+	return phys_base >> PAGE_SHIFT;
 }
-#define io_remap_pfn_range io_remap_pfn_range
+#define io_remap_pfn_range_pfn io_remap_pfn_range_pfn
 
 static inline unsigned long __untagged_addr(unsigned long start)
 {
--- a/include/linux/mm.h~mm-abstract-io_remap_pfn_range-based-on-pfn
+++ a/include/linux/mm.h
@@ -3672,15 +3672,24 @@ static inline vm_fault_t vmf_insert_page
 	return VM_FAULT_NOPAGE;
 }
 
-#ifndef io_remap_pfn_range
-static inline int io_remap_pfn_range(struct vm_area_struct *vma,
-				     unsigned long addr, unsigned long pfn,
-				     unsigned long size, pgprot_t prot)
+#ifndef io_remap_pfn_range_pfn
+static inline unsigned long io_remap_pfn_range_pfn(unsigned long pfn,
+		unsigned long size)
 {
-	return remap_pfn_range(vma, addr, pfn, size, pgprot_decrypted(prot));
+	return pfn;
 }
 #endif
 
+static inline int io_remap_pfn_range(struct vm_area_struct *vma,
+				     unsigned long addr, unsigned long orig_pfn,
+				     unsigned long size, pgprot_t orig_prot)
+{
+	const unsigned long pfn = io_remap_pfn_range_pfn(orig_pfn, size);
+	const pgprot_t prot = pgprot_decrypted(orig_prot);
+
+	return remap_pfn_range(vma, addr, pfn, size, prot);
+}
+
 static inline vm_fault_t vmf_error(int err)
 {
 	if (err == -ENOMEM)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


