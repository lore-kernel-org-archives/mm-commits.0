From: akpm@linux-foundation.org
Subject: - nfsd-fix-possible-read-ahead-cache-and-export-table-corruption.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:04:35 -0700
Message-ID: <200707192004.l6JK4Zdl019964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53735 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932095AbXGSU11 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:27:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, gnb@melbourne.sgi.com, neilb@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     nfsd: fix possible read-ahead cache and export table corruption
has been removed from the -mm tree.  Its filename was
     nfsd-fix-possible-read-ahead-cache-and-export-table-corruption.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nfsd: fix possible read-ahead cache and export table corruption
From: J. Bruce Fields <bfields@citi.umich.edu>

The value of nperbucket calculated here is too small--we should be rounding up
instead of down--with the result that the index j in the following loop can
overflow the raparm_hash array.  At least in my case, the next thing in memory
turns out to be export_table, so the symptoms I see are crashes caused by the
appearance of four zeroed-out export entries in the first bucket of the hash
table of exports (which were actually entries in the readahead cache, a
pointer to which had been written to the export table in this initialization
code).

It looks like the bug was probably introduced with commit
fce1456a19f5c08b688c29f00ef90fdfa074c79b ("knfsd: make the readahead params
cache SMP-friendly").

Cc: <stable@kernel.org>
Cc: Greg Banks <gnb@melbourne.sgi.com>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/vfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nfsd/vfs.c~nfsd-fix-possible-read-ahead-cache-and-export-table-corruption fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~nfsd-fix-possible-read-ahead-cache-and-export-table-corruption
+++ a/fs/nfsd/vfs.c
@@ -1916,7 +1916,7 @@ nfsd_racache_init(int cache_size)
 		raparm_hash[i].pb_head = NULL;
 		spin_lock_init(&raparm_hash[i].pb_lock);
 	}
-	nperbucket = cache_size >> RAPARM_HASH_BITS;
+	nperbucket = DIV_ROUND_UP(cache_size, RAPARM_HASH_SIZE);
 	for (i = 0; i < cache_size - 1; i++) {
 		if (i % nperbucket == 0)
 			raparm_hash[j++].pb_head = raparml + i;
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
vfs-fix-a-race-in-lease-breaking-during-truncate.patch
locks-kill-redundant-local-variable.patch
