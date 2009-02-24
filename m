From: akpm@linux-foundation.org
Subject: + export_symbold_obtain_alias-rather-than-export_symbol_gpl.patch added to -mm tree
Date: Tue, 24 Feb 2009 12:23:31 -0800
Message-ID: <200902242023.n1OKNVLk008195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758488AbZBXUY1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 15:24:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bhalevy@panasas.com, bfields@fieldses.org, hch@infradead.org, torvalds@linux-foundation.org, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk


The patch titled
     EXPORT_SYMBOL(d_obtain_alias) rather than EXPORT_SYMBOL_GPL
has been added to the -mm tree.  Its filename is
     export_symbold_obtain_alias-rather-than-export_symbol_gpl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Al Viro <viro@zeniv.linux.org.uk>
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

linux-next.patch
export_symbold_obtain_alias-rather-than-export_symbol_gpl.patch

