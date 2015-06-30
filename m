From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch removed from -mm tree
Date: Tue, 30 Jun 2015 14:49:23 -0700
Message-ID: <55930ee3.nB2QNjLJgAx9owme%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbbF3Vt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jun 2015 17:49:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel@numascale.com, dave.hansen@intel.com, mgorman@suse.de, nzimmer@sgi.com, scott.norton@hp.com, waiman.long@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix
has been removed from the -mm tree.  Its filename was
     mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch

This patch was dropped because it was folded into mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix

include rwsem.h, use DECLARE_RWSEM, fix comment, remove unneeded cast

Cc: Daniel J Blueman <daniel@numascale.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Scott Norton <scott.norton@hp.com>
Cc: Waiman Long <waiman.long@hp.com>
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
@@ -1061,12 +1062,12 @@ static void __init deferred_free_range(s
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
@@ -1082,7 +1083,7 @@ static int __init deferred_init_memmap(v
 		return 0;
 	}
 
-	/* Bound memory initialisation to a local node if possible */
+	/* Bind memory initialisation thread to a local node if possible */
 	if (!cpumask_empty(cpumask))
 		set_cpus_allowed_ptr(current, cpumask);
 
@@ -1186,7 +1187,6 @@ void __init page_alloc_init_late(void)
 {
 	int nid;
 
-	init_rwsem(&pgdat_init_rwsem);
 	for_each_node_state(nid, N_MEMORY) {
 		down_read(&pgdat_init_rwsem);
 		kthread_run(deferred_init_memmap, NODE_DATA(nid), "pgdatinit%d", nid);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-meminit-inline-some-helper-functions.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
ipcshm-move-bug_on-check-into-shm_lock-fix.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix.patch

