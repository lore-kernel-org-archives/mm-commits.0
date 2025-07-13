Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586A91F560B
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752449991; cv=none; b=itZ2gFW8YPBotStJdR7uBgkeRU7WNZsiHnItNKCSdh4sL2qQIH5kB7tZilkI2MpR2owLhxfm/1D6z4Oui+lYtaTtUrZhFayU76vEsyi1MPCLQj2JnijMjOodKJFC6DrDTwh+wul5y8hlIJfCpK0eykEOXnnU129nPJ7eM7OQBOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752449991; c=relaxed/simple;
	bh=nrdyIQbSEtPDZa7vM1cO5w05CqMxw4oXyuVvlI8QSoc=;
	h=Date:To:From:Subject:Message-Id; b=mBrrx+WFxPeaH3Z0gkBbk+KDjUqYZNf/+mIeDyOloev+Dt9MR+GdFAXttMIeu0BpYqk1MBLbZoimQaVN/yxUsVVD7rYVRU6PPx3k6u1WzqwCVaOIOw0t6d27FYdn1pxyLwrU/dj9eKJDonda+JaIX7ORWlfKl1jryauXacW6J6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tg61WRLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tg61WRLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7957C4CEE3;
	Sun, 13 Jul 2025 23:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752449991;
	bh=nrdyIQbSEtPDZa7vM1cO5w05CqMxw4oXyuVvlI8QSoc=;
	h=Date:To:From:Subject:From;
	b=tg61WRLXG+VmhpniKjObN38t9mpPs+zMpvaky/jhQYbQBlGYcSQlDHoG7pkqYkYdi
	 9gSz98rysjm4CZDI3lrSsD/Sk8MdMjlryAnvCobv4QFG0zLvJqAJOsPWnnly/7zPQZ
	 GnKe5FrnH/DLlnzQIbPcYOMNNXn8e0mVv9Sp26bY=
Date: Sun, 13 Jul 2025 16:39:50 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,ccross@google.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-use-standard-madvise-locking-in-madvise_set_anon_name.patch removed from -mm tree
Message-Id: <20250713233950.E7957C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, madvise: use standard madvise locking in madvise_set_anon_name()
has been removed from the -mm tree.  Its filename was
     mm-madvise-use-standard-madvise-locking-in-madvise_set_anon_name.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, madvise: use standard madvise locking in madvise_set_anon_name()
Date: Tue, 24 Jun 2025 15:03:48 +0200

Use madvise_lock()/madvise_unlock() in madvise_set_anon_name() in the same
way as in do_madvise().  This narrows the lock scope a bit and reuses
existing functionality.  get_lock_mode() already picks the correct
MADVISE_MMAP_WRITE_LOCK mode for __MADV_SET_ANON_VMA_NAME so we can just
remove the explicit assignment.

There is a user visible change in that the prctl(PR_SET_VMA,
PR_SET_VMA_ANON_NAME...) might now return -EINTR.

Link: https://lkml.kernel.org/r/20250624-anon_name_cleanup-v2-4-600075462a11@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Colin Cross <ccross@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/madvise.c~mm-madvise-use-standard-madvise-locking-in-madvise_set_anon_name
+++ a/mm/madvise.c
@@ -2082,10 +2082,10 @@ static int madvise_set_anon_name(struct
 {
 	unsigned long end;
 	unsigned long len;
+	int error;
 	struct madvise_behavior madv_behavior = {
 		.mm = mm,
 		.behavior = __MADV_SET_ANON_VMA_NAME,
-		.lock_mode = MADVISE_MMAP_WRITE_LOCK,
 		.anon_name = anon_name,
 	};
 
@@ -2106,7 +2106,14 @@ static int madvise_set_anon_name(struct
 
 	madv_behavior.range.start = start;
 	madv_behavior.range.end = end;
-	return madvise_walk_vmas(&madv_behavior);
+
+	error = madvise_lock(&madv_behavior);
+	if (error)
+		return error;
+	error = madvise_walk_vmas(&madv_behavior);
+	madvise_unlock(&madv_behavior);
+
+	return error;
 }
 
 int set_anon_vma_name(unsigned long addr, unsigned long size,
@@ -2136,9 +2143,7 @@ int set_anon_vma_name(unsigned long addr
 			return -ENOMEM;
 	}
 
-	mmap_write_lock(mm);
 	error = madvise_set_anon_name(mm, addr, size, anon_name);
-	mmap_write_unlock(mm);
 	anon_vma_name_put(anon_name);
 
 	return error;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter.patch
mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter-fix.patch

