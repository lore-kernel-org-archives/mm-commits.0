From: akpm@linux-foundation.org
Subject: - mm-bootmem-silence-section-mismatch-warning-contig_page_data-bootmem_node_data.patch removed from -mm tree
Date: Wed, 03 Sep 2008 09:11:09 -0700
Message-ID: <200809031611.m83GB96k023750@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbYICQLb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 12:11:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, hannes@saeurebad.de, sam@ravnborg.org, smaclennan@pikatech.com, mm-commits@vger.kernel.org


The patch titled
     mm/bootmem: silence section mismatch warning - contig_page_data/bootmem_node_data
has been removed from the -mm tree.  Its filename was
     mm-bootmem-silence-section-mismatch-warning-contig_page_data-bootmem_node_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/bootmem: silence section mismatch warning - contig_page_data/bootmem_node_data
From: Marcin Slusarz <marcin.slusarz@gmail.com>

WARNING: vmlinux.o(.data+0x1f5c0): Section mismatch in reference from the variable contig_page_data to the variable .init.data:bootmem_node_data
The variable contig_page_data references
the variable __initdata bootmem_node_data
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Johannes Weiner <hannes@saeurebad.de>
Cc: Sean MacLennan <smaclennan@pikatech.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-bootmem-silence-section-mismatch-warning-contig_page_data-bootmem_node_data mm/page_alloc.c
--- a/mm/page_alloc.c~mm-bootmem-silence-section-mismatch-warning-contig_page_data-bootmem_node_data
+++ a/mm/page_alloc.c
@@ -4071,7 +4071,7 @@ void __init set_dma_reserve(unsigned lon
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-struct pglist_data contig_page_data = { .bdata = &bootmem_node_data[0] };
+struct pglist_data __refdata contig_page_data = { .bdata = &bootmem_node_data[0] };
 EXPORT_SYMBOL(contig_page_data);
 #endif
 
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
linux-next.patch

