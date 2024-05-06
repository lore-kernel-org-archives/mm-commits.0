Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EE822089
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957073; cv=none; b=a1xiTJUb4LaqSofxbVHyulFwYlUZp53g912HK/OkVOpoeyUK1xmTLZuIbL+3TqPcxNpdCzjW5gXCYwSzwwAOFGXPeUyt/7aV8AEiY0xph05pY1GFunkXU8+8OOK7N1Edb31uVUoCFuW9RwkjhP7cMRUaI/Csk8R9eXI+WJ9tWao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957073; c=relaxed/simple;
	bh=byXWayXXbaHg75trNvN7KyZnUQCDZ5k6RowpFCMY2HI=;
	h=Date:To:From:Subject:Message-Id; b=FYjRtK/xnpRfeQuce2b/tqtANu5EQ7FXxDBDjMcynH0clHsQHPBnM8/U5DUnWu9N4ysYVLHgVbfQWQM8imeJgMg7tWD9pZQ+ptI/wQIUxP524Ir9LFnr/ZVojIK9rJ7VuABfbbFnlSyiTc9p4mQdggeTXi6nBMpoSw1+HOhsAeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bxKQVJ0d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bxKQVJ0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9ADC113CC;
	Mon,  6 May 2024 00:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957072;
	bh=byXWayXXbaHg75trNvN7KyZnUQCDZ5k6RowpFCMY2HI=;
	h=Date:To:From:Subject:From;
	b=bxKQVJ0dFZeYHWQTfxod3/7cAShyqtPvJ8afszwoWxXsnZw/xJ1o6tWjfZaXDf+WD
	 42UanHPVwVCHaVKOIzeXyP7GG2EmyqLoiOGyL2kOJ7wCltoGpe12RrSuLyly1wbphv
	 bpwHYnsXK6IijOj/IbjXFfAoLuTWWmkl8yeagMN4=
Date: Sun, 05 May 2024 17:57:52 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate.patch removed from -mm tree
Message-Id: <20240506005752.BC9ADC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swapfile: check usable swap device in __folio_throttle_swaprate()
has been removed from the -mm tree.  Its filename was
     mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: swapfile: check usable swap device in __folio_throttle_swaprate()
Date: Thu, 18 Apr 2024 21:56:44 +0800

Skip blk_cgroup_congested() if there is no usable swap device since no
swapin/out will occur, Thereby avoid taking swap_lock.  The difference
is shown below from perf date of CoW pagefault,

  perf report -g -i perf.data.swapon  | egrep "blk_cgroup_congested|__folio_throttle_swaprate"
      1.01%     0.16%  page_fault2_pro  [kernel.kallsyms]      [k] __folio_throttle_swaprate
      0.83%     0.80%  page_fault2_pro  [kernel.kallsyms]      [k] blk_cgroup_congested

  perf report -g -i perf.data.swapoff   | egrep  "blk_cgroup_congested|__folio_throttle_swaprate"
      0.15%     0.15%  page_fault2_pro  [kernel.kallsyms]      [k] __folio_throttle_swaprate

Link: https://lkml.kernel.org/r/20240418135644.2736748-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate
+++ a/mm/swapfile.c
@@ -2444,13 +2444,17 @@ static void reinsert_swap_info(struct sw
 	spin_unlock(&swap_lock);
 }
 
+static bool __has_usable_swap(void)
+{
+	return !plist_head_empty(&swap_active_head);
+}
+
 bool has_usable_swap(void)
 {
-	bool ret = true;
+	bool ret;
 
 	spin_lock(&swap_lock);
-	if (plist_head_empty(&swap_active_head))
-		ret = false;
+	ret = __has_usable_swap();
 	spin_unlock(&swap_lock);
 	return ret;
 }
@@ -3710,6 +3714,9 @@ void __folio_throttle_swaprate(struct fo
 	if (!(gfp & __GFP_IO))
 		return;
 
+	if (!__has_usable_swap())
+		return;
+
 	if (!blk_cgroup_congested())
 		return;
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


