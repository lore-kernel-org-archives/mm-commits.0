From: akpm@linux-foundation.org
Subject: - fs-fix-to-correct-the-mbcache-entries-counter.patch removed from -mm tree
Date: Fri, 26 Oct 2007 11:48:40 -0700
Message-ID: <200710261848.l9QImeJo009157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44260 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760993AbXJZSso (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 14:48:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ram.gupta5@gmail.com, agruen@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs: fix to correct the mbcache entries counter
has been removed from the -mm tree.  Its filename was
     fs-fix-to-correct-the-mbcache-entries-counter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: fix to correct the mbcache entries counter
From: "Ram Gupta" <ram.gupta5@gmail.com>

This patch fixes the c_entry_count counter of the mbcache.  Currently it
increments the counter first & allocate the cache entry later.  In case of
failure to allocate the entry due to insufficient memory this counter is
still left incremented.  This patch fixes this anomaly.

Signed-off-by: Ram Gupta <ram.gupta5@gmail.com>
Cc: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mbcache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/mbcache.c~fs-fix-to-correct-the-mbcache-entries-counter fs/mbcache.c
--- a/fs/mbcache.c~fs-fix-to-correct-the-mbcache-entries-counter
+++ a/fs/mbcache.c
@@ -403,9 +403,9 @@ mb_cache_entry_alloc(struct mb_cache *ca
 {
 	struct mb_cache_entry *ce;
 
-	atomic_inc(&cache->c_entry_count);
 	ce = kmem_cache_alloc(cache->c_entry_cache, GFP_KERNEL);
 	if (ce) {
+		atomic_inc(&cache->c_entry_count);
 		INIT_LIST_HEAD(&ce->e_lru_list);
 		INIT_LIST_HEAD(&ce->e_block_list);
 		ce->e_cache = cache;
_

Patches currently in -mm which might be from ram.gupta5@gmail.com are

origin.patch
