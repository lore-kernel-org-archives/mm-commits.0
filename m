Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27DC16D9C2
	for <mm-commits@vger.kernel.org>; Mon,  5 May 2025 21:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746480901; cv=none; b=gHq1Ai2vHwK4Zv7l8ygeMzh/GvI8cqeMyaic0zkbGo5pI9y7gAcxWtAjKzpt51H/epqezS3bBicwAqzbZ58YOAzQuICqXkXwkKeLZ/C1Pb7CrdwZ0qsF45ruYlVy4d2X9dw7QSj+SgirbnDW418ItWz1XhebagkcetEykg+wJMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746480901; c=relaxed/simple;
	bh=aDcVH1loJpXkogMBq0gC4gxqK4LqlE2JjDU+hPVPkxM=;
	h=Date:To:From:Subject:Message-Id; b=Lq7lAUER6htJRrXhntUz9EuZzmLyPBYsrMmlW+cvTRCumJ1bzhkZ61ExbJ0wf96UaFoyoBwJbskUSEth6CQlopJnVbicixw0bVeRJIFtnjhEiJOONtt3R1i5kqLhjL05rlPtDLDd8KNddr2wAsZi3hdKWEcMCiOUL9682VV0VmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HeD8hNL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HeD8hNL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075A4C4CEE4;
	Mon,  5 May 2025 21:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746480901;
	bh=aDcVH1loJpXkogMBq0gC4gxqK4LqlE2JjDU+hPVPkxM=;
	h=Date:To:From:Subject:From;
	b=HeD8hNL9iyheOtjyHgcHgmucSqgc306ftb7z4r/emRz5rJ7s0sQaKtiGRhq+7SEDB
	 5uydDm5+SuK+6npSlH+A8BrQqO08OzwXsw+DLi93Kp884UKdzm/epA4gms0BW+6NIa
	 p2SO5VsT1JqaxCVTyDCV/mY909uGOF/cgIa9cIVE=
Date: Mon, 05 May 2025 14:35:00 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,thusharms@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-fix-spelling-mistake.patch added to mm-unstable branch
Message-Id: <20250505213501.075A4C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs/mm/damon/design: fix spelling mistake
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-fix-spelling-mistake.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-fix-spelling-mistake.patch

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
From: Thushara.M.S <thusharms@gmail.com>
Subject: docs/mm/damon/design: fix spelling mistake
Date: Mon May  5 02:29:12 PM PDT 2025

The word accuracy was misspelled as "accruracy".

Signed-off-by: Thushara.M.S <thusharms@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-fix-spelling-mistake
+++ a/Documentation/mm/damon/design.rst
@@ -54,7 +54,7 @@ monitoring are address-space dependent.
 DAMON consolidates these implementations in a layer called DAMON Operations
 Set, and defines the interface between it and the upper layer.  The upper layer
 is dedicated for DAMON's core logics including the mechanism for control of the
-monitoring accruracy and the overhead.
+monitoring accuracy and the overhead.
 
 Hence, DAMON can easily be extended for any address space and/or available
 hardware features by configuring the core logic to use the appropriate
_

Patches currently in -mm which might be from thusharms@gmail.com are

docs-mm-damon-design-fix-spelling-mistake.patch

