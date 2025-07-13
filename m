Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EA91E22E6
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752449409; cv=none; b=ihuOlzU/LBIJ0LxnD2YN1Gc996ELze4fSzxgwiYanVM4aY4FrXrGyjJVXEqdAauhPiSuPrJUO9inKcNnCWYb6hMBSUqswQHORVUEtrcX1ualmjPKnUO0+tP47WfqJKReNDc05XDrB/qNUhCqwuiYDhGNnHa8I2JmpV7jk6DCE1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752449409; c=relaxed/simple;
	bh=G1hBcsdF6n8ZCbYF2uikJtEFcByJcsKrstUAYtVJ27Q=;
	h=Date:To:From:Subject:Message-Id; b=Pc9Ctf9p3CEjfWobFkqm/JjRITApqm6/ebmj6s9k7jlsHYKhhJuWwokVidbGCjQaU8bCaHDD5InDUir49IpKoqrX/VtNfq4T3UtiD0CyPOOpg3wlCCD+aYegC+vfW6CoXOlnRqNjHvuf/U9hrvqEDz4rn91MBopfGI24RZ4WeJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P2tG0kCH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P2tG0kCH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384BDC4CEE3;
	Sun, 13 Jul 2025 23:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752449409;
	bh=G1hBcsdF6n8ZCbYF2uikJtEFcByJcsKrstUAYtVJ27Q=;
	h=Date:To:From:Subject:From;
	b=P2tG0kCHibnca8pDINs2/69oasP7oEuZ9NjB+L8siblqm41+1Rd218zVOdbf3HEhx
	 zYq4f2i5f4ZqumSUtiZ4B0eB1jYL3nojdNfkPGnEL2n7ULxsTvKqYolwVnjgP8sJY+
	 av2qO0rA0uNOwzb4Rxt9VOHZd+SQ26FFnPFcUL9A=
Date: Sun, 13 Jul 2025 16:30:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,ryan.roberts@arm.com,npache@redhat.com,liam.howlett@oracle.com,jannh@google.com,ioworker0@gmail.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch removed from -mm tree
Message-Id: <20250713233009.384BDC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: fix very subtle bug
has been removed from the -mm tree.  Its filename was
     mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch

This patch was dropped because it was folded into mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/madvise: fix very subtle bug
Date: Tue, 24 Jun 2025 14:14:19 +0100

With thanks to stress-ng --madvise :)

vma may have been updated (in the modify call in madvise_update_vma()), so
we can't assign prev = vma, we must first reassign vma to
madv_behavior->vma to account for this, before setting prev = vma.

Link: https://lkml.kernel.org/r/dca94cde-8afb-4eab-8e57-3f508624d670@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix
+++ a/mm/madvise.c
@@ -1665,8 +1665,8 @@ int madvise_walk_vmas(struct madvise_beh
 			vma = NULL;
 			madv_behavior->lock_dropped = false;
 		} else {
-			prev = vma;
 			vma = madv_behavior->vma;
+			prev = vma;
 		}
 
 		if (vma && range->end < vma->vm_end)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch
tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
mm-mremap-permit-mremap-move-of-multiple-vmas-fix.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch

