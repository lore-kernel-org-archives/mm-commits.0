From: akpm@linux-foundation.org
Subject: + asm-posix_typesh-scrub-__glibc__.patch added to -mm tree
Date: Thu, 10 Jan 2008 00:05:21 -0800
Message-ID: <200801100805.m0A851jS012049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60944 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752432AbYAJIGb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 03:06:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, drepper@redhat.com, linux-arch@vger.kernel.org, mingo@elte.hu, roland@redhat.com


The patch titled
     asm-*/posix_types.h: scrub __GLIBC__
has been added to the -mm tree.  Its filename is
     asm-posix_typesh-scrub-__glibc__.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-*/posix_types.h: scrub __GLIBC__
From: Mike Frysinger <vapier@gentoo.org>

Some arches (like alpha and ia64) already have a clean posix_types.h header.
This brings all the others in line by removing all references to __GLIBC__
(and some undocumented __USE_ALL).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm/posix_types.h      |    6 +-----
 include/asm-avr32/posix_types.h    |    4 ----
 include/asm-blackfin/posix_types.h |    8 ++------
 include/asm-cris/posix_types.h     |    4 ----
 include/asm-frv/posix_types.h      |    8 ++------
 include/asm-h8300/posix_types.h    |    8 ++------
 include/asm-m32r/posix_types.h     |    8 ++------
 include/asm-m68k/posix_types.h     |    8 ++------
 include/asm-mips/posix_types.h     |    4 ++--
 include/asm-parisc/posix_types.h   |    8 ++------
 include/asm-powerpc/posix_types.h  |    5 ++---
 include/asm-sh/posix_types.h       |    8 ++------
 include/asm-sparc/posix_types.h    |    8 ++------
 include/asm-sparc64/posix_types.h  |    8 ++------
 include/asm-v850/posix_types.h     |    8 ++------
 include/asm-x86/posix_types_32.h   |    8 ++------
 include/asm-xtensa/posix_types.h   |    5 ++---
 17 files changed, 29 insertions(+), 87 deletions(-)

diff -puN include/asm-arm/posix_types.h~asm-posix_typesh-scrub-__glibc__ include/asm-arm/posix_types.h
--- a/include/asm-arm/posix_types.h~asm-posix_typesh-scrub-__glibc__
+++ a/include/asm-arm/posix_types.h
@@ -51,14 +51,10 @@ typedef long long		__kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef	__FD_SET
 #define __FD_SET(fd, fdsetp) \
diff -puN include/asm-avr32/posix_types.h~asm-posix_typesh-scrub-__glibc__ include/asm-avr32/posix_types.h
--- a/include/asm-avr32/posix_types.h~asm-posix_typesh-scrub-__glibc__
+++ a/include/asm-avr32/posix_types.h
@@ -46,11 +46,7 @@ typedef long long       __kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
     int     val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-    int     __val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
 #if defined(__KERNEL__)
diff -puN include/asm-blackfin/posix_types.h~asm-posix_typesh-scrub-__glibc__ include/asm-blackfin/posix_types.h
--- a/include/asm-blackfin/posix_types.h~asm-posix_typesh-scrub-__glibc__
+++ a/include/asm-blackfin/posix_types.h
@@ -39,14 +39,10 @@ typedef long long __kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int val[2];
-#else				/* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int __val[2];
-#endif				/* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef	__FD_SET
 #define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
