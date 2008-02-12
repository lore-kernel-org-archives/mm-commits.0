From: akpm@linux-foundation.org
Subject: + proc-add-rlimit_rttime-to-proc-pid-limits.patch added to -mm tree
Date: Tue, 12 Feb 2008 15:56:03 -0800
Message-ID: <200802122356.m1CNu3Dq029730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59564 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751818AbYBLX4Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 18:56:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eugeneteo@kernel.sg, a.p.zijlstra@chello.nl, mingo@elte.hu


The patch titled
     proc: add RLIMIT_RTTIME to /proc/<pid>/limits
has been added to the -mm tree.  Its filename is
     proc-add-rlimit_rttime-to-proc-pid-limits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

proc-add-rlimit_rttime-to-proc-pid-limits.patch
