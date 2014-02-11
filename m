From: akpm@linux-foundation.org
Subject: + include-linux-syscallsh-add-sys32_quotactl-prototype.patch
 added to -mm tree
Date: Tue, 11 Feb 2014 14:44:40 -0800
Message-ID: <52faa7d8.xv2RPhHc5C9UjWNl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaBKWol (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 17:44:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rashika.kheria@gmail.com

Subject: + include-linux-syscallsh-add-sys32_quotactl-prototype.patch added to -mm tree
To: rashika.kheria@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 14:44:40 -0800


The patch titled
     Subject: include/linux/syscalls.h: add sys32_quotactl() prototype
has been added to the -mm tree.  Its filename is
     include-linux-syscallsh-add-sys32_quotactl-prototype.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-syscallsh-add-sys32_quotactl-prototype.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-syscallsh-add-sys32_quotactl-prototype.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: include/linux/syscalls.h: add sys32_quotactl() prototype

This eliminates the following warning in quota/compat.c:
fs/quota/compat.c:43:17: warning: no previous prototype for `sys32_quotactl' [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/syscalls.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN include/linux/syscalls.h~include-linux-syscallsh-add-sys32_quotactl-prototype include/linux/syscalls.h
--- a/include/linux/syscalls.h~include-linux-syscallsh-add-sys32_quotactl-prototype
+++ a/include/linux/syscalls.h
@@ -198,6 +198,11 @@ extern struct trace_event_functions exit
 	}								\
 	static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__))
 
+#ifdef CONFIG_QUOTACTL_COMPAT
+asmlinkage long sys32_quotactl(unsigned int cmd, const char __user *special,
+			       qid_t id, void __user *addr);
+#endif
+
 asmlinkage long sys_time(time_t __user *tloc);
 asmlinkage long sys_stime(time_t __user *tptr);
 asmlinkage long sys_gettimeofday(struct timeval __user *tv,
_

Patches currently in -mm which might be from rashika.kheria@gmail.com are

mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch
include-linux-syscallsh-add-sys32_quotactl-prototype.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
fs-reiserfs-move-prototype-declaration-to-header-file.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
linux-next.patch

