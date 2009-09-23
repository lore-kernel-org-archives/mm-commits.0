From: akpm@linux-foundation.org
Subject: + ksm-change-default-values-to-better-fit-into-mainline-kernel.patch added to -mm tree
Date: Wed, 23 Sep 2009 13:37:45 -0700
Message-ID: <200909232037.n8NKbjvl022589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441AbZIWUh5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:37:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ieidus@redhat.com, aarcange@redhat.com, hugh.dickins@tiscali.co.uk


The patch titled
     ksm: change default values to better fit into mainline kernel
has been added to the -mm tree.  Its filename is
     ksm-change-default-values-to-better-fit-into-mainline-kernel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: change default values to better fit into mainline kernel
From: Izik Eidus <ieidus@redhat.com>

Now that ksm is in mainline it is better to change the default values to
better fit to most of the users.

This patch change the ksm default values to be:
ksm_thread_pages_to_scan = 100 (instead of 200)
ksm_thread_sleep_millisecs = 20 (like before)
ksm_run = KSM_RUN_STOP (instead of KSM_RUN_MERGE - meaning ksm is
                        disabled by default)
ksm_max_kernel_pages = nr_free_buffer_pages / 4 (instead of 2046)

The important aspect of this patch is: it disables ksm by default, and sets
the number of the kernel_pages that can be allocated to be a reasonable
number.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN mm/ksm.c~ksm-change-default-values-to-better-fit-into-mainline-kernel mm/ksm.c
--- a/mm/ksm.c~ksm-change-default-values-to-better-fit-into-mainline-kernel
+++ a/mm/ksm.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/rbtree.h>
 #include <linux/mmu_notifier.h>
+#include <linux/swap.h>
 #include <linux/ksm.h>
 
 #include <asm/tlbflush.h>
@@ -162,10 +163,10 @@ static unsigned long ksm_pages_unshared;
 static unsigned long ksm_rmap_items;
 
 /* Limit on the number of unswappable pages used */
-static unsigned long ksm_max_kernel_pages = 2000;
+static unsigned long ksm_max_kernel_pages;
 
 /* Number of pages ksmd should scan in one batch */
-static unsigned int ksm_thread_pages_to_scan = 200;
+static unsigned int ksm_thread_pages_to_scan = 100;
 
 /* Milliseconds ksmd should sleep between batches */
 static unsigned int ksm_thread_sleep_millisecs = 20;
@@ -173,7 +174,7 @@ static unsigned int ksm_thread_sleep_mil
 #define KSM_RUN_STOP	0
 #define KSM_RUN_MERGE	1
 #define KSM_RUN_UNMERGE	2
-static unsigned int ksm_run = KSM_RUN_MERGE;
+static unsigned int ksm_run = KSM_RUN_STOP;
 
 static DECLARE_WAIT_QUEUE_HEAD(ksm_thread_wait);
 static DEFINE_MUTEX(ksm_thread_mutex);
@@ -183,6 +184,11 @@ static DEFINE_SPINLOCK(ksm_mmlist_lock);
 		sizeof(struct __struct), __alignof__(struct __struct),\
 		(__flags), NULL)
 
+static void __init ksm_init_max_kernel_pages(void)
+{
+	ksm_max_kernel_pages = nr_free_buffer_pages() / 4;
+}
+
 static int __init ksm_slab_init(void)
 {
 	rmap_item_cache = KSM_KMEM_CACHE(rmap_item, 0);
@@ -1667,6 +1673,8 @@ static int __init ksm_init(void)
 	struct task_struct *ksm_thread;
 	int err;
 
+	ksm_init_max_kernel_pages();
+
 	err = ksm_slab_init();
 	if (err)
 		goto out;
_

Patches currently in -mm which might be from ieidus@redhat.com are

origin.patch
ksm-change-default-values-to-better-fit-into-mainline-kernel.patch

