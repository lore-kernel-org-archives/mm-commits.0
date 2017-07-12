From: akpm@linux-foundation.org
Subject: [patch 52/96] net/netfilter/x_tables.c: use kvmalloc() in
 xt_alloc_table_info()
Date: Wed, 12 Jul 2017 14:35:37 -0700
Message-ID: <20170712213537.F6HLXfI1o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53890 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbdGLVfi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:35:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fw@strlen.de, kadlec@blackhole.kfki.hu, mhocko@suse.com, mm-commits@vger.kernel.org, pablo@netfilter.org, torvalds@linux-foundation.org

From: Michal Hocko <mhocko@suse.com>
Subject: net/netfilter/x_tables.c: use kvmalloc() in xt_alloc_table_info()

xt_alloc_table_info() basically opencodes kvmalloc() so use the library
function instead.

Link: http://lkml.kernel.org/r/20170531155145.17111-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/x_tables.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN net/netfilter/x_tables.c~netfilter-use-kvmalloc-xt_alloc_table_info net/netfilter/x_tables.c
--- a/net/netfilter/x_tables.c~netfilter-use-kvmalloc-xt_alloc_table_info
+++ a/net/netfilter/x_tables.c
@@ -1003,14 +1003,10 @@ struct xt_table_info *xt_alloc_table_inf
 	if ((SMP_ALIGN(size) >> PAGE_SHIFT) + 2 > totalram_pages)
 		return NULL;
 
-	if (sz <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER))
-		info = kmalloc(sz, GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY);
-	if (!info) {
-		info = __vmalloc(sz, GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY,
-				 PAGE_KERNEL);
-		if (!info)
-			return NULL;
-	}
+	info = kvmalloc(sz, GFP_KERNEL);
+	if (!info)
+		return NULL;
+
 	memset(info, 0, sizeof(*info));
 	info->size = size;
 	return info;
_
