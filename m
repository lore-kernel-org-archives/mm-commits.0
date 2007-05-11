From: akpm@linux-foundation.org
Subject: + use-boot-based-time-for-process-start-time-and-boot-time-fix-3.patch added to -mm tree
Date: Fri, 11 May 2007 12:50:03 -0700
Message-ID: <200705111950.l4BJo49m025114@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934176AbXEKTuQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 15:50:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tjanouse@redhat.com, johnstul@us.ibm.com, tsmetana@redhat.com


The patch titled
     use-boot-based-time-for-process-start-time-and-boot-time-fix- 3
has been added to the -mm tree.  Its filename is
     use-boot-based-time-for-process-start-time-and-boot-time-fix-3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/sched.h~use-boot-based-time-for-process-start-time-and-boot-time-fix-3 include/linux/sched.h
--- a/include/linux/sched.h~use-boot-based-time-for-process-start-time-and-boot-time-fix-3
+++ a/include/linux/sched.h
@@ -901,8 +901,8 @@ struct task_struct {
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
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix-2.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix-3.patch
use-boot-based-time-for-uptime-in-proc.patch
