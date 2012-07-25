From: akpm@linux-foundation.org
Subject: + posix_typesh-cleanup-stale-__nfdbits-and-related-definitions.patch added to -mm tree
Date: Wed, 25 Jul 2012 13:02:16 -0700
Message-ID: <20120725200216.C840C100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:56525 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab2GYUCR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jul 2012 16:02:17 -0400
Received: by yenl3 with SMTP id l3so130236yen.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jul 2012 13:02:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jwboyer@redhat.com, law@redhat.com, stable@vger.kernel.org, torvalds@linux-foundation.org


The patch titled
     Subject: posix_types.h: cleanup stale __NFDBITS and related definitions
has been added to the -mm tree.  Its filename is
     posix_typesh-cleanup-stale-__nfdbits-and-related-definitions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Boyer <jwboyer@redhat.com>
Subject: posix_types.h: cleanup stale __NFDBITS and related definitions

Recently, glibc made a change to suppress sign-conversion warnings in
FD_SET (glibc commit ceb9e56b3d1).  This uncovered an issue with the
kernel's definition of __NFDBITS if applications #include <linux/types.h>
after including <sys/select.h>.  A build failure would be seen when
passing the -Werror=sign-compare and -D_FORTIFY_SOURCE=2 flags to gcc.

It was suggested that the kernel should either match the glibc definition
of __NFDBITS or remove that entirely.  The current in-kernel uses of
__NFDBITS can be replaced with BITS_PER_LONG, and there are no uses of the
related __FDELT and __FDMASK defines.  Given that, we'll continue the
cleanup that was started with commit 8b3d1cda4f5f ("posix_types: Remove
fd_set macros") and drop the remaining unused macros.

Additionally, linux/time.h has similar macros defined that expand to
nothing so we'll remove those at the same time.

Reported-by: Jeff Law <law@redhat.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/kspd.c     |    2 +-
 fs/exec.c                   |    2 +-
 fs/select.c                 |   10 +++++-----
 include/linux/posix_types.h |   18 +++---------------
 include/linux/time.h        |    8 --------
 kernel/exit.c               |    2 +-
 security/selinux/hooks.c    |    2 +-
 7 files changed, 12 insertions(+), 32 deletions(-)

diff -puN arch/mips/kernel/kspd.c~posix_typesh-cleanup-stale-__nfdbits-and-related-definitions arch/mips/kernel/kspd.c
--- a/arch/mips/kernel/kspd.c~posix_typesh-cleanup-stale-__nfdbits-and-related-definitions
+++ a/arch/mips/kernel/kspd.c
@@ -323,7 +323,7 @@ static void sp_cleanup(void)
 	fdt = files_fdtable(files);
 	for (;;) {
 		unsigned long set;
-		i = j * __NFDBITS;
+		i = j * BITS_PER_LONG;
 		if (i >= fdt->max_fds)
 			break;
 		set = fdt->open_fds[j++];
diff -puN fs/exec.c~posix_typesh-cleanup-stale-__nfdbits-and-related-definitions fs/exec.c
--- a/fs/exec.c~posix_typesh-cleanup-stale-__nfdbits-and-related-definitions
+++ a/fs/exec.c
@@ -1020,7 +1020,7 @@ static void flush_old_files(struct files
 		unsigned long set, i;
 
 		j++;
-		i = j * __NFDBITS;
+		i = j * BITS_PER_LONG;
 		fdt = files_fdtable(files);
 		if (i >= fdt->max_fds)
 			break;
diff -puN fs/select.c~posix_typesh-cleanup-stale-__nfdbits-and-related-definitions fs/select.c
--- a/fs/select.c~posix_typesh-cleanup-stale-__nfdbits-and-related-definitions
+++ a/fs/select.c
@@ -345,8 +345,8 @@ static int max_select_fd(unsigned long n
 	struct fdtable *fdt;
 
 	/* handle last in-complete long-word first */
-	set = ~(~0UL << (n & (__NFDBITS-1)));
-	n /= __NFDBITS;
+	set = ~(~0UL << (n & (BITS_PER_LONG-1)));
+	n /= BITS_PER_LONG;
 	fdt = files_fdtable(current->files);
 	open_fds = fdt->open_fds + n;
 	max = 0;
@@ -373,7 +373,7 @@ get_max:
 			max++;
 			set >>= 1;
 		} while (set);
-		max += n * __NFDBITS;
+		max += n * BITS_PER_LONG;
 	}
 
 	return max;
@@ -435,11 +435,11 @@ int do_select(int n, fd_set_bits *fds, s
 			in = *inp++; out = *outp++; ex = *exp++;
 			all_bits = in | out | ex;
 			if (all_bits == 0) {
-				i += __NFDBITS;
+				i += BITS_PER_LONG;
 				continue;
 			}
 
-			for (j = 0; j < __NFDBITS; ++j, ++i, bit <<= 1) {
+			for (j = 0; j < BITS_PER_LONG; ++j, ++i, bit <<= 1) {
 				int fput_needed;
 				if (i >= n)
 					break;
diff -puN include/linux/posix_types.h~posix_typesh-cleanup-stale-__nfdbits-and-related-definitions include/linux/posix_types.h
--- a/include/linux/posix_types.h~posix_typesh-cleanup-stale-__nfdbits-and-related-definitions
+++ a/include/linux/posix_types.h
@@ -15,26 +15,14 @@
  */
 
 /*
- * Those macros may have been defined in <gnu/types.h>. But we always
- * use the ones here. 
+ * This macro may have been defined in <gnu/types.h>. But we always
+ * use the one here. 
  */
-#undef __NFDBITS
-#define __NFDBITS	(8 * sizeof(unsigned long))
-
 #undef __FD_SETSIZE
 #define __FD_SETSIZE	1024
 
-#undef __FDSET_LONGS
-#define __FDSET_LONGS	(__FD_SETSIZE/__NFDBITS)
-
-#undef __FDELT
-#define	__FDELT(d)	((d) / __NFDBITS)
-
-#undef __FDMASK
-#define	__FDMASK(d)	(1UL << ((d) % __NFDBITS))
-
 typedef struct {
-	unsigned long fds_bits [__FDSET_LONGS];
+	unsigned long fds_bits [__FD_SETSIZE / (8 * sizeof(long))];
 } __kernel_fd_set;
 
 /* Type of a signal handler.  */
diff -puN include/linux/time.h~posix_typesh-cleanup-stale-__nfdbits-and-related-definitions include/linux/time.h
--- a/include/linux/time.h~posix_typesh-cleanup-stale-__nfdbits-and-related-definitions
+++ a/include/linux/time.h
@@ -257,14 +257,6 @@ static __always_inline void timespec_add
 
 #endif /* __KERNEL__ */
 
-#define NFDBITS			__NFDBITS
-
-#define FD_SETSIZE		__FD_SETSIZE
-#define FD_SET(fd,fdsetp)	__FD_SET(fd,fdsetp)
-#define FD_CLR(fd,fdsetp)	__FD_CLR(fd,fdsetp)
-#define FD_ISSET(fd,fdsetp)	__FD_ISSET(fd,fdsetp)
-#define FD_ZERO(fdsetp)		__FD_ZERO(fdsetp)
-
 /*
  * Names of the interval timers, and structure
  * defining a timer setting:
diff -puN kernel/exit.c~posix_typesh-cleanup-stale-__nfdbits-and-related-definitions kernel/exit.c
--- a/kernel/exit.c~posix_typesh-cleanup-stale-__nfdbits-and-related-definitions
+++ a/kernel/exit.c
@@ -483,7 +483,7 @@ static void close_files(struct files_str
 	rcu_read_unlock();
 	for (;;) {
 		unsigned long set;
-		i = j * __NFDBITS;
+		i = j * BITS_PER_LONG;
 		if (i >= fdt->max_fds)
 			break;
 		set = fdt->open_fds[j++];
diff -puN security/selinux/hooks.c~posix_typesh-cleanup-stale-__nfdbits-and-related-definitions security/selinux/hooks.c
--- a/security/selinux/hooks.c~posix_typesh-cleanup-stale-__nfdbits-and-related-definitions
+++ a/security/selinux/hooks.c
@@ -2129,7 +2129,7 @@ static inline void flush_unauthorized_fi
 		int fd;
 
 		j++;
-		i = j * __NFDBITS;
+		i = j * BITS_PER_LONG;
 		fdt = files_fdtable(files);
 		if (i >= fdt->max_fds)
 			break;
_
Subject: Subject: posix_types.h: cleanup stale __NFDBITS and related definitions

Patches currently in -mm which might be from jwboyer@redhat.com are

origin.patch
linux-next.patch
posix_typesh-cleanup-stale-__nfdbits-and-related-definitions.patch

