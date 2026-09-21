Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7050E34751F
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 04:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789963796; cv=none; b=bgmk3uZYoKOL9buM4sSitfZe/A91fxsytFnAlXn4p6OGhe1mUysLsQrflZPYyPwTvafR7I974bopiZYgCCy9eV2+ubu687dHjmhR8nf0PSSGJGov/mhW55ei8YscA0zG2RozbjshTUAFjyfviP3BOmmkjBWRYz/MiNoulEFF5v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789963796; c=relaxed/simple;
	bh=nLjWEVL+Mav4JFsGYzSLiXfRoRQjsobqN2JyBeFqZR8=;
	h=Date:To:From:Subject:Message-Id; b=k9DZZuCbX6WDY8Xq/m+nVwesAvIl21HSkYMZ+YhsqjWSffiDqkTAizxtW1z/WLLu1fVOGhgVsjoSmRBLqJXQCDV2VK+WNKkGqg7qO/jAjlWj/tSRcLtCbLY88LRYPWU6jRZGJwzUSKQQvv6gVmQ2zo2BEuaVIPbPyDhIvoRJSXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BgZBchnb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BgZBchnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0DE1F000FF;
	Mon, 21 Sep 2026 04:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789963795;
	bh=hQzyjlFFEN8FMALMDsNOzC/HtArZ8hHbVk/1aF8GcPA=;
	h=Date:To:From:Subject;
	b=BgZBchnbNkYJ0Yo8vmQ8H9Z4rtlfY8cexMfEdzfZPv8jmlfw3qOyWp7lacI6g9vNB
	 jN8ch3Pc1vXLmu9Ge8ZraVU+NLzd210Q6okipE5YDBTpTS1VsUkjjHGxfZe8nIaV+w
	 tjB9gyyBY/kPoEBkuf52zlxPMhgmr+ftklc6r6ks=
Date: Sun, 20 Sep 2026 21:09:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + erofs-use-folio_attach-detach_private-instead-of-direct-assignment.patch added to mm-unstable branch
Message-Id: <20260921040955.3C0DE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: erofs: use folio_attach/detach_private() instead of direct assignment
has been added to the -mm mm-unstable branch.  Its filename is
     erofs-use-folio_attach-detach_private-instead-of-direct-assignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/erofs-use-folio_attach-detach_private-instead-of-direct-assignment.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

Assisted-by: LLM
Link: https://lore.kernel.org/20260920-remove-pg_private-v5-9-bb68b6a21869@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
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

mm-zsmalloc-replace-pg_private-with-pointer-comparison.patch
perf-ring_buffer-stop-using-pg_private-as-aux-page-high-order-marker.patch
xen-grant-table-stop-setting-pg_private-on-pages-for-grant-mapping.patch
fscrypt-stop-setting-pg_private-on-bounce-page.patch
mm-hugetlb-use-direct-assignment-instead-of-folio_change_private.patch
f2fs-stop-using-pg_private.patch
f2fs-convert-the-private-flag-helpers-to-folio-only.patch
erofs-mm-pagemap-add-readahead_folio_last-to-avoid-folio-private.patch
erofs-use-folio_attach-detach_private-instead-of-direct-assignment.patch
mm-page-flags-check-page-folio-private-instead-of-pg_private.patch
treewide-remove-folio_set-clear_private-usage.patch
ceph-replace-pageprivate-with-page_private.patch
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

