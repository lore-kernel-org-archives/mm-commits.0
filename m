From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-migratec-check-pagelist-in-move_pages_and_store_status.patch added to
 -mm tree
Date: Thu, 13 Feb 2020 18:52:54 -0800
Message-ID: <20200214025254.sosbfRBil%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727604AbgBNCwz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 Feb 2020 21:52:55 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com


The patch titled
     Subject: mm/migrate.c: check pagelist in move_pages_and_store_status()
has been added to the -mm tree.  Its filename is
     mm-migratec-check-pagelist-in-move_pages_and_store_status.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migratec-check-pagelist-in-move_pages_and_store_status.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migratec-check-pagelist-in-move_pages_and_store_status.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1499,9 +1499,6 @@ static int do_move_pages_to_node(struct
 {
 	int err;
 
-	if (list_empty(pagelist))
-		return 0;
-
 	err = migrate_pages(pagelist, alloc_new_node_page, NULL, node,
 			MIGRATE_SYNC, MR_SYSCALL);
 	if (err)
@@ -1589,6 +1586,9 @@ static int move_pages_and_store_status(s
 {
 	int err;
 
+	if (list_empty(pagelist))
+		return 0;
+
 	err = do_move_pages_to_node(mm, pagelist, node);
 	if (err) {
 		/*
@@ -1686,9 +1686,6 @@ static int do_pages_move(struct mm_struc
 		current_node = NUMA_NO_NODE;
 	}
 out_flush:
-	if (list_empty(&pagelist))
-		return err;
