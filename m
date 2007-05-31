From: akpm@linux-foundation.org
Subject: + better-documentation-for-erestartsys.patch added to -mm tree
Date: Thu, 31 May 2007 14:23:17 -0700
Message-ID: <200705312123.l4VLNJjd028271@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537AbXEaVXm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 17:23:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: takeuchi_satoru@jp.fujitsu.com, oleg@tv-sign.ru, roland@redhat.com


The patch titled
     Better documentation for ERESTARTSYS
has been added to the -mm tree.  Its filename is
     better-documentation-for-erestartsys.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Better documentation for ERESTARTSYS
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Add comment for errnos related to restart syscall to avoid the leakage of
them to user programs.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/errno.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff -puN include/linux/errno.h~better-documentation-for-erestartsys include/linux/errno.h
--- a/include/linux/errno.h~better-documentation-for-erestartsys
+++ a/include/linux/errno.h
@@ -5,7 +5,12 @@
 
 #ifdef __KERNEL__
 
-/* Should never be seen by user programs */
+/*
+ * These should never be seen by user programs.  To return one of ERESTART*
+ * codes, signal_pending() MUST be set.  Note that ptrace can observe these
+ * at syscall exit tracing, but they will never be left for the debugged user
+ * process to see.
+ */
 #define ERESTARTSYS	512
 #define ERESTARTNOINTR	513
 #define ERESTARTNOHAND	514	/* restart if no handler.. */
_

Patches currently in -mm which might be from takeuchi_satoru@jp.fujitsu.com are

git-input.patch
tty-fix-leakage-of-erestartsys-to-userland.patch
better-documentation-for-erestartsys.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
