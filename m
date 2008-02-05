From: akpm@linux-foundation.org
Subject: - include-count-of-pagecache-pages-in-show_mem-output.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:32:22 -0800
Message-ID: <200802052232.m15MW3wx012281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38992 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762408AbYBEWld (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lwoodman@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Include count of pagecache pages in show_mem() output
has been removed from the -mm tree.  Its filename was
     include-count-of-pagecache-pages-in-show_mem-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Include count of pagecache pages in show_mem() output
From: Larry Woodman <lwoodman@redhat.com>

The show_mem() output does not include the total number of pagecache pages.
 This would be helpful when analyzing the debug information in the
/var/log/messages file after OOM kills occur.

This patch includes the total pagecache pages in that output.

Signed-off-by: Larry Woodman <lwoodman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/page_alloc.c~include-count-of-pagecache-pages-in-show_mem-output mm/page_alloc.c
--- a/mm/page_alloc.c~include-count-of-pagecache-pages-in-show_mem-output
+++ a/mm/page_alloc.c
@@ -1874,6 +1874,8 @@ void show_free_areas(void)
 		printk("= %lukB\n", K(total));
 	}
 
+	printk("%ld total pagecache pages\n", global_page_state(NR_FILE_PAGES));
+
 	show_swap_cache_info();
 }
 
_

Patches currently in -mm which might be from lwoodman@redhat.com are

origin.patch
