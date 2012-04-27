From: akpm@linux-foundation.org
Subject: [merged] epoll-clear-the-tfile_check_list-on-eloop.patch removed from -mm tree
Date: Fri, 27 Apr 2012 12:35:09 -0700
Message-ID: <20120427193509.6A955A02CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:42687 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760569Ab2D0TfL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Apr 2012 15:35:11 -0400
Received: by eekc41 with SMTP id c41so54713eek.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Apr 2012 12:35:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@redhat.com, Alexandra.Kossovsky@oktetlabs.ru, Yurij.Plotnikov@oktetlabs.ru, davidel@xmailserver.org, nelhage@nelhage.com, mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: clear the tfile_check_list on -ELOOP
has been removed from the -mm tree.  Its filename was
     epoll-clear-the-tfile_check_list-on-eloop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from jbaron@redhat.com are

origin.patch

