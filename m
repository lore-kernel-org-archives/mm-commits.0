From: akpm@linux-foundation.org
Subject: + pm-hibernate-feed-the-wathdog-when-creating-snapshot-v2.patch
 added to -mm tree
Date: Tue, 22 Aug 2017 15:59:21 -0700
Message-ID: <599cb749.xg/FxVvsArG2uBJp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58130 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751290AbdHVW7W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Aug 2017 18:59:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yu.c.chen@intel.com, dan.j.williams@intel.com, jan.filipcewicz@intel.com, lenb@kernel.org, mgorman@techsingularity.net, mhocko@suse.com, rjw@rjwysocki.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: pm-hibernate-feed-the-wathdog-when-creating-snapshot-v2
has been added to the -mm tree.  Its filename is
     pm-hibernate-feed-the-wathdog-when-creating-snapshot-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pm-hibernate-feed-the-wathdog-when-creating-snapshot-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pm-hibernate-feed-the-wathdog-when-creating-snapshot-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Yu <yu.c.chen@intel.com>
Subject: pm-hibernate-feed-the-wathdog-when-creating-snapshot-v2

use an interval of 128k instead of 100k to avoid modulus operation

Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Cc: Jan Filipcewicz <jan.filipcewicz@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~pm-hibernate-feed-the-wathdog-when-creating-snapshot-v2 mm/page_alloc.c
--- a/mm/page_alloc.c~pm-hibernate-feed-the-wathdog-when-creating-snapshot-v2
+++ a/mm/page_alloc.c
@@ -2536,8 +2536,11 @@ void drain_all_pages(struct zone *zone)
 
 #ifdef CONFIG_HIBERNATION
 
-/* Touch watchdog for every WD_INTERVAL_PAGE pages. */
-#define WD_INTERVAL_PAGE	(100*1024)
+/*
+ * Touch the watchdog for every WD_INTERVAL_PAGE pages,
+ * choose a power of 2 to avoid the modulus operation.
+ */
+#define WD_INTERVAL_PAGE	(128*1024)
 
 void mark_free_pages(struct zone *zone)
 {
_

Patches currently in -mm which might be from yu.c.chen@intel.com are

pm-hibernate-feed-the-wathdog-when-creating-snapshot.patch
pm-hibernate-feed-the-wathdog-when-creating-snapshot-v2.patch

