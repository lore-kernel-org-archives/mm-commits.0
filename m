From: akpm@linux-foundation.org
Subject: [merged] revert-futex-mark-get_robust_list-as-deprecated.patch removed from -mm tree
Date: Tue, 19 Feb 2013 13:03:41 -0800
Message-ID: <20130219210341.E72BF5A4174__32773.1372708969$1361307849$gmane$org@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:41720 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933239Ab3BSVDn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Feb 2013 16:03:43 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so720633yen.4
        for <mm-commits@vger.kernel.org>; Tue, 19 Feb 2013 13:03:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, a.p.zijlstra@chello.nl, dhowells@redhat.com, dvhart@linux.intel.com, ebiederm@xmission.com, gorcunov@openvz.org, jkosina@suse.cz, keescook@chromium.org, rdunlap@xenotime.net, serge.hallyn@canonical.com, stable@vger.kernel.org, tglx@linutronix.de, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: revert "futex: Mark get_robust_list as deprecated"
has been removed from the -mm tree.  Its filename was
     revert-futex-mark-get_robust_list-as-deprecated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
