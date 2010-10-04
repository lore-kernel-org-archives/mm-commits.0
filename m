From: akpm@linux-foundation.org
Subject: + sysctl-fix-min-max-handling-in-__do_proc_doulongvec_minmax.patch added to -mm tree
Date: Mon, 04 Oct 2010 13:10:46 -0700
Message-ID: <201010042010.o94KAkot011707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754119Ab0JDULF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 16:11:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.dumazet@gmail.com, ebiederm@xmission.com


The patch titled
     sysctl: fix min/max handling in __do_proc_doulongvec_minmax()
has been added to the -mm tree.  Its filename is
     sysctl-fix-min-max-handling-in-__do_proc_doulongvec_minmax.patch

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

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/sysctl.c~sysctl-fix-min-max-handling-in-__do_proc_doulongvec_minmax kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-fix-min-max-handling-in-__do_proc_doulongvec_minmax
+++ a/kernel/sysctl.c
@@ -2500,7 +2500,8 @@ static int __do_proc_doulongvec_minmax(v
 				break;
 			if (neg)
 				continue;
-			if ((min && val < *min) || (max && val > *max))
+			if ((table->extra1 && val < *min) ||
+			    (table->extra2 && val > *max))
 				continue;
 			*i = val;
 		} else {
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

origin.patch
sysctl-fix-min-max-handling-in-__do_proc_doulongvec_minmax.patch
linux-next.patch
signals-annotate-lock_task_sighand.patch

