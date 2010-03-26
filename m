From: akpm@linux-foundation.org
Subject: [merged] sunrpc-cache-fix-module-refcnt-leak-in-a-failure-path.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:38:16 -0400
Message-ID: <201003261939.o2QJdGY8016810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752Ab0CZTkA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:40:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, Trond.Myklebust@netapp.com, bfields@fieldses.org, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     sunrpc/cache: fix module refcnt leak in a failure path
has been removed from the -mm tree.  Its filename was
     sunrpc-cache-fix-module-refcnt-leak-in-a-failure-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sunrpc/cache: fix module refcnt leak in a failure path
From: Li Zefan <lizf@cn.fujitsu.com>

Don't forget to release the module refcnt if seq_open() returns failure.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/cache.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN net/sunrpc/cache.c~sunrpc-cache-fix-module-refcnt-leak-in-a-failure-path net/sunrpc/cache.c
--- a/net/sunrpc/cache.c~sunrpc-cache-fix-module-refcnt-leak-in-a-failure-path
+++ a/net/sunrpc/cache.c
@@ -1233,8 +1233,10 @@ static int content_open(struct inode *in
 	if (!cd || !try_module_get(cd->owner))
 		return -EACCES;
 	han = __seq_open_private(file, &cache_content_op, sizeof(*han));
-	if (han == NULL)
+	if (han == NULL) {
+		module_put(cd->owner);
 		return -ENOMEM;
+	}
 
 	han->cd = cd;
 	return 0;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch

