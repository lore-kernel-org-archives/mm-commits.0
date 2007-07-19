From: akpm@linux-foundation.org
Subject: + unexport-asm-shmparamh.patch added to -mm tree
Date: Wed, 18 Jul 2007 18:13:11 -0700
Message-ID: <200707190113.l6J1DBYm006606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41796 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335AbXGSBNY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 21:13:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olaf@aepfle.de, benh@kernel.crashing.org, davem@davemloft.net, paulus@samba.org


The patch titled
     unexport asm/shmparam.h
has been added to the -mm tree.  Its filename is
     unexport-asm-shmparamh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: unexport asm/shmparam.h
From: Olaf Hering <olaf@aepfle.de>

SHMLBA cant possible be used in userspace, see sparc versions of that header.

Do not export asm/shmparam.h during make headers_install_all
This removes another uservisible place of PAGE_SIZE

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/Kbuild.asm |    1 -
 include/asm-powerpc/Kbuild     |    1 -
 include/asm-sparc64/shmparam.h |    2 --
 include/linux/shm.h            |    2 ++
 4 files changed, 2 insertions(+), 4 deletions(-)

diff -puN include/asm-generic/Kbuild.asm~unexport-asm-shmparamh include/asm-generic/Kbuild.asm
--- a/include/asm-generic/Kbuild.asm~unexport-asm-shmparamh
+++ a/include/asm-generic/Kbuild.asm
@@ -30,6 +30,5 @@ unifdef-y += unistd.h
 unifdef-y += user.h
 
 # These probably shouldn't be exported
-unifdef-y += shmparam.h
 unifdef-y += elf.h
 unifdef-y += page.h
diff -puN include/asm-powerpc/Kbuild~unexport-asm-shmparamh include/asm-powerpc/Kbuild
--- a/include/asm-powerpc/Kbuild~unexport-asm-shmparamh
+++ a/include/asm-powerpc/Kbuild
@@ -15,7 +15,6 @@ header-y += termbits.h
 header-y += fcntl.h
 header-y += ipc.h
 header-y += poll.h
-header-y += shmparam.h
 header-y += sockios.h
 header-y += ucontext.h
 header-y += ioctl.h
diff -puN include/asm-sparc64/shmparam.h~unexport-asm-shmparamh include/asm-sparc64/shmparam.h
--- a/include/asm-sparc64/shmparam.h~unexport-asm-shmparamh
+++ a/include/asm-sparc64/shmparam.h
@@ -1,7 +1,6 @@
 /* $Id: shmparam.h,v 1.5 2001/09/24 21:17:57 kanoj Exp $ */
 #ifndef _ASMSPARC64_SHMPARAM_H
 #define _ASMSPARC64_SHMPARAM_H
-#ifdef __KERNEL__
 
 #include <asm/spitfire.h>
 
@@ -9,5 +8,4 @@
 /* attach addr a multiple of this */
 #define	SHMLBA	((PAGE_SIZE > L1DCACHE_SIZE) ? PAGE_SIZE : L1DCACHE_SIZE)
 
-#endif /* __KERNEL__ */
 #endif /* _ASMSPARC64_SHMPARAM_H */
diff -puN include/linux/shm.h~unexport-asm-shmparamh include/linux/shm.h
--- a/include/linux/shm.h~unexport-asm-shmparamh
+++ a/include/linux/shm.h
@@ -16,7 +16,9 @@
 #define SHMALL (SHMMAX/PAGE_SIZE*(SHMMNI/16)) /* max shm system wide (pages) */
 #define SHMSEG SHMMNI			 /* max shared segs per process */
 
+#ifdef __KERNEL__
 #include <asm/shmparam.h>
+#endif
 
 /* Obsolete, used only for backwards compatibility and libc5 compiles */
 struct shmid_ds {
_

Patches currently in -mm which might be from olaf@aepfle.de are

origin.patch
unexport-asm-shmparamh.patch
keep-track-of-network-interface-renaming.patch
