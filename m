From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-migratec-no-need-to-check-for-i-start-in-do_pages_move.patch added to
 -mm tree
Date: Thu, 13 Feb 2020 18:52:50 -0800
Message-ID: <20200214025250.hLJYLVNdP%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727604AbgBNCww (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 Feb 2020 21:52:52 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com


The patch titled
     Subject: mm/migrate.c: no need to check for i > start in do_pages_move()
has been added to the -mm tree.  Its filename is
     mm-migratec-no-need-to-check-for-i-start-in-do_pages_move.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migratec-no-need-to-check-for-i-start-in-do_pages_move.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migratec-no-need-to-check-for-i-start-in-do_pages_move.patch

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
Subject: mm/migrate.c: no need to check for i > start in do_pages_move()

Patch series "cleanup on do_pages_move()", v5.

The logic in do_pages_move() is a little mess for audience to read and has
some potential error on handling the return value. Especially there are
three calls on do_move_pages_to_node() and store_status() with almost the
same form.

This patch set tries to make the code a little friendly for audience by
consolidate the calls.


This patch (of 4):

At this point, we always have i >= start.  If i == start, store_status()
will return 0.  So we can drop the check for i > start.

[david@redhat.com rephrase changelog]

Link: http://lkml.kernel.org/r/20200214003017.25558-2-richardw.yang@linux.intel.com
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/migrate.c~mm-migratec-no-need-to-check-for-i-start-in-do_pages_move
+++ a/mm/migrate.c
@@ -1675,11 +1675,9 @@ static int do_pages_move(struct mm_struc
 				err += nr_pages - i - 1;
 			goto out;
 		}
-		if (i > start) {
-			err = store_status(status, start, current_node, i - start);
-			if (err)
-				goto out;
-		}
+		err = store_status(status, start, current_node, i - start);
+		if (err)
+			goto out;
 		current_node = NUMA_NO_NODE;
 	}
 out_flush:
_

Patches currently in -mm which might be from richardw.yang@linux.intel.com are

mm-sparsemem-get-address-to-page-struct-instead-of-address-to-pfn.patch
mm-migratec-no-need-to-check-for-i-start-in-do_pages_move.patch
mm-migratec-wrap-do_move_pages_to_node-and-store_status.patch
mm-migratec-check-pagelist-in-move_pages_and_store_status.patch
mm-migratec-unify-not-queued-for-migration-handling-in-do_pages_move.patch
