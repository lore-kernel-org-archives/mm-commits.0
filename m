From: akpm@linux-foundation.org
Subject: + fs-hfs-fix-comparison-bug-in-hfs_cat_keycmp.patch added to -mm
 tree
Date: Wed, 10 Dec 2014 13:51:07 -0800
Message-ID: <5488c04b.qTCuqYxNf3di4fo7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932855AbaLJVvI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 16:51:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, slava@dubeyko.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/hfs/catalog.c: fix comparison bug in hfs_cat_keycmp
has been added to the -mm tree.  Its filename is
     fs-hfs-fix-comparison-bug-in-hfs_cat_keycmp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-hfs-fix-comparison-bug-in-hfs_cat_keycmp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-hfs-fix-comparison-bug-in-hfs_cat_keycmp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: fs/hfs/catalog.c: fix comparison bug in hfs_cat_keycmp

Relying on the sign (after casting to int) of the difference of two
quantities for comparison is usually wrong.  For example, should a-b turn
out to be 2^31, the return value of cmp(a,b) is -2^31; but that would also
be the return value from cmp(b, a).  So a compares less than b and b
compares less than a.  One can also easily find three values a,b,c such
that a compares less than b, b compares less than c, but a does not
compare less than c.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/catalog.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN fs/hfs/catalog.c~fs-hfs-fix-comparison-bug-in-hfs_cat_keycmp fs/hfs/catalog.c
--- a/fs/hfs/catalog.c~fs-hfs-fix-comparison-bug-in-hfs_cat_keycmp
+++ a/fs/hfs/catalog.c
@@ -162,14 +162,16 @@ err2:
  */
 int hfs_cat_keycmp(const btree_key *key1, const btree_key *key2)
 {
-	int retval;
+	__be32 k1p, k2p;
 
-	retval = be32_to_cpu(key1->cat.ParID) - be32_to_cpu(key2->cat.ParID);
-	if (!retval)
-		retval = hfs_strcmp(key1->cat.CName.name, key1->cat.CName.len,
-				    key2->cat.CName.name, key2->cat.CName.len);
+	k1p = key1->cat.ParID;
+	k2p = key2->cat.ParID;
 
-	return retval;
+	if (k1p != k2p)
+		return be32_to_cpu(k1p) < be32_to_cpu(k2p) ? -1 : 1;
+
+	return hfs_strcmp(key1->cat.CName.name, key1->cat.CName.len,
+			  key2->cat.CName.name, key2->cat.CName.len);
 }
 
 /* Try to get a catalog entry for given catalog id */
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
lib-lcmc-ensure-correct-result-whenever-it-fits.patch
lib-lcmc-lcmn0=lcm0n-is-0-not-n.patch
fs-hfs-fix-comparison-bug-in-hfs_cat_keycmp.patch
linux-next.patch