@@ -60,6 +56,6 @@ typedef struct {
 #undef	__FD_ZERO
 #define __FD_ZERO(fdsetp) (memset (fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
 
-#endif				/* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif				/* defined(__KERNEL__) */
 
 #endif
diff -puN include/asm-cris/posix_types.h~asm-posix_typesh-scrub-__glibc__ include/asm-cris/posix_types.h
--- a/include/asm-cris/posix_types.h~asm-posix_typesh-scrub-__glibc__
+++ a/include/asm-cris/posix_types.h
@@ -44,11 +44,7 @@ typedef long long	__kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
 #ifdef __KERNEL__
diff -puN include/asm-frv/posix_types.h~asm-posix_typesh-scrub-__glibc__ include/asm-frv/posix_types.h
--- a/include/asm-frv/posix_types.h~asm-posix_typesh-scrub-__glibc__
+++ a/include/asm-frv/posix_types.h
@@ -39,14 +39,10 @@ typedef long long	__kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef	__FD_SET
 #define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
@@ -60,7 +56,7 @@ typedef struct {
 #undef	__FD_ZERO
 #define __FD_ZERO(fdsetp) (memset (fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif
 
diff -puN include/asm-h8300/posix_types.h~asm-posix_typesh-scrub-__glibc__ include/asm-h8300/posix_types.h
--- a/include/asm-h8300/posix_types.h~asm-posix_typesh-scrub-__glibc__
+++ a/include/asm-h8300/posix_types.h
@@ -38,14 +38,10 @@ typedef long long	__kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef	__FD_SET
 #define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
@@ -59,6 +55,6 @@ typedef struct {
 #undef	__FD_ZERO
 #define __FD_ZERO(fdsetp) (memset (fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif
diff -puN include/asm-m32r/posix_types.h~asm-posix_typesh-scrub-__glibc__ include/asm-m32r/posix_types.h
--- a/include/asm-m32r/posix_types.h~asm-posix_typesh-scrub-__glibc__
+++ a/include/asm-m32r/posix_types.h
@@ -39,14 +39,10 @@ typedef long long	__kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef	__FD_SET
 static __inline__ void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
@@ -117,6 +113,6 @@ static __inline__ void __FD_ZERO(__kerne
 	}
 }
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif  /* _ASM_M32R_POSIX_TYPES_H */
diff -puN include/asm-m68k/posix_types.h~asm-posix_typesh-scrub-__glibc__ include/asm-m68k/posix_types.h
--- a/include/asm-m68k/posix_types.h~asm-posix_typesh-scrub-__glibc__
+++ a/include/asm-m68k/posix_types.h
@@ -39,14 +39,10 @@ typedef long long	__kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef	__FD_SET
 #define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
@@ -60,6 +56,6 @@ typedef struct {
 #undef	__FD_ZERO
 #define __FD_ZERO(fdsetp) (memset (fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif
diff -puN include/asm-mips/posix_types.h~asm-posix_typesh-scrub-__glibc__ include/asm-mips/posix_types.h
--- a/include/asm-mips/posix_types.h~asm-posix_typesh-scrub-__glibc__
+++ a/include/asm-mips/posix_types.h
@@ -69,7 +69,7 @@ typedef struct {
 #endif
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef __FD_SET
 static __inline__ void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
@@ -139,6 +139,6 @@ static __inline__ void __FD_ZERO(__kerne
 	}
 }
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif /* _ASM_POSIX_TYPES_H */
diff -puN include/asm-parisc/posix_types.h~asm-posix_typesh-scrub-__glibc__ include/asm-parisc/posix_types.h
--- a/include/asm-parisc/posix_types.h~asm-posix_typesh-scrub-__glibc__
+++ a/include/asm-parisc/posix_types.h
@@ -47,18 +47,14 @@ typedef unsigned long long	__kernel_ino6
 typedef unsigned int		__kernel_old_dev_t;
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
 /* compatibility stuff */
 typedef __kernel_uid_t __kernel_old_uid_t;
 typedef __kernel_gid_t __kernel_old_gid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef __FD_SET
 static __inline__ void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
@@ -128,6 +124,6 @@ static __inline__ void __FD_ZERO(__kerne
 	}
 }
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif
diff -puN include/asm-powerpc/posix_types.h~asm-posix_typesh-scrub-__glibc__ include/asm-powerpc/posix_types.h
--- a/include/asm-powerpc/posix_types.h~asm-posix_typesh-scrub-__glibc__
+++ a/include/asm-powerpc/posix_types.h
@@ -64,8 +64,7 @@ typedef struct {
 
 #else /* __GNUC__ */
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) \
-    || (__GLIBC__ == 2 && __GLIBC_MINOR__ == 0)
+#if defined(__KERNEL__)
 /* With GNU C, use inline functions instead so args are evaluated only once: */
 
 #undef __FD_SET
@@ -124,6 +123,6 @@ static __inline__ void __FD_ZERO(__kerne
 	}
 }
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 #endif /* __GNUC__ */
 #endif /* _ASM_POWERPC_POSIX_TYPES_H */
diff -puN include/asm-sh/posix_types.h~asm-posix_typesh-scrub-__glibc__ include/asm-sh/posix_types.h
--- a/include/asm-sh/posix_types.h~asm-posix_typesh-scrub-__glibc__
+++ a/include/asm-sh/posix_types.h
@@ -39,14 +39,10 @@ typedef long long	__kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef	__FD_SET
 static __inline__ void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
@@ -117,6 +113,6 @@ static __inline__ void __FD_ZERO(__kerne
 	}
 }
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif /* __ASM_SH_POSIX_TYPES_H */
diff -puN include/asm-sparc/posix_types.h~asm-posix_typesh-scrub-__glibc__ include/asm-sparc/posix_types.h
--- a/include/asm-sparc/posix_types.h~asm-posix_typesh-scrub-__glibc__
+++ a/include/asm-sparc/posix_types.h
@@ -39,14 +39,10 @@ typedef long long	__kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int     __val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef __FD_SET
 static inline void __FD_SET(unsigned long fd, __kernel_fd_set *fdsetp)
