From: akpm@linux-foundation.org
Subject: + zsmalloc-calling-zs_map_object-from-irq-is-a-bug.patch added to -mm tree
Date: Mon, 02 Oct 2017 15:28:41 -0700
Message-ID: <59d2bd99.1UFgmJFf4+KgFsuC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43760 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750927AbdJBW2m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2017 18:28:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky.work@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: calling zs_map_object() from irq is a bug
has been added to the -mm tree.  Its filename is
     zsmalloc-calling-zs_map_object-from-irq-is-a-bug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-calling-zs_map_object-from-irq-is-a-bug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-calling-zs_map_object-from-irq-is-a-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are

ratelimit-use-deferred-printk-version.patch
zram-add-zstd-to-the-supported-algorithms-list.patch
zram-remove-zlib-from-the-list-of-recommended-algorithms.patch
zsmalloc-calling-zs_map_object-from-irq-is-a-bug.patch

