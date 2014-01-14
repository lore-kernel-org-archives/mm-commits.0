From: akpm@linux-foundation.org
Subject: + mm-show-message-when-updating-min_free_kbytes-in-thp.patch
 added to -mm tree
Date: Tue, 14 Jan 2014 15:52:50 -0800
Message-ID: <52d5cdd2.vGXWEo54eLPZ2Ka5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaANXwv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jan 2014 18:52:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, mhocko@suse.cz, mgorman@suse.de, dave.hansen@intel.com, hanpt@linux.vnet.ibm.com

Subject: + mm-show-message-when-updating-min_free_kbytes-in-thp.patch added to -mm tree
To: hanpt@linux.vnet.ibm.com,dave.hansen@intel.com,mgorman@suse.de,mhocko@suse.cz,rientjes@google.com
From: akpm@linux-foundation.org
Date: Tue, 14 Jan 2014 15:52:50 -0800


The patch titled
     Subject: mm: show message when updating min_free_kbytes in thp
has been added to the -mm tree.  Its filename is
     mm-show-message-when-updating-min_free_kbytes-in-thp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-show-message-when-updating-min_free_kbytes-in-thp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-show-message-when-updating-min_free_kbytes-in-thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
Subject: mm: show message when updating min_free_kbytes in thp

min_free_kbytes may be raised during THP's initialization.  Sometimes,
this will change the value which was set by the user.  Showing this
message will clarify this confusion.

Only show this message when changing a value which was set by the user
according to Michal Hocko's suggestion.

Show the old value of min_free_kbytes according to Dave Hansen's
suggestion.  This will give user the chance to restore old value of
min_free_kbytes.

Signed-off-by: Han Pingtian <hanpt@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 +++++++-
 mm/internal.h    |    1 +
 mm/page_alloc.c  |    2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-show-message-when-updating-min_free_kbytes-in-thp mm/huge_memory.c
--- a/mm/huge_memory.c~mm-show-message-when-updating-min_free_kbytes-in-thp
+++ a/mm/huge_memory.c
@@ -130,8 +130,14 @@ static int set_recommended_min_free_kbyt
 			      (unsigned long) nr_free_buffer_pages() / 20);
 	recommended_min <<= (PAGE_SHIFT-10);
 
-	if (recommended_min > min_free_kbytes)
+	if (recommended_min > min_free_kbytes) {
+		if (user_min_free_kbytes >= 0)
+			pr_info("raising min_free_kbytes from %d to %lu "
+				"to help transparent hugepage allocations\n",
+				min_free_kbytes, recommended_min);
+
 		min_free_kbytes = recommended_min;
+	}
 	setup_per_zone_wmarks();
 	return 0;
 }
diff -puN mm/internal.h~mm-show-message-when-updating-min_free_kbytes-in-thp mm/internal.h
--- a/mm/internal.h~mm-show-message-when-updating-min_free_kbytes-in-thp
+++ a/mm/internal.h
@@ -99,6 +99,7 @@ extern void prep_compound_page(struct pa
 #ifdef CONFIG_MEMORY_FAILURE
 extern bool is_free_buddy_page(struct page *page);
 #endif
+extern int user_min_free_kbytes;
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
diff -puN mm/page_alloc.c~mm-show-message-when-updating-min_free_kbytes-in-thp mm/page_alloc.c
--- a/mm/page_alloc.c~mm-show-message-when-updating-min_free_kbytes-in-thp
+++ a/mm/page_alloc.c
@@ -205,7 +205,7 @@ static char * const zone_names[MAX_NR_ZO
 };
 
 int min_free_kbytes = 1024;
-int user_min_free_kbytes;
+int user_min_free_kbytes = -1;
 
 static unsigned long __meminitdata nr_kernel_pages;
 static unsigned long __meminitdata nr_all_pages;
_

Patches currently in -mm which might be from hanpt@linux.vnet.ibm.com are

mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes.patch
mm-show-message-when-updating-min_free_kbytes-in-thp.patch

