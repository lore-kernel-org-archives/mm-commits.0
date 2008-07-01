From: akpm@linux-foundation.org
Subject: + gru-driver-v2-export-is_uv_system-zap_page_range-follow_page.patch added to -mm tree
Date: Mon, 30 Jun 2008 22:30:49 -0700
Message-ID: <200807010530.m615UnnK010842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751062AbYGAFbH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 01:31:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com, andrea@qumranet.com, holt@sgi.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     GRU driver: Export is_uv_system(), zap_page_range() & follow_page()
has been added to the -mm tree.  Its filename is
     gru-driver-v2-export-is_uv_system-zap_page_range-follow_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

gru-driver-v2-hardware-data-structures.patch
gru-driver-v2-gru-instructions-macros.patch
gru-driver-v2-driver-internal-header-files.patch
gru-driver-v2-kernel-services-header-files.patch
gru-driver-v2-driver-initialization-file-vma-ops.patch
gru-driver-v2-page-faults-exceptions.patch
gru-driver-v2-kernel-services-provide-by-driver.patch
gru-driver-v2-resource-management.patch
gru-driver-v2-proc-interfaces.patch
gru-driver-v2-tlb-flushing-mmuops-callouts.patch
gru-driver-v2-driver-makefile.patch
gru-driver-v2-export-is_uv_system-zap_page_range-follow_page.patch
gru-driver-v2-driver-misc-makefile-kconfig-changes.patch

