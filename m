Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94434146D6E
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 20:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727296439; cv=none; b=TPdy4HzcJghlv3dQas7XcKx4c+XxRwzhA0sxxVrUmydkGSfcbnsuAEuZrNfEWJtJn23Z2oAal9BzvcaZ5nNCmWlhKvbsMSG0EWCuIiplMlGYPFLOXFbCyFiLXuL6S2LbHlkUwV/hWV7KRTuis5FFnoGtZQT5le9R71Nls5XjiF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727296439; c=relaxed/simple;
	bh=cF9KQ9E0zr7x952H5adQCpPmgeosgjBQmIYc1BA4ITs=;
	h=Date:To:From:Subject:Message-Id; b=WSUJdVUJtXVNRhSmjpZNMGlL6Q/20nBbQ5XyjVzm5xvSYBPT94mMrxjZBkgMZUxT8iOG37E4qyyi1WKwixPhAAJXQGB9bbNaPHqcm7ILAEzt4CP0NZlwJbzW2tSGX6sn1GduQHW550R4VFb2HVpnL8dpHwVPwvbVQMaVMBPPkjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=beGVPwRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="beGVPwRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6290C4CEC3;
	Wed, 25 Sep 2024 20:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727296438;
	bh=cF9KQ9E0zr7x952H5adQCpPmgeosgjBQmIYc1BA4ITs=;
	h=Date:To:From:Subject:From;
	b=beGVPwRjhbxg2yOTn2PJu7eobzhA57IDXf5Ihh6UyeFGGJM+LQSJRKo/UjfNyMdGZ
	 cAU+nKqF6up+4zVZ5xQNBdtE7LRTfkAsskXc7bVazR/gy5JMXZa9Y3dcVBIzEO0Wgk
	 Nnu+bxSwPpNY+MJfAo4wajLt1qtEIsD2f/yLYtMA=
Date: Wed, 25 Sep 2024 13:33:58 -0700
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,zhengqi.arch@bytedance.com,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,longman@redhat.com,hannes@cmpxchg.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-dont-export-list_lru_add.patch added to mm-unstable branch
Message-Id: <20240925203358.D6290C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/list_lru: don't export list_lru_add
has been added to the -mm mm-unstable branch.  Its filename is
     mm-list_lru-dont-export-list_lru_add.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-dont-export-list_lru_add.patch

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
Subject: mm/list_lru: don't export list_lru_add
Date: Thu, 26 Sep 2024 01:10:16 +0800

It's no longer used by any module, just remove it.

Link: https://lkml.kernel.org/r/20240925171020.32142-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/list_lru.c~mm-list_lru-dont-export-list_lru_add
+++ a/mm/list_lru.c
@@ -106,7 +106,6 @@ bool list_lru_add(struct list_lru *lru,
 	spin_unlock(&nlru->lock);
 	return false;
 }
-EXPORT_SYMBOL_GPL(list_lru_add);
 
 bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
 {
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-list_lru-dont-pass-unnecessary-key-parameters.patch
mm-list_lru-dont-export-list_lru_add.patch
mm-list_lru-code-clean-up-for-reparenting.patch
mm-list_lru-simplify-reparenting-and-initial-allocation.patch
mm-list_lru-split-the-lock-to-per-cgroup-scope.patch
mm-list_lru-simplify-the-list_lru-walk-callback-function.patch

