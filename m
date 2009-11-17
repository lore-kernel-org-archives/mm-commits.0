From: akpm@linux-foundation.org
Subject: [wrecked] fcntl-use-consistent-values-for-f_etown_ex.patch removed from -mm tree
Date: Tue, 17 Nov 2009 13:09:55 -0800
Message-ID: <200911172109.nAHL9txZ000971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752663AbZKQVKf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Nov 2009 16:10:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, a.p.zijlstra@chello.nl, drepper@gmail.com, eranian@googlemail.com, hch@infradead.org, joseph@codesourcery.com, mingo@elte.hu, mtk.manpages@googlemail.com, onester


The patch titled
     fcntl: Use consistent values for F_[GS]ETOWN_EX
has been removed from the -mm tree.  Its filename was
     fcntl-use-consistent-values-for-f_etown_ex.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fcntl: Use consistent values for F_[GS]ETOWN_EX
From: Stephen Rothwell <sfr@canb.auug.org.au>

These values were only introduced during this release cycle, so it is
still early enough to get them right.

alpha uses the same values that are in asm-generic/fcntl.h, so just remove
them.

parisc uses the values interchanged for no apparent reason, so remove them
to give us consistency across all architectures.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Joseph S. Myers" <joseph@codesourcery.com>
Cc: Oleg Nesterov <onestero@redhat.com>
Cc: Stephane Eranian <eranian@googlemail.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/fcntl.h  |    2 --
 arch/parisc/include/asm/fcntl.h |    2 --
 include/asm-generic/fcntl.h     |    2 --
 3 files changed, 6 deletions(-)

diff -puN arch/alpha/include/asm/fcntl.h~fcntl-use-consistent-values-for-f_etown_ex arch/alpha/include/asm/fcntl.h
--- a/arch/alpha/include/asm/fcntl.h~fcntl-use-consistent-values-for-f_etown_ex
+++ a/arch/alpha/include/asm/fcntl.h
@@ -26,8 +26,6 @@
 #define F_GETOWN	6	/*  for sockets. */
 #define F_SETSIG	10	/*  for sockets. */
 #define F_GETSIG	11	/*  for sockets. */
-#define F_SETOWN_EX	15
-#define F_GETOWN_EX	16
 
 /* for posix fcntl() and lockf() */
 #define F_RDLCK		1
diff -puN arch/parisc/include/asm/fcntl.h~fcntl-use-consistent-values-for-f_etown_ex arch/parisc/include/asm/fcntl.h
--- a/arch/parisc/include/asm/fcntl.h~fcntl-use-consistent-values-for-f_etown_ex
+++ a/arch/parisc/include/asm/fcntl.h
@@ -28,8 +28,6 @@
 #define F_SETOWN	12	/*  for sockets. */
 #define F_SETSIG	13	/*  for sockets. */
 #define F_GETSIG	14	/*  for sockets. */
-#define F_GETOWN_EX	15
-#define F_SETOWN_EX	16
 
 /* for posix fcntl() and lockf() */
 #define F_RDLCK		01
diff -puN include/asm-generic/fcntl.h~fcntl-use-consistent-values-for-f_etown_ex include/asm-generic/fcntl.h
--- a/include/asm-generic/fcntl.h~fcntl-use-consistent-values-for-f_etown_ex
+++ a/include/asm-generic/fcntl.h
@@ -82,10 +82,8 @@
 #endif
 #endif
 
-#ifndef F_SETOWN_EX
 #define F_SETOWN_EX	15
 #define F_GETOWN_EX	16
-#endif
 
 #define F_OWNER_TID	0
 #define F_OWNER_PID	1
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
fcntl-use-consistent-values-for-f_etown_ex.patch
linux-next.patch
x86-cpufreq-dont-use-acpi_processor_get_bios_limit-when-not-available.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
m68k-dont-export-static-inline-functions.patch

