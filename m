From: akpm@linux-foundation.org
Subject: [merged] ipc-always-handle-a-new-value-of-auto_msgmni.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:21:48 -0700
Message-ID: <543d69bc.nvqiLyzBdyIEYOmG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbaJNSVr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:21:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, davidlohr@hp.com, joe@perches.com, manfred@colorfullife.com, minipli@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: always handle a new value of auto_msgmni
has been removed from the -mm tree.  Its filename was
     ipc-always-handle-a-new-value-of-auto_msgmni.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Vagin <avagin@openvz.org>
Subject: ipc: always handle a new value of auto_msgmni

proc_dointvec_minmax() returns zero if a new value has been set.  So we
don't need to check all charecters have been handled.

Below you can find two examples.  In the new value has not been handled
properly.

$ strace ./a.out
open("/proc/sys/kernel/auto_msgmni", O_WRONLY) = 3
write(3, "0\n\0", 3)                    = 2
close(3)                                = 0
exit_group(0)
$ cat /sys/kernel/debug/tracing/trace

$strace ./a.out
open("/proc/sys/kernel/auto_msgmni", O_WRONLY) = 3
write(3, "0\n", 2)                      = 2
close(3)                                = 0

$ cat /sys/kernel/debug/tracing/trace
a.out-697   [000] ....  3280.998235: unregister_ipcns_notifier <-proc_ipcauto_dointvec_minmax

Fixes: 9eefe520c814 ("ipc: do not use a negative value to re-enable msgmni automatic recomputin")
Signed-off-by: Andrey Vagin <avagin@openvz.org>
Cc: Mathias Krause <minipli@googlemail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Joe Perches <joe@perches.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/ipc_sysctl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN ipc/ipc_sysctl.c~ipc-always-handle-a-new-value-of-auto_msgmni ipc/ipc_sysctl.c
--- a/ipc/ipc_sysctl.c~ipc-always-handle-a-new-value-of-auto_msgmni
+++ a/ipc/ipc_sysctl.c
@@ -123,7 +123,6 @@ static int proc_ipcauto_dointvec_minmax(
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
-	size_t lenp_bef = *lenp;
 	int oldval;
 	int rc;
 
@@ -133,7 +132,7 @@ static int proc_ipcauto_dointvec_minmax(
 
 	rc = proc_dointvec_minmax(&ipc_table, write, buffer, lenp, ppos);
 
-	if (write && !rc && lenp_bef == *lenp) {
+	if (write && !rc) {
 		int newval = *((int *)(ipc_table.data));
 		/*
 		 * The file "auto_msgmni" has correctly been set.
_

Patches currently in -mm which might be from avagin@openvz.org are

origin.patch

