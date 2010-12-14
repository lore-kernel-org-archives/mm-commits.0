From: akpm@linux-foundation.org
Subject: + mm-remove-unlikely-from-page_mapping.patch added to -mm tree
Date: Tue, 14 Dec 2010 12:24:38 -0800
Message-ID: <201012142024.oBEKOcVV007584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759920Ab0LNUYx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Dec 2010 15:24:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srostedt@redhat.com, Lee.Schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com, npiggin@kernel.dk, riel@redhat.com, rostedt@goodmis.org


The patch titled
     mm: remove unlikely() from page_mapping()
has been added to the -mm tree.  Its filename is
     mm-remove-unlikely-from-page_mapping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove unlikely() from page_mapping()
From: Steven Rostedt <srostedt@redhat.com>

page_mapping() has a unlikely that the mapping has PAGE_MAPPING_ANON set. 
But running the annotated branch profiler on a normal desktop system doing
vairous tasks (xchat, evolution, firefox, distcc), it is not really that
unlikely that the mapping here will have the PAGE_MAPPING_ANON flag set:

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
35935762 1270265395  97 page_mapping                   mm.h                 659
1306198001   143659   0 page_mapping                   mm.h                 657
203131478   121586   0 page_mapping                   mm.h                 657
 5415491     1116   0 page_mapping                   mm.h                 657
74899487     1116   0 page_mapping                   mm.h                 657
203132845      224   0 page_mapping                   mm.h                 659
 5415464       27   0 page_mapping                   mm.h                 659
   13552        0   0 page_mapping                   mm.h                 657
   13552        0   0 page_mapping                   mm.h                 659
  242630        0   0 page_mapping                   mm.h                 657
  242630        0   0 page_mapping                   mm.h                 659
74899487        0   0 page_mapping                   mm.h                 659

The page_mapping() is a static inline, which is why it shows up multiple
times.

The unlikely in page_mapping() was correct a total of 1909540379 times and
incorrect 1270533123 times, with a 39% being incorrect.  With this much of
an error, it's best to simply remove the unlikely and have the compiler
and branch prediction figure this out.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mm.h~mm-remove-unlikely-from-page_mapping include/linux/mm.h
--- a/include/linux/mm.h~mm-remove-unlikely-from-page_mapping
+++ a/include/linux/mm.h
@@ -658,7 +658,7 @@ static inline struct address_space *page
 	VM_BUG_ON(PageSlab(page));
 	if (unlikely(PageSwapCache(page)))
 		mapping = &swapper_space;
-	else if (unlikely((unsigned long)mapping & PAGE_MAPPING_ANON))
+	else if ((unsigned long)mapping & PAGE_MAPPING_ANON)
 		mapping = NULL;
 	return mapping;
 }
_

Patches currently in -mm which might be from srostedt@redhat.com are

linux-next.patch
mm-remove-likely-from-mapping_unevictable.patch
mm-remove-unlikely-from-page_mapping.patch
mm-remove-likely-from-grab_cache_page_write_begin.patch
vfs-remove-unlikely-from-fput_light.patch
vfs-remove-unlikely-from-fget_light.patch

