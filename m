From: akpm@linux-foundation.org
Subject: [merged] epoll-fix-size-check-in-epoll_create.patch removed from -mm tree
Date: Wed, 13 May 2009 11:31:56 -0700
Message-ID: <200905131831.n4DIVuDl018638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760947AbZEMSiM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 14:38:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, Hiroyuki.Mach@gmail.com, drepper@redhat.com, rohit.170309@gmail.com, stable@kernel.org, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     epoll: fix size check in epoll_create()
has been removed from the -mm tree.  Its filename was
     epoll-fix-size-check-in-epoll_create.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
poll-avoid-extra-wakeups-in-select-poll.patch

