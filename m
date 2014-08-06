From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
 removed from -mm tree
Date: Wed, 06 Aug 2014 15:48:48 -0700
Message-ID: <53e2b0d0.fs7ZH00e35JZ46My%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:55422 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaHFWst (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:48:49 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so613043oac.3
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:48:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix
has been removed from the -mm tree.  Its filename was
     mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch

This patch was dropped because it was folded into mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix

fix non-numa build

mm/oom_kill.c: In function 'pagefault_out_of_memory':
mm/oom_kill.c:697: error: 'first_memory_node' undeclared (first use in this function)
mm/oom_kill.c:697: error: (Each undeclared identifier is reported only once
mm/oom_kill.c:697: error: for each function it appears in.)

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/nodemask.h~mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix include/linux/nodemask.h
--- a/include/linux/nodemask.h~mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix
+++ a/include/linux/nodemask.h
@@ -479,6 +479,7 @@ static inline int num_node_state(enum no
 	for ( (node) = 0; (node) == 0; (node) = 1)
 
 #define first_online_node	0
+#define first_memory_node	0
 #define next_online_node(nid)	(MAX_NUMNODES)
 #define nr_node_ids		1
 #define nr_online_nodes		1
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fsnotify-rename-event-handling-functions.patch
kbuild-explain-stack-protector-strong-config-logic.patch
slub-use-new-node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch

