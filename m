From: akpm@linux-foundation.org
Subject: [merged] isofs-replace-strnicmp-with-strncasecmp.patch removed
 from -mm tree
Date: Tue, 14 Oct 2014 11:22:16 -0700
Message-ID: <543d69d8.zhDFa6LAwFs+5qQe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaJNSWO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:22:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: isofs: replace strnicmp with strncasecmp
has been removed from the -mm tree.  Its filename was
     isofs-replace-strnicmp-with-strncasecmp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: isofs: replace strnicmp with strncasecmp

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics and a
slightly buggy strncasecmp.  The latter is the POSIX name, so strnicmp was
renamed to strncasecmp, and strnicmp made into a wrapper for the new
strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in the
future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/isofs/inode.c~isofs-replace-strnicmp-with-strncasecmp fs/isofs/inode.c
--- a/fs/isofs/inode.c~isofs-replace-strnicmp-with-strncasecmp
+++ a/fs/isofs/inode.c
@@ -247,7 +247,7 @@ static int isofs_dentry_cmp_common(
 	}
 	if (alen == blen) {
 		if (ci) {
-			if (strnicmp(name->name, str, alen) == 0)
+			if (strncasecmp(name->name, str, alen) == 0)
 				return 0;
 		} else {
 			if (strncmp(name->name, str, alen) == 0)
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

