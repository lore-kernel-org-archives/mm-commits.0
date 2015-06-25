From: akpm@linux-foundation.org
Subject: [folded-merged]
 clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix-2.patch removed from -mm tree
Date: Thu, 25 Jun 2015 14:51:50 -0700
Message-ID: <558c77f6.kU5lUe+wRE/41S0P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbbFYVvv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Jun 2015 17:51:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@joshtriplett.org, fengguang.wu@gmail.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: Fix "clone: Support passing tls argument via C rather than pt_regs magic" for s390
has been removed from the -mm tree.  Its filename was
     clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix-2.patch

This patch was dropped because it was folded into clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic.patch

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: Fix "clone: Support passing tls argument via C rather than pt_regs magic" for s390

s390 has duplicate syscall prototypes; change the type of tls to match
the change to sys_clone.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Reported-by: Fengguang Wu <fengguang.wu@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/compat_wrapper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/s390/kernel/compat_wrapper.c~clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix-2 arch/s390/kernel/compat_wrapper.c
--- a/arch/s390/kernel/compat_wrapper.c~clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix-2
+++ a/arch/s390/kernel/compat_wrapper.c
@@ -202,7 +202,7 @@ COMPAT_SYSCALL_WRAP1(epoll_create1, int,
 COMPAT_SYSCALL_WRAP2(tkill, int, pid, int, sig);
 COMPAT_SYSCALL_WRAP3(tgkill, int, tgid, int, pid, int, sig);
 COMPAT_SYSCALL_WRAP5(perf_event_open, struct perf_event_attr __user *, attr_uptr, pid_t, pid, int, cpu, int, group_fd, unsigned long, flags);
-COMPAT_SYSCALL_WRAP5(clone, unsigned long, newsp, unsigned long, clone_flags, int __user *, parent_tidptr, int __user *, child_tidptr, int, tls_val);
+COMPAT_SYSCALL_WRAP5(clone, unsigned long, newsp, unsigned long, clone_flags, int __user *, parent_tidptr, int __user *, child_tidptr, unsigned long, tls);
 COMPAT_SYSCALL_WRAP2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags);
 COMPAT_SYSCALL_WRAP4(prlimit64, pid_t, pid, unsigned int, resource, const struct rlimit64 __user *, new_rlim, struct rlimit64 __user *, old_rlim);
 COMPAT_SYSCALL_WRAP5(name_to_handle_at, int, dfd, const char __user *, name, struct file_handle __user *, handle, int __user *, mnt_id, int, flag);
_

Patches currently in -mm which might be from josh@joshtriplett.org are

origin.patch
clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic.patch

