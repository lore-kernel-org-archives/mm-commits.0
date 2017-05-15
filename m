From: akpm@linux-foundation.org
Subject: +
 kcmp-fs-epoll-wrap-kcmp-code-with-config_checkpoint_restore.patch added to
 -mm tree
Date: Mon, 15 May 2017 13:03:56 -0700
Message-ID: <591a09ac.QWE5Aa/L1HmAQ6xK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38838 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932677AbdEOUD5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2017 16:03:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, akpm@linuxfoundation.org, avagin@openvz.org, gorcunov@openvz.org, jbaron@akamai.com, luto@amacapital.net, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kcmp: fs/epoll: wrap kcmp code with CONFIG_CHECKPOINT_RESTORE
has been added to the -mm tree.  Its filename is
     kcmp-fs-epoll-wrap-kcmp-code-with-config_checkpoint_restore.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kcmp-fs-epoll-wrap-kcmp-code-with-config_checkpoint_restore.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kcmp-fs-epoll-wrap-kcmp-code-with-config_checkpoint_restore.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: kcmp: fs/epoll: wrap kcmp code with CONFIG_CHECKPOINT_RESTORE

kcmp syscall is build iif CONFIG_CHECKPOINT_RESTORE is selected, so wrap
appropriate helpers in epoll code with the config to build it
conditionally.

Link: http://lkml.kernel.org/r/20170513083456.GG1881@uranus.lan
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reported-by: Andrew Morton <akpm@linuxfoundation.org>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c            |    2 ++
 include/linux/eventpoll.h |    2 ++
 2 files changed, 4 insertions(+)

diff -puN fs/eventpoll.c~kcmp-fs-epoll-wrap-kcmp-code-with-config_checkpoint_restore fs/eventpoll.c
--- a/fs/eventpoll.c~kcmp-fs-epoll-wrap-kcmp-code-with-config_checkpoint_restore
+++ a/fs/eventpoll.c
@@ -1077,6 +1077,7 @@ static struct epitem *ep_find(struct eve
 	return epir;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
 static struct epitem *ep_find_tfd(struct eventpoll *ep, int tfd, unsigned long toff)
 {
 	struct rb_node *rbp;
@@ -1118,6 +1119,7 @@ struct file *get_epoll_tfile_raw_ptr(str
 
 	return file_raw;
 }
+#endif /* CONFIG_CHECKPOINT_RESTORE */
 
 /*
  * This is the callback that is passed to the wait queue wakeup
diff -puN include/linux/eventpoll.h~kcmp-fs-epoll-wrap-kcmp-code-with-config_checkpoint_restore include/linux/eventpoll.h
--- a/include/linux/eventpoll.h~kcmp-fs-epoll-wrap-kcmp-code-with-config_checkpoint_restore
+++ a/include/linux/eventpoll.h
@@ -23,7 +23,9 @@ struct file;
 
 #ifdef CONFIG_EPOLL
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
 struct file *get_epoll_tfile_raw_ptr(struct file *file, int tfd, unsigned long toff);
+#endif
 
 /* Used to initialize the epoll bits inside the "struct file" */
 static inline void eventpoll_init_file(struct file *file)
_

Patches currently in -mm which might be from gorcunov@gmail.com are

procfs-fdinfo-extend-information-about-epoll-target-files.patch
kcmp-add-kcmp_epoll_tfd-mode-to-compare-epoll-target-files.patch
kcmp-fs-epoll-wrap-kcmp-code-with-config_checkpoint_restore.patch

