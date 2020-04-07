From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 012/166] mm/migrate.c: no need to check for i >
 start in do_pages_move()
Date: Mon, 06 Apr 2020 20:04:09 -0700
Message-ID: <20200407030409.WN1Bmd5Ge%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgDGDEK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:04:10 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com, torvalds@linux-foundation.org

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
@@ -1694,11 +1694,9 @@ static int do_pages_move(struct mm_struc
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
