From: akpm@linux-foundation.org
Subject: +
 clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix-2.patch added to -mm tree
Date: Thu, 14 May 2015 12:40:18 -0700
Message-ID: <5554fa22.8VhYyNkDHxyzB6pd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030208AbbENTkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 May 2015 15:40:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@joshtriplett.org, fengguang.wu@gmail.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: Fix "clone: Support passing tls argument via C rather than pt_regs magic" for s390
has been added to the -mm tree.  Its filename is
     clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

uidgid-make-uid_valid-and-gid_valid-work-with-config_multiuser.patch
clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic.patch
clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix.patch
clone-support-passing-tls-argument-via-c-rather-than-pt_regs-magic-fix-2.patch
x86-opt-into-have_copy_thread_tls-for-both-32-bit-and-64-bit.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
linux-next.patch

