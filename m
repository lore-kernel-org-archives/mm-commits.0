From: akpm@linux-foundation.org
Subject: - gru-driver-v2-export-is_uv_system-zap_page_range-follow_page.patch removed from -mm tree
Date: Tue, 01 Jul 2008 01:04:25 -0700
Message-ID: <200807010804.m6184P0T016401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755287AbYGAIEw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 04:04:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, andrea@qumranet.com, holt@sgi.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     GRU driver: Export is_uv_system(), zap_page_range() & follow_page()
has been removed from the -mm tree.  Its filename was
     gru-driver-v2-export-is_uv_system-zap_page_range-follow_page.patch

This patch was dropped because it needs mmu notifiers, which I don't have

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: GRU driver: Export is_uv_system(), zap_page_range() & follow_page()
From: Jack Steiner <steiner@sgi.com>

Exports for the GRU driver

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Robin Holt <holt@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/genapic_64.c |    1 +
 mm/memory.c                  |    2 ++
 2 files changed, 3 insertions(+)

diff -puN arch/x86/kernel/genapic_64.c~gru-driver-v2-export-is_uv_system-zap_page_range-follow_page arch/x86/kernel/genapic_64.c
--- a/arch/x86/kernel/genapic_64.c~gru-driver-v2-export-is_uv_system-zap_page_range-follow_page
+++ a/arch/x86/kernel/genapic_64.c
@@ -99,3 +99,4 @@ int is_uv_system(void)
 {
 	return uv_system_type != UV_NONE;
 }
+EXPORT_SYMBOL_GPL(is_uv_system);
diff -puN mm/memory.c~gru-driver-v2-export-is_uv_system-zap_page_range-follow_page mm/memory.c
--- a/mm/memory.c~gru-driver-v2-export-is_uv_system-zap_page_range-follow_page
+++ a/mm/memory.c
@@ -973,6 +973,7 @@ unsigned long zap_page_range(struct vm_a
 		tlb_finish_mmu(tlb, address, end);
 	return end;
 }
+EXPORT_SYMBOL_GPL(zap_page_range);
 
 /*
  * Do a quick page-table lookup for a single page.
@@ -1067,6 +1068,7 @@ no_page_table:
 	}
 	return page;
 }
+EXPORT_SYMBOL_GPL(follow_page);
 
 /* Can we do the FOLL_ANON optimization? */
 static inline int use_zero_page(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from steiner@sgi.com are

gru-driver-v2-export-is_uv_system-zap_page_range-follow_page.patch
gru-driver-v2-driver-misc-makefile-kconfig-changes.patch

