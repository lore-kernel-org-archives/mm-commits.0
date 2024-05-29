Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6D3522A
	for <mm-commits@vger.kernel.org>; Wed, 29 May 2024 19:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717010444; cv=none; b=IU9uWiJV8budQfDgPACt3eeeqsPCEWKw226KZTvWqQAW6IErmD9anDT4HR3JWbG8fZ1MLAYx6d1tD51/bkLk2XVnouAj43tDl66+ngYAS/WHavvwgS3depm8YbuabRlfTJGuj4sYeC592/ZC4Sj7fM7T6+A5KHejLNk6XfaJfGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717010444; c=relaxed/simple;
	bh=A0JJcaS+mAL/cEY7GFTqg4ojYNYrZvl+CZ5wr62+MOY=;
	h=Date:To:From:Subject:Message-Id; b=RS/aGHXUCe9V5alJNLaGGM3wsgI/lNVM+E71s/yovawEtSF3rZpF9HBxJ4rXGl3uE9RJF59XYqELDRM3SW7wyVg+u+JsCPjjGcX4oTQiYJlof5oYjkbRLVnTt0LAYucS6BP0AGBZ7PrzGLyfywECjhLdpFGwlu9KpLyluhxhiUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ebycNiTs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ebycNiTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD52DC113CC;
	Wed, 29 May 2024 19:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717010443;
	bh=A0JJcaS+mAL/cEY7GFTqg4ojYNYrZvl+CZ5wr62+MOY=;
	h=Date:To:From:Subject:From;
	b=ebycNiTs5ewueqpCE5hDnhJa4YQ9mSjoaWdhYSfIB8HRn+gg0I1sfPFzpJo1YwDgr
	 GRHLf+t2ojsIfh4BqxaMdhYUiln3Iy/at552ZFN28R/aJVkJ1HNjmLdNhcWzlv2IgM
	 nRjI5gTdKOnnBVdrQco0GikMOyZidNzi0Cfd9C8s=
Date: Wed, 29 May 2024 12:20:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yosryahmed@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,v-songbaohua@oppo.com,surenb@google.com,ryan.roberts@arm.com,rafael@kernel.org,pavel@ucw.cz,len.brown@intel.com,khalid.aziz@oracle.com,kasong@tencent.com,hughd@google.com,hch@infradead.org,hannes@cmpxchg.org,david@redhat.com,davem@davemloft.net,chrisl@kernel.org,baolin.wang@linux.alibaba.com,andreas@gaisler.com,hanchuanhua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-make-should_try_to_free_swap-support-large-folio.patch added to mm-unstable branch
Message-Id: <20240529192043.BD52DC113CC@smtp.kernel.org>
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
Date: Wed, 29 May 2024 20:28:23 +1200

The function should_try_to_free_swap() operates under the assumption that
swap-in always occurs at the normal page granularity, i.e.,
folio_nr_pages() = 1.  However, in reality, for large folios,
add_to_swap_cache() will invoke folio_ref_add(folio, nr).  To accommodate
large folio swap-in, this patch eliminates this assumption.

Link: https://lkml.kernel.org/r/20240529082824.150954-6-21cnbao@gmail.com
Signed-off-by: Chuanhua Han <hanchuanhua@oppo.com>
Co-developed-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-swap-make-should_try_to_free_swap-support-large-folio
+++ a/mm/memory.c
@@ -3925,7 +3925,7 @@ static inline bool should_try_to_free_sw
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

