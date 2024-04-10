Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AE41E877
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 21:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712783330; cv=none; b=S01mxl/w6bI1mpsmkApkYmjNxj/zLC/U1NGrewwbRx4SQjy9jVFesQUuEV7Knd0C7YAg8uX9z2W5OHuQ8pLqS+0dTfycx9+JWI0CkBZnDNe2aC9A0cvB/Lgfgva6IZWizxKMg1wZ3RtG917GVgqgGh5J8iV/OiZsTSTVfoiZ2e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712783330; c=relaxed/simple;
	bh=+XiAs+QSsB9SdOJQXjAgHcbtcFzg00SEZME3aIeLJEs=;
	h=Date:To:From:Subject:Message-Id; b=mMxi9iyqjEuIFNMAhHwhhKb5797RS//3Syou7+1LKEILoyqQYLX/9BZ4xt0Vm2JYNhJJMUF1MZxVLB2e87kwgg0nXxqiEZiZ9ACGt7y3HUm+AtVNYoly0Lag+mSdpG6BvDRjxsyL2+EliRiDnaLeyvc1sTbyMyI9XH4unLp3I3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=seRYysuy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="seRYysuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B81C433C7;
	Wed, 10 Apr 2024 21:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712783329;
	bh=+XiAs+QSsB9SdOJQXjAgHcbtcFzg00SEZME3aIeLJEs=;
	h=Date:To:From:Subject:From;
	b=seRYysuyMEPLwHTpEpdtv4GVvXGAvZIuinlBxVo86GvykX7Uz7/cSvkVETETNuKAt
	 3VTcmMBiCOmE2c8Zz+H9RcHRU6DWmB5O6ECv6YKuWNn4qPhxPZoV+GASGvz6k0fim1
	 iUfDp1sSl2LOeowcwbnOgoAcVTi2v4T9XGSZUDbQ=
Date: Wed, 10 Apr 2024 14:08:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yosryahmed@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,v-songbaohua@oppo.com,ryan.roberts@arm.com,kasong@tencent.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,hanchuanhua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-make-should_try_to_free_swap-support-large-folio.patch added to mm-unstable branch
Message-Id: <20240410210849.84B81C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: make should_try_to_free_swap() support large-folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-make-should_try_to_free_swap-support-large-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-make-should_try_to_free_swap-support-large-folio.patch

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
From: Chuanhua Han <hanchuanhua@oppo.com>
Subject: mm: swap: make should_try_to_free_swap() support large-folio
Date: Tue, 9 Apr 2024 20:26:28 +1200

The function should_try_to_free_swap() operates under the assumption that
swap-in always occurs at the normal page granularity, i.e., folio_nr_pages
= 1.  However, in reality, for large folios, add_to_swap_cache() will
invoke folio_ref_add(folio, nr).  To accommodate large folio swap-in, this
patch eliminates this assumption.

Link: https://lkml.kernel.org/r/20240409082631.187483-3-21cnbao@gmail.com
Signed-off-by: Chuanhua Han <hanchuanhua@oppo.com>
Co-developed-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-swap-make-should_try_to_free_swap-support-large-folio
+++ a/mm/memory.c
@@ -3853,7 +3853,7 @@ static inline bool should_try_to_free_sw
 	 * reference only in case it's likely that we'll be the exlusive user.
 	 */
 	return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio) &&
-		folio_ref_count(folio) == 2;
+		folio_ref_count(folio) == (1 + folio_nr_pages(folio));
 }
 
 static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
_

Patches currently in -mm which might be from hanchuanhua@oppo.com are

mm-swap-introduce-swap_free_nr-for-batched-swap_free.patch
mm-swap-make-should_try_to_free_swap-support-large-folio.patch
mm-swap-entirely-map-large-folios-found-in-swapcache.patch

