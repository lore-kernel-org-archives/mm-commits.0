Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E47842BEAE
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816368; cv=none; b=YiRc8p7Cts2HrDENciZoCmoO9edSG1wI/Aud0LIhTnXmRxHL4OTa2FgWHXADBDuBpGkC8kEZbyVnjuIJ+Rfp2tF2vX0+69VjwrZ0ZxHjdR8s61llBElFbiVJ3Rje+uKdlPaVs/TkfSy4+8TX1ZtI8cFuT06ilvbthSUj5aHnTpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816368; c=relaxed/simple;
	bh=J6jgZjNn5gEKHXAM4vtuf/DuEQC12q7EVfH/U1JoJck=;
	h=Date:To:From:Subject:Message-Id; b=OhXQ+bv/Ev7MUOXiYzuUs5POYXAlk1IN34fDZSqN68cCjizj2EkTIlMsNpJ/ETp8lCKON8/V1ClIHtBfQfrnNWhlu3JaYaNA3Fv4KQJXITiYbi2Sce8rgZMQOKT1FaiFCXtl9P+f6MQqP+Ce7BQIi/seOcgK65s3wXNMNpipDR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0Q4fzYRU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Q4fzYRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093821F000E9;
	Tue,  4 Aug 2026 04:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816367;
	bh=7qh9lb/ayrw/kK4BNJOccN0diOfo9SMwesW4KuWZyG4=;
	h=Date:To:From:Subject;
	b=0Q4fzYRUo0VmFOmK4ZC2DJLCJUaTiBOfopLW8rgyogcyYX/RAZWPOrrjiUblhaB6o
	 uWcnFIorLlN9KPTOCwjTJDD+0TWRRw7ouCDdD6pnsAUJ9OCu7LNCifTDaq81E9UE4g
	 lAFizzBGH0hP3hSaIjDQfbI1vjssIn4Ek32QSE8Y=
Date: Mon, 03 Aug 2026 21:06:06 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,sshegde@linux.ibm.com,npiggin@gmail.com,nilay@linux.ibm.com,namcao@linutronix.de,mripard@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,maarten.lankhorst@linux.intel.com,leon@kernel.org,jiazhenyuan@uniontech.com,jgg@ziepe.ca,guanwentao@uniontech.com,clg@kaod.org,bharat@chelsio.com,apopple@nvidia.com,airlied@gmail.com,gouhao@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-test_hmm-remove-dead-null-checks-after-gfp_nofail-allocations.patch removed from -mm tree
Message-Id: <20260804040607.093821F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_hmm: remove dead NULL checks after GFP_NOFAIL allocations
has been removed from the -mm tree.  Its filename was
     lib-test_hmm-remove-dead-null-checks-after-gfp_nofail-allocations.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gou Hao <gouhao@uniontech.com>
Subject: lib/test_hmm: remove dead NULL checks after GFP_NOFAIL allocations
Date: Fri, 24 Jul 2026 10:28:50 +0800

kvcalloc with the __GFP_NOFAIL flag will never return NULL, so the
subsequent NULL checks are unreachable dead code.  Remove them.

Link: https://lore.kernel.org/20260724022851.466017-6-gouhao@uniontech.com
Signed-off-by: Gou Hao <gouhao@uniontech.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Bharat Potnuri <bharat@chelsio.com>
Cc: Cédric Le Goater <clg@kaod.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: jiazhenyuan <jiazhenyuan@uniontech.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nam Cao <namcao@linutronix.de>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nilay Shroff <nilay@linux.ibm.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-remove-dead-null-checks-after-gfp_nofail-allocations
+++ a/lib/test_hmm.c
@@ -1312,16 +1312,10 @@ static int dmirror_migrate_to_device(str
 	if (!mmget_not_zero(mm))
 		return -EINVAL;
 
-	ret = -ENOMEM;
 	src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns),
 			  GFP_KERNEL | __GFP_NOFAIL);
-	if (!src_pfns)
-		goto free_mem;
-
 	dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns),
 			  GFP_KERNEL | __GFP_NOFAIL);
-	if (!dst_pfns)
-		goto free_mem;
 
 	ret = 0;
 	mmap_read_lock(mm);
_

Patches currently in -mm which might be from gouhao@uniontech.com are


