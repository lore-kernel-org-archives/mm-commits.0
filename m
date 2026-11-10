Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794293149;
	b=buCM02q3pgaSOUENaMd8Nrq4BNX89LDnP3dCCYNQqLSYmGfoU3YdegmXz4JO3eDX/ywH
	 3++X+GWM+cFOpZJ09YbpwXCQ78It9aWaNvaiy7NLFYK3Eyj3ah3iQrE90Lcj3KMgTkzqM
	 +dgCxUbeTjqfAbVANJA99ZMA73ajLEv9CepAMhyb1OL3+9jI5u9GmzYyi22GbriD6RUe4
	 6fN+WoQFmjcDYibqnmeO77zDy1lQpfMJAJ8TGJfyPIq8I5PUm6U7j+Kre+7YTNe9zvEOA
	 XmGJ2FYlzXtLjFLO7koMGaMZBZQaApmldnOImBr5xyN8XfIEvqvtrljTpo7xroevtTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794293149;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=HrcEhmc8ghf3ySCV6L/INMIv7TmNoQ+d4qyjcxN7ArQ=;
	b=zFWbkn8rcWvdKOWFeE9FbkFHskBO/qqi8Hl3Bnq+mXYIe+7HzuZoilHftj0PvwNHff0A
	 wKBaawDz9gYXWYRgsAKmDMd0D2/NHS0slOnhL6K+O+YHOHsLPac0/ZXlFiKvU6edtMGxk
	 +98GtUJa6WemzTiLnBE3Bez27oh2i5quVFbP/r9Wguc6L2sauxfPN6Jo4FjOdL12V9d3I
	 OgoATTQBUpoNGvZrSLYvYWXkYLtwvGRUyDmQoBwxYsAB0qlyy4pHubsrjuN4PAep1WF96
	 h0yqMqbHs6YIseFIh5V4G/AK1E91TW1VIA5OcGTVTL9WVprxrfh7odP9NefbJMsstuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tCZxxuoJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD64606A335;
	Tue, 10 Nov 2026 06:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tCZxxuoJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B318C1F0089F;
	Tue, 10 Nov 2026 06:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794293148;
	bh=HrcEhmc8ghf3ySCV6L/INMIv7TmNoQ+d4qyjcxN7ArQ=;
	h=Date:To:From:Subject;
	b=tCZxxuoJn6XX0IXc0X1bOc10UThWk2XxEZg5O+fu3hl8GfzzzMP2npCzTtQ5zzbh0
	 dBg5Vo48m9oH1CsxNkCmbXJDp5pUyvN9VaIBnN88bk3lqI9Dt4Dvb/WVBpc/ruBHju
	 1JcygGv87aT7r/k9y1ngPIEUzpmoGEx1RdbPirdc=
Date: Mon, 09 Nov 2026 22:45:48 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	stable@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,david@kernel.org,umangpokhriyall@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] userfaultfd-validate-the-whole-range-before-changing-write-protection.patch removed from -mm tree
Message-Id: <20261110064548.B318C1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: userfaultfd: validate the whole range before changing write protection
has been removed from the -mm tree.  Its filename was
     userfaultfd-validate-the-whole-range-before-changing-write-protection.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Umang Pokhriyal <umangpokhriyall@gmail.com>
Subject: userfaultfd: validate the whole range before changing write protection
Date: Wed, 04 Nov 2026 15:04:57 +0530

mwriteprotect_range() checks each VMA as it walks the range.  When a later
VMA is not registered for write protection, or is a hugetlb VMA the range
is not aligned to, the call fails after the earlier VMAs were already
changed.  When unprotecting, userfaultfd_writeprotect() then skips
wake_userfault(), so threads blocked on those pages are not woken although
the pages are writable again.

An unprivileged process can trigger this with a range that spans an
unregistered VMA.  It hasn't been seen in practice; it was found while
reviewing the userfaultfd range ioctls with an LLM.

Validate the whole range first, as mrwprotect_range() already does.

Link: https://lore.kernel.org/20261104093457.152245-1-umangpokhriyall@gmail.com
Fixes: a1b92a3f1498 ("mm/userfaultfd: support WP on multiple VMAs")
Signed-off-by: Umang Pokhriyal <umangpokhriyall@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
---

 mm/userfaultfd.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-validate-the-whole-range-before-changing-write-protection
+++ a/mm/userfaultfd.c
@@ -1105,21 +1105,26 @@ static int mwriteprotect_range(struct us
 	if (atomic_read(&ctx->mmap_changing))
 		goto out_unlock;
 
+	/*
+	 * Validate every spanned VMA before changing any of them, so an
+	 * invalid range is rejected without changing part of it.
+	 */
 	err = -ENOENT;
 	for_each_vma_range(vmi, dst_vma, end) {
-
-		if (!userfaultfd_wp(dst_vma)) {
-			err = -ENOENT;
-			break;
-		}
+		if (!userfaultfd_wp(dst_vma))
+			goto out_unlock;
 
 		if (vma_is_hugetlb(dst_vma)) {
-			err = -EINVAL;
 			page_mask = vma_kernel_pagesize(dst_vma) - 1;
-			if ((start & page_mask) || (len & page_mask))
-				break;
+			if ((start & page_mask) || (len & page_mask)) {
+				err = -EINVAL;
+				goto out_unlock;
+			}
 		}
+	}
 
+	vma_iter_set(&vmi, start);
+	for_each_vma_range(vmi, dst_vma, end) {
 		_start = max(dst_vma->vm_start, start);
 		_end = min(dst_vma->vm_end, end);
 
_

Patches currently in -mm which might be from umangpokhriyall@gmail.com are


