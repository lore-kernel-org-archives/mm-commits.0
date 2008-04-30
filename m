From: akpm@linux-foundation.org
Subject: - ipc-define-the-slab_memory_callback-priority-as-a-constant.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:43:54 -0700
Message-ID: <200804300543.m3U5hsCv029351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758508AbYD3FpA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:45:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, cmm@us.ibm.com, matthltc@us.ibm.com, pierre.peiffer@bull.net, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     ipc: define the slab_memory_callback priority as a constant
has been removed from the -mm tree.  Its filename was
     ipc-define-the-slab_memory_callback-priority-as-a-constant.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: define the slab_memory_callback priority as a constant
From: Nadia Derbey <Nadia.Derbey@bull.net>

This is a trivial patch that defines the priority of slab_memory_callback in
the callback chain as a constant.  This is to prepare for next patch in the
series.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Pierre Peiffer <pierre.peiffer@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory.h |    6 ++++++
 mm/slub.c              |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/memory.h~ipc-define-the-slab_memory_callback-priority-as-a-constant include/linux/memory.h
--- a/include/linux/memory.h~ipc-define-the-slab_memory_callback-priority-as-a-constant
+++ a/include/linux/memory.h
@@ -53,6 +53,12 @@ struct memory_notify {
 struct notifier_block;
 struct mem_section;
 
+/*
+ * Priorities for the hotplug memory callback routines (stored in decreasing
+ * order in the callback chain)
+ */
+#define SLAB_CALLBACK_PRI       1
+
 #ifndef CONFIG_MEMORY_HOTPLUG_SPARSE
 static inline int memory_dev_init(void)
 {
diff -puN mm/slub.c~ipc-define-the-slab_memory_callback-priority-as-a-constant mm/slub.c
--- a/mm/slub.c~ipc-define-the-slab_memory_callback-priority-as-a-constant
+++ a/mm/slub.c
@@ -2924,7 +2924,7 @@ void __init kmem_cache_init(void)
 	kmalloc_caches[0].refcount = -1;
 	caches++;
 
-	hotplug_memory_notifier(slab_memory_callback, 1);
+	hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
 #endif
 
 	/* Able to allocate the per node structures */
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch
idr-fix-idr_remove.patch
idr-introduce-the-ridr-structure.patch
idr-introduce-ridr_pre_get.patch
idr-introduce-ridr_init.patch
idr-introduce-ridr_get_new_above.patch
idr-introduce-ridr_get_new.patch
idr-introduce-ridr_find.patch
idr-introduce-ridr_remove.patch
ipc-integrate-the-ridr-code-into-ipc-code.patch
ipc-get-rid-of-ipc_lock_down.patch

