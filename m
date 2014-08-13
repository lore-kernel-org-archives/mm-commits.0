From: akpm@linux-foundation.org
Subject: + ipc-always-handle-a-new-value-of-auto_msgmni.patch added to -mm tree
Date: Wed, 13 Aug 2014 13:38:49 -0700
Message-ID: <53ebccd9.9lvYLkvO8eknjZQu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:41591 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaHMUiu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 16:38:50 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so92536pab.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 13:38:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, davidlohr@hp.com, joe@perches.com, manfred@colorfullife.com, minipli@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: always handle a new value of auto_msgmni
has been added to the -mm tree.  Its filename is
     ipc-always-handle-a-new-value-of-auto_msgmni.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-always-handle-a-new-value-of-auto_msgmni.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-always-handle-a-new-value-of-auto_msgmni.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
ipc-always-handle-a-new-value-of-auto_msgmni.patch

