Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F0E20012B
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 06:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686465; cv=none; b=qN9yn5HnpJZ93oyQPerx3AnCNm3MbUKdckiAU7kIAw/Fq72y064EOZ0v6KCks7IFz8uY6BjCx5S+4gwQQltq+s7aPZIZIs7XrGG+M7QzqQvF19QFMFjNIaHV/DXhVdzbkuk55pQvMOmWOXSXXTQcmbqodfbA9H+OESJGrUA76Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686465; c=relaxed/simple;
	bh=A6U1UekN/RTJChVAUCoqX51KUvsTGVnJOoq1gOF4aIE=;
	h=Date:To:From:Subject:Message-Id; b=C65eWl4KWtmRec4TsRAKRnhVHptqW5rBholMjSYm6IDksfefIyTypjmHZV4KYvF/vFPC89FAjelhBDUVyo1KfwSklD7yNho983Binwe9G7PTpqyyosIHs0MDLafSbdt9mh9qpRnCAwKv/n8AGklbS1bPN6K3QxRVGPyYtHdHqTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fX+9Qjld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fX+9Qjld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA91C4CEF0;
	Thu,  8 May 2025 06:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746686465;
	bh=A6U1UekN/RTJChVAUCoqX51KUvsTGVnJOoq1gOF4aIE=;
	h=Date:To:From:Subject:From;
	b=fX+9QjldHeejOyKKxkT8l8hPX3pyoF5xF4iZXdN6oRJodI/24RCjlXKiP1E/CoC10
	 JEY7Z7/0Dw7ibUlfSZzVvSMpBZzO1eOSxj8itlmuLKHe526CF50dIqt4vysPYl0g5P
	 xTRuVi2lHlK+dpvAwGG9JjaQx/6p7+2Lv83Znr/I=
Date: Wed, 07 May 2025 23:41:04 -0700
To: mm-commits@vger.kernel.org,hca@linux.ibm.com,bhe@redhat.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-swap-fix-false-warning-for-large-allocation-with-thp_swap.patch removed from -mm tree
Message-Id: <20250508064104.EFA91C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: fix false warning for large allocation with !THP_SWAP
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-false-warning-for-large-allocation-with-thp_swap.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: fix false warning for large allocation with !THP_SWAP
Date: Tue, 29 Apr 2025 17:48:03 +0800

The !CONFIG_THP_SWAP check existed before just fine because slot cache
would reject high order allocation and let the caller split all folios and
try again.

But slot cache is gone, so large allocation will directly go to the
allocator, and the allocator should just fail silently to inform caller to
do the folio split, this is totally fine and expected.

Remove this meaningless warning.

Link: https://lkml.kernel.org/r/20250429094803.85518-1-ryncsn@gmail.com
Fixes: 0ff67f990bd4 ("mm, swap: remove swap slot cache")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Heiko Carstens <hca@linux.ibm.com>
Closes: https://lore.kernel.org/linux-mm/20250428135252.25453B17-hca@linux.ibm.com/
Tested-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/mm/swapfile.c~mm-swap-fix-false-warning-for-large-allocation-with-thp_swap
+++ a/mm/swapfile.c
@@ -1272,13 +1272,22 @@ int folio_alloc_swap(struct folio *folio
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
 
-	/*
-	 * Should not even be attempting large allocations when huge
-	 * page swap is disabled. Warn and fail the allocation.
-	 */
-	if (order && (!IS_ENABLED(CONFIG_THP_SWAP) || size > SWAPFILE_CLUSTER)) {
-		VM_WARN_ON_ONCE(1);
-		return -EINVAL;
+	if (order) {
+		/*
+		 * Reject large allocation when THP_SWAP is disabled,
+		 * the caller should split the folio and try again.
+		 */
+		if (!IS_ENABLED(CONFIG_THP_SWAP))
+			return -EAGAIN;
+
+		/*
+		 * Allocation size should never exceed cluster size
+		 * (HPAGE_PMD_SIZE).
+		 */
+		if (size > SWAPFILE_CLUSTER) {
+			VM_WARN_ON_ONCE(1);
+			return -EINVAL;
+		}
 	}
 
 	local_lock(&percpu_swap_cluster.lock);
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memory-fix-mapcount-refcount-sanity-check-for-mthp-reuse.patch
fuse-drop-usage-of-folio_index.patch
btrfs-drop-usage-of-folio_index.patch
f2fs-drop-usage-of-folio_index.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios.patch
mm-move-folio_index-to-mm-swaph-and-remove-no-longer-needed-helper.patch
mm-swap-remove-no-longer-used-swap-mapping-helper.patch

