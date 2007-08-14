From: akpm@linux-foundation.org
Subject: - x86_64-use-wbinvd-macro-instead-of-raw-inline-assembly-in-c-files.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:14:03 -0700
Message-ID: <200708141914.l7EJE3jI016573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44970 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765480AbXHNTUh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:20:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gcosta@redhat.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: use wbinvd() macro instead of raw inline assembly in .c files
has been removed from the -mm tree.  Its filename was
     x86_64-use-wbinvd-macro-instead-of-raw-inline-assembly-in-c-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: use wbinvd() macro instead of raw inline assembly in .c files
From: Glauber de Oliveira Costa <gcosta@redhat.com>

This patch uses the already-existant wbinvd() macro to replace
raw assembly to perform this very same task in some .c files

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/tce.c  |    2 +-
 arch/x86_64/mm/pageattr.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/kernel/tce.c~x86_64-use-wbinvd-macro-instead-of-raw-inline-assembly-in-c-files arch/x86_64/kernel/tce.c
--- a/arch/x86_64/kernel/tce.c~x86_64-use-wbinvd-macro-instead-of-raw-inline-assembly-in-c-files
+++ a/arch/x86_64/kernel/tce.c
@@ -42,7 +42,7 @@ static inline void flush_tce(void* tcead
 	if (cpu_has_clflush)
 		asm volatile("clflush (%0)" :: "r" (tceaddr));
 	else
-		asm volatile("wbinvd":::"memory");
+		wbinvd();
 }
 
 void tce_build(struct iommu_table *tbl, unsigned long index,
diff -puN arch/x86_64/mm/pageattr.c~x86_64-use-wbinvd-macro-instead-of-raw-inline-assembly-in-c-files arch/x86_64/mm/pageattr.c
--- a/arch/x86_64/mm/pageattr.c~x86_64-use-wbinvd-macro-instead-of-raw-inline-assembly-in-c-files
+++ a/arch/x86_64/mm/pageattr.c
@@ -76,7 +76,7 @@ static void flush_kernel_map(void *arg)
 	/* When clflush is available always use it because it is
 	   much cheaper than WBINVD. */
 	if (!cpu_has_clflush)
-		asm volatile("wbinvd" ::: "memory");
+		wbinvd();
 	else list_for_each_entry(pg, l, lru) {
 		void *adr = page_address(pg);
 		cache_flush_page(adr);
_

Patches currently in -mm which might be from gcosta@redhat.com are
