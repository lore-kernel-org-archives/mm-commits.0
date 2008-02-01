From: akpm@linux-foundation.org
Subject: - config_highpte-vs-sub-page-page-tables-fix.patch removed from -mm tree
Date: Fri, 01 Feb 2008 15:07:37 -0800
Message-ID: <200802012316.m11NGKpP003683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42173 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755740AbYBAXRP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 18:17:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schwidefsky@de.ibm.com, kamalesh@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     config_highpte-vs-sub-page-page-tables fix
has been removed from the -mm tree.  Its filename was
     config_highpte-vs-sub-page-page-tables-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: config_highpte-vs-sub-page-page-tables fix
From: Martin Schwidefsky <schwidefsky@de.ibm.com>

On Tue, 2007-11-13 at 20:13 +0530, Kamalesh Babulal wrote:
> Hi Andrew,
>
> The kernel build fails, with following build error
>
> mm/memory.c: In function `free_pte_range':
> mm/memory.c:126: error: implicit declaration of function `pmd_pgtable'
> mm/memory.c:126: warning: initialization makes pointer from integer without a cast
> mm/memory.c: In function `apply_to_pte_range':
> mm/memory.c:1389: warning: assignment makes pointer from integer without a cast
> make[1]: *** [mm/memory.o] Error 1
> make: *** [mm] Error 2
>
> The patch causing this issue is config_highpte-vs-sub-page-page-tables.patch.
> Where the marco is defined #ifndef CONFIG_PPC_64K_PAGES.

Forget the request for the .config. Found the problem, fixup patch
below.

Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/pgalloc-64.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-powerpc/pgalloc-64.h~config_highpte-vs-sub-page-page-tables-fix include/asm-powerpc/pgalloc-64.h
--- a/include/asm-powerpc/pgalloc-64.h~config_highpte-vs-sub-page-page-tables-fix
+++ a/include/asm-powerpc/pgalloc-64.h
@@ -68,6 +68,7 @@ static inline void pmd_populate_kernel(s
 
 #define pmd_populate(mm, pmd, pte_page) \
 	pmd_populate_kernel(mm, pmd, page_address(pte_page))
+#define pmd_pgtable(pmd) pmd_page(pmd)
 
 #endif /* CONFIG_PPC_64K_PAGES */
 
_

Patches currently in -mm which might be from schwidefsky@de.ibm.com are

origin.patch
timerfd-v3-new-timerfd-api-arch-fixes.patch
git-s390.patch
git-sched.patch
config_highpte-vs-sub-page-page-tables-fix.patch
config_highpte-vs-sub-page-page-tables-fix-2.patch
config_highpte-vs-sub-page-page-tables-avr32-fix.patch
arch_rebalance_pgtables-call.patch
taskstats-scaled-time-cleanup.patch
calibrate_delay-must-be-__cpuinit.patch
unexport-asm-pageh.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-s390.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
tty-let-architectures-override-the-user-kernel-macros.patch
tty-s390-support-for-termios2.patch
