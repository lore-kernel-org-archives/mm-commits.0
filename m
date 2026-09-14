Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5566D36D4F1
	for <mm-commits@vger.kernel.org>; Mon, 14 Sep 2026 03:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789357932; cv=none; b=lJkgfYuR8svZk9w8kWY/2uKwvO49CVNb/UiEdBEM4otL1Cb1jx4Wl08LIOZ59hXYGgK3AYbuwUKxDZhQImjiBeS1+gXHhtVTMX44xqNJ2cb0+Ds9Qp//RmNXZbuBM60hCofmKvdo1I0r0urpYi084QSYkzitnEsU5+yuK9X1FU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789357932; c=relaxed/simple;
	bh=vJ5LYfSPFx7gDaOpqU4PrpxgJ3ljN64TlFn/jtHaCe8=;
	h=Date:To:From:Subject:Message-Id; b=NiJvEB14rRwreSV3nJFjzdeyYKkjbwB6jFF56Mr4NV/vcpPohwLsP4z8Ros3uvwkmmkJolp9Hgb3ocgOvePsZxcIBZH479pwOkbgHVuHzqEQn4hpdWQvB3NbmP1+1gOJRxBmtwVbpSa0NpNTkT9Zwy1YYVRzneuMuSeWdum3vEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c9MYEZcO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c9MYEZcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C300A1F000FF;
	Mon, 14 Sep 2026 03:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789357930;
	bh=aYVWjYLUGsR5zksmWYdsjMO2WwV0+zfD/4UJR68UGAQ=;
	h=Date:To:From:Subject;
	b=c9MYEZcO2i910smtj4ayX9H2rs86FXDUc4jJGe4AswmArR+hAVQRkn89S71xrTGkD
	 S7HiS7cwltsA5XCKysoTd62bDhDerQ8wxu0sfHk3fK1FIG4jw2J51lpNUlMeHtd3pW
	 k98qxITAnDCfbwyFx/TlCyxd1B9npl3p+H/rh+9I=
Date: Sun, 13 Sep 2026 20:52:10 -0700
To: mm-commits@vger.kernel.org,zbestahu@gmail.com,xiang@kernel.org,jefflexu@linux.alibaba.com,hongbohbli@tencent.com,guochunhai@vivo.com,dhavale@google.com,chao@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + erofs-use-folio_attach-detach_private-instead-of-direct-assignment.patch added to mm-new branch
Message-Id: <20260914035210.C300A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: erofs: use folio_attach/detach_private() instead of direct assignment
has been added to the -mm mm-new branch.  Its filename is
     erofs-use-folio_attach-detach_private-instead-of-direct-assignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/erofs-use-folio_attach-detach_private-instead-of-direct-assignment.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Date: Sun, 13 Sep 2026 22:24:07 -0400

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
Link: https://lore.kernel.org/20260913-remove-pg_private-v4-9-848550f7574e@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Sandeep Dhavale <dhavale@google.com>
Cc: Hongbo Li <hongbohbli@tencent.com>
Cc: Chunhai Guo <guochunhai@vivo.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Chao Yu <chao@kernel.org>
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
md-md-bitmap-replace-pageprivate-with-page_private.patch
buffer-replace-page_buffer-with-page_private-and-delete-it.patch
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

