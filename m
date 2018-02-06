From: akpm@linux-foundation.org
Subject: [merged]
 net-netfilter-x_tablesc-make-allocation-less-aggressive.patch removed from
 -mm tree
Date: Tue, 06 Feb 2018 11:46:58 -0800
Message-ID: <20180206194658.WeCUysU49%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54138 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752873AbeBFTrA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 14:47:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, fw@strlen.de, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net/netfilter/x_tables.c: make allocation less aggressive
has been removed from the -mm tree.  Its filename was
     net-netfilter-x_tablesc-make-allocation-less-aggressive.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@kernel.org>
Subject: net/netfilter/x_tables.c: make allocation less aggressive

syzbot has noticed that xt_alloc_table_info can allocate a lot of memory. 
This is an admin only interface but an admin in a namespace is sufficient
as well.  eacd86ca3b03 ("net/netfilter/x_tables.c: use kvmalloc() in
xt_alloc_table_info()") has changed the opencoded kmalloc->vmalloc
fallback into kvmalloc.  It has dropped __GFP_NORETRY on the way because
vmalloc has simply never fully supported __GFP_NORETRY semantic.  This is
still the case because e.g.  page tables backing the vmalloc area are
hardcoded GFP_KERNEL.

Revert back to __GFP_NORETRY as a poors man defence against excessively
large allocation request here.  We will not rule out the OOM killer
completely but __GFP_NORETRY should at least stop the large request in
most cases.

This patch merely gets us back to pre eacd86ca3b03 times where
__GFP_NORETRY was been used for both kmalloc and vmalloc paths.  So it
is more a quick bandaid than a longterm solution.

[akpm@linux-foundation.org: coding-style fixes]
Fixes: eacd86ca3b03 ("net/netfilter/x_tables.c: use kvmalloc() in xt_alloc_tableLink: http://lkml.kernel.org/r/20180130140104.GE21609@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/x_tables.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN net/netfilter/x_tables.c~net-netfilter-x_tablesc-make-allocation-less-aggressive net/netfilter/x_tables.c
--- a/net/netfilter/x_tables.c~net-netfilter-x_tablesc-make-allocation-less-aggressive
+++ a/net/netfilter/x_tables.c
@@ -1008,7 +1008,12 @@ struct xt_table_info *xt_alloc_table_inf
 	if ((size >> PAGE_SHIFT) + 2 > totalram_pages)
 		return NULL;
 
-	info = kvmalloc(sz, GFP_KERNEL);
+	/* __GFP_NORETRY is not fully supported by kvmalloc but it should
+	 * work reasonably well if sz is too large and bail out rather
+	 * than shoot all processes down before realizing there is nothing
+	 * more to reclaim.
+	 */
+	info = kvmalloc(sz, GFP_KERNEL | __GFP_NORETRY);
 	if (!info)
 		return NULL;
 
_

Patches currently in -mm which might be from mhocko@kernel.org are

mm-migrate-remove-reason-argument-from-new_page_t-fix.patch

