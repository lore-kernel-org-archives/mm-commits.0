From: akpm@linux-foundation.org
Subject: + ipc-define-the-slab_memory_callback-priority-as-a-constant.patch added to -mm tree
Date: Mon, 11 Feb 2008 12:46:22 -0800
Message-ID: <200802112046.m1BKkMre032122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51490 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026AbYBKVHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 16:07:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, cmm@us.ibm.com, matthltc@us.ibm.com, pierre.peiffer@bull.net, y-goto@jp.fujitsu.com


The patch titled
     ipc: define the slab_memory_callback priority as a constant
has been added to the -mm tree.  Its filename is
     ipc-define-the-slab_memory_callback-priority-as-a-constant.patch

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
@@ -2983,7 +2983,7 @@ void __init kmem_cache_init(void)
 	kmalloc_caches[0].refcount = -1;
 	caches++;
 
-	hotplug_memory_notifier(slab_memory_callback, 1);
+	hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
 #endif
 
 	/* Able to allocate the per node structures */
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch
ipc-use-ipc_buildid-directly-from-ipc_addid.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-scale-msgmni-to-the-amount-of-lowmem.patch
ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch
ipc-define-the-slab_memory_callback-priority-as-a-constant.patch
ipc-recompute-msgmni-on-memory-add--remove.patch
ipc-invoke-the-ipcns-notifier-chain-as-a-work-item.patch
ipc-recompute-msgmni-on-ipc-namespace-creation-removal.patch
ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user.patch
ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative.patch
