Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B501F74C14
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 19:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712260347; cv=none; b=sikF30UimH+1mM6K+doJ9TKrc9s3ZRleuyVHwYfnS8SoASvKYoE2QI18Uf+TBno0FAqjgXPnBIIsHC1HCEdKubz6tgAh8mPajPC1+HHzqIFGiL6mKzHSQzmdAgkdy/JnHS5PD5A9FUT/0C7GHLngGy+Ogp+Nn3DEDRD/TUbb0ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712260347; c=relaxed/simple;
	bh=/Ayjsl/WammzKcvgnO+Cs8DjaR65VI4y2bZc3pW+5l0=;
	h=Date:To:From:Subject:Message-Id; b=gLU/LnaibV3DrqQ/4gyX6m6IkJG/nqpHX1mgTDPh6BO4r9QnAlRfThWs6wqCWEeFH1300rtzQfcb+XluJ6z9ZVSP8VP7HU0+JYNdvtSIXIkNUbrYYyzJk9eop6TNwb4TYWTn6cYNfzGFdgwW+GxWc+zNte2Xr4NpXZz1+PEAync=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iSVIPWra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iSVIPWra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225D1C433F1;
	Thu,  4 Apr 2024 19:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712260347;
	bh=/Ayjsl/WammzKcvgnO+Cs8DjaR65VI4y2bZc3pW+5l0=;
	h=Date:To:From:Subject:From;
	b=iSVIPWraoYspUy7oOW+k6V3ltECuLoDPR+paJOLucVEXCMY3pK7HTuYf5e9231pZL
	 hy7vZmgTg1B4gTKWB98ALyGPsPmTtBTl1GhW7kCKS0KQWrijHd1LNDZrgIcdZaIGqx
	 VU12CRgOot/kk5wHP6bqQdmoc3ykwm3aVAFLJP3s=
Date: Thu, 04 Apr 2024 12:52:25 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,shr@devkernel.io,riel@surriel.com,hannes@cmpxchg.org,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-remove-redundant-code-in-ksm_fork.patch added to mm-unstable branch
Message-Id: <20240404195227.225D1C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: remove redundant code in ksm_fork
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-remove-redundant-code-in-ksm_fork.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-remove-redundant-code-in-ksm_fork.patch

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
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/ksm: remove redundant code in ksm_fork
Date: Tue, 2 Apr 2024 10:49:34 +0800

Since commit 3c6f33b7273a ("mm/ksm: support fork/exec for prctl"), when a
child process is forked, the MMF_VM_MERGE_ANY flag will be inherited in
mm_init(). So, it's unnecessary to set the flag in ksm_fork().

Link: https://lkml.kernel.org/r/20240402024934.1093361-1-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/include/linux/ksm.h~mm-ksm-remove-redundant-code-in-ksm_fork
+++ a/include/linux/ksm.h
@@ -45,16 +45,8 @@ static inline void ksm_might_unmap_zero_
 
 static inline int ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
-	int ret;
-
-	if (test_bit(MMF_VM_MERGEABLE, &oldmm->flags)) {
-		ret = __ksm_enter(mm);
-		if (ret)
-			return ret;
-	}
-
-	if (test_bit(MMF_VM_MERGE_ANY, &oldmm->flags))
-		set_bit(MMF_VM_MERGE_ANY, &mm->flags);
+	if (test_bit(MMF_VM_MERGEABLE, &oldmm->flags))
+		return __ksm_enter(mm);
 
 	return 0;
 }
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-ksm-fix-ksm-exec-support-for-prctl.patch
selftest-mm-ksm_functional_tests-refactor-mmap_and_merge_range.patch
selftest-mm-ksm_functional_tests-extend-test-case-for-ksm-fork-exec.patch
mm-ksm-remove-redundant-code-in-ksm_fork.patch

