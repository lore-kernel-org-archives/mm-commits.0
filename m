From: akpm@linux-foundation.org
Subject: [merged] selinux-tag-avc-cache-alloc-as-non-critical.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:16:47 -0700
Message-ID: <20120801201648.588B35C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:52066 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2HAUQv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:16:51 -0400
Received: by mail-bk0-f74.google.com with SMTP id jc3so345257bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:16:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, Trond.Myklebust@netapp.com, a.p.zijlstra@chello.nl, davem@davemloft.net, dfeng@redhat.com, emunson@mgebm.net, eparis@redhat.com, hch@infradead.org, jmorris@namei.org, michaelc@cs.wisc.edu, neilb@suse.de, riel@redhat.com, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: selinux: tag avc cache alloc as non-critical
has been removed from the -mm tree.  Its filename was
     selinux-tag-avc-cache-alloc-as-non-critical.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: selinux: tag avc cache alloc as non-critical

Failing to allocate a cache entry will only harm performance not
correctness.  Do not consume valuable reserve pages for something like
that.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Eric Paris <eparis@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Neil Brown <neilb@suse.de>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Xiaotian Feng <dfeng@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/avc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/selinux/avc.c~selinux-tag-avc-cache-alloc-as-non-critical security/selinux/avc.c
--- a/security/selinux/avc.c~selinux-tag-avc-cache-alloc-as-non-critical
+++ a/security/selinux/avc.c
@@ -274,7 +274,7 @@ static struct avc_node *avc_alloc_node(v
 {
 	struct avc_node *node;
 
-	node = kmem_cache_zalloc(avc_node_cachep, GFP_ATOMIC);
+	node = kmem_cache_zalloc(avc_node_cachep, GFP_ATOMIC|__GFP_NOMEMALLOC);
 	if (!node)
 		goto out;
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch

