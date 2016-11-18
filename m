From: akpm@linux-foundation.org
Subject: + mm-add-support-for-releasing-multiple-instances-of-a-page.patch added to -mm tree
Date: Fri, 18 Nov 2016 15:30:59 -0800
Message-ID: <582f8f33.pY3WXwGRVi24j9z8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42568 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753512AbcKRXbB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2016 18:31:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, cmetcalf@mellanox.com, dalias@libc.org, davem@davemloft.net, deller@gmx.de, dhowells@redhat.com, egtvedt@samfundet.no, geert@linux-m68k.org, james.hogan@imgtec.com, jcmvbkbc@gmail.com, jeffrey.t.kirsher@intel.com, jejb@parisc-linux.org, jonas@southpole.se, keguang.zhang@gmail.com, lftan@altera.com, linux@armlinux.org.uk, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, ralf@linux-mips.org, realmz6@gmail.com, rkuo@codeaurora.org, tklauser@distanz.ch, vgupta@synopsys.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add support for releasing multiple instances of a page
has been added to the -mm tree.  Its filename is
     mm-add-support-for-releasing-multiple-instances-of-a-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-support-for-releasing-multiple-instances-of-a-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-support-for-releasing-multiple-instances-of-a-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: mm: add support for releasing multiple instances of a page

Add a function that allows us to batch free a page that has multiple
references outstanding.  Specifically this function can be used to drop a
page being used in the page frag alloc cache.  With this drivers can make
use of functionality similar to the page frag alloc cache without having
to do any workarounds for the fact that there is no function that frees
multiple references.

Link: http://lkml.kernel.org/r/20161110113606.76501.70752.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hans-Christian Noren Egtvedt <egtvedt@samfundet.no>
Cc: Helge Deller <deller@gmx.de>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Keguang Zhang <keguang.zhang@gmail.com>
Cc: Ley Foon Tan <lftan@altera.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Tobias Klauser <tklauser@distanz.ch>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 ++
 mm/page_alloc.c     |   14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff -puN include/linux/gfp.h~mm-add-support-for-releasing-multiple-instances-of-a-page include/linux/gfp.h
--- a/include/linux/gfp.h~mm-add-support-for-releasing-multiple-instances-of-a-page
+++ a/include/linux/gfp.h
@@ -506,6 +506,8 @@ extern void free_hot_cold_page(struct pa
 extern void free_hot_cold_page_list(struct list_head *list, bool cold);
 
 struct page_frag_cache;
+extern void __page_frag_drain(struct page *page, unsigned int order,
+			      unsigned int count);
 extern void *__alloc_page_frag(struct page_frag_cache *nc,
 			       unsigned int fragsz, gfp_t gfp_mask);
 extern void __free_page_frag(void *addr);
diff -puN mm/page_alloc.c~mm-add-support-for-releasing-multiple-instances-of-a-page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-add-support-for-releasing-multiple-instances-of-a-page
+++ a/mm/page_alloc.c
@@ -3917,6 +3917,20 @@ static struct page *__page_frag_refill(s
 	return page;
 }
 
+void __page_frag_drain(struct page *page, unsigned int order,
+		       unsigned int count)
+{
+	VM_BUG_ON_PAGE(page_ref_count(page) == 0, page);
+
+	if (page_ref_sub_and_test(page, count)) {
+		if (order == 0)
+			free_hot_cold_page(page, false);
+		else
+			__free_pages_ok(page, order);
+	}
+}
+EXPORT_SYMBOL(__page_frag_drain);
+
 void *__alloc_page_frag(struct page_frag_cache *nc,
 			unsigned int fragsz, gfp_t gfp_mask)
 {
_

Patches currently in -mm which might be from alexander.h.duyck@intel.com are

arch-arc-add-option-to-skip-sync-on-dma-mapping.patch
arch-arm-add-option-to-skip-sync-on-dma-map-and-unmap.patch
arch-avr32-add-option-to-skip-sync-on-dma-map.patch
arch-blackfin-add-option-to-skip-sync-on-dma-map.patch
arch-c6x-add-option-to-skip-sync-on-dma-map-and-unmap.patch
arch-frv-add-option-to-skip-sync-on-dma-map.patch
arch-hexagon-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
arch-m68k-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
arch-metag-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-microblaze-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-mips-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-nios2-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-openrisc-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
arch-parisc-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-powerpc-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
arch-sh-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
arch-sparc-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-tile-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
arch-xtensa-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch
dma-add-calls-for-dma_map_page_attrs-and-dma_unmap_page_attrs.patch
mm-add-support-for-releasing-multiple-instances-of-a-page.patch
igb-update-driver-to-make-use-of-dma_attr_skip_cpu_sync.patch
igb-update-code-to-better-handle-incrementing-page-count.patch

