From: akpm@linux-foundation.org
Subject: + signal-always-clear-sa_restorer-on-execve.patch added to -mm tree
Date: Mon, 11 Mar 2013 13:22:55 -0700
Message-ID: <20130311202255.942745A4121@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:49089 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab3CKUW5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 16:22:57 -0400
Received: by mail-qa0-f73.google.com with SMTP id g10so226123qah.4
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 13:22:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: keescook@chromium.org, ebiederm@xmission.com, jln@google.com, oleg@redhat.com, pageexec@freemail.hu, re.emese@gmail.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: signal: always clear sa_restorer on execve
has been added to the -mm tree.  Its filename is
     signal-always-clear-sa_restorer-on-execve.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: signal: always clear sa_restorer on execve

When the new signal handlers are set up, the location of sa_restorer is
not cleared, leaking a parent process's address space location to
children.  This allows for a potential bypass of the parent's ASLR by
examining the sa_restorer value returned when calling sigaction().

Based on what should be considered "secret" about addresses, it only
matters across the exec not the fork (since the VMAs haven't changed until
the exec).  But since exec sets SIG_DFL and keeps sa_restorer, this is
where it should be fixed.

Given the few uses of sa_restorer, a "set" function was not written since
this would be the only use.  Instead, we use __ARCH_HAS_SA_RESTORER, as
already done in other places.

Example of the leak before applying this patch:

$ cat /proc/$$/maps
...
7fb9f3083000-7fb9f3238000 r-xp 00000000 fd:01 404469 .../libc-2.15.so
...
$ ./leak
...
7f278bc74000-7f278be29000 r-xp 00000000 fd:01 404469 .../libc-2.15.so
...
1 0 (nil) 0x7fb9f30b94a0
2 4000000 (nil) 0x7f278bcaa4a0
3 4000000 (nil) 0x7f278bcaa4a0
4 0 (nil) 0x7fb9f30b94a0
...

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Emese Revfy <re.emese@gmail.com>
Cc: Emese Revfy <re.emese@gmail.com>
Cc: PaX Team <pageexec@freemail.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Julien Tinnes <jln@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/signal.c~signal-always-clear-sa_restorer-on-execve kernel/signal.c
--- a/kernel/signal.c~signal-always-clear-sa_restorer-on-execve
+++ a/kernel/signal.c
@@ -485,6 +485,9 @@ flush_signal_handlers(struct task_struct
 		if (force_default || ka->sa.sa_handler != SIG_IGN)
 			ka->sa.sa_handler = SIG_DFL;
 		ka->sa.sa_flags = 0;
+#ifdef __ARCH_HAS_SA_RESTORER
+		ka->sa.sa_restorer = NULL;
+#endif
 		sigemptyset(&ka->sa.sa_mask);
 		ka++;
 	}
_

Patches currently in -mm which might be from keescook@chromium.org are

linux-next.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
signal-always-clear-sa_restorer-on-execve.patch

