Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317C13E7145
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 22:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786660966; cv=none; b=f2Wvr47MxTamHv1wVlF+LHFSkoMv2iQyVpKjBWFZg2NafA53or75scAHs8M/vN64WGOBIPgoYLkwoXiZipzGYYFAID+IyuG4k7LNpmvoLpT8XMCKxS/QBmKVAOBcp+jn8M4BKKESglzrh+bqChQD9IGMHAQTRud+eyP8bID0YPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786660966; c=relaxed/simple;
	bh=AP9IqKQEHyqt4liooqGJrgdNxp7Ktr86r8oYPlnBPzI=;
	h=Date:To:From:Subject:Message-Id; b=cuKBEKW71e+UQmFbDYTWSHDfJDTxnaQe9n5MT4wlLonQ43L95A5+zzi2Y05sPj6eUr+mcR2gjDZuJzzZwJvDB4yufq0W5655eO/wnsUqPUeO0LNY7PaNsxKJhkd1RqO/0nBXiGx+9Ec1HtOdya3crywmuQsdiiz/5aFD4ptpVy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BZ9MFDYP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BZ9MFDYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAF81F000E9;
	Thu, 13 Aug 2026 22:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786660964;
	bh=V40dnd6NnHbG53uX4WmtLpFihJhtigyCCtNoxQiRVGs=;
	h=Date:To:From:Subject;
	b=BZ9MFDYP5IO0YbOBVCwBdls7ZPpQ+DwvuzpgCv3mNW/OYyChXQ1xD45KlxXFbeElG
	 Lng44ZfGkYkxPE8z8NHax6vku1NCdx1bX0++BLLE49yzP0NskPvvFRaFEA9rQpsCop
	 oMzqrVKiudeD9dQsShEqfspa4eoogOC5D018haUs=
Date: Thu, 13 Aug 2026 15:42:43 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,mhiramat@kernel.org,lance.yang@linux.dev,wangxb12@chinatelecom.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hung_task-update-detect_hung_task_blocker-kconfig-help.patch removed from -mm tree
Message-Id: <20260813224243.ECAF81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task: update DETECT_HUNG_TASK_BLOCKER Kconfig help
has been removed from the -mm tree.  Its filename was
     hung_task-update-detect_hung_task_blocker-kconfig-help.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1320,10 +1320,10 @@ config DETECT_HUNG_TASK_BLOCKER
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


