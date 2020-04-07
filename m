From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 014/166] mm/migrate.c: check pagelist in
 move_pages_and_store_status()
Date: Mon, 06 Apr 2020 20:04:15 -0700
Message-ID: <20200407030415.P_Ho3gLkV%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgDGDES (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:04:18 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com, torvalds@linux-foundation.org

From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm/migrate.c: check pagelist in move_pages_and_store_status()

When pagelist is empty, it is not necessary to do the move and store. 
Also it consolidate the empty list check in one place.

Link: http://lkml.kernel.org/r/20200214003017.25558-4-richardw.yang@linux.intel.com
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/migrate.c~mm-migratec-check-pagelist-in-move_pages_and_store_status
+++ a/mm/migrate.c
@@ -1518,9 +1518,6 @@ static int do_move_pages_to_node(struct
 {
 	int err;
 
-	if (list_empty(pagelist))
-		return 0;
-
 	err = migrate_pages(pagelist, alloc_new_node_page, NULL, node,
 			MIGRATE_SYNC, MR_SYSCALL);
 	if (err)
@@ -1608,6 +1605,9 @@ static int move_pages_and_store_status(s
 {
 	int err;
 
+	if (list_empty(pagelist))
+		return 0;
+
 	err = do_move_pages_to_node(mm, pagelist, node);
 	if (err) {
 		/*
@@ -1705,9 +1705,6 @@ static int do_pages_move(struct mm_struc
 		current_node = NUMA_NO_NODE;
 	}
 out_flush:
-	if (list_empty(&pagelist))
-		return err;
