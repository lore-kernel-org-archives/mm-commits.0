Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F6C384242
	for <mm-commits@vger.kernel.org>; Thu, 30 Jul 2026 20:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785443538; cv=none; b=tjlpPZnRiOMMlLCH7fbROwLyNpK/XYMsMdbOWJiPhUDJpeLa8K+tyFaIg9XFgWBRgoewsFDl+mhH0nXkUdwmgyS9yhs/bmmMAIMZdCGK5QAdzknaArhWybegmMSjHuIEgmxn4BY/j5nXcB0ZPVwo0Lan3A3/iP/rxtQL76VcCg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785443538; c=relaxed/simple;
	bh=jnGSj29w9lWFc3OQDO9VAmPnjGRSTbwF02faCxXWB88=;
	h=Date:To:From:Subject:Message-Id; b=cpaGtLQNG7n3US8YJzziCvVTCI1yE3nkjFy77EjUp+IWcYhqanjP8fUv9y8tnHH7G0IClqAMHzXWTcOPy3kgm2cUyomHhn9MBZL4HiGP/F1rertlYqhVwPl0aie5eln+VX2emgKdEQcgWR34pLF1RQwMZE1x8/YBHLDY0QJZczU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=um8vzGBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="um8vzGBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C20F1F000E9;
	Thu, 30 Jul 2026 20:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785443529;
	bh=/1T48aBKHcyN536SDS3qLy9RzvVkABLz2oMlTt2sksE=;
	h=Date:To:From:Subject;
	b=um8vzGBImkQ+tKWWrovMUlIN7QwpCyPQhB4zHSX9u260vmf2RkJnDA24pCFJyEDDy
	 IdT1GXTBTrAimaU0MGbIWecVqX+YDjH4n8CEelB7VoY3P3BnMiUBIfjeGvug8MKW8X
	 vs4+pnxDGOKhXHASj434WW1up7AHWh1KxAt0NK98=
Date: Thu, 30 Jul 2026 13:32:08 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,mhiramat@kernel.org,lance.yang@linux.dev,wangxb12@chinatelecom.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-update-detect_hung_task_blocker-kconfig-help.patch added to mm-nonmm-unstable branch
Message-Id: <20260730203209.3C20F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hung_task: update DETECT_HUNG_TASK_BLOCKER Kconfig help
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hung_task-update-detect_hung_task_blocker-kconfig-help.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hung_task-update-detect_hung_task_blocker-kconfig-help.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Xibo Wang <wangxb12@chinatelecom.cn>
Subject: hung_task: update DETECT_HUNG_TASK_BLOCKER Kconfig help
Date: Thu, 30 Jul 2026 14:18:54 +0800

The help text still says the feature only covers mutexes, but blocker
tracking has since been extended to semaphores and rwsems. Update the
description to match the supported lock types.

Link: https://lore.kernel.org/20260730061854.176547-1-wangxb12@chinatelecom.cn
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Xibo Wang <wangxb12@chinatelecom.cn>
Suggested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/lib/Kconfig.debug~hung_task-update-detect_hung_task_blocker-kconfig-help
+++ a/lib/Kconfig.debug
@@ -1292,10 +1292,10 @@ config DETECT_HUNG_TASK_BLOCKER
 	depends on !PREEMPT_RT
 	default y
 	help
-	  Say Y here to show the blocker task's stacktrace who acquires
-	  the mutex lock which "hung tasks" are waiting.
-	  This will add overhead a bit but shows suspicious tasks and
-	  call trace if it comes from waiting a mutex.
+	  Say Y here to show a possible blocker task's stacktrace when
+	  a hung task is waiting on a mutex, semaphore, or rwsem.
+	  This will add a bit of overhead but shows suspicious tasks and
+	  call traces for waits on one of these locks.
 
 config WQ_WATCHDOG
 	bool "Detect Workqueue Stalls"
_

Patches currently in -mm which might be from wangxb12@chinatelecom.cn are

hung_task-update-detect_hung_task_blocker-kconfig-help.patch

