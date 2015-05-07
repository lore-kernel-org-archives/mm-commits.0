From: akpm@linux-foundation.org
Subject: +
 mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch added to -mm tree
Date: Thu, 07 May 2015 15:09:43 -0700
Message-ID: <554be2a7.+W628Mf+Brnk7aHC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbbEGWJo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2015 18:09:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel@numascale.com, dave.hansen@intel.com, mgorman@suse.de, nzimmer@sgi.com, scott.norton@hp.com, waiman.long@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix
has been added to the -mm tree.  Its filename is
     mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix

include rwsem.h, use DECLARE_RWSEM, fix comment, remove unneeded cast

Cc: Daniel J Blueman <daniel@numascale.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Scott Norton <scott.norton@hp.com>
Cc: Waiman Long <waiman.long@hp.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix
+++ a/mm/page_alloc.c
@@ -18,6 +18,7 @@
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/interrupt.h>
+#include <linux/rwsem.h>
 #include <linux/pagemap.h>
 #include <linux/jiffies.h>
 #include <linux/bootmem.h>
@@ -1075,12 +1076,12 @@ static void __init deferred_free_range(s
 		__free_pages_boot_core(page, pfn, 0);
 }
 
-static struct rw_semaphore __initdata pgdat_init_rwsem;
+static __initdata DECLARE_RWSEM(pgdat_init_rwsem);
 
 /* Initialise remaining memory on a node */
 static int __init deferred_init_memmap(void *data)
 {
-	pg_data_t *pgdat = (pg_data_t *)data;
+	pg_data_t *pgdat = data;
 	int nid = pgdat->node_id;
 	struct mminit_pfnnid_cache nid_init_state = { };
 	unsigned long start = jiffies;
@@ -1096,7 +1097,7 @@ static int __init deferred_init_memmap(v
 		return 0;
 	}
 
-	/* Bound memory initialisation to a local node if possible */
+	/* Bind memory initialisation thread to a local node if possible */
 	if (!cpumask_empty(cpumask))
 		set_cpus_allowed_ptr(current, cpumask);
 
@@ -1200,7 +1201,6 @@ void __init page_alloc_init_late(void)
 {
 	int nid;
 
-	init_rwsem(&pgdat_init_rwsem);
 	for_each_node_state(nid, N_MEMORY) {
 		down_read(&pgdat_init_rwsem);
 		kthread_run(deferred_init_memmap, NODE_DATA(nid), "pgdatinit%d", nid);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-rtc-rtc-armada38xc-remove-unused-local-flags.patch
gfp-add-__gfp_noaccount-v2-fix.patch
cma-page_isolation-check-buddy-before-access-it-fix.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
linux-next-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

