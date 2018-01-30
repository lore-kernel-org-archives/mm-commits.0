From: akpm@linux-foundation.org
Subject: + net-netfilter-x_tablesc-make-allocation-less-aggressive.patch
 added to -mm tree
Date: Tue, 30 Jan 2018 11:29:09 -0800
Message-ID: <5a70c785.E88N8ZaErNrjCS8L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52190 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752500AbeA3T3L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jan 2018 14:29:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, davem@davemloft.net, fw@strlen.de, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net/netfilter/x_tables.c: make allocation less aggressive
has been added to the -mm tree.  Its filename is
     net-netfilter-x_tablesc-make-allocation-less-aggressive.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-netfilter-x_tablesc-make-allocation-less-aggressive.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-netfilter-x_tablesc-make-allocation-less-aggressive.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Fixes: eacd86ca3b03 ("net/netfilter/x_tables.c: use kvmalloc() in xt_alloc_tableLink: http://lkml.kernel.org/r/20180130140104.GE21609@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Florian Westphal <fw@strlen.de>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/x_tables.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN net/netfilter/x_tables.c~net-netfilter-x_tablesc-make-allocation-less-aggressive net/netfilter/x_tables.c
--- a/net/netfilter/x_tables.c~net-netfilter-x_tablesc-make-allocation-less-aggressive
+++ a/net/netfilter/x_tables.c
@@ -1008,7 +1008,13 @@ struct xt_table_info *xt_alloc_table_inf
 	if ((size >> PAGE_SHIFT) + 2 > totalram_pages)
 		return NULL;
 
-	info = kvmalloc(sz, GFP_KERNEL);
+	/*
+	 * __GFP_NORETRY is not fully supported by kvmalloc but it should
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
net-netfilter-x_tablesc-make-allocation-less-aggressive.patch

