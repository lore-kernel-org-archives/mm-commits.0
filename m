Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96431FA254
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 17:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728410248; cv=none; b=MDzqL971503ZeIuGqeHznj3tcRgXmcGluVWmFforuvbJ/LEx511HqxGwgCBZ2x+rGEzAvCEOGvgTZ21ZFTVaTeeloz9QFMreJT9ZFZ9AMoSy+2rJTNpJWesXaF32yMKQoxf1vadGimksTsME/dqIolKYVzCldYmgAMg1VOWdV0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728410248; c=relaxed/simple;
	bh=s7l43JlcVncniOQUBsV88sV7WWeWaxV7Jlkol4NEjyg=;
	h=Date:To:From:Subject:Message-Id; b=b7CdjEAjl8bstfdeSbMWzk3ng3jswT2jZYHekqA0T4/mhV8mgy1K1ETgUqB1R721Pu9ARUEDy6TbSVMIfb+8mDqtoWoupwq/+R3kgIDY8PzKRUwIKaS02ATpsbYY/VjxTBQSpGHssAgMCZM/3+nonMKuh3iUzWibqceKjlH7nCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1BzvWSNE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1BzvWSNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B34BC4CEC7;
	Tue,  8 Oct 2024 17:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728410248;
	bh=s7l43JlcVncniOQUBsV88sV7WWeWaxV7Jlkol4NEjyg=;
	h=Date:To:From:Subject:From;
	b=1BzvWSNEkr+9wXs1CXIJVNhZ2tzj1tmt3eG0AgdSTCMxgJrX+MxNgzx2PMP41IIgm
	 6tH8NwQKh8sNBv7pjTKrqBLdcjygBFxJ/9GM9VXVtd9gz6xvmV2nqY4L57VY4rxI1p
	 XET6Gi2jJFvkw57DVIjAQsWQ64z5O5mqixO79lqA=
Date: Tue, 08 Oct 2024 10:57:27 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,surenb@google.com,sj@kernel.org,minchan@kernel.org,mhocko@suse.com,liyangouwen1@oppo.com,kasong@tencent.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-avoid-unconditional-one-tick-sleep-when-swapcache_prepare-fails-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20241008175728.4B34BC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: wake_up only when swapcache_wq waitqueue is active
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-avoid-unconditional-one-tick-sleep-when-swapcache_prepare-fails-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-avoid-unconditional-one-tick-sleep-when-swapcache_prepare-fails-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: wake_up only when swapcache_wq waitqueue is active
Date: Tue, 8 Oct 2024 20:18:27 +0800

wake_up() will acquire spinlock even waitqueue is empty. This might
involve cache sync overhead. Let's only call wake_up() when waitqueue
is active.

Link: https://lkml.kernel.org/r/20241008130807.40833-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Oven Liyang <liyangouwen1@oppo.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-avoid-unconditional-one-tick-sleep-when-swapcache_prepare-fails-fix
+++ a/mm/memory.c
@@ -4616,7 +4616,8 @@ out:
 	/* Clear the swap cache pin for direct swapin after PTL unlock */
 	if (need_clear_cache) {
 		swapcache_clear(si, entry, nr_pages);
-		wake_up(&swapcache_wq);
+		if (waitqueue_active(&swapcache_wq))
+			wake_up(&swapcache_wq);
 	}
 	if (si)
 		put_swap_device(si);
@@ -4634,7 +4635,8 @@ out_release:
 	}
 	if (need_clear_cache) {
 		swapcache_clear(si, entry, nr_pages);
-		wake_up(&swapcache_wq);
+		if (waitqueue_active(&swapcache_wq))
+			wake_up(&swapcache_wq);
 	}
 	if (si)
 		put_swap_device(si);
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-avoid-unconditional-one-tick-sleep-when-swapcache_prepare-fails.patch
mm-avoid-unconditional-one-tick-sleep-when-swapcache_prepare-fails-fix.patch

