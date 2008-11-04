From: akpm@linux-foundation.org
Subject: - x86-convert-highmem-macros-to-functions.patch removed from -mm tree
Date: Tue, 04 Nov 2008 11:57:58 -0800
Message-ID: <200811041957.mA4JvwTH029395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753751AbYKDT6M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2008 14:58:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     x86: convert highmem macros to functions
has been removed from the -mm tree.  Its filename was
     x86-convert-highmem-macros-to-functions.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: convert highmem macros to functions
From: Marcin Slusarz <marcin.slusarz@gmail.com>

convert kmap_init, permanent_kmaps_init, set_highmem_pages_init macros
defined when !CONFIG_HIGHMEM to functions

supresses following warning from gcc:
arch/x86/mm/init_32.c: In function 'pagetable_init':
arch/x86/mm/init_32.c:516: warning: unused variable 'pgd_base'

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_32.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/mm/init_32.c~x86-convert-highmem-macros-to-functions arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~x86-convert-highmem-macros-to-functions
+++ a/arch/x86/mm/init_32.c
@@ -436,9 +436,9 @@ static void __init set_highmem_pages_ini
 #endif /* !CONFIG_NUMA */
 
 #else
-# define kmap_init()				do { } while (0)
-# define permanent_kmaps_init(pgd_base)		do { } while (0)
-# define set_highmem_pages_init()	do { } while (0)
+static inline void kmap_init(void) {}
+static inline void permanent_kmaps_init(pgd_t *pgd_base) {}
+static inline void set_highmem_pages_init(void) {}
 #endif /* CONFIG_HIGHMEM */
 
 void __init native_pagetable_setup_start(pgd_t *base)
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
x86-convert-highmem-macros-to-functions.patch

