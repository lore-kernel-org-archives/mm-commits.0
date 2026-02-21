Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19E4280A5B
	for <mm-commits@vger.kernel.org>; Sat, 21 Feb 2026 00:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771634327; cv=none; b=u6/DlTPT/RPSiM2mF5X8BDLfQeBR7KZ6cIDpC+Lqmnd6VqnfcmRqMWm73L0t85zUWS+ooWIM09kPG1SoCU5BzYvDX0W5/aJHYNOKFNW+X5BOuCZWDVlCRHG9XVUwxCQvmWSESY6mcY5k3NRidZPPXBXF3Ds15/Pzb2PRGLzE+eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771634327; c=relaxed/simple;
	bh=/Q/eBCTuG6Qx516PAGoOEfCUp9oVY+vjoNVoCu83Ub4=;
	h=Date:To:From:Subject:Message-Id; b=jNn3eJ4z3Aqs5l1Z6J9uKYL/qz1IZx+wgKq/nBUPnXS6ialrx/4Let1J/UK/cXAg9QNnEIWqyFiy47DtAxzEMak1VeZDphL2l1+4xQOnGBxZXN4BcHso/Lf2o5p6y7NtwZXfMLHjPxiCa3tzShOuUFgU6kzW8ZPl1oivDsKHdHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gFm/Y+Cx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gFm/Y+Cx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92A2C116C6;
	Sat, 21 Feb 2026 00:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771634326;
	bh=/Q/eBCTuG6Qx516PAGoOEfCUp9oVY+vjoNVoCu83Ub4=;
	h=Date:To:From:Subject:From;
	b=gFm/Y+Cx6HSKBrRWg8T0K4x++uJEdWphJMEgNhEc5b/LZwcS9FqVWWRLkPe50MrNY
	 65uAnbxCTZljiEKrvkwA3r9bxlUDtnMUzCf0GARW7kE84W34k7ffIKNHiW4dI7H+yR
	 DQ53IbkAtagAV23BddDML3P1AGa54HIyxgTHeGGM=
Date: Fri, 20 Feb 2026 16:38:46 -0800
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,zhongqiu.han@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-remove-unreachable-return-statement-in-scan_should_stop.patch added to mm-new branch
Message-Id: <20260221003846.B92A2C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kmemleak: remove unreachable return statement in scan_should_stop()
has been added to the -mm mm-new branch.  Its filename is
     mm-kmemleak-remove-unreachable-return-statement-in-scan_should_stop.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-remove-unreachable-return-statement-in-scan_should_stop.patch

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
From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Subject: mm/kmemleak: remove unreachable return statement in scan_should_stop()
Date: Fri, 30 Jan 2026 17:37:28 +0800

Patch series "mm/kmemleak: Improve scan_should_stop() implementation".

This series improves the scan_should_stop() function by addressing code
quality issues and enhancing kernel thread detection robustness.


This patch (of 2):

Remove unreachable "return 0;" statement as all execution paths return
before reaching it.

No functional change.

Link: https://lkml.kernel.org/r/20260130093729.2045858-2-zhongqiu.han@oss.qualcomm.com
Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-remove-unreachable-return-statement-in-scan_should_stop
+++ a/mm/kmemleak.c
@@ -1507,10 +1507,8 @@ static int scan_should_stop(void)
 	 */
 	if (current->mm)
 		return signal_pending(current);
-	else
-		return kthread_should_stop();
 
-	return 0;
+	return kthread_should_stop();
 }
 
 /*
_

Patches currently in -mm which might be from zhongqiu.han@oss.qualcomm.com are

mm-kmemleak-remove-unreachable-return-statement-in-scan_should_stop.patch
mm-kmemleak-use-pf_kthread-flag-to-detect-kernel-threads.patch

