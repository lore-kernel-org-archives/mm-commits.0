Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CE33E025C;
	Sun, 20 Sep 2026 20:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789934695; cv=none; b=W5AhuxeNMQzc0WgMUA1uZUpjXJwi7E0Uw9B2kiSlfEspJwOOPEwXA1wNH3CH6IHLRriMvjxaPF+28ttwvNlttJu+GQoj9Sl30kppK5PV1Uk8FqskWTW11tXeXiSAHbjZmOhoF4RWX5x9HOaDQPcu9J30I9x5bnDG21efscsjzPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789934695; c=relaxed/simple;
	bh=F9VWCBk6W2fAx2w7W+IPdruqMXGOEdpHzq4qFClzn2Y=;
	h=Date:To:From:Subject:Message-Id; b=PmTR50DJOhDDDHKgxOJJhnTrZCSnwury04jXyIkyzvqs0qSx4CEeiLvuP3aboZ3qV/DBjlEnSFPA2hUg820bXwGTM2Fp3gfYAnnSqW8Ut88+WR+0k1/M2Tr1DK9bMTk+Zk5c9PknnVPVIBFqKYVjVg5IZvk3bHRdYhYI08sGwWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r24ncsOC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r24ncsOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061751F000FF;
	Sun, 20 Sep 2026 20:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789934694;
	bh=OuesB80kFgKLhQbqV3mXBdfFdoWR/T8OGK3Z6z90oK4=;
	h=Date:To:From:Subject;
	b=r24ncsOC14PalfNkUiQd5m6ycCPEqs61vA89SqxPmnmIJD67Oi9FKePs2jke/I/dQ
	 jQ/qlJBo67Ascj7Zm1OM4dcyAY6puscgVwWEJR4qqNxE13o9JC8o7A1NoLxUMewhI+
	 Debd0OCMQ197tlDxkwvkAIU9jg9wYP2kGFiNGo7o=
Date: Sun, 20 Sep 2026 13:04:53 -0700
To: mm-commits@vger.kernel.org,syzbot+23b25ba3c6bf971f9c57@syzkaller.appspotmail.com,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,hughd@google.com,https://lore.kernel.org/20260920155002.1030454-1-devnexen@gmail.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-dont-release-a-swapin-error-marker-as-a-swap-entry.patch added to mm-new branch
Message-Id: <20260920200454.061751F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: don't release a swapin-error marker as a swap entry
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-dont-release-a-swapin-error-marker-as-a-swap-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-dont-release-a-swapin-error-marker-as-a-swap-entry.patch

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
From: David Carlier <devnexen@gmail.com>
Subject: mm/shmem: don't release a swapin-error marker as a swap entry
Date: Sun, 20 Sep 2026 16:50:02 +0100

A failed shmem swapin (eg, EIO) frees the swap slot and leaves a
PTE_MARKER_POISONED entry in the page cache.  On truncate or eviction
shmem_free_swap() passes that marker to swap_put_entries_direct(), which
warns because it is not a swap entry.  There is nothing left to release
either way.

Skip the release for non-swap entries, as every other caller already does.

Link: https://lore.kernel.org/20260920155002.1030454-1-devnexen@gmail.com
Fixes: ac2d3268284b ("mm/swapfile.c: remove the unneeded checking")
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: syzbot+23b25ba3c6bf971f9c57@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=23b25ba3c6bf971f9c57
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan he <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chis Li <chrisl@kernel.org> (Google)
Cc: Hugh Dickens <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/shmem.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-dont-release-a-swapin-error-marker-as-a-swap-entry
+++ a/mm/shmem.c
@@ -1184,6 +1184,7 @@ static long shmem_free_swap(struct addre
 			    pgoff_t index, pgoff_t end, void *radswap)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
+	const softleaf_t swp = radix_to_swp_entry(radswap);
 	unsigned int nr_pages = 0;
 	pgoff_t base;
 	void *entry;
@@ -1200,8 +1201,9 @@ static long shmem_free_swap(struct addre
 	}
 	xas_unlock_irq(&xas);
 
-	if (nr_pages)
-		swap_put_entries_direct(radix_to_swp_entry(radswap), nr_pages);
+	/* A swapin-error marker holds no swap slot, so just drop it. */
+	if (nr_pages && softleaf_is_swap(swp))
+		swap_put_entries_direct(swp, nr_pages);
 
 	return nr_pages;
 }
_

Patches currently in -mm which might be from devnexen@gmail.com are

mm-shmem-dont-release-a-swapin-error-marker-as-a-swap-entry.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin.patch

