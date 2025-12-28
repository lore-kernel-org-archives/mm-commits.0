Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDE42144C7
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 22:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766962263; cv=none; b=eWFv+Qf6i45SkwmEcFWzxzt+Ua2zi8GhallT2vlmzQGuRGaaUNXSdYLoKIy05Xp8p0eOWZjWttvXkA73ps05ObJbSPEiRTStbmqsOxcsqn1O3rWhISamFq5OuqgcQccmzHzGK/Enznng1oAW1w6n2eAAgpePM3Aji64x2wkK0bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766962263; c=relaxed/simple;
	bh=OVgR9F/4WSIgsP/APp9KYTQbTfjtP4YlMYrsCA3VXBM=;
	h=Date:To:From:Subject:Message-Id; b=eHo29Iuwsu2mt8LB1ZAgdvKn7ytxmUfy9JQIS7XquRwrqqA9ld5WL1Kd9SC3ULphLyPgFI+kVp3ZShTuWX8FbwWzNK7aXf1OPpR7Pug+hZs2rElOVW8cNc2zOiaalo9bCAmb2HTmDLYHqp/m9yb9W4rpt4JFn2BMc4m8BTo8qxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RfVqbZ4W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RfVqbZ4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F506C4CEFB;
	Sun, 28 Dec 2025 22:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766962263;
	bh=OVgR9F/4WSIgsP/APp9KYTQbTfjtP4YlMYrsCA3VXBM=;
	h=Date:To:From:Subject:From;
	b=RfVqbZ4WfeFCC6eka6LCAr4aC0ZOcJGf1FDor1NxuBfPZnRbJEFZOhG2ySqc0Ewd+
	 GSW/RQ2QxXpG6q6hNr1S2IUABWFa+HhSHb06Xbi9WSq+iMKUGHd6f/yj4ppjIm3UNk
	 rxFjdFR0HyAcK6HujwM1iZCq9eqiusJFhzkmx6QQ=
Date: Sun, 28 Dec 2025 14:51:03 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-make-khugepaged_collapse_control-static.patch added to mm-new branch
Message-Id: <20251228225103.9F506C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: make khugepaged_collapse_control static
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-make-khugepaged_collapse_control-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-make-khugepaged_collapse_control-static.patch

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
From: Shivank Garg <shivankg@amd.com>
Subject: mm/khugepaged: make khugepaged_collapse_control static
Date: Wed, 24 Dec 2025 11:13:59 +0000

The global variable 'khugepaged_collapse_control' is not used outside of
mm/khugepaged.c.  Make it static to limit its scope.

Link: https://lkml.kernel.org/r/20251224111351.41042-14-shivankg@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-make-khugepaged_collapse_control-static
+++ a/mm/khugepaged.c
@@ -829,7 +829,7 @@ static void khugepaged_alloc_sleep(void)
 	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
-struct collapse_control khugepaged_collapse_control = {
+static struct collapse_control khugepaged_collapse_control = {
 	.is_khugepaged = true,
 };
 
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-khugepaged-map-dirty-writeback-pages-failures-to-eagain.patch
mm-khugepaged-retry-with-sync-writeback-for-madv_collapse.patch
mm-khugepaged-remove-unnecessary-goto-skip-label.patch
mm-khugepaged-count-small-vmas-towards-scan-limit.patch
mm-khugepaged-count-small-vmas-towards-scan-limit-fix.patch
mm-khugepaged-change-collapse_pte_mapped_thp-to-return-void.patch
mm-khugepaged-use-enum-scan_result-for-result-variables-and-return-types.patch
mm-khugepaged-make-khugepaged_collapse_control-static.patch

