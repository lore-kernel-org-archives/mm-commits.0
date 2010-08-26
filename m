From: akpm@linux-foundation.org
Subject: + percpu-fix-a-memory-leak-in-pcpu_extend_area_map.patch added to -mm tree
Date: Thu, 26 Aug 2010 15:10:29 -0700
Message-ID: <201008262210.o7QMAThu017413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753618Ab0HZWLB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Aug 2010 18:11:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shijie8@gmail.com, stable@kernel.org, tj@kernel.org


The patch titled
     percpu: fix a memory leak in pcpu_extend_area_map()
has been added to the -mm tree.  Its filename is
     percpu-fix-a-memory-leak-in-pcpu_extend_area_map.patch

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
Subject: percpu: fix a memory leak in pcpu_extend_area_map()
From: Huang Shijie <shijie8@gmail.com>

The original code did not free the old map.  This patch fixes it.

[tj@kernel.org: use @old as memcpy source instead of @chunk->map, and indentation and description update]
Signed-off-by: Huang Shijie <shijie8@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/percpu.c~percpu-fix-a-memory-leak-in-pcpu_extend_area_map mm/percpu.c
--- a/mm/percpu.c~percpu-fix-a-memory-leak-in-pcpu_extend_area_map
+++ a/mm/percpu.c
@@ -393,7 +393,9 @@ static int pcpu_extend_area_map(struct p
 		goto out_unlock;
 
 	old_size = chunk->map_alloc * sizeof(chunk->map[0]);
-	memcpy(new, chunk->map, old_size);
+	old = chunk->map;
+
+	memcpy(new, old, old_size);
 
 	chunk->map_alloc = new_alloc;
 	chunk->map = new;
_

Patches currently in -mm which might be from shijie8@gmail.com are

percpu-fix-a-memory-leak-in-pcpu_extend_area_map.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch

