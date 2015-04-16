From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-remove-synchronize_rcu-from-zs_compact.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:53:58 -0700
Message-ID: <552fe926.8ZVvLh+llNNs2H7k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbbDPQs3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:48:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: remove synchronize_rcu from zs_compact()
has been removed from the -mm tree.  Its filename was
     zsmalloc-remove-synchronize_rcu-from-zs_compact.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc: remove synchronize_rcu from zs_compact()

Do not synchronize rcu in zs_compact(). Neither zsmalloc not
zram use rcu.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-remove-synchronize_rcu-from-zs_compact mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-remove-synchronize_rcu-from-zs_compact
+++ a/mm/zsmalloc.c
@@ -1778,8 +1778,6 @@ unsigned long zs_compact(struct zs_pool
 		nr_migrated += __zs_compact(pool, class);
 	}
 
-	synchronize_rcu();
