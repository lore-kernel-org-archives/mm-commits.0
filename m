From: akpm@linux-foundation.org
Subject: + epoll-clear-the-tfile_check_list-on-eloop.patch added to -mm tree
Date: Tue, 17 Apr 2012 14:13:23 -0700
Message-ID: <20120417211323.BBB26A03CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:61140 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2DQVNZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Apr 2012 17:13:25 -0400
Received: by ghbz15 with SMTP id z15so776683ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Apr 2012 14:13:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbaron@redhat.com, Alexandra.Kossovsky@oktetlabs.ru, Yurij.Plotnikov@oktetlabs.ru, davidel@xmailserver.org, nelhage@nelhage.com


The patch titled
     Subject: epoll: clear the tfile_check_list on -ELOOP
has been added to the -mm tree.  Its filename is
     epoll-clear-the-tfile_check_list-on-eloop.patch

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
Subject: epoll: clear the tfile_check_list on -ELOOP

An epoll_ctl(,EPOLL_CTL_ADD,,) operation can return '-ELOOP' to prevent
circular epoll dependencies from being created.  However, in that case we
do not properly clear the 'tfile_check_list'.  Thus, add a call to
clear_tfile_check_list() for the -ELOOP case.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Reported-by: Yurij M. Plotnikov <Yurij.Plotnikov@oktetlabs.ru>
Cc: Nelson Elhage <nelhage@nelhage.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Tested-by: Alexandra N. Kossovsky <Alexandra.Kossovsky@oktetlabs.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/eventpoll.c~epoll-clear-the-tfile_check_list-on-eloop fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-clear-the-tfile_check_list-on-eloop
+++ a/fs/eventpoll.c
@@ -1663,8 +1663,10 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 	if (op == EPOLL_CTL_ADD) {
 		if (is_file_epoll(tfile)) {
 			error = -ELOOP;
-			if (ep_loop_check(ep, tfile) != 0)
+			if (ep_loop_check(ep, tfile) != 0) {
+				clear_tfile_check_list();
 				goto error_tgt_fput;
+			}
 		} else
 			list_add(&tfile->f_tfile_llink, &tfile_check_list);
 	}
_
Subject: Subject: epoll: clear the tfile_check_list on -ELOOP

Patches currently in -mm which might be from jbaron@redhat.com are

epoll-clear-the-tfile_check_list-on-eloop.patch

