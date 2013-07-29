From: akpm@linux-foundation.org
Subject: +
 mm-revert-page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch added to -mm tree
Date: Mon, 29 Jul 2013 12:59:56 -0700
Message-ID: <51f6c9bc.rRF3JbNwVLXejXW4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3G2T75 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 15:59:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, psz@maths.usyd.edu.au, minchan@kernel.org, hannes@cmpxchg.org

Subject: + mm-revert-page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch added to -mm tree
To: hannes@cmpxchg.org,minchan@kernel.org,psz@maths.usyd.edu.au,riel@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 12:59:56 -0700


The patch titled
     Subject: mm: revert "page-writeback.c: subtract min_free_kbytes from dirtyable memory"
has been added to the -mm tree.  Its filename is
     mm-revert-page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-revert-page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-revert-page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: revert "page-writeback.c: subtract min_free_kbytes from dirtyable memory"

This reverts 75f7ad8e043.  It was the result of a problem observed with a
3.2 kernel and merged in 3.9, while the issue had been resolved upstream
in 3.3 (ab8fabd mm: exclude reserved pages from dirtyable memory).

The "reserved pages" are a superset of min_free_kbytes, thus this change
is redundant and confusing.  Revert it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Paul Szabo <psz@maths.usyd.edu.au>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/page-writeback.c~mm-revert-page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory mm/page-writeback.c
--- a/mm/page-writeback.c~mm-revert-page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory
+++ a/mm/page-writeback.c
@@ -241,9 +241,6 @@ static unsigned long global_dirtyable_me
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
 
-	/* Subtract min_free_kbytes */
-	x -= min_t(unsigned long, x, min_free_kbytes >> (PAGE_SHIFT - 10));
