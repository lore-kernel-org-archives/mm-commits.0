Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814C41EEA47
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119324; cv=none; b=BhcOhsQuy7XoX/077MncUspLG1QCiJlTJfCJuXgqQoARmy2coWj97V9u70R1U1pMhJUqw4ivF8zVMegzXSfMDoEipAb7tZR5tGjzdrL89cPGKYLrl8U1Q9A1l1FMF8e9MKV90lX1bducZg4RWa8mBjGQ+fghft5ozm2iszk4QvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119324; c=relaxed/simple;
	bh=8Rs+XiMTH4VZ26uToqVB35BhLGNjjoJ4ex3FWaejuA8=;
	h=Date:To:From:Subject:Message-Id; b=sB9ldlwP638nEHOc6Pk/X5Vj2OYEOG4ljFLkg0ef4ny7Uzb2+IkeWCNxB+7F6aSK/qjRk3no0G3LHGHl7sEiiDN28pzBsEEpSlaW84kGcZB4mBoS1FE0aBDadz4QMjIGkLuSKzVdpbruvjcqYecjzUL38ZGL8aOUCksm5grkwTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vxqf7ZuR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vxqf7ZuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5867FC4CEE4;
	Tue, 13 May 2025 06:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119324;
	bh=8Rs+XiMTH4VZ26uToqVB35BhLGNjjoJ4ex3FWaejuA8=;
	h=Date:To:From:Subject:From;
	b=Vxqf7ZuRuw/gtlCvuyWFrdM8tSC8GXuiXQ73ECB2J3A5muYPZomTBjgJIDgsUtnmM
	 eiRb5Bx5j7Z5fkbkAsPZi6mUmg71kF/s3LWnSTr3wsRRuVN6kqG1MxdzJ1hXO/VzXw
	 AND2TjJ6GmlQpsAH0QtvnXokhh5hMAuqz5NJl46Q=
Date: Mon, 12 May 2025 23:55:23 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,wqu@suse.com,willy@infradead.org,nphamcs@gmail.com,miklos@szeredi.hu,josef@toxicpanda.com,joannelkoong@gmail.com,jaegeuk@kernel.org,hughd@google.com,hannes@cmpxchg.org,dsterba@suse.com,david@redhat.com,clm@fb.com,chrisl@kernel.org,chao@kernel.org,brauner@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-do-not-use-folio_contains-for-swap-cache-folios.patch removed from -mm tree
Message-Id: <20250513065524.5867FC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: filemap: do not use folio_contains for swap cache folios
has been removed from the -mm tree.  Its filename was
     filemap-do-not-use-folio_contains-for-swap-cache-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: filemap: do not use folio_contains for swap cache folios
Date: Thu, 1 May 2025 02:10:50 +0800

Currently, none of the folio_contains callers should encounter swap cache
folios.

For fs/ callers, swap cache folios are never part of their workflow.

For filemap and truncate, folio_contains is only used for sanity checks to
verify the folio index matches the expected lookup / invalidation target.

The swap cache does not utilize filemap or truncate helpers in ways that
would trigger these checks, as it mostly implements its own cache
management.

Shmem won't trigger these sanity checks either unless thing went wrong, as
it would directly trigger a BUG because swap cache index are unrelated and
almost never matches shmem index.  Shmem have to handle mixed values of
folios, shadows, and swap entries, so it has its own way of handling the
mapping.

While some filemap helpers works for swap cache space, the swap cache is
different from the page cache in many ways.  So this particular helper
will unlikely to work in a helpful way for swap cache folios.

So make it explicit here that folio_contains should not be used for swap
cache folios.  This helps to avoid misuse, make swap cache less exposed
and remove the folio_index usage here.

[akpm@linux-foundation.org: s/VM_WARN_ON_FOLIO/VM_WARN_ON_ONCE_FOLIO/, per Kairui]
Link: https://lkml.kernel.org/r/20250430181052.55698-5-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Qu Wenruo <wqu@suse.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/pagemap.h~filemap-do-not-use-folio_contains-for-swap-cache-folios
+++ a/include/linux/pagemap.h
@@ -935,14 +935,14 @@ static inline struct page *folio_file_pa
  * @folio: The folio.
  * @index: The page index within the file.
  *
- * Context: The caller should have the page locked in order to prevent
- * (eg) shmem from moving the page between the page cache and swap cache
- * and changing its index in the middle of the operation.
+ * Context: The caller should have the folio locked and ensure
+ * e.g., shmem did not move this folio to the swap cache.
  * Return: true or false.
  */
 static inline bool folio_contains(struct folio *folio, pgoff_t index)
 {
-	return index - folio_index(folio) < folio_nr_pages(folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
+	return index - folio->index < folio_nr_pages(folio);
 }
 
 unsigned filemap_get_folios(struct address_space *mapping, pgoff_t *start,
_

Patches currently in -mm which might be from kasong@tencent.com are


