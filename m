Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794972665;
	b=09legZGFn5zxZCX4yjzIe7EH6TrF8ErYSdLpyzsE8Whlq+Kb2vNEzI1ykI6rqkfezAZR
	 RUDr9J6AVtd5+dO8QdOkd7TKg3I0muXofvV/PAEEVRwbJfcq+v/wUSjUS2P3giJfYEMFp
	 7e0u8sJtuqVS4hffzB4NFx4qJhNsw9sxqSzbCJGJzraHJjz2Dg6brogymOP/UPhsB5m2L
	 2aXW1Ox0o0sOm2gpcivaHriTfn35hYu5KrPXYBvLyOnMVwHMtN8IdEiXLs7IeEfZwF1IP
	 ZKgEx1/mQLs2fUGh/HGcn36J2RlJej5q/MBStS2eThFmAg59ct1kVbBEKhdlkz1iqow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794972665;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=kwBqJMF0ql2tuxijfyoL6SO9dx2MUcAULKpZ+Tguzng=;
	b=xifIoZHEMyuCQhmV3jxNs1K2HJ5y9Z15OsWcTXf/zcOdOfJRu+jqAHxxJPQ2CxzlQe00
	 IFxH2EspvuGkppj2eMOsPB7vU2fOBx2l6ukx3fOZ9dBue/24bgrlXnJkyosQhujGGsx2A
	 8PXF2F2ifRok5gN1XOSqG2RL2TfGnAOOLp1kd2jgHJNS6AVNt+pHqwxYq1nLOFHODtJoB
	 zGgm/iavdUpvW9SkTRmjrL9EBZfzSla9t1JYBrLFvBFx/sa/YlDwy7RDCW+6Zg7tP7VWJ
	 O0dnriFH2bVbwacj6saxhZZYSGeoXPy4kSnzDZGLeMyE/rzq2dh8oyTqMrDhRZVF6Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="CeM/LD/u";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B209B606A32F;
	Wed, 18 Nov 2026 03:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CeM/LD/u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53B21F000C4;
	Wed, 18 Nov 2026 03:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794972664;
	bh=kwBqJMF0ql2tuxijfyoL6SO9dx2MUcAULKpZ+Tguzng=;
	h=Date:To:From:Subject;
	b=CeM/LD/ugvOUGxloTPC0OKxhKhy9SYOSKcNjtp23+N+AUsBRla4mIkpUYojDa5aXi
	 /LiRMjYbqb+rFxClyqxVTEYz87o9K8c9jwVC40Q67PH5aMaqXJ7Y78PBFc9yRQD7ev
	 VgdYnMOpJPCag5eF/lCmnykJZecVdR54Rmx9TtJc=
Date: Tue, 17 Nov 2026 19:31:04 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,
	stable@vger.kernel.org,osalvador@suse.de,osalvador@kernel.org,
	muchun.song@linux.dev,lance.yang@linux.dev,fvdl@google.com,david@kernel.org,
	azpijr@gmail.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-hugetlb-disable-default-cma-reservations-on-32-bit-kernel.patch added to mm-new branch
Message-Id: <20261118033104.A53B21F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: x86: hugetlb: disable default CMA reservations on 32-bit kernel
has been added to the -mm mm-new branch.  Its filename is
     x86-hugetlb-disable-default-cma-reservations-on-32-bit-kernel.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-hugetlb-disable-default-cma-reservations-on-32-bit-kernel.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: x86: hugetlb: disable default CMA reservations on 32-bit kernel
Date: Tue, 17 Nov 2026 17:33:57 +0800

Patch series "mm: hugetlb: fix CMA-related issues", v5.

This series fixes three CMA-related issues in HugeTLB reservation,
long-term pinning and allocation:

 - Avoid ineffective CMA reservations on 32-bit x86 kernels running on
   CPUs that advertise 1 GiB page support.
 - Allow long-term pins of explicitly CMA-allocated HugeTLB folios,
   which already own the CMA memory.
 - Preserve the caller's GFP mask when allocating from CMA.


This patch (of 3):

A 32-bit x86 kernel can run on a 64-bit-capable CPU advertising GBPAGES.
arch_hugetlb_cma_order() checks only this feature and returns a nonzero
order, although gigantic HugeTLB support on x86 requires CONFIG_X86_64.
Specifying hugetlb_cma= can therefore reserve a CMA area that cannot
serve the intended gigantic HugeTLB allocations.

On non-PAE kernels, the folded PUD_SHIFT yields a 4 MiB order, which is
equal to MAX_PAGE_ORDER. With CONFIG_DEBUG_VM enabled, this triggers the
VM_WARN_ON(order <= MAX_PAGE_ORDER) check in hugetlb_cma_reserve(),
warning that hugetlb_cma is attempting to reserve a non-gigantic order.

Require CONFIG_X86_64 as well as GBPAGES when selecting the default CMA
order to avoid these ineffective reservations.

Link: https://lore.kernel.org/cover.1794907279.git.zhengqi.arch@bytedance.com
Link: https://lore.kernel.org/6866920502a4eaafd99a9e272df572e3a7d3da4e.1794907279.git.zhengqi.arch@bytedance.com
Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Frank van der Linden <fvdl@google.com>
Cc: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>

 arch/x86/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/hugetlbpage.c~x86-hugetlb-disable-default-cma-reservations-on-32-bit-kernel
+++ a/arch/x86/mm/hugetlbpage.c
@@ -45,7 +45,7 @@ arch_initcall(gigantic_pages_init);
 
 unsigned int __init arch_hugetlb_cma_order(void)
 {
-	if (boot_cpu_has(X86_FEATURE_GBPAGES))
+	if (IS_ENABLED(CONFIG_X86_64) && boot_cpu_has(X86_FEATURE_GBPAGES))
 		return PUD_SHIFT - PAGE_SHIFT;
 
 	return 0;
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

x86-hugetlb-disable-default-cma-reservations-on-32-bit-kernel.patch
mm-gup-allow-long-term-pins-of-cma-allocated-hugetlb-folios.patch
mm-hugetlb-fix-gfp-mask-propagation-to-cma.patch

