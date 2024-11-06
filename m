Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCA420CCC4
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 21:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730928913; cv=none; b=FrSVFDdGGyEx1UxO3WUgMKBElOOlqJo5PP6DQeoe8bDO10yn6mllj9jr871b9VAv7r9sOKnt0AlB9AwbBWuYocv083cicfQLIDDFM/O45p8b496G6zC9P64wxrwnYcvf++jwx+6pDPWyxGnhLElcxYGM7jzI7F68sTEQUN7g/bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730928913; c=relaxed/simple;
	bh=qduNWPwh3C9zPbc6UQispJWMkYOdh9dNJRJUh9ZRpxI=;
	h=Date:To:From:Subject:Message-Id; b=nIJJOV3AdtDPReMAapAb5bE5zcO1AIFbXLt7WAFL6hgMeKR2P64zNj2Siri7rOpEhLkbLEuxXs5/txWn5xMS2mCYAeLHT75biSYlRKx2459pQaQEZVqoWhviDAzw+F9JzQHPmN5z/L5qPpfmQB02Cq8bbU3OgPkfHaNMomZ+/3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aPrlEial; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aPrlEial"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92E7C4CEC6;
	Wed,  6 Nov 2024 21:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730928913;
	bh=qduNWPwh3C9zPbc6UQispJWMkYOdh9dNJRJUh9ZRpxI=;
	h=Date:To:From:Subject:From;
	b=aPrlEialeBh8RD+Wmp+XTagdIS12O8m6HrZdggjhA2AZgnC/ooGl3CPn4uBtMqPNV
	 G5PDsQsiNrYrRknZBJudlVr8nIn2D+FqQZyfmKz9RvH9DeREj1xv2Jk0DNuc1ta4Ht
	 KfE+yILvCrZ/GoyXb9Si5ZrGGV93BIYFHtKmYtr4=
Date: Wed, 06 Nov 2024 13:35:12 -0800
To: mm-commits@vger.kernel.org,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-add-detect-count-for-hung-tasks-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20241106213512.E92E7C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hung_task-add-detect-count-for-hung-tasks-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hung_task-add-detect-count-for-hung-tasks-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hung_task-add-detect-count-for-hung-tasks-fix.patch

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
From: Lance Yang <ioworker0@gmail.com>
Subject: hung_task-add-detect-count-for-hung-tasks-fix
Date: Fri, 1 Nov 2024 19:48:33 +0800

sysctl_hung_task_detect_count is defined as an unsigned long, so we need
to use proc_doulongvec_minmax instead of proc_dointvec to handle it
correctly.

Link: https://lkml.kernel.org/r/20241101114833.8377-1-ioworker0@gmail.com
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/hung_task.c~hung_task-add-detect-count-for-hung-tasks-fix
+++ a/kernel/hung_task.c
@@ -330,7 +330,7 @@ static struct ctl_table hung_task_sysctl
 		.data		= &sysctl_hung_task_detect_count,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0444,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_doulongvec_minmax,
 	},
 };
 
_

Patches currently in -mm which might be from ioworker0@gmail.com are

hung_task-add-detect-count-for-hung-tasks-fix.patch

