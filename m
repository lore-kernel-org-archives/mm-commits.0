From: akpm@linux-foundation.org
Subject: [merged] mm-nommu-export-symbol-max_mapnr.patch removed from -mm
 tree
Date: Mon, 16 Mar 2015 11:02:46 -0700
Message-ID: <55071ac6.u58CmsUVtN5gxAVx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33555 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933115AbbCPSCq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Mar 2015 14:02:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xili_gchen_5257@hotmail.com, a-jacquiot@ti.com, gang.chen.5i5j@gmail.com, msalter@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nommu.c: export symbol max_mapnr
has been removed from the -mm tree.  Its filename was
     mm-nommu-export-symbol-max_mapnr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: gchen gchen <xili_gchen_5257@hotmail.com>
Subject: mm/nommu.c: export symbol max_mapnr

Several modules may need max_mapnr, so export, the related error with
allmodconfig under c6x:

MODPOST 3327 modules
ERROR: "max_mapnr" [fs/pstore/ramoops.ko] undefined!
ERROR: "max_mapnr" [drivers/media/v4l2-core/videobuf2-dma-contig.ko] undefined!

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/nommu.c~mm-nommu-export-symbol-max_mapnr mm/nommu.c
--- a/mm/nommu.c~mm-nommu-export-symbol-max_mapnr
+++ a/mm/nommu.c
@@ -62,6 +62,7 @@ void *high_memory;
 EXPORT_SYMBOL(high_memory);
 struct page *mem_map;
 unsigned long max_mapnr;
+EXPORT_SYMBOL(max_mapnr);
 unsigned long highest_memmap_pfn;
 struct percpu_counter vm_committed_as;
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
_

Patches currently in -mm which might be from xili_gchen_5257@hotmail.com are

linux-next.patch

