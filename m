Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F2C1FCC5F
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 21:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730755185; cv=none; b=QwvF4YesF3cOghUkQVawSNJJyvWebi9IAsl5fT2xMopUb5w1J29R9X8o4s50k9wnTpcr/5YqE2BSnFCLPGle8dH+E9tJogx3BzvmGYEmPdxMG6SKOYMx+UL1QCYlB664iepbZP51h44XXw3Imbx5QOVMJZtj51iPjknreRBAaD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730755185; c=relaxed/simple;
	bh=/AH8mdQhqGXW0D68Zh79SH6XTCLgrZ1rGERfeubzYaQ=;
	h=Date:To:From:Subject:Message-Id; b=n8WnlPNIUGOmzXzbkF0SIu7VVgdxt/UsNBxB57JlsX3Ut6Ppw3fAC+Ta9Uo75P+GxupXrnwkZOXX4h4LuqrAzR0ZVcSKofzL4uCz0en7i7doI3g/dYtWtQz5uJrz4rhPJuqJJq6xAxFaoIvXKPZjSC63Ytr2zwM407MTI3SIWsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Afqg+4Js; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Afqg+4Js"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133D9C4CECE;
	Mon,  4 Nov 2024 21:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730755185;
	bh=/AH8mdQhqGXW0D68Zh79SH6XTCLgrZ1rGERfeubzYaQ=;
	h=Date:To:From:Subject:From;
	b=Afqg+4JsHSLRHd0lDCooIEL1WE3AvAPHEDP2/Pl150F1WDuP7LT26gW8R/1v5tYZX
	 Zcdk28+XRtkfIFkgbijzD/K5r7Qh1w5pqiMGqsY9P8M3kDL3N44rQjtF+fMlgL2Eep
	 pa8ih5OyEhgVFYa1zGrfRhfIS58trdf0WxGylPmo=
Date: Mon, 04 Nov 2024 13:19:44 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,zhengqi.arch@bytedance.com,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,longman@redhat.com,hannes@cmpxchg.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-dont-export-list_lru_add.patch added to mm-unstable branch
Message-Id: <20241104211945.133D9C4CECE@smtp.kernel.org>
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
Date: Tue, 5 Nov 2024 01:52:53 +0800

It's no longer used by any module, just remove it.

Link: https://lkml.kernel.org/r/20241104175257.60853-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
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

mm-zswap-avoid-touching-xarray-for-unnecessary-invalidation.patch
mm-list_lru-dont-pass-unnecessary-key-parameters.patch
mm-list_lru-dont-export-list_lru_add.patch
mm-list_lru-code-clean-up-for-reparenting.patch
mm-list_lru-simplify-reparenting-and-initial-allocation.patch
mm-list_lru-split-the-lock-to-per-cgroup-scope.patch
mm-list_lru-simplify-the-list_lru-walk-callback-function.patch

