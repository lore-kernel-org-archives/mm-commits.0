From: akpm@linux-foundation.org
Subject: [merged]
 mm-migrate-count-pages-failing-all-retries-in-vmstat-and-tracepoint.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:08:00 -0800
Message-ID: <563d08a0.ZZitmccZSfQEComc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033604AbbKFUIB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:08:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aneesh.kumar@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mel@csn.ul.ie, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, migrate: count pages failing all retries in vmstat and tracepoint
has been removed from the -mm tree.  Its filename was
     mm-migrate-count-pages-failing-all-retries-in-vmstat-and-tracepoint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, migrate: count pages failing all retries in vmstat and tracepoint

Migration tries up to 10 times to migrate pages that return -EAGAIN until
it gives up.  If some pages fail all retries, they are counted towards the
number of failed pages that migrate_pages() returns.  They should also be
counted in the /proc/vmstat pgmigrate_fail and in the mm_migrate_pages
tracepoint.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-migrate-count-pages-failing-all-retries-in-vmstat-and-tracepoint mm/migrate.c
--- a/mm/migrate.c~mm-migrate-count-pages-failing-all-retries-in-vmstat-and-tracepoint
+++ a/mm/migrate.c
@@ -1169,7 +1169,8 @@ int migrate_pages(struct list_head *from
 			}
 		}
 	}
-	rc = nr_failed + retry;
+	nr_failed += retry;
+	rc = nr_failed;
 out:
 	if (nr_succeeded)
 		count_vm_events(PGMIGRATE_SUCCESS, nr_succeeded);
_

Patches currently in -mm which might be from vbabka@suse.cz are


