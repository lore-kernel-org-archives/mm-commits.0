Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5227396599
	for <mm-commits@vger.kernel.org>; Tue,  3 Mar 2026 23:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772579551; cv=none; b=hBOo5ARFNuzY/XgU9UaS1CdlFXMycLyllug4nffNJFcurjb+garozil934S+c4T+7Pcezk5zRd60yQzQm/Kj8SA/xQz1Zu75RBCcOWtESoKpIKABO2gF9mdL9uRJQCvH5YH0hh+l649nJK/dPzzQJ3nrm6EMhlAvl6bhAdx1x9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772579551; c=relaxed/simple;
	bh=kNgQPj/O0UTXcW82ux0nOfUdPsuIE0brCyWvyHH7z3E=;
	h=Date:To:From:Subject:Message-Id; b=o54shx9BWRex2pHBlZ6W5xDtHdjORCGPPvWlkZx8aHsoGG+IlIDzS+iaqRPtrFuiikYlQktU8uwCId9BiIDkmA2wQvhFq5pBcdtQ/tNwfg39RYh8508KgVMjDvriVD/aS+W0nHuDbzMJ2MlNwJEF0s1yOvpKOZPT3wkJlzYNcMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hzEYap7f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hzEYap7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36695C116C6;
	Tue,  3 Mar 2026 23:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772579550;
	bh=kNgQPj/O0UTXcW82ux0nOfUdPsuIE0brCyWvyHH7z3E=;
	h=Date:To:From:Subject:From;
	b=hzEYap7f2Y7o8hedD6EM90fSU4JDHPLBYOyGmHFGIiBnIR5I2Irs5cDptbSSskFcP
	 J+ACyuywITUt9Dhgml8FiUqMxhM2UFSaxLVEKNSUVHiXaXRDu0e8oj2d/VIa73VCTT
	 C86Lg/ZorDKFU/e6+X02xvBTPJO/LwH/YYOeT9ZU=
Date: Tue, 03 Mar 2026 15:12:29 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,rientjes@google.com,mhocko@suse.com,d@ilvokhin.com,maninder1.s@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-oom_killc-simpilfy-rcu-call-with-guardrcu.patch added to mm-new branch
Message-Id: <20260303231230.36695C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/oom_kill.c: simpilfy rcu call with guard(rcu)
has been added to the -mm mm-new branch.  Its filename is
     mm-oom_killc-simpilfy-rcu-call-with-guardrcu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-oom_killc-simpilfy-rcu-call-with-guardrcu.patch

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
From: Maninder Singh <maninder1.s@samsung.com>
Subject: mm/oom_kill.c: simpilfy rcu call with guard(rcu)
Date: Tue, 3 Mar 2026 15:56:00 +0530

guard(rcu)() simplifies code readability and there is no need of extra
goto labels.

Thus replacing rcu_read_lock/unlock with guard(rcu)().

Link: https://lkml.kernel.org/r/20260303102600.105255-1-maninder1.s@samsung.com
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/oom_kill.c~mm-oom_killc-simpilfy-rcu-call-with-guardrcu
+++ a/mm/oom_kill.c
@@ -135,19 +135,16 @@ struct task_struct *find_lock_task_mm(st
 {
 	struct task_struct *t;
 
-	rcu_read_lock();
+	guard(rcu)();
 
 	for_each_thread(p, t) {
 		task_lock(t);
 		if (likely(t->mm))
-			goto found;
+			return t;
 		task_unlock(t);
 	}
-	t = NULL;
-found:
-	rcu_read_unlock();
 
-	return t;
+	return NULL;
 }
 
 /*
_

Patches currently in -mm which might be from maninder1.s@samsung.com are

mm-oom_killc-simpilfy-rcu-call-with-guardrcu.patch

