Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832255;
	b=qlAJa3m1NZOOb0AY3XnUtXq7bd8waRJQbvcPDrZbsSGTGtrDCqN0OAY8He1i8Cy+kh9g
	 3npMzqy1N1K9FdRXNnx0ns1TSlkQ+4WpM3+updOl06O3QiTDO05UUU2qxvzv0OE+y2DDS
	 1CEcJoFZOwGiwDLqYJVd89DKXB82hD2W7WQK0dyjNqrNg8Nh2YU7sMMHqlWjPyQR9US5w
	 dG+gTjxDSYgR3DcdvJyJN6pYIgvkg+cDwv8oLkKSgRgAUBGd2o7POaWD5zaFaZHFuYZat
	 FBLcpklSb/UQgc9fajLU+w3WJTqTiKLL67hNDZxNDQNNXKsu29nT/LtJE4k1I9H4t1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832255;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=NZuv4/OTNpEOHYy6SxrI2wWMhpUhlu5gxzWTCn874rI=;
	b=BTMFHWymlhegG/8OEnlMzqqUFpauHbPhnSB3sdkzUYXpV34+nv9egLsFNkn5CUpHZy7b
	 JckKvG5sdK1ZSKEgIDhkxENOHVeT++/OeC5EDM1PdHgDh4cN2eci0TYTzRaF7Y0AWFW72
	 BdO/Y4jZ4RvvxA/OXFjN0Zuni7viePXJy8UWC8pZe7JczMz0cgL8u7zPCk1eJAOT+oNno
	 GYRtLF6TeozpTdVw/tInAQdWtRjRHxa4nioKLf1A8Kmhl7UwAjFkB8HWr3O8B/5yAVXsK
	 29W7TZCzq7HGcaVC65bmuZSBLm2XXQwj7b/FVL+NrQDfmV2aDXcKLmRuKPx7MAIxBsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GGgOod4c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3A3606A320;
	Sat, 24 Oct 2026 08:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GGgOod4c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8051F01825;
	Sat, 24 Oct 2026 08:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832255;
	bh=NZuv4/OTNpEOHYy6SxrI2wWMhpUhlu5gxzWTCn874rI=;
	h=Date:To:From:Subject;
	b=GGgOod4cWI9ZBJqcYD3mRC+buugjfQe2k0k1xmUQLgARc8A4Yg6dE4/TQaidV3tu7
	 R+Pv6riMyOAwTWA0FefRkbRNFAKnL/n27CCV70Xqb0HYJMNJMoItyvli12NckLO/nw
	 6wcvTeBVzusJoK58AfZ8Y2GKiXbBKt2cFHag7FZo=
Date: Sat, 24 Oct 2026 01:57:34 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mgorman@techsingularity.net,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,josef@toxicpanda.com,jannh@google.com,agl@us.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-fix-calling-fixup_hugetlb_reservations-on-the-wrong-vma.patch removed from -mm tree
Message-Id: <20261024085735.1C8051F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mremap: fix calling fixup_hugetlb_reservations() on the wrong VMA
has been removed from the -mm tree.  Its filename was
     mm-mremap-fix-calling-fixup_hugetlb_reservations-on-the-wrong-vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/mremap: fix calling fixup_hugetlb_reservations() on the wrong VMA
Date: Thu, 15 Oct 2026 18:07:16 +0200

In case we fail to move the page tables, for example, because we fail
to allocate a page table, we actually keep the old VMA.

Calling fixup_hugetlb_reservations() on the old VMA is wrong. Fix it
by just calling it on the VMA that will be removed.

The user-visible impact is that the VMA loses its reservations, meaning
that the existing reservations get stranded (leaked) and new hugetlb folios
that are getting allocated in the VMA cannot make use of the
reservations, failing these allocations.

Link: https://lore.kernel.org/20261015-urgent_fixes-v1-10-42796911043b@kernel.org
Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: <stable@vger.kernel.org>
---

 mm/mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-fix-calling-fixup_hugetlb_reservations-on-the-wrong-vma
+++ a/mm/mremap.c
@@ -1345,7 +1345,7 @@ static int copy_vma_and_data(struct vma_
 		mremap_userfaultfd_prep(new_vma, vrm->uf);
 	}
 
-	fixup_hugetlb_reservations(vma);
+	fixup_hugetlb_reservations(vrm->vma);
 
 	*new_vma_ptr = new_vma;
 	return err;
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch

