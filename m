Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D40B181
	for <mm-commits@vger.kernel.org>; Sat,  1 Jun 2024 00:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717200209; cv=none; b=kX6SR0frkLsqGA26r/gbN6ZtBoQc683aVGmCG1lO8A0BjPC0DcCclh7kk+cmn7d5mA0vJA9Rijd08NM9/Yv4rse0ZMlfhIQO1E+m1MT1jPMguFRDTHHE4AaN6yLL4tkX1kpIAWbxw/WjZRRAFw8iMKqkuxx0xjHuuOUmooMgMQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717200209; c=relaxed/simple;
	bh=ioIRd8b9ICnLO+xPqAlwSWQXAr6jydh+YdAKjThSNSI=;
	h=Date:To:From:Subject:Message-Id; b=X/+XfUMI4qNqVFjjcyOM3zwEFL/k3IIHkUM9NhDFQJhVzt5QyTnZoi3GGwSLt12YmqThFynT21Px4lkMeaDaKr0DPLQptZ8uOCdvUtu+imYjSxE2Ppawu0hl2MxQhN3eCQXZY4OZSgHmLrCdL6KWiENE9NkXwgNggbcT9FEinY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rN3XYSEe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rN3XYSEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7ABC116B1;
	Sat,  1 Jun 2024 00:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717200208;
	bh=ioIRd8b9ICnLO+xPqAlwSWQXAr6jydh+YdAKjThSNSI=;
	h=Date:To:From:Subject:From;
	b=rN3XYSEeqeVN6UKEvMMqkCChe634H9zT688lvmC94g5NgqLWFYFO/lt4t7iALld2p
	 wt9GINWW+2r2QoKNI6w1gMA5zAFR0gSbhLNVzKCT3fUwbF5VLs99Qb0XBc1PCvmLoa
	 xJn9/x8+hY0SYTK2ahlfdsor7X2e6my3E0LypdJU=
Date: Fri, 31 May 2024 17:03:27 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,abaci@linux.alibaba.com,jiapeng.chong@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-use-swap-in-double_pt_lock.patch added to mm-unstable branch
Message-Id: <20240601000328.AD7ABC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: userfaultfd: use swap() in double_pt_lock()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-userfaultfd-use-swap-in-double_pt_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-use-swap-in-double_pt_lock.patch

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
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: mm: userfaultfd: use swap() in double_pt_lock()
Date: Fri, 31 May 2024 17:16:43 +0800

Use existing swap() function rather than duplicating its implementation.

./mm/userfaultfd.c:1006:13-14: WARNING opportunity for swap()

Link: https://lkml.kernel.org/r/20240531091643.67778-1-jiapeng.chong@linux.alibaba.com
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=9266
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-use-swap-in-double_pt_lock
+++ a/mm/userfaultfd.c
@@ -995,14 +995,8 @@ void double_pt_lock(spinlock_t *ptl1,
 	__acquires(ptl1)
 	__acquires(ptl2)
 {
-	spinlock_t *ptl_tmp;
-
-	if (ptl1 > ptl2) {
-		/* exchange ptl1 and ptl2 */
-		ptl_tmp = ptl1;
-		ptl1 = ptl2;
-		ptl2 = ptl_tmp;
-	}
+	if (ptl1 > ptl2)
+		swap(ptl1, ptl2);
 	/* lock in virtual address order to avoid lock inversion */
 	spin_lock(ptl1);
 	if (ptl1 != ptl2)
_

Patches currently in -mm which might be from jiapeng.chong@linux.alibaba.com are

mm-userfaultfd-use-swap-in-double_pt_lock.patch

