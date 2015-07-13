From: akpm@linux-foundation.org
Subject: + zsmalloc-do-not-take-class-lock-in-zs_pages_to_compact.patch
 added to -mm tree
Date: Mon, 13 Jul 2015 14:50:29 -0700
Message-ID: <55a432a5.7Vfotqw7okO2jFeV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33822 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbbGMVua (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jul 2015 17:50:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: do not take class lock in zs_pages_to_compact()
has been added to the -mm tree.  Its filename is
     zsmalloc-do-not-take-class-lock-in-zs_pages_to_compact.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-do-not-take-class-lock-in-zs_pages_to_compact.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-do-not-take-class-lock-in-zs_pages_to_compact.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc: do not take class lock in zs_pages_to_compact()

We can avoid taking class ->lock around zs_can_compact() in
zs_pages_to_compact(), because the number that we return back is outdated
in general case, by design.  We have different source that are able to
change class's state right after we return from zs_can_compact() --
ongoing IO operations, manually triggered compaction or automatic
compaction, or all three simultaneously.

We re-do this calculations during compaction on a per class basis
anyway.

zs_unregister_shrinker() will not return until we have an active shrinker,
so classes won't unexpectedly disappear while zs_pages_to_compact(),
invoked by zs_shrinker_count(), iterates them.

When called from zram, we are protected by zram's ->init_lock, so, again,
classes will be there until zs_pages_to_compact() iterates them.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-do-not-take-class-lock-in-zs_pages_to_compact mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-do-not-take-class-lock-in-zs_pages_to_compact
+++ a/mm/zsmalloc.c
@@ -1811,9 +1811,7 @@ unsigned long zs_pages_to_compact(struct
 		if (class->index != i)
 			continue;
 
-		spin_lock(&class->lock);
 		pages_to_free += zs_can_compact(class);
-		spin_unlock(&class->lock);
 	}
 
 	return pages_to_free;
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zsmalloc-drop-unused-variable-nr_to_migrate.patch
zsmalloc-always-keep-per-class-stats.patch
zsmalloc-introduce-zs_can_compact-function.patch
zsmalloc-cosmetic-compaction-code-adjustments.patch
zsmalloc-zram-introduce-zs_pool_stats-api.patch
zsmalloc-account-the-number-of-compacted-pages.patch
zsmalloc-use-shrinker-to-trigger-auto-compaction.patch
zsmalloc-partial-page-ordering-within-a-fullness_list.patch
zsmalloc-consider-zs_almost_full-as-migrate-source.patch
zsmalloc-factor-out-zs_pages_to_compact.patch
zram-make-compact-a-read-write-sysfs-node.patch
zsmalloc-do-not-take-class-lock-in-zs_pages_to_compact.patch

