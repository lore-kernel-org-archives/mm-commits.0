From: akpm@linux-foundation.org
Subject: + memory-hotplug-fix-early-allocation-handling.patch added to -mm tree
Date: Wed, 21 May 2008 15:08:12 -0700
Message-ID: <200805212208.m4LM8CHw003255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761485AbYEUWKZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 May 2008 18:10:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, apw@shadowen.org, gerald.schaefer@de.ibm.com, haveblue@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com


The patch titled
     memory hotplug: fix early allocation handling
has been added to the -mm tree.  Its filename is
     memory-hotplug-fix-early-allocation-handling.patch

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
+ 	if (!slab_is_available()) {
 		zone->wait_table = (wait_queue_head_t *)
 			alloc_bootmem_node(pgdat, alloc_size);
 	} else {
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
linux-next.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
memory-hotplug-fix-early-allocation-handling.patch

