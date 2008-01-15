From: akpm@linux-foundation.org
Subject: + include-count-of-pagecache-pages-in-show_mem-output.patch added to -mm tree
Date: Tue, 15 Jan 2008 01:47:31 -0800
Message-ID: <200801150947.m0F9lBm2009473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45105 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbYAOJrw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 04:47:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lwoodman@redhat.com


The patch titled
     Include count of pagecache pages in show_mem() output
has been added to the -mm tree.  Its filename is
     include-count-of-pagecache-pages-in-show_mem-output.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

include-count-of-pagecache-pages-in-show_mem-output.patch
