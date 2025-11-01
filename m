Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D15023958D
	for <mm-commits@vger.kernel.org>; Sat,  1 Nov 2025 03:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761966538; cv=none; b=YHOdFYZK6Y/vKgeYQOLVNZDaXsx6tB26MS+LQwJ/2rlqDVp54vBgp5bod4YETwauGFQX3DfQ8UlXSztNK8VxHsC62MthlWjtlPha5s7PDTbLYTLbizSfNDtqUtxyxybkW6jb6jq8RIio95gxh4LaHrC+FORBOipXXq5vb8kJfOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761966538; c=relaxed/simple;
	bh=oVtwe1cXxRM6FHAB3LL1ezBvn2jQuPtIXS7hR6qO5BI=;
	h=Date:To:From:Subject:Message-Id; b=uXLQ9WrT30Gu77/+YP2KjXacCV7RflK8zpu/TInhjxTcZMl9C1JRWp3EaF/mCIqwATvU938/5hhkj3mtnChB7pTbmZbfGkohO9CQjqo0l46qT4WDsRGAwFIgYR3hi94VuhWBvAZZirF7UakB09WnfUKpvb6/oqmJe9E8xkQ485E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wCCVvtP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wCCVvtP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F1DC4CEE7;
	Sat,  1 Nov 2025 03:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761966538;
	bh=oVtwe1cXxRM6FHAB3LL1ezBvn2jQuPtIXS7hR6qO5BI=;
	h=Date:To:From:Subject:From;
	b=wCCVvtP7S97yfZzNYhVUR1tJhiIsveIlKLoCunBjDxZ4mwQhY1B4pVGwiRg5rNzM3
	 kyp/afUEBvwwzscc2uWCguEqlLeB6xHbnTQ2/s2GA25eztBXFr+s3wNOh6DffewG9k
	 ppxxnHvX90BJWvaImGNzszpBsWtzVmOxcBWi2cIs=
Date: Fri, 31 Oct 2025 20:08:57 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-redundant-comment-for-read_swap_cache_async.patch added to mm-new branch
Message-Id: <20251101030858.59F1DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: remove redundant comment for read_swap_cache_async
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-remove-redundant-comment-for-read_swap_cache_async.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-redundant-comment-for-read_swap_cache_async.patch

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
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm, swap: remove redundant comment for read_swap_cache_async
Date: Fri, 31 Oct 2025 15:50:09 +0900

The function now manages get/put_swap_device() internally, making the
comment explaining this behavior to callers unnecessary.

Link: https://lkml.kernel.org/r/20251031065011.40863-4-youngjun.park@lge.com
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/swap_state.c~mm-swap-remove-redundant-comment-for-read_swap_cache_async
+++ a/mm/swap_state.c
@@ -509,10 +509,6 @@ put_and_return:
  * and reading the disk if it is not already cached.
  * A failure return means that either the page allocation failed or that
  * the swap entry is no longer in use.
- *
- * get/put_swap_device() aren't needed to call this function, because
- * __read_swap_cache_async() call them and swap_read_folio() holds the
- * swap cache folio lock.
  */
 struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct vm_area_struct *vma, unsigned long addr,
_

Patches currently in -mm which might be from youngjun.park@lge.com are

mm-swap-fix-memory-leak-in-setup_clusters-error-path.patch
mm-swap-use-swp_solidstate-to-determine-if-swap-is-rotational.patch
mm-swap-remove-redundant-comment-for-read_swap_cache_async.patch
mm-swap-change-swap_alloc_slow-to-void.patch
mm-swap-remove-scan_swap_map_slots-references-from-comments.patch

