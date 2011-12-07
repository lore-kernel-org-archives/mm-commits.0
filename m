From: akpm@linux-foundation.org
Subject: + sys_getppid-add-missing-rcu_dereference.patch added to -mm tree
Date: Wed, 07 Dec 2011 14:26:10 -0800
Message-ID: <201112072226.pB7MQBQB026338@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:36403 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752Ab1LGW0N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Dec 2011 17:26:13 -0500
Received: by mail-gx0-f202.google.com with SMTP id p2so126940ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Dec 2011 14:26:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: msb@chromium.org, keescook@chromium.org, oleg@redhat.com, tglx@linutronix.de, xemul@openvz.org


The patch titled
     Subject: sys_getppid: add missing rcu_dereference
has been added to the -mm tree.  Its filename is
     sys_getppid-add-missing-rcu_dereference.patch

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
From: Mandeep Singh Baines <msb@chromium.org>
Subject: sys_getppid: add missing rcu_dereference

In order to safely dereference current->real_parent inside an
rcu_read_lock, we need an rcu_dereference.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/timer.c~sys_getppid-add-missing-rcu_dereference kernel/timer.c
--- a/kernel/timer.c~sys_getppid-add-missing-rcu_dereference
+++ a/kernel/timer.c
@@ -1418,7 +1418,7 @@ SYSCALL_DEFINE0(getppid)
 	int pid;
 
 	rcu_read_lock();
-	pid = task_tgid_vnr(current->real_parent);
+	pid = task_tgid_vnr(rcu_dereference(current->real_parent));
 	rcu_read_unlock();
 
 	return pid;
_
Subject: Subject: sys_getppid: add missing rcu_dereference

Patches currently in -mm which might be from msb@chromium.org are

linux-next.patch
sys_getppid-add-missing-rcu_dereference.patch

