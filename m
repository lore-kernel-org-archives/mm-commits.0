From: akpm@linux-foundation.org
Subject: [merged]
 mm-add-support-for-releasing-multiple-instances-of-a-page.patch removed
 from -mm tree
Date: Thu, 15 Dec 2016 10:46:01 -0800
Message-ID: <5852e4e9.f7koZfC+Xbc32PWg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48750 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754972AbcLOSqv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:46:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, cmetcalf@mellanox.com, dalias@libc.org, davem@davemloft.net, deller@gmx.de, dhowells@redhat.com, egtvedt@samfundet.no, geert@linux-m68k.org, james.hogan@imgtec.com, jcmvbkbc@gmail.com, jeffrey.t.kirsher@intel.com, jejb@parisc-linux.org, jonas@southpole.se, keguang.zhang@gmail.com, lftan@altera.com, linux@armlinux.org.uk, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, ralf@linux-mips.org, realmz6@gmail.com, rkuo@codeaurora.org, tklauser@distanz.ch, vgupta@synopsys.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add support for releasing multiple instances of a page
has been removed from the -mm tree.  Its filename was
     mm-add-support-for-releasing-multiple-instances-of-a-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -3925,6 +3925,20 @@ static struct page *__page_frag_refill(s
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


