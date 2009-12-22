From: akpm@linux-foundation.org
Subject: [nacked] kernel-sysc-implement-prctlpr_get_endian-for-all-architectures.patch removed from -mm tree
Date: Mon, 21 Dec 2009 16:31:04 -0800
Message-ID: <200912220031.nBM0V458005597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752777AbZLVAbR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Dec 2009 19:31:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deller@gmx.de, anton@samba.org, mikpe@it.uu.se, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     kernel/sys.c: implement prctl(PR_GET_ENDIAN) for all architectures
has been removed from the -mm tree.  Its filename was
     kernel-sysc-implement-prctlpr_get_endian-for-all-architectures.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/sys.c: implement prctl(PR_GET_ENDIAN) for all architectures
From: Helge Deller <deller@gmx.de>

The kernel provides an interface (for all architectures) which is
currently only useable on one single architecture (ppc).

So, either we could just remove the interface alltogether for all
architectures beside ppc, or implement the functionality for all
architectures so that they return at least some kind of useful values back
to userspace.  This patch takes the latter approach.


The PR_GET_ENDIAN and PR_SET_ENDIAN prctl() calls have been implemented to
allow to switch processes at runtime from big-endian to little-endian mode
(and vice versa) on PowerPC processors.  Since the other architectures
don't support this feature, they currently will just fail and return
-EINVAL.

This patch adds just minimal overhead and implements the PR_GET_ENDIAN
call for all other architectures by returning the native endianess of the
architecture.  Furthermore, calling prctl(PR_SET_ENDIAN) with the native
endianess of the architecture will succeed, while trying to set another
(not-supported) endianess, will fail.

The patch can be tested with the following program:

#include <stdio.h>
#include <linux/prctl.h>

int main(int argc, char **argv)
{
	int endian, ret;

	ret = prctl(PR_GET_ENDIAN, &endian);
	if (ret)
		perror("prctl(PR_GET_ENDIAN) not implemented");
	printf("current process/machine is running in %s endian mode (%d)\n",
		endian == PR_ENDIAN_LITTLE ? "little":"big", endian);

	/* setting native endianess should succeed */
	ret = prctl(PR_SET_ENDIAN, endian);
	printf("prctl(PR_SET_ENDIAN,%d) should succeed: %s\n",
		endian, ret == 0 ? "OK":"FAIL");

	/* setting foreign endianess should fail */
	endian = (endian == PR_ENDIAN_LITTLE) ?
		PR_ENDIAN_BIG : PR_ENDIAN_LITTLE;
	ret = prctl(PR_SET_ENDIAN, endian);
	printf("prctl(PR_SET_ENDIAN,%d) should fail: %s\n",
		endian, ret == 0 ? "OK":"FAIL");
}

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Anton Blanchard <anton@samba.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN kernel/sys.c~kernel-sysc-implement-prctlpr_get_endian-for-all-architectures kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-implement-prctlpr_get_endian-for-all-architectures
+++ a/kernel/sys.c
@@ -45,6 +45,15 @@
 #include <asm/io.h>
 #include <asm/unistd.h>
 
+#if defined(__BIG_ENDIAN)
+# define PRCTL_ENDIAN_DEFAULT	(PR_ENDIAN_BIG)
+#elif defined(__LITTLE_ENDIAN)
+# define PRCTL_ENDIAN_DEFAULT	(PR_ENDIAN_LITTLE)
+#else
+# error "No endianess?"
+#endif
+
+
 #ifndef SET_UNALIGN_CTL
 # define SET_UNALIGN_CTL(a,b)	(-EINVAL)
 #endif
@@ -64,10 +73,12 @@
 # define GET_FPEXC_CTL(a,b)	(-EINVAL)
 #endif
 #ifndef GET_ENDIAN
-# define GET_ENDIAN(a,b)	(-EINVAL)
+# define GET_ENDIAN(task,addr)	\
+	put_user(PRCTL_ENDIAN_DEFAULT, (int __user *) (addr))
 #endif
 #ifndef SET_ENDIAN
-# define SET_ENDIAN(a,b)	(-EINVAL)
+# define SET_ENDIAN(task,value)	\
+	( (value) == PRCTL_ENDIAN_DEFAULT ? 0 : -EINVAL )
 #endif
 #ifndef GET_TSC_CTL
 # define GET_TSC_CTL(a)		(-EINVAL)
_

Patches currently in -mm which might be from deller@gmx.de are

kernel-sysc-implement-prctlpr_get_endian-for-all-architectures.patch

