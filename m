Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECDE3644A6
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388584; cv=none; b=ORIeToBFwY6iNMAEJOCat33jhHo4K+y6FUGq+ZIvRCskLiUENcNIqOjamVpBsN2/oz3IgjngFvDv0C09Km+WKLtHCJpIRAYb0w3y1Di8SLyLPw3y00GezwWw0eLuDJTQc8VzXkGAKQDKYjwgkPVGzVkfxZcULGziTfIL1QZRzKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388584; c=relaxed/simple;
	bh=i2Do4cpLgivv9gNBKJUPuGeqAYbQDYHRgoXMe8bzgBM=;
	h=Date:To:From:Subject:Message-Id; b=CsNEy8D1ZuDpvNiHU/uLZyIs1nCkhQeCUFnBaDF2XrW/eglCqdz+Gw7P09EnwXuf5sJ+xV5K/Hachuiat3P7iwClokYLaB2mfZ6vGoUVzv/IBNJqQuS0aLIaiav1om0japq9Qg+O0aKsQa/3kPhfoLeRg2ZSuXLSlupOmcJFI9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MaOVLrpZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MaOVLrpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8667BC19424;
	Tue, 24 Mar 2026 21:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388584;
	bh=i2Do4cpLgivv9gNBKJUPuGeqAYbQDYHRgoXMe8bzgBM=;
	h=Date:To:From:Subject:From;
	b=MaOVLrpZBclaOVWMFH4wHubSuT789QJkR47lDz9TmtijnJPwHMbl73pMD65PfO3Sx
	 bj+55gucPD+fTadkU42uiwe9517XrLIUIX3xo8TSHkGWmspYfeuifBnc/kDI8ti/CA
	 RhJrNOhejQTFXT67uld0mARw+CqE0lFTHj0LCR+U=
Date: Tue, 24 Mar 2026 14:43:04 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,zhongqiu.han@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-use-pf_kthread-flag-to-detect-kernel-threads.patch removed from -mm tree
Message-Id: <20260324214304.8667BC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kmemleak: use PF_KTHREAD flag to detect kernel threads
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-use-pf_kthread-flag-to-detect-kernel-threads.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Subject: mm/kmemleak: use PF_KTHREAD flag to detect kernel threads
Date: Fri, 30 Jan 2026 17:37:29 +0800

Replace the current->mm check with PF_KTHREAD flag for more reliable
kernel thread detection in scan_should_stop().  The PF_KTHREAD flag is the
standard way to identify kernel threads and is not affected by temporary
mm borrowing via kthread_use_mm() (although kmemleak does not currently
encounter such cases, this makes the code more robust).

No functional change.

Link: https://lkml.kernel.org/r/20260130093729.2045858-3-zhongqiu.han@oss.qualcomm.com
Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-use-pf_kthread-flag-to-detect-kernel-threads
+++ a/mm/kmemleak.c
@@ -1505,10 +1505,10 @@ static int scan_should_stop(void)
 	 * This function may be called from either process or kthread context,
 	 * hence the need to check for both stop conditions.
 	 */
-	if (current->mm)
-		return signal_pending(current);
+	if (current->flags & PF_KTHREAD)
+		return kthread_should_stop();
 
-	return kthread_should_stop();
+	return signal_pending(current);
 }
 
 /*
_

Patches currently in -mm which might be from zhongqiu.han@oss.qualcomm.com are


