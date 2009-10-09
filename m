From: akpm@linux-foundation.org
Subject: [merged] ksm-more-on-default-values.patch removed from -mm tree
Date: Fri, 09 Oct 2009 15:04:47 -0700
Message-ID: <200910092204.n99M4leZ020004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934301AbZJIWFl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 18:05:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: more on default values
has been removed from the -mm tree.  Its filename was
     ksm-more-on-default-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: more on default values
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Adjust the max_kernel_pages default to a quarter of totalram_pages,
instead of nr_free_buffer_pages() / 4: the KSM pages themselves come from
highmem, and even on a 16GB PAE machine, 4GB of KSM pages would only be
pinning 32MB of lowmem with their rmap_items, so no need for the more
obscure calculation (nor for its own special init function).

There is no way for the user to switch KSM on if CONFIG_SYSFS is not
enabled, so in that case default run to KSM_RUN_MERGE.

Update KSM Documentation and Kconfig to reflect the new defaults.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/vm/ksm.txt~ksm-more-on-default-values Documentation/vm/ksm.txt
--- a/Documentation/vm/ksm.txt~ksm-more-on-default-values
+++ a/Documentation/vm/ksm.txt
@@ -52,15 +52,15 @@ The KSM daemon is controlled by sysfs fi
 readable by all but writable only by root:
 
 max_kernel_pages - set to maximum number of kernel pages that KSM may use
-                   e.g. "echo 2000 > /sys/kernel/mm/ksm/max_kernel_pages"
+                   e.g. "echo 100000 > /sys/kernel/mm/ksm/max_kernel_pages"
                    Value 0 imposes no limit on the kernel pages KSM may use;
                    but note that any process using MADV_MERGEABLE can cause
                    KSM to allocate these pages, unswappable until it exits.
-                   Default: 2000 (chosen for demonstration purposes)
+                   Default: quarter of memory (chosen to not pin too much)
 
 pages_to_scan    - how many present pages to scan before ksmd goes to sleep
-                   e.g. "echo 200 > /sys/kernel/mm/ksm/pages_to_scan"
-                   Default: 200 (chosen for demonstration purposes)
+                   e.g. "echo 100 > /sys/kernel/mm/ksm/pages_to_scan"
+                   Default: 100 (chosen for demonstration purposes)
 
 sleep_millisecs  - how many milliseconds ksmd should sleep before next scan
                    e.g. "echo 20 > /sys/kernel/mm/ksm/sleep_millisecs"
@@ -70,7 +70,8 @@ run              - set 0 to stop ksmd fr
                    set 1 to run ksmd e.g. "echo 1 > /sys/kernel/mm/ksm/run",
                    set 2 to stop ksmd and unmerge all pages currently merged,
                          but leave mergeable areas registered for next run
-                   Default: 1 (for immediate use by apps which register)
+                   Default: 0 (must be changed to 1 to activate KSM,
+                               except if CONFIG_SYSFS is disabled)
 
 The effectiveness of KSM and MADV_MERGEABLE is shown in /sys/kernel/mm/ksm/:
 
@@ -86,4 +87,4 @@ pages_volatile embraces several differen
 proportion there would also indicate poor use of madvise MADV_MERGEABLE.
 
 Izik Eidus,
-Hugh Dickins, 30 July 2009
+Hugh Dickins, 24 Sept 2009
diff -puN mm/Kconfig~ksm-more-on-default-values mm/Kconfig
--- a/mm/Kconfig~ksm-more-on-default-values
+++ a/mm/Kconfig
@@ -224,7 +224,9 @@ config KSM
 	  the many instances by a single resident page with that content, so
 	  saving memory until one or another app needs to modify the content.
 	  Recommended for use with KVM, or with other duplicative applications.
-	  See Documentation/vm/ksm.txt for more information.
+	  See Documentation/vm/ksm.txt for more information: KSM is inactive
+	  until a program has madvised that an area is MADV_MERGEABLE, and
+	  root has set /sys/kernel/mm/ksm/run to 1 (if CONFIG_SYSFS is set).
 
 config DEFAULT_MMAP_MIN_ADDR
         int "Low address space to protect from user allocation"
diff -puN mm/ksm.c~ksm-more-on-default-values mm/ksm.c
--- a/mm/ksm.c~ksm-more-on-default-values
+++ a/mm/ksm.c
@@ -184,11 +184,6 @@ static DEFINE_SPINLOCK(ksm_mmlist_lock);
 		sizeof(struct __struct), __alignof__(struct __struct),\
 		(__flags), NULL)
 
-static void __init ksm_init_max_kernel_pages(void)
-{
-	ksm_max_kernel_pages = nr_free_buffer_pages() / 4;
-}
-
 static int __init ksm_slab_init(void)
 {
 	rmap_item_cache = KSM_KMEM_CACHE(rmap_item, 0);
@@ -1673,7 +1668,7 @@ static int __init ksm_init(void)
 	struct task_struct *ksm_thread;
 	int err;
 
-	ksm_init_max_kernel_pages();
+	ksm_max_kernel_pages = totalram_pages / 4;
 
 	err = ksm_slab_init();
 	if (err)
@@ -1697,6 +1692,9 @@ static int __init ksm_init(void)
 		kthread_stop(ksm_thread);
 		goto out_free2;
 	}
+#else
+	ksm_run = KSM_RUN_MERGE;	/* no way for user to start it */
+
 #endif /* CONFIG_SYSFS */
 
 	return 0;
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
munmap-dont-check-sysctl_max_mapcount.patch
munmap-dont-check-sysctl_max_mapcount-fix.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

