From: akpm@linux-foundation.org
Subject: [merged] signal-always-clear-sa_restorer-on-execve.patch removed from -mm tree
Date: Thu, 14 Mar 2013 11:52:10 -0700
Message-ID: <20130314185210.99B2031C174__1495.20979398421$1363287171$gmane$org@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:33894 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab3CNSwM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 14:52:12 -0400
Received: by mail-gh0-f201.google.com with SMTP id z19so258659ghb.0
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 11:52:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, ebiederm@xmission.com, jln@google.com, oleg@redhat.com, pageexec@freemail.hu, re.emese@gmail.com, serge.hallyn@canonical.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: signal: always clear sa_restorer on execve
has been removed from the -mm tree.  Its filename was
     signal-always-clear-sa_restorer-on-execve.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: use SA_RESTORER for backportability]
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Emese Revfy <re.emese@gmail.com>
Cc: Emese Revfy <re.emese@gmail.com>
Cc: PaX Team <pageexec@freemail.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Julien Tinnes <jln@google.com>
Cc: <stable@vger.kernel.org>
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
+#ifdef SA_RESTORER
+		ka->sa.sa_restorer = NULL;
+#endif
 		sigemptyset(&ka->sa.sa_mask);
 		ka++;
 	}
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
linux-next.patch
fs-dont-compile-in-drop_cachesc-when-config_sysctl=n.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch

