From: akpm@linux-foundation.org
Subject: + alpha-unbreak-osf_setsysinfossi_nvpairs.patch added to -mm tree
Date: Tue, 16 Aug 2011 15:37:42 -0700
Message-ID: <201108162237.p7GMbgli032736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816Ab1HPWiN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 18:38:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slyfox@gentoo.org, ink@jurassic.park.msu.ru, mattst88@gmail.com, mcree@orcon.net.nz, rth@twiddle.net


The patch titled
     alpha: unbreak osf_setsysinfo(SSI_NVPAIRS, [SSIN_UACPROC, UAC_SIGBUS])
has been added to the -mm tree.  Its filename is
     alpha-unbreak-osf_setsysinfossi_nvpairs.patch

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
Subject: alpha: unbreak osf_setsysinfo(SSI_NVPAIRS, [SSIN_UACPROC, UAC_SIGBUS])
From: Sergei Trofimovich <slyfox@gentoo.org>

The bug was accidentally found by the following program:

    #include <asm/sysinfo.h>
    #include <asm/unistd.h>
    #include <sys/syscall.h>
    static int setsysinfo(unsigned long op, void *buffer, unsigned long size,
                          int *start, void *arg, unsigned long flag) {
        return syscall(__NR_osf_setsysinfo, op, buffer, size, start, arg, flag);
    }

    int main(int argc, char **argv) {
        short x[10];
        unsigned int buf[2] = { SSIN_UACPROC, UAC_SIGBUS, };
        setsysinfo(SSI_NVPAIRS, buf, 1, 0, 0, 0);

        int  *y = (int*) (x+1);
        *y = 0;
        return 0;
    }

The program shoud fail on SIGBUS, but didn't.

The patch is a second part of userspace flag fix:
> commit 745dd2405e281d96c0a449103bdf6a895048f28c
> Author: Michael Cree <mcree@orcon.net.nz>
> Date:   Mon Nov 30 22:44:40 2009 -0500
>
>    Alpha: Rearrange thread info flags fixing two regressions
>
>    Both regressions fixed by (1) rearranging TIF_NOTIFY_RESUME flag to be
>    in lower 8 bits of the thread info flags, and (2) making sure that
>    ALPHA_UAC_SHIFT matches the rearrangement of the thread info flags.

Deleted outdated out-of-sync 'UAC_SHIFT' (the cause of bug) in favour of
'ALPHA_UAC_SHIFT'.

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Acked-by: Michael Cree <mcree@orcon.net.nz>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/sysinfo.h     |    9 ---------
 arch/alpha/include/asm/thread_info.h |    8 ++++----
 arch/alpha/kernel/osf_sys.c          |    7 ++++---
 3 files changed, 8 insertions(+), 16 deletions(-)

diff -puN arch/alpha/include/asm/sysinfo.h~alpha-unbreak-osf_setsysinfossi_nvpairs arch/alpha/include/asm/sysinfo.h
--- a/arch/alpha/include/asm/sysinfo.h~alpha-unbreak-osf_setsysinfossi_nvpairs
+++ a/arch/alpha/include/asm/sysinfo.h
@@ -27,13 +27,4 @@
 #define UAC_NOFIX			2
 #define UAC_SIGBUS			4
 
-
-#ifdef __KERNEL__
-
-/* This is the shift that is applied to the UAC bits as stored in the
-   per-thread flags.  See thread_info.h.  */
-#define UAC_SHIFT			6
-
-#endif
-
 #endif /* __ASM_ALPHA_SYSINFO_H */
diff -puN arch/alpha/include/asm/thread_info.h~alpha-unbreak-osf_setsysinfossi_nvpairs arch/alpha/include/asm/thread_info.h
--- a/arch/alpha/include/asm/thread_info.h~alpha-unbreak-osf_setsysinfossi_nvpairs
+++ a/arch/alpha/include/asm/thread_info.h
@@ -74,9 +74,9 @@ register struct thread_info *__current_t
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_POLLING_NRFLAG	8	/* poll_idle is polling NEED_RESCHED */
 #define TIF_DIE_IF_KERNEL	9	/* dik recursion lock */
-#define TIF_UAC_NOPRINT		10	/* see sysinfo.h */
-#define TIF_UAC_NOFIX		11
-#define TIF_UAC_SIGBUS		12
+#define TIF_UAC_NOPRINT		10	/* ! Preserve sequence of following */
+#define TIF_UAC_NOFIX		11	/* ! flags as they match            */
+#define TIF_UAC_SIGBUS		12	/* ! userspace part of 'osf_sysinfo' */
 #define TIF_MEMDIE		13	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	14	/* restore signal mask in do_signal */
 #define TIF_FREEZE		16	/* is freezing for suspend */
@@ -97,7 +97,7 @@ register struct thread_info *__current_t
 #define _TIF_ALLWORK_MASK	(_TIF_WORK_MASK		\
 				 | _TIF_SYSCALL_TRACE)
 
-#define ALPHA_UAC_SHIFT		10
+#define ALPHA_UAC_SHIFT		TIF_UAC_NOPRINT
 #define ALPHA_UAC_MASK		(1 << TIF_UAC_NOPRINT | 1 << TIF_UAC_NOFIX | \
 				 1 << TIF_UAC_SIGBUS)
 
diff -puN arch/alpha/kernel/osf_sys.c~alpha-unbreak-osf_setsysinfossi_nvpairs arch/alpha/kernel/osf_sys.c
--- a/arch/alpha/kernel/osf_sys.c~alpha-unbreak-osf_setsysinfossi_nvpairs
+++ a/arch/alpha/kernel/osf_sys.c
@@ -42,6 +42,7 @@
 #include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/sysinfo.h>
+#include <asm/thread_info.h>
 #include <asm/hwrpb.h>
 #include <asm/processor.h>
 
@@ -633,7 +634,7 @@ SYSCALL_DEFINE5(osf_getsysinfo, unsigned
  	case GSI_UACPROC:
 		if (nbytes < sizeof(unsigned int))
 			return -EINVAL;
- 		w = (current_thread_info()->flags >> UAC_SHIFT) & UAC_BITMASK;
+ 		w = (current_thread_info()->flags >> ALPHA_UAC_SHIFT) & UAC_BITMASK;
  		if (put_user(w, (unsigned int __user *)buffer))
  			return -EFAULT;
  		return 1;
@@ -756,8 +757,8 @@ SYSCALL_DEFINE5(osf_setsysinfo, unsigned
  			case SSIN_UACPROC:
 			again:
 				old = current_thread_info()->flags;
-				new = old & ~(UAC_BITMASK << UAC_SHIFT);
-				new = new | (w & UAC_BITMASK) << UAC_SHIFT;
+				new = old & ~(UAC_BITMASK << ALPHA_UAC_SHIFT);
+				new = new | (w & UAC_BITMASK) << ALPHA_UAC_SHIFT;
 				if (cmpxchg(&current_thread_info()->flags,
 					    old, new) != old)
 					goto again;
_

Patches currently in -mm which might be from slyfox@gentoo.org are

drivers-misc-ptic-add-missing-includes.patch
alpha-unbreak-osf_setsysinfossi_nvpairs.patch

