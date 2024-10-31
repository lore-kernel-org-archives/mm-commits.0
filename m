Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489401CCEEC
	for <mm-commits@vger.kernel.org>; Thu, 31 Oct 2024 20:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730407704; cv=none; b=D95CPHhPewRyNu1b84adURqle9ADJLN4e271KxilN3azclhG+ttl32grHhAgfqeYGYAYmsb2cE1jfB+cCi7O5/amHR0kMcIaJLZchNNCWIBzZ2ZfY8WjOBffXqIOut6r864sKdv2XfhVRbrf1vznHeQOPFEiRD+4DLu8Bvv9Ng4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730407704; c=relaxed/simple;
	bh=2ale/jpihqpwRf6sVK8GsuwkVDDV9laJtQh5ekp8dQI=;
	h=Date:To:From:Subject:Message-Id; b=NjtDvbmpyfR0f/8iJgRQl/e6TSf0MPn4Pc5YRzr7ifF+OOIDvWkz8B0VqZs8yKBP2yVfnD9fLTIeCnYoaT2q38w9nVs1wliHwm1ydzxUIURzSTmkbidbFf/afkOJK3Zl5ZjUcnw+cJIFiq1BThoBk3smPkXXGgGVjbmlDyoZs/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DBW888Yw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DBW888Yw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A11C4CEC3;
	Thu, 31 Oct 2024 20:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730407703;
	bh=2ale/jpihqpwRf6sVK8GsuwkVDDV9laJtQh5ekp8dQI=;
	h=Date:To:From:Subject:From;
	b=DBW888YwKKQJTjSqyHiEjT2dK2lRKbiCFuHKPZu4ZzkT4hyfmVs5rcSfXen8Tyvdz
	 ezSbPQwlzPoJvlrTCjUEdB40+gPzYVyNm4O3Ty8Vx+wAcXzxdvgNk+8SfQWdVYcNnw
	 VIJiuTSa2j0eNF1995cAmRMVZAco9OHdZrWJHdUA=
Date: Thu, 31 Oct 2024 13:48:23 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vma-detect-infinite-loop-in-vma-tree-fix.patch added to mm-unstable branch
Message-Id: <20241031204823.B6A11C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vma-detect-infinite-loop-in-vma-tree-fix
has been added to the -mm mm-unstable branch.  Its filename is
     vma-detect-infinite-loop-in-vma-tree-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vma-detect-infinite-loop-in-vma-tree-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: vma-detect-infinite-loop-in-vma-tree-fix
Date: Thu Oct 31 01:45:34 PM PDT 2024

add comment

Cc: Jann Horn <jannh@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vma.c~vma-detect-infinite-loop-in-vma-tree-fix
+++ a/mm/vma.c
@@ -615,6 +615,7 @@ void validate_mm(struct mm_struct *mm)
 			anon_vma_unlock_read(anon_vma);
 		}
 #endif
+		/* Check for a infinite loop */
 		if (++i > mm->map_count + 10) {
 			i = -1;
 			break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-keep-track-of-free-highatomic-fix.patch
mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix.patch
mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
bootmem-stop-using-page-index-fix.patch
mm-kasan-kmsan-copy_from-to_kernel_nofault-fix.patch
tools-mm-free-the-allocated-memory-fix.patch
memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch
mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch
memcg-workingset-remove-folio_memcg_rcu-usage-fix.patch
vma-detect-infinite-loop-in-vma-tree-fix.patch
fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix.patch

