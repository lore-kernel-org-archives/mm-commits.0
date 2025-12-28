Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D87929BDA5
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 22:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766962601; cv=none; b=i9kJpA0z60K6aKGUBHt7yhcR+OHGUZ09aV6vubgTIX+8cyPt9ttIYuaZJPMmnuNpy+CW1tabaBnKToJC1+PSSe6inX7hIhmiC5HdapNCgDbLJs103TbUjm3LHskY0ksf2N0GlrX5HWgXh/rMTCJnnIDQbuMZcsVFzB2JCYb17eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766962601; c=relaxed/simple;
	bh=D7smbQLhNxn9txuC43yfriYMYG/hXGYv12K6tQ4T+fc=;
	h=Date:To:From:Subject:Message-Id; b=KWJ1AWyGjzkjlTmLYeRYcH2GrpVdBm6kHSS8Vx3+TOGseY+GqYWPecPwDLMPYXnjNNBxmDnvvv8Qs1iU++DJ4O1x4HWU22YhBdw9hD1RSfV8borN9fy44cibu4bviChE8ZVjtqJSWCPtQHWxhV2zFM0x6LYuB9IHicAArENR/88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mreLAWbN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mreLAWbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2198EC4CEFB;
	Sun, 28 Dec 2025 22:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766962601;
	bh=D7smbQLhNxn9txuC43yfriYMYG/hXGYv12K6tQ4T+fc=;
	h=Date:To:From:Subject:From;
	b=mreLAWbN7lfV/NR+DJPstAnACtk0Tc9PIIM/5/4lvMy1NmQM0O0kkpa3LpapRd+ok
	 teVuP4z2IA4KoyytbAQnh5u5I4N32p4WxN3/5KR5DiP07lSLAD+26jomBYjQi+cXjd
	 CQSPh1u1RwRkhS3fb6oF5HYiJhywxJoPJ7jrKyA4=
Date: Sun, 28 Dec 2025 14:56:40 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry.ahmed@linux.dev,willy@infradead.org,weixugc@google.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,nphamcs@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david.laight.linux@gmail.com,david@kernel.org,chengming.zhou@linux.dev,axelrasmussen@google.com,chandna.sahil@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-zswap-use-%pe-to-print-error-pointers.patch removed from -mm tree
Message-Id: <20251228225641.2198EC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: use %pe to print error pointers
has been removed from the -mm tree.  Its filename was
     mm-zswap-use-%pe-to-print-error-pointers.patch

This patch was dropped because it had testing failures

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


