From: akpm@linux-foundation.org
Subject: - powerpc-keep-3-high-personality-bytes-across-exec.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:47:11 -0700
Message-ID: <200807020747.m627lB1f005630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628AbYGBH40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:56:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebmunson@us.ibm.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: keep 3 high personality bytes across exec
has been removed from the -mm tree.  Its filename was
     powerpc-keep-3-high-personality-bytes-across-exec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: keep 3 high personality bytes across exec
From: Eric B Munson <ebmunson@us.ibm.com>

Currently when a 32 bit process is exec'd on a powerpc 64 bit host the
value in the top three bytes of the personality is clobbered.  This patch
adds a check in the SET_PERSONALITY macro that will carry all the values
in the top three bytes across the exec.

These three bytes currently carry flags to disable address randomisation,
limit the address space, force zeroing of an mmapped page, etc.  Should an
application set any of these bits they will be maintained and honoured on
homogeneous environment but discarded and ignored on a heterogeneous
environment.  So if an application requires all mmapped pages to be
initial= ised to zero and a wrapper is used to setup the personality and
exec the target, these flags will remain set on an all 32 or all 64 bit
envrionment, but they will be lost in the exec on a mixed 32/64 bit
environment.  Losing these bi= ts means that the same application would
behave differently in different environments.  Tested on a POWER5+ machine
with 64bit kernel and a mixed 64/32 bit user space.

Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/elf.h   |    3 ++-
 include/linux/personality.h |    6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN include/asm-powerpc/elf.h~powerpc-keep-3-high-personality-bytes-across-exec include/asm-powerpc/elf.h
--- a/include/asm-powerpc/elf.h~powerpc-keep-3-high-personality-bytes-across-exec
+++ a/include/asm-powerpc/elf.h
@@ -257,7 +257,8 @@ do {								\
 	else							\
 		clear_thread_flag(TIF_ABI_PENDING);		\
 	if (personality(current->personality) != PER_LINUX32)	\
-		set_personality(PER_LINUX);			\
+		set_personality(PER_LINUX |			\
+			(current->personality & PER_INHERIT));	\
 } while (0)
 /*
  * An executable for which elf_read_implies_exec() returns TRUE will
diff -puN include/linux/personality.h~powerpc-keep-3-high-personality-bytes-across-exec include/linux/personality.h
--- a/include/linux/personality.h~powerpc-keep-3-high-personality-bytes-across-exec
+++ a/include/linux/personality.h
@@ -36,6 +36,12 @@ enum {
 	ADDR_LIMIT_3GB = 	0x8000000,
 };
 
+/* Mask for the above personality values */
+#define PER_INHERIT (ADDR_NO_RANDOMIZE|FDPIC_FUNCPTRS|MMAP_PAGE_ZERO| \
+			ADDR_COMPAT_LAYOUT|READ_IMPLIES_EXEC|ADDR_LIMIT_32BIT| \
+			SHORT_INODE|WHOLE_SECONDS|STICKY_TIMEOUTS| \
+			ADDR_LIMIT_3GB)
+
 /*
  * Security-relevant compatibility flags that must be
  * cleared upon setuid or setgid exec:
_

Patches currently in -mm which might be from ebmunson@us.ibm.com are

linux-next.patch

