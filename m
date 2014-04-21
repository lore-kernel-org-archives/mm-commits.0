From: akpm@linux-foundation.org
Subject: [merged] mips-export-flush_icache_range.patch removed from -mm
 tree
Date: Mon, 21 Apr 2014 11:11:07 -0700
Message-ID: <53555f3b.To7d+JIBH8wgOD0r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbaDUSLI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 14:11:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergei.shtylyov@cogentembedded.com, sanjayl@kymasys.com, ralf@linux-mips.org, paul.gortmaker@windriver.com, blogic@openwrt.org, keescook@chromium.org

Subject: [merged] mips-export-flush_icache_range.patch removed from -mm tree
To: keescook@chromium.org,blogic@openwrt.org,paul.gortmaker@windriver.com,ralf@linux-mips.org,sanjayl@kymasys.com,sergei.shtylyov@cogentembedded.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 11:11:07 -0700


The patch titled
     Subject: mips: export flush_icache_range
has been removed from the -mm tree.  Its filename was
     mips-export-flush_icache_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mips: export flush_icache_range

The lkdtm module performs tests against executable memory ranges, so it
needs to flush the icache for proper behaviors.  Other architectures
already export this, so do the same for MIPS.

[akpm@linux-foundation.org: relocate export sites]
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Sanjay Lal <sanjayl@kymasys.com>
Cc: John Crispin <blogic@openwrt.org>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/cache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/mips/mm/cache.c~mips-export-flush_icache_range arch/mips/mm/cache.c
--- a/arch/mips/mm/cache.c~mips-export-flush_icache_range
+++ a/arch/mips/mm/cache.c
@@ -29,15 +29,15 @@ void (*flush_cache_range)(struct vm_area
 void (*flush_cache_page)(struct vm_area_struct *vma, unsigned long page,
 	unsigned long pfn);
 void (*flush_icache_range)(unsigned long start, unsigned long end);
+EXPORT_SYMBOL_GPL(flush_icache_range);
 void (*local_flush_icache_range)(unsigned long start, unsigned long end);
 
 void (*__flush_cache_vmap)(void);
 void (*__flush_cache_vunmap)(void);
 
 void (*__flush_kernel_vmap_range)(unsigned long vaddr, int size);
-void (*__invalidate_kernel_vmap_range)(unsigned long vaddr, int size);
