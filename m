Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D382335541
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025877; cv=none; b=tfVNDrv0KYEBjTZ3HrDSWXhNjJJQdZYP+l2hFvx2qLBQV0m8GwfkLk9KGq5upoTZwqHOKpikYfg55+MnYtXZro4PYije+m3jaI/4q062JWlH1gEO1yUlH7UYqA4zmKc+jgrfw3gXrZGaLlh7ebNz9WCjCCuFyz19fvc1pYQJL18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025877; c=relaxed/simple;
	bh=BObYIKgKkSCtHRXiGP4NofT8OIHQ7uNSvWq1nBolgGI=;
	h=Date:To:From:Subject:Message-Id; b=OvSf/7k9xk4q8ynm9lytz554+TD1eIxczgAmT3mDcFRx1UxN2TG4e43wJuWtbWmZ86vFHBzwkKeP0WJiMIbDBjB9QKRH0Y4s4IUxLv7p2xE8mPyj9P5Pn5+zLil/9X78oR04nOR0/qCur0kH3gXxqPMacee+mMbAPt4m5iBuAhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uupi5sjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uupi5sjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B32C4CEF1;
	Mon, 24 Nov 2025 23:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025877;
	bh=BObYIKgKkSCtHRXiGP4NofT8OIHQ7uNSvWq1nBolgGI=;
	h=Date:To:From:Subject:From;
	b=uupi5sjBrk4dIr1NchmxVfxqDQeg8ukQQInup5p3W4m0+XfLHwew1j7sa1pXlnFTU
	 obSdDl1jSNjkJVnL7+E2d4ba/6y0njqQCrqg0BYsbmBmSqvPR/4mqTHToLg2l0AkAv
	 zGbnVM9mu08pk1FK23LVbxitTpXe6YTsSjGoWaLo=
Date: Mon, 24 Nov 2025 15:11:16 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-fix-wrong-plist-empty-check-in-swap_alloc_slow.patch removed from -mm tree
Message-Id: <20251124231117.43B32C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: fix wrong plist empty check in swap_alloc_slow()
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-wrong-plist-empty-check-in-swap_alloc_slow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm/swap: fix wrong plist empty check in swap_alloc_slow()
Date: Wed, 19 Nov 2025 20:41:36 +0900

swap_alloc_slow() was checking `si->avail_list` instead of
`next->avail_list` when verifying if the next swap device is still in the
list, which could cause unnecessary restarts during allocation.

Link: https://lkml.kernel.org/r/20251119114136.594108-1-youngjun.park@lge.com
Fixes: 8e689f8ea45f ("mm/swap: do not choose swap device according to numa node")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Acked-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-fix-wrong-plist-empty-check-in-swap_alloc_slow
+++ a/mm/swapfile.c
@@ -1374,7 +1374,7 @@ start_over:
 		 * still in the swap_avail_head list then try it, otherwise
 		 * start over if we have not gotten any slots.
 		 */
-		if (plist_node_empty(&si->avail_list))
+		if (plist_node_empty(&next->avail_list))
 			goto start_over;
 	}
 	spin_unlock(&swap_avail_lock);
_

Patches currently in -mm which might be from youngjun.park@lge.com are


