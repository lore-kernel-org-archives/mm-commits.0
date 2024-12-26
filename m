Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D415450F2
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 22:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735251135; cv=none; b=Cp4+RMY67Lw5kDdpFMnpuPoio8yr18yPhor6QHeyVUhvqR1VG2Ek07JxfBMl06DamPd9wMxSZdMLV0zAteuQ81qmwniB6mGUnpSXWSxdtlU6rbiNx6AZim+aX0gdhIQIFyYIeDDITKeXEWAKSsaRdiWw2STUqBlml3MIv4ba7+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735251135; c=relaxed/simple;
	bh=9+4N3Fxg4ONvBOcHk4EXCK4nFaKmPHT/zcVkXFaTQj4=;
	h=Date:To:From:Subject:Message-Id; b=ArTxBHvDV+XgQ8KUB5K0AeJXX0s9XI3mRIz/jAe6BJIFGu1dFh0SU8y8KdV3yEOUPMLmGpSSrW7djjLvzvWevrXoXbOeJHWNcFLYoBFbPWRESNjLOJC9n7MGTaScPzSViGPuyHVIW7dstAXQLovWhKd52BnW7gaUsmqoOSyGoQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o1/T0+0o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o1/T0+0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2305FC4CED1;
	Thu, 26 Dec 2024 22:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735251134;
	bh=9+4N3Fxg4ONvBOcHk4EXCK4nFaKmPHT/zcVkXFaTQj4=;
	h=Date:To:From:Subject:From;
	b=o1/T0+0oYUJu3BBzEOfT6XIRxQImkPKB5u2Zc+lvp/mhuEbpq5Bx7jw+mcV9RN8kR
	 /99duasNHHMSjGWc0fw8dsi4Y7x3YcQhMmKgKrKCzy+Xi4TyvUDm3IXjGXgYET1M2c
	 JU3pOa3+ovGGVGPvWrm/RylDnvdhHA9I05q3d7zo=
Date: Thu, 26 Dec 2024 14:12:13 -0800
To: mm-commits@vger.kernel.org,oliver.sang@intel.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-rework-workingset-protection-fix.patch added to mm-unstable branch
Message-Id: <20241226221214.2305FC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-mglru-rework-workingset-protection-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-rework-workingset-protection-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-rework-workingset-protection-fix.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm-mglru-rework-workingset-protection-fix
Date: Tue, 24 Dec 2024 12:04:44 -0700

Revert change to folio_mark_accessed() that unncessarily dirties cache
lines shared between different cores.

Link: https://lkml.kernel.org/r/Z2sFzKmHPI0kI_fq@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Tested-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/swap.c~mm-mglru-rework-workingset-protection-fix
+++ a/mm/swap.c
@@ -395,7 +395,8 @@ static void lru_gen_inc_refs(struct foli
 
 	do {
 		if ((old_flags & LRU_REFS_MASK) == LRU_REFS_MASK) {
-			folio_set_workingset(folio);
+			if (!folio_test_workingset(folio))
+				folio_set_workingset(folio);
 			return;
 		}
 
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-mglru-clean-up-workingset.patch
mm-mglru-optimize-deactivation.patch
mm-mglru-rework-aging-feedback.patch
mm-mglru-rework-type-selection.patch
mm-mglru-rework-refault-detection.patch
mm-mglru-rework-workingset-protection.patch
mm-mglru-rework-workingset-protection-fix.patch

