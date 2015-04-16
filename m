From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-remove-extra-cond_resched-in-__zs_compact.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:54:08 -0700
Message-ID: <552fe930.hAk6bkRVb7q4KrRV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbbDPQsj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:48:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: remove extra cond_resched() in __zs_compact
has been removed from the -mm tree.  Its filename was
     zsmalloc-remove-extra-cond_resched-in-__zs_compact.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc: remove extra cond_resched() in __zs_compact

Do not perform cond_resched() before the busy compaction loop in
__zs_compact(), because this loop does it when needed.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-remove-extra-cond_resched-in-__zs_compact mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-remove-extra-cond_resched-in-__zs_compact
+++ a/mm/zsmalloc.c
@@ -1711,8 +1711,6 @@ static unsigned long __zs_compact(struct
 	struct page *dst_page = NULL;
 	unsigned long nr_total_migrated = 0;
 
-	cond_resched();
