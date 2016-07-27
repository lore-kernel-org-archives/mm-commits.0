From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-use-bit_spin_lock.patch removed from -mm tree
Date: Wed, 27 Jul 2016 12:00:25 -0700
Message-ID: <579904c9.YTbHtqizXXs1fM/3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043AbcG0TA0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:00:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: use bit_spin_lock
has been removed from the -mm tree.  Its filename was
     zsmalloc-use-bit_spin_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: use bit_spin_lock

Use kernel standard bit spin-lock instead of custom mess.  Even, it has a
bug which doesn't disable preemption.  The reason we don't have any
problem is that we have used it during preemption disable section by
class->lock spinlock.  So no need to go to stable.

Link: http://lkml.kernel.org/r/1464736881-24886-6-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-use-bit_spin_lock mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-use-bit_spin_lock
+++ a/mm/zsmalloc.c
@@ -868,21 +868,17 @@ static unsigned long obj_idx_to_offset(s
 
 static inline int trypin_tag(unsigned long handle)
 {
-	unsigned long *ptr = (unsigned long *)handle;
-
-	return !test_and_set_bit_lock(HANDLE_PIN_BIT, ptr);
+	return bit_spin_trylock(HANDLE_PIN_BIT, (unsigned long *)handle);
 }
 
 static void pin_tag(unsigned long handle)
 {
-	while (!trypin_tag(handle));
+	bit_spin_lock(HANDLE_PIN_BIT, (unsigned long *)handle);
 }
 
 static void unpin_tag(unsigned long handle)
 {
-	unsigned long *ptr = (unsigned long *)handle;
