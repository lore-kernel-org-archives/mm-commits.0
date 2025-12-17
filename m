Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E239C296BBF
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 21:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006273; cv=none; b=Ug+iCE1eATGrgaEBAvuEPBHM1vSeqTfxuNiQabI/12gECv8KtGyhKGn16Y9q3My+bsF+2vhngTVZ2jMbSiCHQc4Ivde1NKAdYp/3I6zW/URxePlz/DMgKkl/hdAxiDKWvmLfOzaqQuHzRLRxxOhbospUEY6uIoQVnnXQV/8Luf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006273; c=relaxed/simple;
	bh=1p2oIlmCJsmoedTyiXVOgO6pMWLQfkIo0XpEbN0gr+E=;
	h=Date:To:From:Subject:Message-Id; b=PvApUl3fjA6BAPIlLfGhKETfl+fv26x/dtFYWmSX/8iCJV4tOdPkblJcoCFtJ8+B6e1etDgvOmw7tFg7H8yPZZDtZrsw1rk84SCkvLaGCCkokhs0WFc3W1TTC1osJASAP45knbM8RRzceqaAYQ+UvMpFDuYu6i8naB6M6R7diRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2fFlrYI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2fFlrYI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581EEC4CEF5;
	Wed, 17 Dec 2025 21:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766006272;
	bh=1p2oIlmCJsmoedTyiXVOgO6pMWLQfkIo0XpEbN0gr+E=;
	h=Date:To:From:Subject:From;
	b=2fFlrYI1+RCY1qxSnMHwzv0XEDpihXG6AjC4A1VF4rrMNfPKe6IyDdCQxC2B5feaR
	 +0PafsbwBaeFCJPXJ0RwCY9biQ1RylC1+tezpi1HuJfvBTwQg05C63azz5ie/eyaxa
	 LSv17JCtZpGhehuQU373QzBDtAzR6rwZzQJHpJbE=
Date: Wed, 17 Dec 2025 13:17:51 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry.ahmed@linux.dev,willy@infradead.org,weixugc@google.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,nphamcs@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david.laight.linux@gmail.com,david@kernel.org,chengming.zhou@linux.dev,axelrasmussen@google.com,chandna.sahil@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-use-%pe-to-print-error-pointers.patch added to mm-new branch
Message-Id: <20251217211752.581EEC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: use %pe to print error pointers
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-use-%pe-to-print-error-pointers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-use-%pe-to-print-error-pointers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sahil Chandna <chandna.sahil@gmail.com>
Subject: mm/zswap: use %pe to print error pointers
Date: Fri, 28 Nov 2025 12:31:44 +0530

Use the %pe printk format specifier to report error pointers directly
instead of printing PTR_ERR() as a long value.  This improves clarity,
produces more readable error messages.

This instance was flagged by the Coccinelle script
(misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.

Found by: make coccicheck MODE=report M=mm/ No functional change intended.

Link: https://lkml.kernel.org/r/6d729a60eb71baade3670e5bb609a068683af3eb.1764312627.git.chandna.sahil@gmail.com
Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-use-%pe-to-print-error-pointers
+++ a/mm/zswap.c
@@ -748,8 +748,8 @@ static int zswap_cpu_comp_prepare(unsign
 
 	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR(acomp)) {
-		pr_err("could not alloc crypto acomp %s : %ld\n",
-				pool->tfm_name, PTR_ERR(acomp));
+		pr_err("could not alloc crypto acomp %s : %pe\n",
+				pool->tfm_name, acomp);
 		ret = PTR_ERR(acomp);
 		goto fail;
 	}
_

Patches currently in -mm which might be from chandna.sahil@gmail.com are

mm-pagewalk-simplify-hugepage-boundary-calculation.patch
mm-vmscan-use-%pe-to-print-error-pointers.patch
mm-zswap-use-%pe-to-print-error-pointers.patch

