Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A724B1F1505
	for <mm-commits@vger.kernel.org>; Wed, 30 Apr 2025 21:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746047091; cv=none; b=OTDlud/z7GtW7kuI7H4i6pMN4Jj4c/kxXgPj07/eYUFTO/x6CPqxhmKaqWdrh4VtHcDIqKXcPUWVUzWZgQ021wVqWTM8431S37vd8FWvCK3TWIRE12wFWicHwNy7AIKpnMcLr3YGrBNkleWlpQY1X/+Wuw+Fk7SL2TEAfMeZofQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746047091; c=relaxed/simple;
	bh=ooBfOGX/kIx7DzRuSaoPfCp5lrAAKfH1FjWcgx0umM0=;
	h=Date:To:From:Subject:Message-Id; b=Zke0PZinzwQ5l9h7N3rdRMOEy4HeHxJFXE74B4Qmagk6mktl19iX90XWvZqk/7aZrV+OO9afqY3syBbuQ418yAjbbrULXR0OvMOV9G8ZgXHnhH5qkL1u3HeTy0411j7GhibobkbXpjIjWet+hq6X3gjvBAONBhLumb/YPp4lvXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qDRbtqZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qDRbtqZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC3AC4CEE7;
	Wed, 30 Apr 2025 21:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746047090;
	bh=ooBfOGX/kIx7DzRuSaoPfCp5lrAAKfH1FjWcgx0umM0=;
	h=Date:To:From:Subject:From;
	b=qDRbtqZ+UT9NFCQMXOwlWB4rP2XYJt/JqwqhQ3eSXdUzPIXOPX3Y3925QApXLS8nC
	 b1yNTDRNY5JOfczuuDmNC7AltolEG+RTPf/Kouqox9oiUw3lM3Ioe6b8MIFgbPen70
	 HBU6IGQy/+Cib7LrnzOKo/lRax7loZ+iTr1uNCf4=
Date: Wed, 30 Apr 2025 14:04:50 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,wqu@suse.com,willy@infradead.org,nphamcs@gmail.com,miklos@szeredi.hu,josef@toxicpanda.com,joannelkoong@gmail.com,jaegeuk@kernel.org,hughd@google.com,hannes@cmpxchg.org,dsterba@suse.com,david@redhat.com,clm@fb.com,chrisl@kernel.org,chao@kernel.org,brauner@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-do-not-use-folio_contains-for-swap-cache-folios.patch added to mm-new branch
Message-Id: <20250430210450.CDC3AC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: filemap: do not use folio_contains for swap cache folios
has been added to the -mm mm-new branch.  Its filename is
     filemap-do-not-use-folio_contains-for-swap-cache-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-do-not-use-folio_contains-for-swap-cache-folios.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
+	VM_WARN_ON_FOLIO(folio_test_swapcache(folio), folio);
+	return index - folio->index < folio_nr_pages(folio);
 }
 
 unsigned filemap_get_folios(struct address_space *mapping, pgoff_t *start,
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memory-fix-mapcount-refcount-sanity-check-for-mthp-reuse.patch
mm-swap-fix-false-warning-for-large-allocation-with-thp_swap.patch
fuse-drop-usage-of-folio_index.patch
btrfs-drop-usage-of-folio_index.patch
f2fs-drop-usage-of-folio_index.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios.patch
mm-move-folio_index-to-mm-swaph-and-remove-no-longer-needed-helper.patch
mm-swap-remove-no-longer-used-swap-mapping-helper.patch