@@ -117,6 +113,6 @@ static inline void __FD_ZERO(__kernel_fd
 	}
 }
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif /* !(__ARCH_SPARC_POSIX_TYPES_H) */
diff -puN include/asm-sparc64/posix_types.h~asm-posix_typesh-scrub-__glibc__ include/asm-sparc64/posix_types.h
--- a/include/asm-sparc64/posix_types.h~asm-posix_typesh-scrub-__glibc__
+++ a/include/asm-sparc64/posix_types.h
@@ -43,14 +43,10 @@ typedef long long              __kernel_
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int     __val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef __FD_SET
 static inline void __FD_SET(unsigned long fd, __kernel_fd_set *fdsetp)
@@ -121,6 +117,6 @@ static inline void __FD_ZERO(__kernel_fd
 	}
 }
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif /* !(__ARCH_SPARC64_POSIX_TYPES_H) */
diff -puN include/asm-v850/posix_types.h~asm-posix_typesh-scrub-__glibc__ include/asm-v850/posix_types.h
--- a/include/asm-v850/posix_types.h~asm-posix_typesh-scrub-__glibc__
+++ a/include/asm-v850/posix_types.h
@@ -44,15 +44,11 @@ typedef __kernel_uid_t __kernel_old_uid_
 typedef unsigned int	__kernel_old_dev_t;
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 /* We used to include <asm/bitops.h> here, which seems the right thing, but
    it caused nasty include-file definition order problems.  Removing the
@@ -71,6 +67,6 @@ typedef struct {
 #define __FD_ZERO(fd_set) \
   memset (fd_set, 0, sizeof (*(fd_set *)fd_set))
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif /* __V850_POSIX_TYPES_H__ */
diff -puN include/asm-x86/posix_types_32.h~asm-posix_typesh-scrub-__glibc__ include/asm-x86/posix_types_32.h
--- a/include/asm-x86/posix_types_32.h~asm-posix_typesh-scrub-__glibc__
+++ a/include/asm-x86/posix_types_32.h
@@ -39,14 +39,10 @@ typedef long long	__kernel_loff_t;
 #endif
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
 	int	val[2];
-#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
-	int	__val[2];
-#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
 } __kernel_fsid_t;
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__)
 
 #undef	__FD_SET
 #define __FD_SET(fd,fdsetp) \
@@ -77,6 +73,6 @@ do { \
 			"2" ((__kernel_fd_set *) (fdsetp)) : "memory"); \
 } while (0)
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 
 #endif
diff -puN include/asm-xtensa/posix_types.h~asm-posix_typesh-scrub-__glibc__ include/asm-xtensa/posix_types.h
--- a/include/asm-xtensa/posix_types.h~asm-posix_typesh-scrub-__glibc__
+++ a/include/asm-xtensa/posix_types.h
@@ -64,8 +64,7 @@ typedef struct {
 
 #else /* __GNUC__ */
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) \
-    || (__GLIBC__ == 2 && __GLIBC_MINOR__ == 0)
+#if defined(__KERNEL__)
 /* With GNU C, use inline functions instead so args are evaluated only once: */
 
 #undef __FD_SET
@@ -118,6 +117,6 @@ static __inline__ void __FD_ZERO(__kerne
 	}
 }
 
-#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+#endif /* defined(__KERNEL__) */
 #endif /* __GNUC__ */
 #endif /* _XTENSA_POSIX_TYPES_H */
_

Patches currently in -mm which might be from vapier@gentoo.org are

git-kbuild.patch
git-x86.patch
asm-posix_typesh-scrub-__glibc__.patch
