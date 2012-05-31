From: akpm@linux-foundation.org
Subject: [merged] mm-bootmemc-cleanup-on-addition-to-bootmem-data-list.patch removed from -mm tree
Date: Thu, 31 May 2012 12:16:14 -0700
Message-ID: <20120531191614.62289A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:63870 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932949Ab2EaTQQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:16:16 -0400
Received: by mail-fa0-f74.google.com with SMTP id a25so75263faa.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:16:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shangw@linux.vnet.ibm.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/bootmem.c: cleanup on addition to bootmem data list
has been removed from the -mm tree.  Its filename was
     mm-bootmemc-cleanup-on-addition-to-bootmem-data-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: mm/bootmem.c: cleanup on addition to bootmem data list

The objects of "struct bootmem_data_t" are linked together to form
double-linked list sequentially based on its minimal page frame number. 

The current implementation implicitly supports the following cases, which
means the inserting point for current bootmem data depends on how
"list_for_each" works.  That makes the code a little hard to read. 
Besides, "list_for_each" and "list_entry" can be replaced with
"list_for_each_entry".

        - The linked list is empty.
        - There has no entry in the linked list, whose minimal page
          frame number is bigger than current one.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/bootmem.c~mm-bootmemc-cleanup-on-addition-to-bootmem-data-list mm/bootmem.c
--- a/mm/bootmem.c~mm-bootmemc-cleanup-on-addition-to-bootmem-data-list
+++ a/mm/bootmem.c
@@ -77,16 +77,16 @@ unsigned long __init bootmem_bootmap_pag
  */
 static void __init link_bootmem(bootmem_data_t *bdata)
 {
-	struct list_head *iter;
+	bootmem_data_t *ent;
 
-	list_for_each(iter, &bdata_list) {
-		bootmem_data_t *ent;
