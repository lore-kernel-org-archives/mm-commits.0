From: akpm@linux-foundation.org
Subject: + nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0.patch added to -mm tree
Date: Mon, 08 Dec 2008 14:46:09 -0800
Message-ID: <200812082246.mB8MkAmZ016071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbYLHWqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 17:46:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: staubach@redhat.com


The patch titled
     nfs: optimize attribute timeouts for "noac" and "actimeo=0"
has been added to the -mm tree.  Its filename is
     nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0.patch

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
Subject: nfs: optimize attribute timeouts for "noac" and "actimeo=0"
From: Peter Staubach <staubach@redhat.com>

I've been looking at a bugzilla which describes a problem where a customer
was advised to use either the "noac" or "actimeo=0" mount options to solve
a consistency problem that they were seeing in the file attributes.  It
turned out that this solution did not work reliably for them because
sometimes, the local attribute cache was believed to be valid and not
timed out.  (With an attribute cache timeout of 0, the cache should always
appear to be timed out.)

In looking at this situation, it appears to me that the problem is that
the attribute cache timeout code has an off-by-one error in it.  It is
assuming that the cache is valid in the region, [read_cache_jiffies,
read_cache_jiffies + attrtimeo].  The cache should be considered valid
only in the region, [read_cache_jiffies, read_cache_jiffies + attrtimeo). 
With this change, the options, "noac" and "actimeo=0", work as originally
expected.

This problem was previously addressed by special casing the attrtimeo == 0
case.  However, since the problem is only an off- by-one error, the
cleaner solution is address the off-by-one error and thus, not require the
special case.

Signed-off-by: Peter Staubach <staubach@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/dir.c            |    2 +-
 fs/nfs/inode.c          |   11 ++---------
 include/linux/jiffies.h |   10 ++++++++++
 include/linux/nfs_fs.h  |    5 ++++-
 net/sunrpc/auth.c       |    2 +-
 5 files changed, 18 insertions(+), 12 deletions(-)

diff -puN fs/nfs/dir.c~nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0 fs/nfs/dir.c
--- a/fs/nfs/dir.c~nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0
+++ a/fs/nfs/dir.c
@@ -1794,7 +1794,7 @@ static int nfs_access_get_cached(struct 
 	cache = nfs_access_search_rbtree(inode, cred);
 	if (cache == NULL)
 		goto out;
-	if (!time_in_range(jiffies, cache->jiffies, cache->jiffies + nfsi->attrtimeo))
+	if (!time_in_range_open(jiffies, cache->jiffies, cache->jiffies + nfsi->attrtimeo))
 		goto out_stale;
 	res->jiffies = cache->jiffies;
 	res->cred = cache->cred;
diff -puN fs/nfs/inode.c~nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0 fs/nfs/inode.c
--- a/fs/nfs/inode.c~nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0
+++ a/fs/nfs/inode.c
@@ -712,14 +712,7 @@ int nfs_attribute_timeout(struct inode *
 
 	if (nfs_have_delegation(inode, FMODE_READ))
 		return 0;
-	/*
-	 * Special case: if the attribute timeout is set to 0, then always
-	 * 		 treat the cache as having expired (unless holding
-	 * 		 a delegation).
-	 */
-	if (nfsi->attrtimeo == 0)
-		return 1;
-	return !time_in_range(jiffies, nfsi->read_cache_jiffies, nfsi->read_cache_jiffies + nfsi->attrtimeo);
+	return !time_in_range_open(jiffies, nfsi->read_cache_jiffies, nfsi->read_cache_jiffies + nfsi->attrtimeo);
 }
 
 /**
@@ -1182,7 +1175,7 @@ static int nfs_update_inode(struct inode
 		nfsi->attrtimeo_timestamp = now;
 		nfsi->attr_gencount = nfs_inc_attr_generation_counter();
 	} else {
-		if (!time_in_range(now, nfsi->attrtimeo_timestamp, nfsi->attrtimeo_timestamp + nfsi->attrtimeo)) {
+		if (!time_in_range_open(now, nfsi->attrtimeo_timestamp, nfsi->attrtimeo_timestamp + nfsi->attrtimeo)) {
 			if ((nfsi->attrtimeo <<= 1) > NFS_MAXATTRTIMEO(inode))
 				nfsi->attrtimeo = NFS_MAXATTRTIMEO(inode);
 			nfsi->attrtimeo_timestamp = now;
diff -puN include/linux/jiffies.h~nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0 include/linux/jiffies.h
--- a/include/linux/jiffies.h~nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0
+++ a/include/linux/jiffies.h
@@ -115,10 +115,20 @@ static inline u64 get_jiffies_64(void)
 	 ((long)(a) - (long)(b) >= 0))
 #define time_before_eq(a,b)	time_after_eq(b,a)
 
+/*
+ * Calculate whether a is in the range of [b, c].
+ */
 #define time_in_range(a,b,c) \
 	(time_after_eq(a,b) && \
 	 time_before_eq(a,c))
 
+/*
+ * Calculate whether a is in the range of [b, c).
+ */
+#define time_in_range_open(a,b,c) \
+	(time_after_eq(a,b) && \
+	 time_before(a,c))
+
 /* Same as above, but does so with platform independent 64bit types.
  * These must be used when utilizing jiffies_64 (i.e. return value of
  * get_jiffies_64() */
diff -puN include/linux/nfs_fs.h~nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0 include/linux/nfs_fs.h
--- a/include/linux/nfs_fs.h~nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0
+++ a/include/linux/nfs_fs.h
@@ -130,7 +130,10 @@ struct nfs_inode {
 	 *
 	 * We need to revalidate the cached attrs for this inode if
 	 *
-	 *	jiffies - read_cache_jiffies > attrtimeo
+	 *	jiffies - read_cache_jiffies >= attrtimeo
+	 *
+	 * Please note the comparison is greater than or equal
+	 * so that zero timeout values can be specified.
 	 */
 	unsigned long		read_cache_jiffies;
 	unsigned long		attrtimeo;
diff -puN net/sunrpc/auth.c~nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0 net/sunrpc/auth.c
--- a/net/sunrpc/auth.c~nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0
+++ a/net/sunrpc/auth.c
@@ -234,7 +234,7 @@ rpcauth_prune_expired(struct list_head *
 	list_for_each_entry_safe(cred, next, &cred_unused, cr_lru) {
 
 		/* Enforce a 60 second garbage collection moratorium */
-		if (time_in_range(cred->cr_expire, expired, jiffies) &&
+		if (time_in_range_open(cred->cr_expire, expired, jiffies) &&
 		    test_bit(RPCAUTH_CRED_HASHED, &cred->cr_flags) != 0)
 			continue;
 
_

Patches currently in -mm which might be from staubach@redhat.com are

nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0.patch

