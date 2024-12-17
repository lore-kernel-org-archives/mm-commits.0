Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B84E53389
	for <mm-commits@vger.kernel.org>; Tue, 17 Dec 2024 17:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734457201; cv=none; b=sWD2vNptXTZzgawfVa8eIct3LB/eDsjw3d+MDM0Rjj38GO5CrAOFY6BL8+az+abUnN3NI4EO7cHieJl1d7pgiYXdAeuyHOVKh0Cwo3obFECIaLV+wbC/elftWru8smEKGWsfe8S81gCHV8zQ+o3hCYxF1geGlzCKpPYd0xTpN3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734457201; c=relaxed/simple;
	bh=w1GelekGhlOFCxEFTUr/dD2bYiTF3VtpOBL0mCHTzEo=;
	h=Date:To:From:Subject:Message-Id; b=QNJdnFen6QcOw3w1QfyJSoDUViLsxo15ilB2/5KmBJ7e1KaOGRyoln5a2/bmCdIKKfotMxAcOKDv4iubDgF0UlbueJNAI/JlC3xbhnqZz9iNwCJ36+Z4VXB27mMBmKQq+DNoV+em9s0y74AzynQL3BpF25fuG4ZcftjqFfsIQA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MkTE3bnr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MkTE3bnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE30C4CED3;
	Tue, 17 Dec 2024 17:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734457201;
	bh=w1GelekGhlOFCxEFTUr/dD2bYiTF3VtpOBL0mCHTzEo=;
	h=Date:To:From:Subject:From;
	b=MkTE3bnrNtYB3CiCkXB9mz/L2RldP2iHpOJTHpapFmtEBV2zAswhzoWifqnr6CyX6
	 hugHcv9gVMfdSuqecsQ6fq/y+OJrtej7sOl7CG1JGqWYuk26/FIe50BOK7+P9AjQzm
	 GwLzdSZGw5VQYi+Vwu+xLYIkTIn608jFf5tAT2WQ=
Date: Tue, 17 Dec 2024 09:40:00 -0800
To: mm-commits@vger.kernel.org,eahariha@linux.microsoft.com,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-kernel-convert-timeouts-to-use-secs_to_jiffies-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20241217174000.DEE30C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390-kernel-convert-timeouts-to-use-secs_to_jiffies-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     s390-kernel-convert-timeouts-to-use-secs_to_jiffies-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-kernel-convert-timeouts-to-use-secs_to_jiffies-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: s390-kernel-convert-timeouts-to-use-secs_to_jiffies-fix
Date: Tue, 17 Dec 2024 18:31:16 +0100

simplify cmm_set_timer()

Link: https://lkml.kernel.org/r/Z2G1ZPL2cAlQOYlF@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Easwar Hariharan <eahariha@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/cmm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/mm/cmm.c~s390-kernel-convert-timeouts-to-use-secs_to_jiffies-fix
+++ a/arch/s390/mm/cmm.c
@@ -204,7 +204,7 @@ static void cmm_set_timer(void)
 			del_timer(&cmm_timer);
 		return;
 	}
-	mod_timer(&cmm_timer, jiffies + msecs_to_jiffies(cmm_timeout_seconds * MSEC_PER_SEC));
+	mod_timer(&cmm_timer, jiffies + secs_to_jiffies(cmm_timeout_seconds));
 }
 
 static void cmm_timer_fn(struct timer_list *unused)
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are

s390-kernel-convert-timeouts-to-use-secs_to_jiffies-fix.patch

