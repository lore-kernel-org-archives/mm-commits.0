From: akpm@linux-foundation.org
Subject: +
 pidns-disable-pid-allocation-if-pid_ns_prepare_proc-is-failed-in-alloc_pid.patch added to -mm tree
Date: Wed, 12 Apr 2017 12:49:32 -0700
Message-ID: <58ee84cc.otRxrD3q5AnjXbFv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52252 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754445AbdDLTtd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2017 15:49:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ktkhai@virtuozzo.com, agruenba@redhat.com, avagin@virtuozzo.com, ebiederm@xmission.com, gorcunov@openvz.org, keescook@chromium.org, luto@amacapital.net, mingo@kernel.org, mtk.manpages@googlemail.com, oleg@redhat.com, paul@paul-moore.com, serge@hallyn.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: pidns: disable pid allocation if pid_ns_prepare_proc() is failed in alloc_pid()
has been added to the -mm tree.  Its filename is
     pidns-disable-pid-allocation-if-pid_ns_prepare_proc-is-failed-in-alloc_pid.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pidns-disable-pid-allocation-if-pid_ns_prepare_proc-is-failed-in-alloc_pid.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pidns-disable-pid-allocation-if-pid_ns_prepare_proc-is-failed-in-alloc_pid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: pidns: disable pid allocation if pid_ns_prepare_proc() is failed in alloc_pid()

alloc_pidmap() advances pid_namespace::last_pid.  When first pid
allocation fails, then next created process will have pid 2 and
pid_ns_prepare_proc() won't be called.  So, pid_namespace::proc_mnt will
never be initialized (not to mention that there won't be a child reaper).

I saw crash stack of such case on kernel 3.10:

    BUG: unable to handle kernel NULL pointer dereference at (null)
    IP: [<ffffffff8126b18f>] proc_flush_task+0x8f/0x1b0
    Call Trace:
        [<ffffffff810807ff>] release_task+0x3f/0x490
        [<ffffffff810c0570>] ? thread_group_cputime_adjusted+0x50/0x70
        [<ffffffff8108144f>] wait_consider_task.part.10+0x7ff/0xb00
        [<ffffffff8108186f>] do_wait+0x11f/0x280
        [<ffffffff81082b2d>] SyS_wait4+0x7d/0x110

We may fix this by restore of last_pid in 0 or by prohibiting of futher
allocations.  Since there was a similar issue in Oleg Nesterov's
314a8ad0f18a ("pidns: fix free_pid() to handle the first fork failure"). 
and it was fixed via prohibiting allocation, let's follow this way, and do
the same.

Link: http://lkml.kernel.org/r/149201021004.4863.6762095011554287922.stgit@localhost.localdomain
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrei Vagin <avagin@virtuozzo.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Serge Hallyn <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/pid.c~pidns-disable-pid-allocation-if-pid_ns_prepare_proc-is-failed-in-alloc_pid kernel/pid.c
--- a/kernel/pid.c~pidns-disable-pid-allocation-if-pid_ns_prepare_proc-is-failed-in-alloc_pid
+++ a/kernel/pid.c
@@ -321,8 +321,10 @@ struct pid *alloc_pid(struct pid_namespa
 	}
 
 	if (unlikely(is_child_reaper(pid))) {
-		if (pid_ns_prepare_proc(ns))
+		if (pid_ns_prepare_proc(ns)) {
+			disable_pid_allocation(ns);
 			goto out_free;
+		}
 	}
 
 	get_pid_ns(ns);
_

Patches currently in -mm which might be from ktkhai@virtuozzo.com are

pidns-disable-pid-allocation-if-pid_ns_prepare_proc-is-failed-in-alloc_pid.patch
ns-allow-ns_entries-to-have-custom-symlink-content.patch
pidns-expose-task-pid_ns_for_children-to-userspace.patch

