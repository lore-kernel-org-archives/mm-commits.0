From: akpm@linux-foundation.org
Subject: - gru-driver-v3-export-is_uv_system-zap_page_range-follow_page.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:16:11 -0700
Message-ID: <200807301916.m6UJGBv6011103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752861AbYG3TRG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:17:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     GRU Driver: export is_uv_system(), zap_page_range() & follow_page()
has been removed from the -mm tree.  Its filename was
     gru-driver-v3-export-is_uv_system-zap_page_range-follow_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: GRU Driver: export is_uv_system(), zap_page_range() & follow_page()
From: Jack Steiner <steiner@sgi.com>

Exports needed by the GRU driver.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/genapic_64.c |    1 +
 mm/memory.c                  |    2 ++
 2 files changed, 3 insertions(+)

diff -puN arch/x86/kernel/genapic_64.c~gru-driver-v3-export-is_uv_system-zap_page_range-follow_page arch/x86/kernel/genapic_64.c
--- a/arch/x86/kernel/genapic_64.c~gru-driver-v3-export-is_uv_system-zap_page_range-follow_page
+++ a/arch/x86/kernel/genapic_64.c
@@ -99,3 +99,4 @@ int is_uv_system(void)
 {
 	return uv_system_type != UV_NONE;
 }
+EXPORT_SYMBOL_GPL(is_uv_system);
diff -puN mm/memory.c~gru-driver-v3-export-is_uv_system-zap_page_range-follow_page mm/memory.c
--- a/mm/memory.c~gru-driver-v3-export-is_uv_system-zap_page_range-follow_page
+++ a/mm/memory.c
@@ -993,6 +993,7 @@ unsigned long zap_page_range(struct vm_a
 		tlb_finish_mmu(tlb, address, end);
 	return end;
 }
+EXPORT_SYMBOL_GPL(zap_page_range);
 
 /**
  * zap_vma_ptes - remove ptes mapping the vma
@@ -1110,6 +1111,7 @@ no_page_table:
 	}
 	return page;
 }
+EXPORT_SYMBOL_GPL(follow_page);
 
 /* Can we do the FOLL_ANON optimization? */
 static inline int use_zero_page(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch
linux-next.patch

