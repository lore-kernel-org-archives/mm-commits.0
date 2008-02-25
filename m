From: akpm@linux-foundation.org
Subject: - proc-add-rlimit_rttime-to-proc-pid-limits.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:45:12 -0800
Message-ID: <200802250045.m1P0jCJZ006238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753629AbYBYAsr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:48:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eugeneteo@kernel.sg, a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     proc: add RLIMIT_RTTIME to /proc/<pid>/limits
has been removed from the -mm tree.  Its filename was
     proc-add-rlimit_rttime-to-proc-pid-limits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: add RLIMIT_RTTIME to /proc/<pid>/limits
From: Eugene Teo <eugeneteo@kernel.sg>

RLIMIT_RTTIME was introduced to allow the user to set a runtime timeout on
real-time tasks: http://lkml.org/lkml/2007/12/18/218. This patch updates
/proc/<pid>/limits with the new rlimit.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/proc/base.c~proc-add-rlimit_rttime-to-proc-pid-limits fs/proc/base.c
--- a/fs/proc/base.c~proc-add-rlimit_rttime-to-proc-pid-limits
+++ a/fs/proc/base.c
@@ -416,6 +416,7 @@ static const struct limit_names lnames[R
 	[RLIMIT_MSGQUEUE] = {"Max msgqueue size", "bytes"},
 	[RLIMIT_NICE] = {"Max nice priority", NULL},
 	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
+	[RLIMIT_RTTIME] = {"Max realtime timeout", "us"},
 };
 
 /* Display limits for a process */
_

Patches currently in -mm which might be from eugeneteo@kernel.sg are

git-sched.patch
