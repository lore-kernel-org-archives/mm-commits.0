From: akpm@linux-foundation.org
Subject: + epoll-fix-size-check-in-epoll_create.patch added to -mm tree
Date: Tue, 12 May 2009 12:37:33 -0700
Message-ID: <200905121937.n4CJbYCA015815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751612AbZELTml (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 May 2009 15:42:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, Hiroyuki.Mach@gmail.com, drepper@redhat.com, rohit.170309@gmail.com, stable@kernel.org, torvalds@linux-foundation.org


The patch titled
     epoll: fix size check in epoll_create()
has been added to the -mm tree.  Its filename is
     epoll-fix-size-check-in-epoll_create.patch

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
Subject: epoll: fix size check in epoll_create()
From: Davide Libenzi <davidel@xmailserver.org>

Fix a size check WRT the manual pages.  This was inadvertently broken by

: commit 9fe5ad9c8cef9ad5873d8ee55d1cf00d9b607df0
: Author:     Ulrich Drepper <drepper@redhat.com>
: AuthorDate: Wed Jul 23 21:29:43 2008 -0700
: Commit:     Linus Torvalds <torvalds@linux-foundation.org>
: CommitDate: Thu Jul 24 10:47:29 2008 -0700
: 
:     flag parameters add-on: remove epoll_create size param
    
Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: <Hiroyuki.Mach@gmail.com>
Cc: rohit verma <rohit.170309@gmail.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/eventpoll.c~epoll-fix-size-check-in-epoll_create fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-fix-size-check-in-epoll_create
+++ a/fs/eventpoll.c
@@ -1212,7 +1212,7 @@ SYSCALL_DEFINE1(epoll_create1, int, flag
 
 SYSCALL_DEFINE1(epoll_create, int, size)
 {
-	if (size < 0)
+	if (size <= 0)
 		return -EINVAL;
 
 	return sys_epoll_create1(0);
_

Patches currently in -mm which might be from davidel@xmailserver.org are

epoll-fix-size-check-in-epoll_create.patch
linux-next.patch
poll-avoid-extra-wakeups-in-select-poll.patch

