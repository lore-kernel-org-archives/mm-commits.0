Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CC2485CF7
	for <mm-commits@vger.kernel.org>; Thu, 27 Aug 2026 16:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787847650; cv=none; b=ZieRf8VjAg7q7yaGt1gtTaD/hD2turXc0Bhak5vvNmiVBBp84eaQydVigcbv9rdC99jtYnbQIQjkAm6wLpBrdedtrS4xirngO7gb3RC/KSCnQZnc9k1ZQJJCuIExf0VZ7YhvejXaUvSQmZp3oc2k6hWbf4NBgSRe1CgyUF+faEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787847650; c=relaxed/simple;
	bh=jlJfCG9e7f30Ge4SwMgGIThX1XfA9AiiJu8nU5ivmGg=;
	h=Date:To:From:Subject:Message-Id; b=FuH9ui2y9Za8gifmyTtdcS8n1z/LRAoI8X0HOlsPY4jKHEfl+5scleGhK8VuLhoUppJ9BOLvdGyLsUXmf7tic+5d4+5gqh77wavNcF+nTj4TmfILJB4PxzjRHvztpUr/wEm2rS4JIvDokl9B1EqReKlVC78H8dAx9XxGmz4jf6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fmFijKIU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fmFijKIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B80F1F000E9;
	Thu, 27 Aug 2026 16:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787847648;
	bh=PlFUKVVRjm9TDHMhRtgrUjc/Tp7Vxlw389zOibIMLZE=;
	h=Date:To:From:Subject;
	b=fmFijKIUrjb4fuHGtMWLVk2e4+7tv1L4q/9DAfUjSm5Oeq2dn3aRDmPbcdpOh3Dl6
	 bbMBkRrWIH2LJxfQUONgRQWWoW4IijORv6jVZL/K3jdtfr0jzrpDL+C6teBa97iJoa
	 YwnOnvVZw8NdrkAj18MTEF4zOxl0YjMk/w9us/N8=
Date: Thu, 27 Aug 2026 09:20:47 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,sef1548@gmail.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,yuehaibing@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-unused-declaration-swapcache_clear.patch added to mm-new branch
Message-Id: <20260827162048.5B80F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: remove unused declaration swapcache_clear()
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-remove-unused-declaration-swapcache_clear.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-unused-declaration-swapcache_clear.patch

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
From: Yue Haibing <yuehaibing@huawei.com>
Subject: mm/swap: remove unused declaration swapcache_clear()
Date: Thu, 27 Aug 2026 16:27:22 +0800

Commit c246d236b18b ("mm/shmem: never bypass the swap cache for
SWP_SYNCHRONOUS_IO") removed the implementations but leave this.

Link: https://lore.kernel.org/20260827082722.1809702-1-yuehaibing@huawei.com
Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Acked-by: Kairui Song <kasong@tencent.com>
Acked-by: Nick Huang <sef1548@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/swap.h~mm-swap-remove-unused-declaration-swapcache_clear
+++ a/mm/swap.h
@@ -324,7 +324,6 @@ void __swap_cache_replace_folio(struct s
 				struct folio *old, struct folio *new);
 
 void show_swap_cache_info(void);
-void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
 struct folio *read_swap_cache_async(struct swap_io_ctx *ctx, swp_entry_t entry,
 		gfp_t gfp_mask, struct vm_area_struct *vma, unsigned long addr);
 struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
_

Patches currently in -mm which might be from yuehaibing@huawei.com are

mm-swap-remove-unused-declaration-swapcache_clear.patch

