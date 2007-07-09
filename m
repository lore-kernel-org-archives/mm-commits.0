From: akpm@linux-foundation.org
Subject: - use-boot-based-time-for-process-start-time-and-boot-time-fix-3.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:46:17 -0700
Message-ID: <200707092146.l69LkHRu013964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36640 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754997AbXGIVsK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 17:48:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tjanouse@redhat.com, johnstul@us.ibm.com, tsmetana@redhat.com, mm-commits@vger.kernel.org


The patch titled
     use-boot-based-time-for-process-start-time-and-boot-time-fix- 3
has been removed from the -mm tree.  Its filename was
     use-boot-based-time-for-process-start-time-and-boot-time-fix-3.patch

This patch was dropped because it was folded into use-boot-based-time-for-process-start-time-and-boot-time.patch

------------------------------------------------------
Subject: use-boot-based-time-for-process-start-time-and-boot-time-fix- 3
From: Tomas Janousek <tjanouse@redhat.com>

Document start times in struct task_struct

Signed-off-by: Tomas Janousek <tjanouse@redhat.com>
Cc: Tomas Smetana <tsmetana@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/sched.h~use-boot-based-time-for-process-start-time-and-boot-time-fix-3 include/linux/sched.h
--- a/include/linux/sched.h~use-boot-based-time-for-process-start-time-and-boot-time-fix-3
+++ a/include/linux/sched.h
@@ -902,8 +902,8 @@ struct task_struct {
 	unsigned int rt_priority;
 	cputime_t utime, stime;
 	unsigned long nvcsw, nivcsw; /* context switch counts */
-	struct timespec start_time;
-	struct timespec real_start_time;
+	struct timespec start_time; 		/* monotonic time */
+	struct timespec real_start_time;	/* boot based time */
 /* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
 	unsigned long min_flt, maj_flt;
 
_

Patches currently in -mm which might be from tjanouse@redhat.com are

introduce-boot-based-time.patch
use-boot-based-time-for-process-start-time-and-boot-time.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix-3.patch
use-boot-based-time-for-uptime-in-proc.patch
