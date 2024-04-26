Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68370763E2
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714102001; cv=none; b=SbqXsI7vjm/MVxx9kqoa2f05hTtu5uJZZsEoVzdoi2cevCmNEjOAB/VcGnph571I9AP7srUvJrNcHbXJlFb6NqYNfO6KYC/mWg4s6Q+xH6hL30rGD/49PeX4ibQTZr912L0sOrmkGRKv2lq2Q+ZQPFOVXDV+Hsj/Fu134jhPboA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714102001; c=relaxed/simple;
	bh=jOE/8HRMMVBz0vqYmtB/m+nZDZcK3rQfGv8Vr1u08cY=;
	h=Date:To:From:Subject:Message-Id; b=NKdwMYN+c2nS3x/IMcHicJhQgxMZUocCOHvYgIe8W6z4g93FHzD/mYOCHDffYIUD1zGUFLMhUGcruwWfK69NDPZoBTnFaYs8Nxvn677KHYGPrxSQOS0pX4KbbfFEJ992xAHo39rtyjPeQFNp4icrBGreZ+pNjZ0sCCctBNHe7mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tBjdntnu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tBjdntnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2223C116B1;
	Fri, 26 Apr 2024 03:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714102001;
	bh=jOE/8HRMMVBz0vqYmtB/m+nZDZcK3rQfGv8Vr1u08cY=;
	h=Date:To:From:Subject:From;
	b=tBjdntnuMLBT8DJcoVZxsnfu/it5paHkoA58p64kvm38YVWgPkd8U92dZiQRSGzzl
	 pqe+OnCtyQ7ySpiEjDwDssXctb8buIYmrRnyYqoNT45NzcoeJWdRebvGhcmR1gd0HR
	 hm70RaLb2EQQef9jDVNSNk0JLlh7JtuACSwhCjm4=
Date: Thu, 25 Apr 2024 20:26:40 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-slab-move-memcg-charging-to-post-alloc-hook-fix-2.patch removed from -mm tree
Message-Id: <20240426032640.E2223C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-slab-move-memcg-charging-to-post-alloc-hook-fix-2
has been removed from the -mm tree.  Its filename was
     mm-slab-move-memcg-charging-to-post-alloc-hook-fix-2.patch

This patch was dropped because it was folded into mm-slab-move-memcg-charging-to-post-alloc-hook.patch

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm-slab-move-memcg-charging-to-post-alloc-hook-fix-2
Date: Wed, 3 Apr 2024 10:02:40 -0700

comment fixup

Link: https://lkml.kernel.org/r/Zg2LsNm6twOmG69l@P9FQF9L96D.corp.robot.car
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-slab-move-memcg-charging-to-post-alloc-hook-fix-2
+++ a/mm/memcontrol.c
@@ -350,7 +350,7 @@ static void memcg_reparent_objcgs(struct
 
 /*
  * A lot of the calls to the cache allocation functions are expected to be
- * inlined by the compiler. Since the calls to memcg_slab_pre_alloc_hook() are
+ * inlined by the compiler. Since the calls to memcg_slab_post_alloc_hook() are
  * conditional to this static branch, we'll have to allow modules that does
  * kmem_cache_alloc and the such to see this symbol as well
  */
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-slab-move-memcg-charging-to-post-alloc-hook.patch

