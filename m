From: akpm@linux-foundation.org
Subject: [merged] nfs-prevent-page-allocator-recursions-with-swap-over-nfs.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:17:35 -0700
Message-ID: <20120801201736.657EB5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:39737 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab2HAURj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:17:39 -0400
Received: by mail-fa0-f74.google.com with SMTP id 25so342001fat.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:17:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, Trond.Myklebust@netapp.com, a.p.zijlstra@chello.nl, davem@davemloft.net, dfeng@redhat.com, emunson@mgebm.net, eparis@redhat.com, hch@infradead.org, jmorris@namei.org, michaelc@cs.wisc.edu, neilb@suse.de, riel@redhat.com, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: nfs: prevent page allocator recursions with swap over NFS.
has been removed from the -mm tree.  Its filename was
     nfs-prevent-page-allocator-recursions-with-swap-over-nfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: nfs: prevent page allocator recursions with swap over NFS.

GFP_NOFS is _more_ permissive than GFP_NOIO in that it will initiate IO,
just not of any filesystem data.

The problem is that previously NOFS was correct because that avoids
recursion into the NFS code.  With swap-over-NFS, it is no longer correct
as swap IO can lead to this recursion.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Neil Brown <neilb@suse.de>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Xiaotian Feng <dfeng@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/pagelist.c |    2 +-
 fs/nfs/write.c    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/nfs/pagelist.c~nfs-prevent-page-allocator-recursions-with-swap-over-nfs fs/nfs/pagelist.c
--- a/fs/nfs/pagelist.c~nfs-prevent-page-allocator-recursions-with-swap-over-nfs
+++ a/fs/nfs/pagelist.c
@@ -70,7 +70,7 @@ void nfs_set_pgio_error(struct nfs_pgio_
 static inline struct nfs_page *
 nfs_page_alloc(void)
 {
-	struct nfs_page	*p = kmem_cache_zalloc(nfs_page_cachep, GFP_KERNEL);
+	struct nfs_page	*p = kmem_cache_zalloc(nfs_page_cachep, GFP_NOIO);
 	if (p)
 		INIT_LIST_HEAD(&p->wb_list);
 	return p;
diff -puN fs/nfs/write.c~nfs-prevent-page-allocator-recursions-with-swap-over-nfs fs/nfs/write.c
--- a/fs/nfs/write.c~nfs-prevent-page-allocator-recursions-with-swap-over-nfs
+++ a/fs/nfs/write.c
@@ -52,7 +52,7 @@ static mempool_t *nfs_commit_mempool;
 
 struct nfs_commit_data *nfs_commitdata_alloc(void)
 {
-	struct nfs_commit_data *p = mempool_alloc(nfs_commit_mempool, GFP_NOFS);
+	struct nfs_commit_data *p = mempool_alloc(nfs_commit_mempool, GFP_NOIO);
 
 	if (p) {
 		memset(p, 0, sizeof(*p));
@@ -70,7 +70,7 @@ EXPORT_SYMBOL_GPL(nfs_commit_free);
 
 struct nfs_write_header *nfs_writehdr_alloc(void)
 {
-	struct nfs_write_header *p = mempool_alloc(nfs_wdata_mempool, GFP_NOFS);
+	struct nfs_write_header *p = mempool_alloc(nfs_wdata_mempool, GFP_NOIO);
 
 	if (p) {
 		struct nfs_pgio_header *hdr = &p->header;
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch

