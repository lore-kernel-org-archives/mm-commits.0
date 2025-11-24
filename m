Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B64D2FB990
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025879; cv=none; b=FoFaFFNjrIvlac3n2sOWtm5zyLA5qL0PpdSlVsNynXxHLI5hW29drnzUXthjEfWDWRYpIN8ryUeJja8soQh73mJ5X9uodFFfg8jTzN5TfcX9Bcc5ANsK4caJexi35Yf+1UOMtsOxbkVJESpTvnYSbDtHNcA4A4dC8/9Ed7nb3TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025879; c=relaxed/simple;
	bh=Z8ICcIGIteLOgQc5vj0VfG3L84JfpztJoxV4bYObqg4=;
	h=Date:To:From:Subject:Message-Id; b=RGeLBr+IqctWMyqa6VCZmjAuNQ+IRrKSmXiAzmmaSyWrAC6dzttuPECUl8VAeRCAuprNlt1m1WI+pl2q6t9Mja8fH+R82uZ3O1oLcBmD3dskcEvTsuF8pbsAJgGvSeiRF7Ugmv6c6Zxo+zQO2pLGuHafr5qAamBcG/zM26HmlO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MFKmwWNx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MFKmwWNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C46C4CEF1;
	Mon, 24 Nov 2025 23:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025879;
	bh=Z8ICcIGIteLOgQc5vj0VfG3L84JfpztJoxV4bYObqg4=;
	h=Date:To:From:Subject:From;
	b=MFKmwWNxuYIe27rwXL4EHxEawhZUI+vNUOZ+TNA9wH3baUw8tM2/paYZxKyC6LvLM
	 RJqu8gkwuGHOyKOdbg8qHrHIXGzSj55LWq8Xnp5nci5OlUNb0OfgxB96TTZipwMrCg
	 Z9rZQaFXxLNDpiixam5f8/kzCncncYBnEPXQr300=
Date: Mon, 24 Nov 2025 15:11:18 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-use-swp_solidstate-to-determine-if-swap-is-rotational.patch removed from -mm tree
Message-Id: <20251124231119.71C46C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: use SWP_SOLIDSTATE to determine if swap is rotational
has been removed from the -mm tree.  Its filename was
     mm-swap-use-swp_solidstate-to-determine-if-swap-is-rotational.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm, swap: use SWP_SOLIDSTATE to determine if swap is rotational
Date: Fri, 31 Oct 2025 15:50:08 +0900

The current non rotational check is unreliable as the device's rotational
status can be changed by a user via sysfs.

Use the more reliable SWP_SOLIDSTATE flag which is set at swapon time, to
ensure the nr_rotate_swap count remains consistent.  Plus, it is easy to
read and simple.

Link: https://lkml.kernel.org/r/20251031065011.40863-3-youngjun.park@lge.com
Fixes: 81a0298bdfab ("mm, swap: don't use VMA based swap readahead if HDD is used as swap")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-use-swp_solidstate-to-determine-if-swap-is-rotational
+++ a/mm/swapfile.c
@@ -2910,7 +2910,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	if (p->flags & SWP_CONTINUED)
 		free_swap_count_continuations(p);
 
-	if (!p->bdev || !bdev_nonrot(p->bdev))
+	if (!(p->flags & SWP_SOLIDSTATE))
 		atomic_dec(&nr_rotate_swap);
 
 	mutex_lock(&swapon_mutex);
_

Patches currently in -mm which might be from youngjun.park@lge.com are


