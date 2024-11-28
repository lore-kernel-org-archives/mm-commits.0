Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E81912AAC6
	for <mm-commits@vger.kernel.org>; Thu, 28 Nov 2024 01:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732758463; cv=none; b=o+LGZ3z5AsLZJXuTLqsQ6DwLxFeHMHEny5zNXwQjY+Bx+HPNtiWNDQhVTPBguJU75Bx31s3sPEMxKbI/2LwChk/W1MD7NpAuSXPD1UaSJL9wNcfWlxSFRKSRulfnY2W2bj7/fsCDg3TGLiyuJMSFAR1QX8FmLagRAz+TZNchdcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732758463; c=relaxed/simple;
	bh=jrmlJ2RVg7hcp4GrMqBVyNIpR2Xr9ow6QzF0to5/wzg=;
	h=Date:To:From:Subject:Message-Id; b=nrvP5Fa6c4J9c4K+LCJdOuzOdj455c02BxxL/t5ZE+S73y6Zx3fsF7W7e7w7N9NOIvZhLRXx/niLW+nrgp9oJ5K0Ofgy7P8F9NWzbvnPcO/NgfF6RZ15UATID2eTovICTqy/167aLGc/9x/US8LjIKh3MkQwWxeutokQt0ETCmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2sWhagw0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2sWhagw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2B8C4CECC;
	Thu, 28 Nov 2024 01:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732758462;
	bh=jrmlJ2RVg7hcp4GrMqBVyNIpR2Xr9ow6QzF0to5/wzg=;
	h=Date:To:From:Subject:From;
	b=2sWhagw0OyJ7YqiSJtIo9P34WNbK3FxlKQCokvt8naQjTMIl6tuF9xXE0Elc/BGfJ
	 40jKl5g6vliM/g4e7WaL3PQa5JHTCIYv7eKvfHD4c+F5RxabnPVly5vljHUHYM6xoS
	 LgQFyB/Bk5BhULPtmq+e2DycINZxkt+ctmOav8Ts=
Date: Wed, 27 Nov 2024 17:47:42 -0800
To: mm-commits@vger.kernel.org,295107659@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-type-of-cma_area_count-to-unsigned-int.patch added to mm-unstable branch
Message-Id: <20241128014742.9F2B8C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: change type of cma_area_count to unsigned int
has been added to the -mm mm-unstable branch.  Its filename is
     mm-change-type-of-cma_area_count-to-unsigned-int.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-type-of-cma_area_count-to-unsigned-int.patch

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
From: Jiale Yang <295107659@qq.com>
Subject: mm: change type of cma_area_count to unsigned int
Date: Wed, 20 Nov 2024 11:01:35 +0000

Prefer 'unsigned int' over plain 'unsigned'. Also make it
consistent with mm/cma.c

Link: https://lkml.kernel.org/r/tencent_1E5E3AA25C261196D8C1F7097F130E382008@qq.com
Signed-off-by: Jiale Yang <295107659@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.h~mm-change-type-of-cma_area_count-to-unsigned-int
+++ a/mm/cma.h
@@ -36,7 +36,7 @@ struct cma {
 };
 
 extern struct cma cma_areas[MAX_CMA_AREAS];
-extern unsigned cma_area_count;
+extern unsigned int cma_area_count;
 
 static inline unsigned long cma_bitmap_maxno(struct cma *cma)
 {
_

Patches currently in -mm which might be from 295107659@qq.com are

mm-change-type-of-cma_area_count-to-unsigned-int.patch

