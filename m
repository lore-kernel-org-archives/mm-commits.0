From: akpm@linux-foundation.org
Subject: + sysctl-fix-min-max-handling-in-__do_proc_doulongvec_minmax-v2.patch added to -mm tree
Date: Thu, 07 Oct 2010 12:18:53 -0700
Message-ID: <201010071918.o97JIs28018487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103Ab0JGTS6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Oct 2010 15:18:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.dumazet@gmail.com, ebiederm@xmission.com, xiyou.wangcong@gmail.com


The patch titled
     sysctl: fix min/max handling in __do_proc_doulongvec_minmax()
has been added to the -mm tree.  Its filename is
     sysctl-fix-min-max-handling-in-__do_proc_doulongvec_minmax-v2.patch

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
Subject: sysctl: fix min/max handling in __do_proc_doulongvec_minmax()
From: Eric Dumazet <eric.dumazet@gmail.com>

When proc_doulongvec_minmax() is used with an array of longs, and no
min/max check requested (.extra1 or .extra2 being NULL), we dereference a
NULL pointer for the second element of the array.

Noticed while doing some changes in network stack for the "16TB problem"

Fix is to not change min & max pointers in __do_proc_doulongvec_minmax(),
so that all elements of the vector share an unique min/max limit, like
proc_dointvec_minmax().

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Americo Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sysctl.c~sysctl-fix-min-max-handling-in-__do_proc_doulongvec_minmax-v2 kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-fix-min-max-handling-in-__do_proc_doulongvec_minmax-v2
+++ a/kernel/sysctl.c
@@ -2485,7 +2485,7 @@ static int __do_proc_doulongvec_minmax(v
 		kbuf[left] = 0;
 	}
 
-	for (; left && vleft--; i++, min++, max++, first=0) {
+	for (; left && vleft--; i++, first=0) {
 		unsigned long val;
 
 		if (write) {
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

sysctl-fix-min-max-handling-in-__do_proc_doulongvec_minmax-v2.patch
linux-next.patch
net-avoid-limits-overflow.patch
fs-allow-for-more-than-231-files.patch
signals-annotate-lock_task_sighand.patch

