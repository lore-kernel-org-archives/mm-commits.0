From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 027/127] arch/xtensa: move kmap build bug out of
 the way
Date: Thu, 04 Jun 2020 16:47:26 -0700
Message-ID: <20200604234726.fCciYd4hU%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXr2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:47:28 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hch@lst.de, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, linux-mm@kvack.org, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, torvalds@linux-foundation.org, tsbogend@alpha.franken.de, viro@zeniv.linux.org.uk

=46rom: Ira Weiny <ira.weiny@intel.com>
Subject: arch/xtensa: move kmap build bug out of the way

Move the kmap() build bug to kmap_init() to facilitate patches to lift
kmap() to the core.

Link: http://lkml.kernel.org/r/20200507150004.1423069-3-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/highmem.h |    5 -----
 arch/xtensa/mm/highmem.c          |    4 ++++
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/arch/xtensa/include/asm/highmem.h~arch-xtensa-move-kmap-build-bug-out=
-of-the-way
+++ a/arch/xtensa/include/asm/highmem.h
@@ -68,11 +68,6 @@ void kunmap_high(struct page *page);
=20
 static inline void *kmap(struct page *page)
 {
-	/* Check if this memory layout is broken because PKMAP overlaps
-	 * page table.
-	 */
-	BUILD_BUG_ON(PKMAP_BASE <
-		     TLBTEMP_BASE_1 + TLBTEMP_SIZE);
 	might_sleep();
 	if (!PageHighMem(page))
 		return page_address(page);
--- a/arch/xtensa/mm/highmem.c~arch-xtensa-move-kmap-build-bug-out-of-the-w=
ay
+++ a/arch/xtensa/mm/highmem.c
@@ -88,6 +88,10 @@ void __init kmap_init(void)
 {
 	unsigned long kmap_vstart;
=20
+	/* Check if this memory layout is broken because PKMAP overlaps
+	 * page table.
+	 */
+	BUILD_BUG_ON(PKMAP_BASE < TLBTEMP_BASE_1 + TLBTEMP_SIZE);
 	/* cache the first kmap pte */
 	kmap_vstart =3D __fix_to_virt(FIX_KMAP_BEGIN);
 	kmap_pte =3D kmap_get_fixmap_pte(kmap_vstart);
_
