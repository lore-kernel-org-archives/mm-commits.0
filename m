Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DFB42AA9
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 20:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741898465; cv=none; b=MSclyKc6tHlAvmWkKeeBTwmuc005uhp9FhQRFI6qFbB1LsNVK6sB7cOBtP++8b7mPTBxmxKgcEscmSjMqjY2iJZQIbEAwtN5SA5jZZu1wvWEypSgyu/vrRT6Mb2mWp/X4EwNTfu9ZnqJ7ebfBy27Ag/daOum+8Hq9aLD3K3ZG+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741898465; c=relaxed/simple;
	bh=Osw541MBCWOoee+J2k5gdGFOatzBmRqgSIDFp1YXVJg=;
	h=Date:To:From:Subject:Message-Id; b=FtJSUOJebVtDG8lWWyeKyONkk+FtJETbATVF8tArzcs8nJH0g//GkQtdF6W3Ld6BC0/8MA9n0V85Fk6UjDjHgEwQoSSzeuOmId/KjFBQpQeF38RXfdunWWDyHKhAsRJ2m80ulaTHIXeZrVuwLCceRIEnoHqlZo5HiRV2yjZyLoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tpFVy/78; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tpFVy/78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0229CC4CEEA;
	Thu, 13 Mar 2025 20:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741898465;
	bh=Osw541MBCWOoee+J2k5gdGFOatzBmRqgSIDFp1YXVJg=;
	h=Date:To:From:Subject:From;
	b=tpFVy/78PxOxbqgGfKlWbE0qtg6l4YdgiGL2WsOYr8nvsvu2Pu6pJFLHhbWzpYgIX
	 FTdGBSjO0PrhVB+HbnYsk/4TgROgFbbWruEK0x+GkRTZ7uF0qwfC0KsP8tgXeNyByT
	 +D1yqp/+Kltnd97sQ3KDQgA+uqVcRInsAJFAYVP0=
Date: Thu, 13 Mar 2025 13:41:04 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,v-songbaohua@oppo.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-dont-update-the-counter-up-front.patch added to mm-unstable branch
Message-Id: <20250313204105.0229CC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: don't update the counter up-front
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-dont-update-the-counter-up-front.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-dont-update-the-counter-up-front.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: don't update the counter up-front
Date: Fri, 14 Mar 2025 00:59:32 +0800

The counter update before allocation design was useful to avoid
unnecessary scan when device is full, so it will abort early if the
counter indicates the device is full.  But that is an uncommon case, and
now scanning of a full device is very fast, so the up-front update is not
helpful any more.

Remove it and simplify the slot allocation logic.

Link: https://lkml.kernel.org/r/20250313165935.63303-5-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

--- a/mm/swapfile.c~mm-swap-dont-update-the-counter-up-front
+++ a/mm/swapfile.c
@@ -1201,22 +1201,10 @@ int get_swap_pages(int n_goal, swp_entry
 	int order = swap_entry_order(entry_order);
 	unsigned long size = 1 << order;
 	struct swap_info_struct *si, *next;
-	long avail_pgs;
 	int n_ret = 0;
 	int node;
 
 	spin_lock(&swap_avail_lock);
-
-	avail_pgs = atomic_long_read(&nr_swap_pages) / size;
-	if (avail_pgs <= 0) {
-		spin_unlock(&swap_avail_lock);
-		goto noswap;
-	}
-
-	n_goal = min3((long)n_goal, (long)SWAP_BATCH, avail_pgs);
-
-	atomic_long_sub(n_goal * size, &nr_swap_pages);
-
 start_over:
 	node = numa_node_id();
 	plist_for_each_entry_safe(si, next, &swap_avail_heads[node], avail_lists[node]) {
@@ -1250,10 +1238,8 @@ start_over:
 	spin_unlock(&swap_avail_lock);
 
 check_out:
-	if (n_ret < n_goal)
-		atomic_long_add((long)(n_goal - n_ret) * size,
-				&nr_swap_pages);
-noswap:
+	atomic_long_sub(n_ret * size, &nr_swap_pages);
+
 	return n_ret;
 }
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-avoid-reclaiming-irrelevant-swap-cache.patch
mm-swap-drop-the-flag-ttrs_direct.patch
mm-swap-avoid-redundant-swap-device-pinning.patch
mm-swap-dont-update-the-counter-up-front.patch
mm-swap-use-percpu-cluster-as-allocation-fast-path.patch
mm-swap-remove-swap-slot-cache.patch
mm-swap-simplify-folio-swap-allocation.patch

