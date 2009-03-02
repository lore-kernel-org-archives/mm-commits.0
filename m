From: akpm@linux-foundation.org
Subject: [merged] export_symbold_obtain_alias-rather-than-export_symbol_gpl.patch removed from -mm tree
Date: Mon, 02 Mar 2009 11:22:53 -0800
Message-ID: <200903021922.n22JMr3C014346@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757976AbZCBTXn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 14:23:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhalevy@panasas.com, bfields@fieldses.org, hch@infradead.org, torvalds@linux-foundation.org, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     EXPORT_SYMBOL(d_obtain_alias) rather than EXPORT_SYMBOL_GPL
has been removed from the -mm tree.  Its filename was
     export_symbold_obtain_alias-rather-than-export_symbol_gpl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: EXPORT_SYMBOL(d_obtain_alias) rather than EXPORT_SYMBOL_GPL
From: Benny Halevy <bhalevy@panasas.com>

Commit 4ea3ada2955e4519befa98ff55dd62d6dfbd1705 declares d_obtain_alias()
as EXPORT_SYMBOL_GPL where it's supposed to replace d_alloc_anon which was
previously declared as EXPORT_SYMBOL and thus available to any loadable
module.

This patch reverts that.

Signed-off-by: Benny Halevy <bhalevy@panasas.com>
Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dcache.c~export_symbold_obtain_alias-rather-than-export_symbol_gpl fs/dcache.c
--- a/fs/dcache.c~export_symbold_obtain_alias-rather-than-export_symbol_gpl
+++ a/fs/dcache.c
@@ -1180,7 +1180,7 @@ struct dentry *d_obtain_alias(struct ino
 	iput(inode);
 	return res;
 }
-EXPORT_SYMBOL_GPL(d_obtain_alias);
+EXPORT_SYMBOL(d_obtain_alias);
 
 /**
  * d_splice_alias - splice a disconnected dentry into the tree if one exists
_

Patches currently in -mm which might be from bhalevy@panasas.com are

origin.patch
linux-next.patch

