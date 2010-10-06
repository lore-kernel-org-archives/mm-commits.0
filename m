From: akpm@linux-foundation.org
Subject: + memblock-add-input-size-checking-to-memblock_find_region.patch added to -mm tree
Date: Wed, 06 Oct 2010 15:07:17 -0700
Message-ID: <201010062207.o96M7HEu025015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756823Ab0JFWHh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Oct 2010 18:07:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, akpm@linux-foundation.org, benh@kernel.crashing.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     memblock: add input size checking to memblock_find_region()
has been added to the -mm tree.  Its filename is
     memblock-add-input-size-checking-to-memblock_find_region.patch

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
Subject: memblock: add input size checking to memblock_find_region()
From: Yinghai Lu <yinghai@kernel.org>

Make sure two callers have right inputs.  and add print warning to catch
other offending callers.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memblock.c~memblock-add-input-size-checking-to-memblock_find_region mm/memblock.c
--- a/mm/memblock.c~memblock-add-input-size-checking-to-memblock_find_region
+++ a/mm/memblock.c
@@ -106,7 +106,7 @@ static phys_addr_t __init memblock_find_
 	long j;
 
 	/* In case, huge size is requested */
-	if (end < size)
+	if (WARN_ONCE(end < size, "memblock_find_region: wrong range [%#llx-%#llx] size %#llx", start, end, size))
 		return MEMBLOCK_ERROR;
 
 	base = memblock_align_down((end - size), align);
@@ -152,14 +152,14 @@ static phys_addr_t __init_memblock membl
 		phys_addr_t memblocksize = memblock.memory.regions[i].size;
 		phys_addr_t bottom, top, found;
 
-		if (memblocksize < size)
-			continue;
 		if ((memblockbase + memblocksize) <= start)
 			break;
 		bottom = max(memblockbase, start);
 		top = min(memblockbase + memblocksize, end);
 		if (bottom >= top)
 			continue;
+		if ((top - bottom) < size)
+			continue;
 		found = memblock_find_region(bottom, top, size, align);
 		if (found != MEMBLOCK_ERROR)
 			return found;
@@ -547,7 +547,7 @@ static phys_addr_t __init memblock_alloc
 		int this_nid;
 
 		this_end = memblock_nid_range(start, end, &this_nid);
-		if (this_nid == nid) {
+		if (this_nid == nid && (this_end - start) >= size) {
 			phys_addr_t ret = memblock_find_region(start, this_end, size, align);
 			if (ret != MEMBLOCK_ERROR &&
 			    memblock_add_region(&memblock.reserved, ret, size) >= 0)
_

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch
linux-next.patch
memblock-fix-big-size-with-find_region.patch
memblock-add-input-size-checking-to-memblock_find_region.patch

