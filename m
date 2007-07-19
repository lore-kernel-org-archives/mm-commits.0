From: akpm@linux-foundation.org
Subject: + nfsd-fix-possible-read-ahead-cache-and-export-table-corruption.patch added to -mm tree
Date: Wed, 18 Jul 2007 17:16:33 -0700
Message-ID: <200707190016.l6J0GXoa004456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52308 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761330AbXGSARY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 20:17:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, gnb@melbourne.sgi.com, stable@kernel.org


The patch titled
     nfsd: fix possible read-ahead cache and export table corruption
has been added to the -mm tree.  Its filename is
     nfsd-fix-possible-read-ahead-cache-and-export-table-corruption.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/vfs.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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
git-vfs-lease-api.patch
nfsd-fix-possible-read-ahead-cache-and-export-table-corruption.patch
nfsd-return-errors-not-null-from-export-functions.patch
nfsd-remove-unnecessary-null-checks-from-nfsd_cross_mnt.patch
knfsd-move-ex_rdonly-out-of-header.patch
knfsd-clean-up-ex_rdonly.patch
