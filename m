From: akpm@linux-foundation.org
Subject: [merged] net-netfilter-x_tablesc-remove-size-check.patch
 removed from -mm tree
Date: Fri, 09 Feb 2018 12:04:28 -0800
Message-ID: <20180209200428.BwfJrtOAd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43102 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752558AbeBIUE3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Feb 2018 15:04:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, fw@strlen.de, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net/netfilter/x_tables.c: remove size check
has been removed from the -mm tree.  Its filename was
     net-netfilter-x_tablesc-remove-size-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: net/netfilter/x_tables.c: remove size check

Back in 2002 vmalloc used to BUG on too large sizes.  We are much better
behaved these days and vmalloc simply returns NULL for those.  Remove the
check as it simply not needed and the comment is even misleading.

Link: http://lkml.kernel.org/r/20180131081916.GO21609@dhcp22.suse.cz
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/x_tables.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN net/netfilter/x_tables.c~net-netfilter-x_tablesc-remove-size-check net/netfilter/x_tables.c
--- a/net/netfilter/x_tables.c~net-netfilter-x_tablesc-remove-size-check
+++ a/net/netfilter/x_tables.c
@@ -1004,10 +1004,6 @@ struct xt_table_info *xt_alloc_table_inf
 	if (sz < sizeof(*info))
 		return NULL;
 
-	/* Pedantry: prevent them from hitting BUG() in vmalloc.c --RR */
-	if ((size >> PAGE_SHIFT) + 2 > totalram_pages)
-		return NULL;
