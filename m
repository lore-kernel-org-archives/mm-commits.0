From: akpm@linux-foundation.org
Subject: [patch 30/96] kcmp: fs/epoll: wrap kcmp code with
 CONFIG_CHECKPOINT_RESTORE
Date: Wed, 12 Jul 2017 14:34:31 -0700
Message-ID: <20170712213431.X82bozQeH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53444 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751862AbdGLVed (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:34:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, akpm@linuxfoundation.org, avagin@openvz.org, gorcunov@gmail.com, gorcunov@openvz.org, jbaron@akamai.com, luto@amacapital.net, mm-commits@vger.kernel.org, mtk.manpages@gmail.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, xemul@virtuozzo.com

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
