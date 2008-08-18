From: akpm@linux-foundation.org
Subject: + mm-mminit_loglevel-cannot-be-__meminitdata-anymore.patch added to -mm tree
Date: Mon, 18 Aug 2008 15:35:23 -0700
Message-ID: <200808182235.m7IMZNVs016614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753450AbYHRWgA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 18:36:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, mel@csn.ul.ie


The patch titled
     mm: mminit_loglevel cannot be __meminitdata anymore
has been added to the -mm tree.  Its filename is
     mm-mminit_loglevel-cannot-be-__meminitdata-anymore.patch

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
Subject: mm: mminit_loglevel cannot be __meminitdata anymore
From: Marcin Slusarz <marcin.slusarz@gmail.com>

mminit_loglevel is now used from mminit_verify_zonelist <- build_all_zonelists <-

1. online_pages <- memory_block_action <- memory_block_change_state <- store_mem_state (sys handler)
2. numa_zonelist_order_handler (proc handler)

so it cannot be annotated __meminit - drop it

fixes following section mismatch warning:
WARNING: vmlinux.o(.text+0x71628): Section mismatch in reference from the function mminit_verify_zonelist() to the variable .meminit.data:mminit_loglevel
The function mminit_verify_zonelist() references
the variable __meminitdata mminit_loglevel.
This is often because mminit_verify_zonelist lacks a __meminitdata
annotation or the annotation of mminit_loglevel is wrong.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mm_init.c~mm-mminit_loglevel-cannot-be-__meminitdata-anymore mm/mm_init.c
--- a/mm/mm_init.c~mm-mminit_loglevel-cannot-be-__meminitdata-anymore
+++ a/mm/mm_init.c
@@ -12,7 +12,7 @@
 #include "internal.h"
 
 #ifdef CONFIG_DEBUG_MEMORY_INIT
-int __meminitdata mminit_loglevel;
+int mminit_loglevel;
 
 #ifndef SECTIONS_SHIFT
 #define SECTIONS_SHIFT	0
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
mm-mminit_loglevel-cannot-be-__meminitdata-anymore.patch
linux-next.patch

