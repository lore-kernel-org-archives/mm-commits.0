From: akpm@linux-foundation.org
Subject: + revert-futex-mark-get_robust_list-as-deprecated.patch added to -mm tree
Date: Fri, 15 Feb 2013 15:01:17 -0800
Message-ID: <20130215230117.EC1C731C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:49701 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab3BOXBU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Feb 2013 18:01:20 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so386714qen.3
        for <mm-commits@vger.kernel.org>; Fri, 15 Feb 2013 15:01:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, a.p.zijlstra@chello.nl, dhowells@redhat.com, dvhart@linux.intel.com, ebiederm@xmission.com, gorcunov@openvz.org, jkosina@suse.cz, keescook@chromium.org, rdunlap@xenotime.net, serge.hallyn@canonical.com, stable@vger.kernel.org, tglx@linutronix.de, xemul@parallels.com


The patch titled
     Subject: revert "futex: Mark get_robust_list as deprecated"
has been added to the -mm tree.  Its filename is
     revert-futex-mark-get_robust_list-as-deprecated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Richard Weinberger <richard@nod.at>
Subject: revert "futex: Mark get_robust_list as deprecated"

Revert ec0c4274e33c0373e.

get_robust_list() has at least two valid use cases:

1. checkpoint/restore in userspace
2. post mortem analysis

Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: David Howells <dhowells@redhat.com>
Cc: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: <stable@vger.kernel.org> [3.4.x+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c        |    2 --
 kernel/futex_compat.c |    2 --
 2 files changed, 4 deletions(-)

diff -puN /dev/null /dev/null
diff -puN kernel/futex.c~revert-futex-mark-get_robust_list-as-deprecated kernel/futex.c
--- a/kernel/futex.c~revert-futex-mark-get_robust_list-as-deprecated
+++ a/kernel/futex.c
@@ -2472,8 +2472,6 @@ SYSCALL_DEFINE3(get_robust_list, int, pi
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
-	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
-
 	rcu_read_lock();
 
 	ret = -ESRCH;
diff -puN kernel/futex_compat.c~revert-futex-mark-get_robust_list-as-deprecated kernel/futex_compat.c
--- a/kernel/futex_compat.c~revert-futex-mark-get_robust_list-as-deprecated
+++ a/kernel/futex_compat.c
@@ -143,8 +143,6 @@ COMPAT_SYSCALL_DEFINE3(get_robust_list, 
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
-	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
