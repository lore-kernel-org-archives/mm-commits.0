From: akpm@linux-foundation.org
Subject: [merged]
 include-linux-syscallsh-add-sys32_quotactl-prototype.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:32:18 -0700
Message-ID: <533f08c2.Xs9uEP+V0jhOyjmW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43147 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbaDDTcS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:32:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, josh@joshtriplett.org, rashika.kheria@gmail.com

Subject: [merged] include-linux-syscallsh-add-sys32_quotactl-prototype.patch removed from -mm tree
To: rashika.kheria@gmail.com,josh@joshtriplett.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:32:18 -0700


The patch titled
     Subject: include/linux/syscalls.h: add sys32_quotactl() prototype
has been removed from the -mm tree.  Its filename was
     include-linux-syscallsh-add-sys32_quotactl-prototype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: include/linux/syscalls.h: add sys32_quotactl() prototype

This eliminates the following warning in quota/compat.c:
fs/quota/compat.c:43:17: warning: no previous prototype for `sys32_quotactl' [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/syscalls.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/syscalls.h~include-linux-syscallsh-add-sys32_quotactl-prototype include/linux/syscalls.h
--- a/include/linux/syscalls.h~include-linux-syscallsh-add-sys32_quotactl-prototype
+++ a/include/linux/syscalls.h
@@ -200,6 +200,8 @@ extern struct trace_event_functions exit
 	}								\
 	static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__))
 
+asmlinkage long sys32_quotactl(unsigned int cmd, const char __user *special,
+			       qid_t id, void __user *addr);
 asmlinkage long sys_time(time_t __user *tloc);
 asmlinkage long sys_stime(time_t __user *tptr);
 asmlinkage long sys_gettimeofday(struct timeval __user *tv,
_

Patches currently in -mm which might be from rashika.kheria@gmail.com are

origin.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
linux-next.patch

