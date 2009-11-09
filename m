From: akpm@linux-foundation.org
Subject: + kernel-sysc-implement-prctlpr_get_endian-for-all-architectures.patch added to -mm tree
Date: Mon, 09 Nov 2009 12:47:10 -0800
Message-ID: <200911092047.nA9KlAe3016322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751132AbZKIUrJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 15:47:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deller@gmx.de, anton@samba.org, paulus@samba.org


The patch titled
     kernel/sys.c: implement prctl(PR_GET_ENDIAN) for all architectures
has been added to the -mm tree.  Its filename is
     kernel-sysc-implement-prctlpr_get_endian-for-all-architectures.patch

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
Subject: kernel/sys.c: implement prctl(PR_GET_ENDIAN) for all architectures
From: Helge Deller <deller@gmx.de>

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/sys.c~kernel-sysc-implement-prctlpr_get_endian-for-all-architectures kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-implement-prctlpr_get_endian-for-all-architectures
+++ a/kernel/sys.c
@@ -46,6 +46,15 @@
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
@@ -65,10 +74,12 @@
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

linux-next.patch
kernel-sysc-implement-prctlpr_get_endian-for-all-architectures.patch

