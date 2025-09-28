Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045AB19F40B
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085325; cv=none; b=Y9hvVIHhqmYNWVU4AoMEFmrnKCuDIWCFGm+IXOj2J3UvAQh/zEwkfMZjizf/8popI//4MPqrXSKfd928otcwa/9LqW+iCRAigE7PcmAaRkSBWR/6sn7cax+6sYI+D+PPYe6H/NVk22eRCw26gJLON2i+IYKRdluwxeLvLuMGDGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085325; c=relaxed/simple;
	bh=pR7GJ/7QLWLaRfq5VdunmIJIlkICELZ7AM7Ga2BwO7I=;
	h=Date:To:From:Subject:Message-Id; b=hh0c/04URpGuMQhfNLYbNRafaRAQnpnmPVLGZLJvgU+VU/9BWyEA5EKzZ2Dvyc3iBNfj/PdVr0gXXICetS0FSbSKyNskQeI8w9Q+TOmUQzXeAA3LnUl5oLLnzMVWjrgMXjUnsr5Xgl+03dvYeZiJKQ69ztCM6xsTg2W5dRRST08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W1PdG7Kc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W1PdG7Kc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95781C4CEF0;
	Sun, 28 Sep 2025 18:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085324;
	bh=pR7GJ/7QLWLaRfq5VdunmIJIlkICELZ7AM7Ga2BwO7I=;
	h=Date:To:From:Subject:From;
	b=W1PdG7Kc/wT+y00ie0IWN7wbCREpYS4F8YtkjppqvyM7/+FHQeYtSQsHuep7sk6Vi
	 BbfO/fy9kodRK1qd2udwpxNyL21+nQXIUz1jiBpS8Vsgu99YzHz0Q7zGIVv4L1b0R7
	 XypwBCt7qpjKrWaPN/0TnQYRuHUoJNGhRnHyqhD4=
Date: Sun, 28 Sep 2025 11:48:44 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,kas@kernel.org,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-rmap-mlock-large-folios-in-try_to_unmap_one-fix.patch removed from -mm tree
Message-Id: <20250928184844.95781C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-rmap-mlock-large-folios-in-try_to_unmap_one-fix
has been removed from the -mm tree.  Its filename was
     mm-rmap-mlock-large-folios-in-try_to_unmap_one-fix.patch

This patch was dropped because it was folded into mm-rmap-mlock-large-folios-in-try_to_unmap_one.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-rmap-mlock-large-folios-in-try_to_unmap_one-fix
Date: Tue Sep 23 02:28:52 PM PDT 2025

s/CROSSSED/CROSSED/

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-mlock-large-folios-in-try_to_unmap_one-fix
+++ a/mm/rmap.c
@@ -1933,7 +1933,7 @@ static bool try_to_unmap_one(struct foli
 			 * If page table boundary has been cross, current ptl
 			 * only protect part of ptes.
 			 */
-			if (pvmw.flags & PVMW_PGTABLE_CROSSSED)
+			if (pvmw.flags & PVMW_PGTABLE_CROSSED)
 				goto walk_done;
 
 			/* Restore the mlock which got missed */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-rmap-mlock-large-folios-in-try_to_unmap_one.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes.patch

