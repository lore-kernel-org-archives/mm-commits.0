From: akpm@linux-foundation.org
Subject: - memory-hotplug-fix-early-allocation-handling.patch removed from -mm tree
Date: Tue, 27 May 2008 00:27:51 -0700
Message-ID: <200805270727.m4R7RpFg014799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756076AbYE0Har (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:30:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, apw@shadowen.org, gerald.schaefer@de.ibm.com, haveblue@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memory hotplug: fix early allocation handling
has been removed from the -mm tree.  Its filename was
     memory-hotplug-fix-early-allocation-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: fix early allocation handling
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Trying to add memory via add_memory() from within an initcall function
results in

bootmem alloc of 163840 bytes failed!
Kernel panic - not syncing: Out of memory

This is caused by zone_wait_table_init() which uses system_state to decide
if it should use the bootmem allocator or not.

When initcalls are handled the system_state is still SYSTEM_BOOTING but
the bootmem allocator doesn't work anymore.  So the allocation will fail.

To fix this use slab_is_available() instead as indicator like we do it
everywhere else.

[akpm@linux-foundation.org: coding-style fix]
Reviewed-by: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~memory-hotplug-fix-early-allocation-handling mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-fix-early-allocation-handling
+++ a/mm/page_alloc.c
@@ -2807,7 +2807,7 @@ int zone_wait_table_init(struct zone *zo
 	alloc_size = zone->wait_table_hash_nr_entries
 					* sizeof(wait_queue_head_t);
 
- 	if (system_state == SYSTEM_BOOTING) {
+	if (!slab_is_available()) {
 		zone->wait_table = (wait_queue_head_t *)
 			alloc_bootmem_node(pgdat, alloc_size);
 	} else {
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

linux-next.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch

