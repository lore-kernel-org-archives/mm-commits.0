Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F21621518B
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188240; cv=none; b=smLyfYvTC6vVxMpuaj7Drxg6/Z73f59HPsJfCV+Bb/wl5ank1EAWE1rys41JMI/4ARBQHtTIebT/TQe8M+W4jQy+Vp31pccevje8aCvvsztUhdINTcHVkJzYJBDbq+jqQNeZoA+NL2PFjHDG2/Cr5GrBtFKjOtAT46598/clNac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188240; c=relaxed/simple;
	bh=UXDt4I8Mis9r/00R1Kd945nO5pAf6kqBJoswJvVraJI=;
	h=Date:To:From:Subject:Message-Id; b=aNWIrm5azgy/mKat7NsvX51kdcA+lRk8StTjmofKNVzUSOvdcqpUWLE2oUVl9zAaB63zPTBATuutR2RdGV8+u+dY89Ovb2LaV0JeJ4Mu5DvD4Yb4f1Z57vg6ca+z+p4qn4EuXTTUfgt0lEYRTKZr/xAqlUJXJOzA4Rcn6SdjjPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wp4FF3TB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wp4FF3TB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0B3C4CEEC;
	Mon, 17 Mar 2025 05:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188239;
	bh=UXDt4I8Mis9r/00R1Kd945nO5pAf6kqBJoswJvVraJI=;
	h=Date:To:From:Subject:From;
	b=Wp4FF3TBY7uj20KESQ6YDbh1qwI8i14Ao4YvThhgvxcE/+2gwtkthpVMXbWiRYUCz
	 1dMkUdPnHDc9WJnwNqCg3UPiXV+uK4gEz7FsiD6f4NpoKWalrQVMsYLwctA+He9uG5
	 r6oLNaMbQ4N2XiF6U6XxlcV1BnaEBdPx1Td8gVBg=
Date: Sun, 16 Mar 2025 22:10:39 -0700
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-rename-swap_is_has_cache-to-swap_only_has_cache.patch removed from -mm tree
Message-Id: <20250317051039.CC0B3C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: rename swap_is_has_cache() to swap_only_has_cache()
has been removed from the -mm tree.  Its filename was
     mm-swap-rename-swap_is_has_cache-to-swap_only_has_cache.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/swap: rename swap_is_has_cache() to swap_only_has_cache()
Date: Wed, 5 Feb 2025 17:27:14 +0800

There are two predicates in the name of swap_is_has_cache() which is
confusing.  Renaming it to remove the confusion and can better reflect its
functionality.

Link: https://lkml.kernel.org/r/20250205092721.9395-6-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swap-rename-swap_is_has_cache-to-swap_only_has_cache
+++ a/mm/swapfile.c
@@ -161,7 +161,7 @@ static long swap_usage_in_pages(struct s
 /* Reclaim directly, bypass the slot cache and don't touch device lock */
 #define TTRS_DIRECT		0x8
 
-static bool swap_is_has_cache(struct swap_info_struct *si,
+static bool swap_only_has_cache(struct swap_info_struct *si,
 			      unsigned long offset, int nr_pages)
 {
 	unsigned char *map = si->swap_map + offset;
@@ -243,7 +243,7 @@ static int __try_to_reclaim_swap(struct
 	 * reference or pending writeback, and can't be allocated to others.
 	 */
 	ci = lock_cluster(si, offset);
-	need_reclaim = swap_is_has_cache(si, offset, nr_pages);
+	need_reclaim = swap_only_has_cache(si, offset, nr_pages);
 	unlock_cluster(ci);
 	if (!need_reclaim)
 		goto out_unlock;
@@ -1577,7 +1577,7 @@ void put_swap_folio(struct folio *folio,
 		return;
 
 	ci = lock_cluster(si, offset);
-	if (swap_is_has_cache(si, offset, size))
+	if (swap_only_has_cache(si, offset, size))
 		swap_entry_range_free(si, ci, entry, size);
 	else {
 		for (int i = 0; i < size; i++, entry.val++) {
_

Patches currently in -mm which might be from bhe@redhat.com are


