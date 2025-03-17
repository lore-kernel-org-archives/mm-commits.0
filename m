Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D232A1D8
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188452; cv=none; b=mbL2osQU/NBxbHUIiC1rSnG5NXTkrp+0i8tVccBLCTS0q8rRX6j8PwIF1e9kIgxNpd/FS0GHXWG5eid9sVUILBl2lxce5yz3HXcyYiHduwmyYJdnx//uNDsPJ9Q2FbO9mguvylqQAmjewV12eS1OlQy5WtfoP1sL9QpJ1GH6igA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188452; c=relaxed/simple;
	bh=sbOISLmQ1+JIyborbXFaHpEzj14PFTa2EIcwdrUI13o=;
	h=Date:To:From:Subject:Message-Id; b=BGBnJ2ItzheJs18/4YuQxFwsoY9ROvn5PA6A7WTLtKqFL6lq4YcQusBFLnln54i2Qi8ST6uX2i/bZBZZgQzqzo7M9F5kRStI1pb4x1W9gnbpLEPCcO6q8s6PKfdx1lJvZ+jDs85myYLa1inyr67AHVBJuID1J9qPhR7sAi6TG+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i4VRPlbZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i4VRPlbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C86C4CEEC;
	Mon, 17 Mar 2025 05:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188452;
	bh=sbOISLmQ1+JIyborbXFaHpEzj14PFTa2EIcwdrUI13o=;
	h=Date:To:From:Subject:From;
	b=i4VRPlbZ4qGgeBNSrmntzb4PHFAIxvReSjm5ErGAf73L9DsBZnWzdkWoIWFV9cV7u
	 gQ33PT7ScdGsgyyVS/eoCd+3LVSo02mZJkyj5tY0X59SQRP321Nmbjb97bTpZHWBTr
	 lwTPl5U5B0B/g/A9Tp2TPBMjceE02HarbG2rJIGg=
Date: Sun, 16 Mar 2025 22:14:11 -0700
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-correct-comment-in-swap_usage_sub.patch removed from -mm tree
Message-Id: <20250317051412.27C86C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: correct comment in swap_usage_sub()
has been removed from the -mm tree.  Its filename was
     mm-swap-correct-comment-in-swap_usage_sub.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm, swap: correct comment in swap_usage_sub()
Date: Sun, 23 Feb 2025 00:08:49 +0800

We will add si back to plist in swap_usage_sub(), just correct the wrong
comment which says we will remove si from plist in swap_usage_sub().

Link: https://lkml.kernel.org/r/20250222160850.505274-6-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-correct-comment-in-swap_usage_sub
+++ a/mm/swapfile.c
@@ -1098,7 +1098,7 @@ static void swap_usage_sub(struct swap_i
 
 	/*
 	 * If device is not full, and SWAP_USAGE_OFFLIST_BIT is set,
-	 * remove it from the plist.
+	 * add it to the plist.
 	 */
 	if (unlikely(val & SWAP_USAGE_OFFLIST_BIT))
 		add_to_avail_list(si, false);
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


