From: akpm@linux-foundation.org
Subject: + allow-times-and-time-system-calls-to-return-small-negative-values.patch added to -mm tree
Date: Sat, 06 Dec 2008 23:40:11 -0800
Message-ID: <200812070740.mB77eBiZ000993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752735AbYLGHlO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 7 Dec 2008 02:41:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulus@samba.org, Joakim.Tjernlund@transmode.se, davem@davemloft.net, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Allow times and time system calls to return small negative values
has been added to the -mm tree.  Its filename is
     allow-times-and-time-system-calls-to-return-small-negative-values.patch

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
Subject: Allow times and time system calls to return small negative values
From: Paul Mackerras <paulus@samba.org>

At the moment, the times() system call will appear to fail for a period
shortly after boot, while the value it want to return is between -4095 and
-1.  The same thing will also happen for the time() system call on 32-bit
platforms some time in 2106 or so.

On some platforms, such as x86, this is unavoidable because of the system
call ABI, but other platforms such as powerpc have a separate error
indication from the return value, so system calls can in fact return small
negative values without indicating an error.  On those platforms,
force_successful_syscall_return() provides a way to indicate that the
system call return value should not be treated as an error even if it is
in the range which would normally be taken as a negative error number.

This adds a force_successful_syscall_return() call to the time() and
times() system calls plus their 32-bit compat versions, so that they don't
erroneously indicate an error on those platforms whose system call ABI has
a separate error indication.  This will not affect anything on other
platforms.

Joakim Tjernlund added the fix for time() and the compat versions of
time() and times(), after I did the fix for times().

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/compat.c |    5 ++++-
 kernel/sys.c    |    2 ++
 kernel/time.c   |    4 +++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff -puN kernel/compat.c~allow-times-and-time-system-calls-to-return-small-negative-values kernel/compat.c
--- a/kernel/compat.c~allow-times-and-time-system-calls-to-return-small-negative-values
+++ a/kernel/compat.c
@@ -24,6 +24,7 @@
 #include <linux/migrate.h>
 #include <linux/posix-timers.h>
 #include <linux/times.h>
+#include <linux/ptrace.h>
 
 #include <asm/uaccess.h>
 
@@ -229,6 +230,7 @@ asmlinkage long compat_sys_times(struct 
 		if (copy_to_user(tbuf, &tmp, sizeof(tmp)))
 			return -EFAULT;
 	}
+	force_successful_syscall_return();
 	return compat_jiffies_to_clock_t(jiffies);
 }
 
@@ -883,8 +885,9 @@ asmlinkage long compat_sys_time(compat_t
 
 	if (tloc) {
 		if (put_user(i,tloc))
-			i = -EFAULT;
+			return -EFAULT;
 	}
+	force_successful_syscall_return();
 	return i;
 }
 
diff -puN kernel/sys.c~allow-times-and-time-system-calls-to-return-small-negative-values kernel/sys.c
--- a/kernel/sys.c~allow-times-and-time-system-calls-to-return-small-negative-values
+++ a/kernel/sys.c
@@ -33,6 +33,7 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/seccomp.h>
 #include <linux/cpu.h>
+#include <linux/ptrace.h>
 
 #include <linux/compat.h>
 #include <linux/syscalls.h>
@@ -927,6 +928,7 @@ asmlinkage long sys_times(struct tms __u
 		if (copy_to_user(tbuf, &tmp, sizeof(struct tms)))
 			return -EFAULT;
 	}
+	force_successful_syscall_return();
 	return (long) jiffies_64_to_clock_t(get_jiffies_64());
 }
 
diff -puN kernel/time.c~allow-times-and-time-system-calls-to-return-small-negative-values kernel/time.c
--- a/kernel/time.c~allow-times-and-time-system-calls-to-return-small-negative-values
+++ a/kernel/time.c
@@ -37,6 +37,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/math64.h>
+#include <linux/ptrace.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -65,8 +66,9 @@ asmlinkage long sys_time(time_t __user *
 
 	if (tloc) {
 		if (put_user(i,tloc))
-			i = -EFAULT;
+			return -EFAULT;
 	}
+	force_successful_syscall_return();
 	return i;
 }
 
_

Patches currently in -mm which might be from paulus@samba.org are

origin.patch
linux-next.patch
net-ppp_asynctty_ioctl-remove-dead-code.patch
allow-times-and-time-system-calls-to-return-small-negative-values.patch
kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe.patch
unaligned-wire-up-trivial-arches-for-new-common-unaligned-header.patch

