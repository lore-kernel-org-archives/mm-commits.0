From: akpm@linux-foundation.org
Subject: +
 mm-migrate-count-pages-failing-all-retries-in-vmstat-and-tracepoint.patch
 added to -mm tree
Date: Wed, 16 Sep 2015 15:19:57 -0700
Message-ID: <55f9eb0d.jz+fhYScqfO3990B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbbIPWT6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Sep 2015 18:19:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aneesh.kumar@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mel@csn.ul.ie, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, migrate: count pages failing all retries in vmstat and tracepoint
has been added to the -mm tree.  Its filename is
     mm-migrate-count-pages-failing-all-retries-in-vmstat-and-tracepoint.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-count-pages-failing-all-retries-in-vmstat-and-tracepoint.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-count-pages-failing-all-retries-in-vmstat-and-tracepoint.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1159,7 +1159,8 @@ int migrate_pages(struct list_head *from
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

mm-migrate-count-pages-failing-all-retries-in-vmstat-and-tracepoint.patch

