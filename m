From: akpm@linux-foundation.org
Subject: [merged] mm-remove-likely-from-mapping_unevictable.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:45:45 -0800
Message-ID: <201101142248.p0EMmZmI005214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079Ab1ANWsx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:48:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srostedt@redhat.com, Lee.Schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com, npiggin@kernel.dk, riel@redhat.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     mm: remove likely() from mapping_unevictable()
has been removed from the -mm tree.  Its filename was
     mm-remove-likely-from-mapping_unevictable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove likely() from mapping_unevictable()
From: Steven Rostedt <srostedt@redhat.com>

The mapping_unevictable() has a likely() around the mapping parameter. 
This mapping parameter comes from page_mapping() which has an unlikely()
that the page will be set as PAGE_MAPPING_ANON, and if so, it will return
NULL.  One would think that this unlikely() means that the mapping
returned by page_mapping() would not be NULL, but where page_mapping() is
used just above mapping_unevictable(), that unlikely() is incorrect most
of the time.  This means that the "likely(mapping)" in
mapping_unevictable() is incorrect most of the time.

Running the annotated branch profiler on my main box which runs firefox,
evolution, xchat and is part of my distcc farm, I had this:

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
12872836 1269443893  98 mapping_unevictable            pagemap.h            51
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
times.  The mapping_unevictable() is also a static inline but seems to be
used only once in my setup.

The unlikely in page_mapping() was correct a total of 1909540379 times and
incorrect 1270533123 times, with a 39% being incorrect.  Perhaps this is
enough to remove the unlikely from page_mapping() as well.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Nick Piggin <npiggin@kernel.dk>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/pagemap.h~mm-remove-likely-from-mapping_unevictable include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-remove-likely-from-mapping_unevictable
+++ a/include/linux/pagemap.h
@@ -48,7 +48,7 @@ static inline void mapping_clear_unevict
 
 static inline int mapping_unevictable(struct address_space *mapping)
 {
-	if (likely(mapping))
+	if (mapping)
 		return test_bit(AS_UNEVICTABLE, &mapping->flags);
 	return !!mapping;
 }
_

Patches currently in -mm which might be from srostedt@redhat.com are

origin.patch
linux-next.patch
vfs-remove-unlikely-from-fput_light.patch
vfs-remove-unlikely-from-fget_light.patch

