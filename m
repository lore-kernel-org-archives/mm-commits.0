Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832525;
	b=2QC10bxdb5VuoDnGtidaqSrUhnW1XFDMBRrJEqgcasQAFsQS0lBApVmNo3gdO3Qx9FUU
	 6Cp4CgKPtA+QcFde4ipM41Py6Fk7IXrR4tAaph50UBm/9kAOmiz/gtIyR5/8+w+m95chO
	 UvhznxJm5wcROAmLFYnCxpxVto+CYVBioeAtlpfe1BcHhEcu9JxQ33eNsw5L4EOWiTjk1
	 oFbSZDIC86F7FY3mS/w+ka/cRSFD49ottpA19ZnRLML1Kg0HJqwLNJofmG6cqoweF5vJe
	 8W3WzmFx4kYVg7XL8NRtOb4J1Q3p8/tEUWIhkkZyaPRK7OieDY7GJNq1fvXbvK3lgYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832525;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=l2u8mGopkPdQ+jQDqoLo+GPHsLxMcppQlKQwsUr8oKQ=;
	b=3VabakvLuRu05+JJBrhhThOlLOFIPtIGx1MRZAVXJTSmR7dJ1aGvqMjxC1LNGCU986U+
	 MkTbtMyu5+jBchwIVRubpsiITeNMFvBP0BMCI/sPxUVVWzN/qdYOooU165nlouGBeYFf2
	 CB97u3+d1ZzLCMYdUGx4F7cd/mE7yzq+B6kp0nfDCmzxETu9zsYJDl3NxM6zOzmJU57wy
	 gcVAznpbNHW9cAm00Y08I2IJqiOSyRHnxIpScvCRdRBK+5lAomiHsHkDCNAd61udjOYv3
	 apXGI+FB1wYRoIA4qvANsqiL6CARAGBMoGkhxcwKQNlP3FPw45MocFeb+3P3Go3IbOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nhsh3zFN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFC3606A31A;
	Sat, 24 Oct 2026 09:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nhsh3zFN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A6B1F01825;
	Sat, 24 Oct 2026 09:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832525;
	bh=l2u8mGopkPdQ+jQDqoLo+GPHsLxMcppQlKQwsUr8oKQ=;
	h=Date:To:From:Subject;
	b=nhsh3zFNsRjSYuXPDWN5PpTech+Nr0hdUCzhL0BpjrLQI3uF+ytDZ7vnJNS2WNbcB
	 vDGZFk/ySNFMxlkFZrKGfnI3bsWKlQ7c4eJC4yk98SwHdOpzB55U10uykHVyrjjdWq
	 r0uiTnYEFTrSQBn3sWCNcVKWtytkDiIhLM5CBeyo=
Date: Sat, 24 Oct 2026 02:02:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,qi.zheng@linux.dev,mhocko@suse.com,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,fvdl@google.com,dev.jain@arm.com,david@kernel.org,brendan.jackman@linux.dev,baoquan.he@linux.dev,riel@surriel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-count-guard-pages-as-free-again-when-their-buddy-merges.patch removed from -mm tree
Message-Id: <20261024090205.25A6B1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/page_alloc: count guard pages as free again when their buddy merges
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-count-guard-pages-as-free-again-when-their-buddy-merges.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: mm/page_alloc: count guard pages as free again when their buddy merges
Date: Fri, 16 Oct 2026 12:23:04 -0400

With debug_guardpage_minorder set, expand() turns the unused halves of a
split into guard pages, which page_del_and_expand() leaves out of the free
counts.  Freeing the allocated half credits only that half, and
__free_one_page() then merges the guard buddy with clear_page_guard(),
which no longer touches the counters.

The merged block goes on a free list with the guard pages never counted,
so NR_FREE_PAGES falls behind the free lists by every guard that merges. 
Before commit e0932b6c1f94 ("mm: page_alloc: consolidate free page
accounting"), __set_page_guard() and __clear_page_guard() adjusted the
counts themselves; that commit dropped both adjustments but kept the
subtraction implicit in expand().

Count the guard pages under the merged block's migratetype when the buddy
is cleared.  account_freepages() skips an isolated block as it does for
every other free page, and moving the block off the isolated list counts
it then.

Booting a 16GB VM with debug_pagealloc=on debug_guardpage_minorder=1,
check the difference in free pages reported between /proc/vmstat and
/proc/buddyinfo.

At three points (idle, after a read and file-creation load, after a second
load), check the difference between nr_free_pages and the buddyinfo
numbers in the normal zone, as a number of pages:

                idle   after load   after second load
    unpatched   -130        79205               99121
    patched      -16           45                   0

The small remaining difference seems to be due to the numbers not being
read at exactly the same time, and is also seen without guard pages.

Link: https://lore.kernel.org/20261016122304.5b1eba8e@fangorn
Fixes: e0932b6c1f94 ("mm: page_alloc: consolidate free page accounting")
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Assisted-by: LLM
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/page_alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-count-guard-pages-as-free-again-when-their-buddy-merges
+++ a/mm/page_alloc.c
@@ -971,10 +971,12 @@ static inline void __free_one_page(struc
 		 * Our buddy is free or it is CONFIG_DEBUG_PAGEALLOC guard page,
 		 * merge with it and move up one order.
 		 */
-		if (page_is_guard(buddy))
+		if (page_is_guard(buddy)) {
 			clear_page_guard(zone, buddy, order);
-		else
+			account_freepages(zone, 1 << order, migratetype);
+		} else {
 			__del_page_from_free_list(buddy, zone, order, buddy_mt);
+		}
 
 		if (unlikely(buddy_mt != migratetype)) {
 			/*
_

Patches currently in -mm which might be from riel@surriel.com are


