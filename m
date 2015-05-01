From: akpm@linux-foundation.org
Subject: + sparc-use-for_each_sg.patch added to -mm tree
Date: Fri, 01 May 2015 14:40:28 -0700
Message-ID: <5543f2cc.GVW1YBvX2NsAc1JA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbbEAVk3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 May 2015 17:40:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc: use for_each_sg()
has been added to the -mm tree.  Its filename is
     sparc-use-for_each_sg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sparc-use-for_each_sg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sparc-use-for_each_sg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: sparc: use for_each_sg()

This replaces the plain loop over the sglist array with for_each_sg()
macro which consists of sg_next() function calls.  Since sparc does select
ARCH_HAS_SG_CHAIN, it is necessary to use for_each_sg() in order to loop
over each sg element.  This also help find problems with drivers that do
not properly initialize their sg tables when CONFIG_DEBUG_SG is enabled.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/ldc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN arch/sparc/kernel/ldc.c~sparc-use-for_each_sg arch/sparc/kernel/ldc.c
--- a/arch/sparc/kernel/ldc.c~sparc-use-for_each_sg
+++ a/arch/sparc/kernel/ldc.c
@@ -2086,6 +2086,7 @@ int ldc_map_sg(struct ldc_channel *lp,
 	struct cookie_state state;
 	struct ldc_iommu *iommu;
 	int err;
+	struct scatterlist *s;
 
 	if (map_perm & ~LDC_MAP_ALL)
 		return -EINVAL;
@@ -2112,9 +2113,10 @@ int ldc_map_sg(struct ldc_channel *lp,
 	state.pte_idx = (base - iommu->page_table);
 	state.nc = 0;
 
-	for (i = 0; i < num_sg; i++)
-		fill_cookies(&state, page_to_pfn(sg_page(&sg[i])) << PAGE_SHIFT,
-			     sg[i].offset, sg[i].length);
+	for_each_sg(sg, s, num_sg, i) {
+		fill_cookies(&state, page_to_pfn(sg_page(s)) << PAGE_SHIFT,
+			     s->offset, s->length);
+	}
 
 	return state.nc;
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

lib-scatterlist-fix-kerneldoc-for-sg_pcopy_tofrom_buffer.patch
lib-scatterlist-mark-input-buffer-parameters-as-const.patch
linux-next.patch
m68k-use-for_each_sg.patch
arc-use-for_each_sg.patch
metag-use-for_each_sg.patch
xtensa-use-for_each_sg.patch
mips-use-for_each_sg.patch
frv-use-for_each_sg.patch
avr32-use-for_each_sg.patch
powerpc-use-for_each_sg.patch
sparc-use-for_each_sg.patch
parisc-use-for_each_sg.patch

