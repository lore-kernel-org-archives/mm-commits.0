From: akpm@linux-foundation.org
Subject: + epoll-permit-unlimited-number-of-depth=1-paths.patch added to -mm tree
Date: Fri, 16 Mar 2012 14:12:42 -0700
Message-ID: <20120316211242.9714CA032F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:63389 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2CPVMo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Mar 2012 17:12:44 -0400
Received: by qabg24 with SMTP id g24so7242qab.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Mar 2012 14:12:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbaron@redhat.com


The patch titled
     Subject: epoll: permit unlimited number of depth=1 paths.
has been added to the -mm tree.  Its filename is
     epoll-permit-unlimited-number-of-depth=1-paths.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Baron <jbaron@redhat.com>
Subject: epoll: permit unlimited number of depth=1 paths.

The patch I did to limit the number of possible wakeup paths in epoll is
causing a few applications to longer work (dovecot for one).  Commit:
28d82dc1c4edbc352129f97f4ca22624d1fe61de.

The original patch is really about limiting the amount of epoll nesting
(since epoll fds can be attached to other fds).  Thus, we probably can
allow an unlimited number of paths of depth 1.  My current patch limits it
at 1000.  And enforce the limits on paths that have a greater depth. 
Thus, I *believe* the patch below should fix the issue.  But I'm still
waiting for some testing confirmation.  I wanted to give you a heads up
before 3.3 comes out, as I believe this is something we don't want broken
in 3.3.

As soon as I have testing confirmation, I will post a patch to lkml.

This is captured in: https://bugzilla.redhat.com/show_bug.cgi?id=681578

Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/eventpoll.c~epoll-permit-unlimited-number-of-depth=1-paths fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-permit-unlimited-number-of-depth=1-paths
+++ a/fs/eventpoll.c
@@ -988,6 +988,10 @@ static int path_count[PATH_ARR_SIZE];
 
 static int path_count_inc(int nests)
 {
+	/* Allow an arbitrary number of depth 1 paths */
+	if (nests == 0)
+		return 0;
+
 	if (++path_count[nests] > path_limits[nests])
 		return -1;
 	return 0;
_
Subject: Subject: epoll: permit unlimited number of depth=1 paths.

Patches currently in -mm which might be from jbaron@redhat.com are

epoll-permit-unlimited-number-of-depth=1-paths.patch
linux-next.patch
epoll-remove-unneeded-variable-in-reverse_path_check.patch
coredump-remove-vm_alwaysdump-flag.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch

