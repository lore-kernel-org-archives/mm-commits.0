From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 039/155] mm/gup: pass a flags arg to
 __gup_device_* functions
Date: Wed, 01 Apr 2020 21:05:14 -0700
Message-ID: <20200402040514.dfJiuRrUe%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEFQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:05:16 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, corbet@lwn.net, dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org, ira.weiny@intel.com, jack@suse.cz, jgg@ziepe.ca, jglisse@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, shuah@kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz, viro@zeniv.linux.org.uk, willy@infradead.org

=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: pass a flags arg to __gup_device_* functions

A subsequent patch requires access to gup flags, so pass the flags
argument through to the __gup_device_* functions.

Also placate checkpatch.pl by shortening a nearby line.

Link: http://lkml.kernel.org/r/20200211001536.1027652-3-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- a/mm/gup.c~mm-gup-pass-a-flags-arg-to-__gup_device_-functions
+++ a/mm/gup.c
@@ -1963,7 +1963,8 @@ static int gup_pte_range(pmd_t pmd, unsi
=20
 #if defined(CONFIG_ARCH_HAS_PTE_DEVMAP) && defined(CONFIG_TRANSPARENT_HUGE=
PAGE)
 static int __gup_device_huge(unsigned long pfn, unsigned long addr,
-		unsigned long end, struct page **pages, int *nr)
+			     unsigned long end, unsigned int flags,
+			     struct page **pages, int *nr)
 {
 	int nr_start =3D *nr;
 	struct dev_pagemap *pgmap =3D NULL;
@@ -1989,13 +1990,14 @@ static int __gup_device_huge(unsigned lo
 }
=20
 static int __gup_device_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long ad=
dr,
-		unsigned long end, struct page **pages, int *nr)
+				 unsigned long end, unsigned int flags,
+				 struct page **pages, int *nr)
 {
 	unsigned long fault_pfn;
 	int nr_start =3D *nr;
=20
 	fault_pfn =3D pmd_pfn(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
-	if (!__gup_device_huge(fault_pfn, addr, end, pages, nr))
+	if (!__gup_device_huge(fault_pfn, addr, end, flags, pages, nr))
 		return 0;
=20
 	if (unlikely(pmd_val(orig) !=3D pmd_val(*pmdp))) {
@@ -2006,13 +2008,14 @@ static int __gup_device_huge_pmd(pmd_t o
 }
=20
 static int __gup_device_huge_pud(pud_t orig, pud_t *pudp, unsigned long ad=
dr,
-		unsigned long end, struct page **pages, int *nr)
+				 unsigned long end, unsigned int flags,
+				 struct page **pages, int *nr)
 {
 	unsigned long fault_pfn;
 	int nr_start =3D *nr;
=20
 	fault_pfn =3D pud_pfn(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
-	if (!__gup_device_huge(fault_pfn, addr, end, pages, nr))
+	if (!__gup_device_huge(fault_pfn, addr, end, flags, pages, nr))
 		return 0;
=20
 	if (unlikely(pud_val(orig) !=3D pud_val(*pudp))) {
@@ -2023,14 +2026,16 @@ static int __gup_device_huge_pud(pud_t o
 }
 #else
 static int __gup_device_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long ad=
dr,
-		unsigned long end, struct page **pages, int *nr)
+				 unsigned long end, unsigned int flags,
+				 struct page **pages, int *nr)
 {
 	BUILD_BUG();
 	return 0;
 }
=20
 static int __gup_device_huge_pud(pud_t pud, pud_t *pudp, unsigned long add=
r,
-		unsigned long end, struct page **pages, int *nr)
+				 unsigned long end, unsigned int flags,
+				 struct page **pages, int *nr)
 {
 	BUILD_BUG();
 	return 0;
@@ -2146,7 +2151,8 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 	if (pmd_devmap(orig)) {
 		if (unlikely(flags & FOLL_LONGTERM))
 			return 0;
-		return __gup_device_huge_pmd(orig, pmdp, addr, end, pages, nr);
+		return __gup_device_huge_pmd(orig, pmdp, addr, end, flags,
+					     pages, nr);
 	}
=20
 	page =3D pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
@@ -2167,7 +2173,8 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 }
=20
 static int gup_huge_pud(pud_t orig, pud_t *pudp, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages, int *nr)
+			unsigned long end, unsigned int flags,
+			struct page **pages, int *nr)
 {
 	struct page *head, *page;
 	int refs;
@@ -2178,7 +2185,8 @@ static int gup_huge_pud(pud_t orig, pud_
 	if (pud_devmap(orig)) {
 		if (unlikely(flags & FOLL_LONGTERM))
 			return 0;
-		return __gup_device_huge_pud(orig, pudp, addr, end, pages, nr);
+		return __gup_device_huge_pud(orig, pudp, addr, end, flags,
+					     pages, nr);
 	}
=20
 	page =3D pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
_
