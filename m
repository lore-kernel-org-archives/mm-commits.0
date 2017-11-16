From: akpm@linux-foundation.org
Subject: [patch 046/131] zsmalloc: calling zs_map_object() from irq
 is a bug
Date: Wed, 15 Nov 2017 17:34:03 -0800
Message-ID: <20171116013403.RkTy-wm41%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39022 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932972AbdKPBeF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:34:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org

From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: zsmalloc: calling zs_map_object() from irq is a bug

Use BUG_ON(in_interrupt()) in zs_map_object().  This is not a new
BUG_ON(), it's always been there, but was recently changed to VM_BUG_ON().
There are several problems there.  First, we use use per-CPU mappings
both in zsmalloc and in zram, and interrupt may easily corrupt those
buffers.  Second, and more importantly, we believe it's possible to start
leaking sensitive information.  Consider the following case:

-> process P
	swap out
	 zram
	  per-cpu mapping CPU1
	   compress page A
-> IRQ

	swap out
	 zram
	  per-cpu mapping CPU1
	   compress page B
	    write page from per-cpu mapping CPU1 to zsmalloc pool
	iret

-> process P
	    write page from per-cpu mapping CPU1 to zsmalloc pool  [*]
	return

* so we store overwritten data that actually belongs to another
  page (task) and potentially contains sensitive data. And when
  process P will page fault it's going to read (swap in) that
  other task's data.

Link: http://lkml.kernel.org/r/20170929045140.4055-1-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~zsmalloc-calling-zs_map_object-from-irq-is-a-bug mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-calling-zs_map_object-from-irq-is-a-bug
+++ a/mm/zsmalloc.c
@@ -1349,7 +1349,7 @@ void *zs_map_object(struct zs_pool *pool
 	 * pools/users, we can't allow mapping in interrupt context
 	 * because it can corrupt another users mappings.
 	 */
-	WARN_ON_ONCE(in_interrupt());
+	BUG_ON(in_interrupt());
 
 	/* From now on, migration cannot move the object */
 	pin_tag(handle);
_
