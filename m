From: akpm@linux-foundation.org
Subject: + page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch added to -mm tree
Date: Tue, 22 Jan 2013 15:38:08 -0800
Message-ID: <20130122233809.4846B31C19C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:39121 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab3AVXiK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 18:38:10 -0500
Received: by mail-vb0-f73.google.com with SMTP id fs19so144049vbb.4
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 15:38:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: psz@maths.usyd.edu.au, fengguang.wu@intel.com, riel@redhat.com


The patch titled
     Subject: page-writeback.c: subtract min_free_kbytes from dirtyable memory
has been added to the -mm tree.  Its filename is
     page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Szabo <psz@maths.usyd.edu.au>
Subject: page-writeback.c: subtract min_free_kbytes from dirtyable memory

When calculating amount of dirtyable memory, min_free_kbytes should be
subtracted because it is not intended for dirty pages.

Addresses http://bugs.debian.org/695182

Signed-off-by: Paul Szabo <psz@maths.usyd.edu.au>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/page-writeback.c~page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory mm/page-writeback.c
--- a/mm/page-writeback.c~page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory
+++ a/mm/page-writeback.c
@@ -233,6 +233,7 @@ static unsigned long highmem_dirtyable_m
 static unsigned long global_dirtyable_memory(void)
 {
 	unsigned long x;
+	extern int min_free_kbytes;
 
 	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
 	x -= min(x, dirty_balance_reserve);
@@ -240,6 +241,9 @@ static unsigned long global_dirtyable_me
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
 
+	/* Subtract min_free_kbytes */
+	x -= min(x, min_free_kbytes >> (PAGE_SHIFT - 10));
+
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
_

Patches currently in -mm which might be from psz@maths.usyd.edu.au are

page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix.patch

