From: akpm@linux-foundation.org
Subject: + errnoh-remove-nfs-from-descriptions-in-comments.patch added to
 -mm tree
Date: Thu, 31 Oct 2013 14:43:29 -0700
Message-ID: <5272cf01.wgNHhgZB/93fdz6F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab3JaVn3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Oct 2013 17:43:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sandeen@redhat.com

Subject: + errnoh-remove-nfs-from-descriptions-in-comments.patch added to -mm tree
To: sandeen@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 31 Oct 2013 14:43:29 -0700


The patch titled
     Subject: errno.h: remove "NFS" from descriptions in comments
has been added to the -mm tree.  Its filename is
     errnoh-remove-nfs-from-descriptions-in-comments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/errnoh-remove-nfs-from-descriptions-in-comments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/errnoh-remove-nfs-from-descriptions-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Sandeen <sandeen@redhat.com>
Subject: errno.h: remove "NFS" from descriptions in comments

glibc recently changed the error string for ESTALE to remove "NFS" -

https://sourceware.org/git/?p=glibc.git;a=commitdiff;h=96945714ec61951cc748da2b4b8a80cf02127ee9

from: [ERR_REMAP (ESTALE)] = N_("Stale NFS file handle"),
to:   [ERR_REMAP (ESTALE)] = N_("Stale file handle"),

And some have expressed concern that the kernel's errno.h
comments still refer to NFS.

So make that change... note that this is a comment-only change,
and has no functional difference.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/uapi/asm/errno.h                         |    2 +-
 arch/mips/include/uapi/asm/errno.h                          |    2 +-
 arch/parisc/include/uapi/asm/errno.h                        |    2 +-
 arch/sparc/include/uapi/asm/errno.h                         |    2 +-
 drivers/staging/lustre/lustre/include/lustre/lustre_errno.h |    2 +-
 include/uapi/asm-generic/errno.h                            |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/alpha/include/uapi/asm/errno.h~errnoh-remove-nfs-from-descriptions-in-comments arch/alpha/include/uapi/asm/errno.h
--- a/arch/alpha/include/uapi/asm/errno.h~errnoh-remove-nfs-from-descriptions-in-comments
+++ a/arch/alpha/include/uapi/asm/errno.h
@@ -43,7 +43,7 @@
 
 #define	EUSERS		68	/* Too many users */
 #define	EDQUOT		69	/* Quota exceeded */
-#define	ESTALE		70	/* Stale NFS file handle */
+#define	ESTALE		70	/* Stale file handle */
 #define	EREMOTE		71	/* Object is remote */
 
 #define	ENOLCK		77	/* No record locks available */
diff -puN arch/mips/include/uapi/asm/errno.h~errnoh-remove-nfs-from-descriptions-in-comments arch/mips/include/uapi/asm/errno.h
--- a/arch/mips/include/uapi/asm/errno.h~errnoh-remove-nfs-from-descriptions-in-comments
+++ a/arch/mips/include/uapi/asm/errno.h
@@ -102,7 +102,7 @@
 #define EWOULDBLOCK	EAGAIN	/* Operation would block */
 #define EALREADY	149	/* Operation already in progress */
 #define EINPROGRESS	150	/* Operation now in progress */
-#define ESTALE		151	/* Stale NFS file handle */
+#define ESTALE		151	/* Stale file handle */
 #define ECANCELED	158	/* AIO operation canceled */
 
 /*
diff -puN arch/parisc/include/uapi/asm/errno.h~errnoh-remove-nfs-from-descriptions-in-comments arch/parisc/include/uapi/asm/errno.h
--- a/arch/parisc/include/uapi/asm/errno.h~errnoh-remove-nfs-from-descriptions-in-comments
+++ a/arch/parisc/include/uapi/asm/errno.h
@@ -37,7 +37,7 @@
 #define	EBADMSG		67	/* Not a data message */
 #define	EUSERS		68	/* Too many users */
 #define	EDQUOT		69	/* Quota exceeded */
-#define	ESTALE		70	/* Stale NFS file handle */
+#define	ESTALE		70	/* Stale file handle */
 #define	EREMOTE		71	/* Object is remote */
 #define	EOVERFLOW	72	/* Value too large for defined data type */
 
diff -puN arch/sparc/include/uapi/asm/errno.h~errnoh-remove-nfs-from-descriptions-in-comments arch/sparc/include/uapi/asm/errno.h
--- a/arch/sparc/include/uapi/asm/errno.h~errnoh-remove-nfs-from-descriptions-in-comments
+++ a/arch/sparc/include/uapi/asm/errno.h
@@ -40,7 +40,7 @@
 #define EPROCLIM        67      /* SUNOS: Too many processes */
 #define	EUSERS		68	/* Too many users */
 #define	EDQUOT		69	/* Quota exceeded */
-#define	ESTALE		70	/* Stale NFS file handle */
+#define	ESTALE		70	/* Stale file handle */
 #define	EREMOTE		71	/* Object is remote */
 #define	ENOSTR		72	/* Device not a stream */
 #define	ETIME		73	/* Timer expired */
diff -puN drivers/staging/lustre/lustre/include/lustre/lustre_errno.h~errnoh-remove-nfs-from-descriptions-in-comments drivers/staging/lustre/lustre/include/lustre/lustre_errno.h
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_errno.h~errnoh-remove-nfs-from-descriptions-in-comments
+++ a/drivers/staging/lustre/lustre/include/lustre/lustre_errno.h
@@ -165,7 +165,7 @@
 #define LUSTRE_EHOSTUNREACH	113	/* No route to host */
 #define LUSTRE_EALREADY		114	/* Operation already in progress */
 #define LUSTRE_EINPROGRESS	115	/* Operation now in progress */
-#define LUSTRE_ESTALE		116	/* Stale NFS file handle */
+#define LUSTRE_ESTALE		116	/* Stale file handle */
 #define LUSTRE_EUCLEAN		117	/* Structure needs cleaning */
 #define LUSTRE_ENOTNAM		118	/* Not a XENIX named type file */
 #define LUSTRE_ENAVAIL		119	/* No XENIX semaphores available */
diff -puN include/uapi/asm-generic/errno.h~errnoh-remove-nfs-from-descriptions-in-comments include/uapi/asm-generic/errno.h
--- a/include/uapi/asm-generic/errno.h~errnoh-remove-nfs-from-descriptions-in-comments
+++ a/include/uapi/asm-generic/errno.h
@@ -86,7 +86,7 @@
 #define	EHOSTUNREACH	113	/* No route to host */
 #define	EALREADY	114	/* Operation already in progress */
 #define	EINPROGRESS	115	/* Operation now in progress */
-#define	ESTALE		116	/* Stale NFS file handle */
+#define	ESTALE		116	/* Stale file handle */
 #define	EUCLEAN		117	/* Structure needs cleaning */
 #define	ENOTNAM		118	/* Not a XENIX named type file */
 #define	ENAVAIL		119	/* No XENIX semaphores available */
_

Patches currently in -mm which might be from sandeen@redhat.com are

errnoh-remove-nfs-from-descriptions-in-comments.patch
linux-next.patch

