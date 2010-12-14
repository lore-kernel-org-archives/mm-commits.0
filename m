From: akpm@linux-foundation.org
Subject: + delayacct-fix-iotop-on-x86_64.patch added to -mm tree
Date: Tue, 14 Dec 2010 12:16:49 -0800
Message-ID: <201012142016.oBEKGoOQ007249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759873Ab0LNUQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Dec 2010 15:16:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, balbir@in.ibm.com, brian@xyzw.org, guichaz@gmail.com, jeffm@suse.com


The patch titled
     delayacct: fix iotop on x86_64
has been added to the -mm tree.  Its filename is
     delayacct-fix-iotop-on-x86_64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: delayacct: fix iotop on x86_64
From: Dan Carpenter <error27@gmail.com>

We changed how the taskstats was exported to user space in: 85893120699
("delayacct: align to 8 byte boundary on 64-bit systems").  This was
important because it fixes a run time warning on IA64.  In theory it
shouldn't have broken anything, if you just assume that user space
programmers don't smoke crack all day long.

But actually it breaks iotop on x86_64.

Reported-by: Brian Rogers <brian@xyzw.org>
Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Guillaume Chazarain <guichaz@gmail.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN kernel/taskstats.c~delayacct-fix-iotop-on-x86_64 kernel/taskstats.c
--- a/kernel/taskstats.c~delayacct-fix-iotop-on-x86_64
+++ a/kernel/taskstats.c
@@ -357,7 +357,19 @@ static struct taskstats *mk_reply(struct
 	 * This causes lots of runtime warnings on systems requiring 8 byte
 	 * alignment */
 	u32 pids[2] = { pid, 0 };
-	int pid_size = ALIGN(sizeof(pid), sizeof(long));
+	int pid_size;
+
+	/*
+	 * IA64 can't be aligned on a 4 byte boundary.  But iotop on x86_64
+	 * depends on the current struct layout.  The next version of iotop
+	 * will fix this so maybe we can move everything to the new code in
+	 * a couple years.
+	 */
+#if defined(CONFIG_IA64)
+	pid_size = ALIGN(sizeof(pid), sizeof(long));
+#else
+	pid_size = sizeof(u32);
+#endif
 
 	aggr = (type == TASKSTATS_TYPE_PID)
 			? TASKSTATS_TYPE_AGGR_PID
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
delayacct-fix-iotop-on-x86_64.patch
delayacct-fix-iotop-on-x86_64-fix.patch
dca-remove-unneeded-null-check.patch

