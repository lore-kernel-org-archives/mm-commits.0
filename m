Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA0541D225
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525587; cv=none; b=qK0e7KMMcQpHbxV8NfOkJwAMEQWcgr86shK2mBeco4c6wJo2V4a081G0SibscgbRCY+FYS0RFYruJXnJ4cfpQ819rE1xDTyYt2guwfPVbsCG+FDw4dqkM5daiJ9IaZjM7EA/38I5gLUA9QEDpBwd3fNyCW5nUjzMOWsq15NaYJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525587; c=relaxed/simple;
	bh=Qwng8JuRVPje91vMalKMyGqWleJ0k5kFAAIIZS8rybo=;
	h=Date:To:From:Subject:Message-Id; b=X8hi8qoKMSnSMvAxZvINPw/BbF2JfSk8ttWbWLg48XtK1YE0ZNslzRG7fQSUr/4nW3mW4rXYcrb6ms78PqHIZjlUwXztjgaHDrViDfHgoJLXZnUqhCnEnEkbSv2TolbiKxS6ROYDso0TrNpB8w/K7DL+9rGK+94UTUEuFcR+Lkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oOtpVcbf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oOtpVcbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038BC1F000FF;
	Fri,  9 Oct 2026 05:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525581;
	bh=0HzocoW8yzq7pPxb5Wt1O79X/duLzLlHSf+R3vYA0TI=;
	h=Date:To:From:Subject;
	b=oOtpVcbfrNWZIIbQom3FH90Hw2ml1s4jXFcEWtGbgzjzpZt2p0yzpbOR4tt3c9hRL
	 90ERVaeGmrKujPG1TEsM32Ldvl3K3FkqVNHOad7cHqOPiLu6Oef/tPS9WpuekZssRR
	 hdajXuhaSAIG+uriJaORWvlUhN0YzyCE/KHKr1lg=
Date: Thu, 08 Oct 2026 22:59:40 -0700
To: mm-commits@vger.kernel.org,zbestahu@gmail.com,xiang@kernel.org,lance.yang@linux.dev,jefflexu@linux.alibaba.com,hongbohbli@tencent.com,guochunhai@vivo.com,dhavale@google.com,david@kernel.org,chao@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] erofs-use-folio_attach-detach_private-instead-of-direct-assignment.patch removed from -mm tree
Message-Id: <20261009055941.038BC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: erofs: use folio_attach/detach_private() instead of direct assignment
has been removed from the -mm tree.  Its filename was
     erofs-use-folio_attach-detach_private-instead-of-direct-assignment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: erofs: use folio_attach/detach_private() instead of direct assignment
Date: Sun, 20 Sep 2026 22:28:05 -0400

erofs_onlinefolio_init/split/end() use folio->private without setting
PG_private or increasing folio refcount and it works.  But after
PG_private is replaced by checking folio->private in a future commit, it
can break folio_expected_ref_count(), since the folio has private data
without elevated refcount.  Change them to use
folio_attach/detach_private().  Folios during this process are locked as
they are in the process of readahead, so no parallel migration/folio split
can happen.

Furthermore, because folio->private is used to store in-flight I/O counter
and the counter reaches 0 when all I/O completes successfully without
error or being dirty, ->private=0 causes folio_detach_private() to not
drop the elevated folio refcount.  Solve this issue by using bias=1 for
the counter, so that ->private stays non NULL throughout every
attach-to-detach process.  Add a macro EROFS_ONLINEFOLIO_BIAS=1.  While at
it, fix the comment about ->private bit layout and add
EROFS_ONLINEFOLIO_COUNT_MASK.

It prepares for a future commit that removes PG_private.

Link: https://lore.kernel.org/20260920-remove-pg_private-v5-9-bb68b6a21869@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Assisted-by: LLM
Cc: Chao Yu <chao@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Sandeep Dhavale <dhavale@google.com>
Cc: Hongbo Li <hongbohbli@tencent.com>
Cc: Chunhai Guo <guochunhai@vivo.com>
---

 fs/erofs/data.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/fs/erofs/data.c~erofs-use-folio_attach-detach_private-instead-of-direct-assignment
+++ a/fs/erofs/data.c
@@ -239,19 +239,23 @@ int erofs_map_dev(struct super_block *sb
 /*
  * bit 30: I/O error occurred on this folio
  * bit 29: CPU has dirty data in D-cache (needs aliasing handling);
- * bit 0 - 29: remaining parts to complete this folio
+ * bit 0 - 28: remaining parts to complete this folio, biased by 1 so that
+ *	       ->private stays non-NULL while the folio is attached
  */
 #define EROFS_ONLINEFOLIO_EIO		30
 #define EROFS_ONLINEFOLIO_DIRTY		29
+#define EROFS_ONLINEFOLIO_COUNT_MASK	(BIT(EROFS_ONLINEFOLIO_DIRTY) - 1)
+#define EROFS_ONLINEFOLIO_BIAS		1
 
 void erofs_onlinefolio_init(struct folio *folio)
 {
 	union {
 		atomic_t o;
 		void *v;
-	} u = { .o = ATOMIC_INIT(1) };
+	} u = { .o = ATOMIC_INIT(1 + EROFS_ONLINEFOLIO_BIAS) };
 
-	folio->private = u.v;	/* valid only if file-backed folio is locked */
+	/* valid only if file-backed folio is locked */
+	folio_attach_private(folio, u.v);
 }
 
 void erofs_onlinefolio_split(struct folio *folio)
@@ -265,14 +269,14 @@ void erofs_onlinefolio_end(struct folio
 
 	do {
 		orig = atomic_read((atomic_t *)&folio->private);
-		DBG_BUGON(orig <= 0);
+		DBG_BUGON((orig & EROFS_ONLINEFOLIO_COUNT_MASK) <= EROFS_ONLINEFOLIO_BIAS);
 		v = dirty << EROFS_ONLINEFOLIO_DIRTY;
 		v |= (orig - 1) | (!!err << EROFS_ONLINEFOLIO_EIO);
 	} while (atomic_cmpxchg((atomic_t *)&folio->private, orig, v) != orig);
 
-	if (v & (BIT(EROFS_ONLINEFOLIO_DIRTY) - 1))
+	if ((v & EROFS_ONLINEFOLIO_COUNT_MASK) != EROFS_ONLINEFOLIO_BIAS)
 		return;
-	folio->private = 0;
+	folio_detach_private(folio);
 	if (v & BIT(EROFS_ONLINEFOLIO_DIRTY))
 		flush_dcache_folio(folio);
 	folio_end_read(folio, !(v & BIT(EROFS_ONLINEFOLIO_EIO)));
_

Patches currently in -mm which might be from ziy@nvidia.com are


