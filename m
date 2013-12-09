From: akpm@linux-foundation.org
Subject: [merged] kernel-paramsc-improve-standard-definitions.patch
 removed from -mm tree
Date: Mon, 09 Dec 2013 13:53:55 -0800
Message-ID: <52a63bf3.jWjOkCmVWl3K4h6F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933057Ab3LIVxz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Dec 2013 16:53:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, levex@linux.com, felipe.contreras@gmail.com

Subject: [merged] kernel-paramsc-improve-standard-definitions.patch removed from -mm tree
To: felipe.contreras@gmail.com,levex@linux.com,rusty@rustcorp.com.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Dec 2013 13:53:55 -0800


The patch titled
     Subject: kernel/params.c: improve standard definitions
has been removed from the -mm tree.  Its filename was
     kernel-paramsc-improve-standard-definitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Felipe Contreras <felipe.contreras@gmail.com>
Subject: kernel/params.c: improve standard definitions

We are repeating the functionality of kstrtol in param_set_long, and the
same for kstrtoint.  We can get rid of the extra code by using the right
functions.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Levente Kurusa <levex@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/params.c |   25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff -puN kernel/params.c~kernel-paramsc-improve-standard-definitions kernel/params.c
--- a/kernel/params.c~kernel-paramsc-improve-standard-definitions
+++ a/kernel/params.c
@@ -227,17 +227,10 @@ int parse_args(const char *doing,
 }
 
 /* Lazy bastard, eh? */
-#define STANDARD_PARAM_DEF(name, type, format, tmptype, strtolfn)      	\
+#define STANDARD_PARAM_DEF(name, type, format, strtolfn)      		\
 	int param_set_##name(const char *val, const struct kernel_param *kp) \
 	{								\
-		tmptype l;						\
-		int ret;						\
-									\
-		ret = strtolfn(val, 0, &l);				\
-		if (ret < 0 || ((type)l != l))				\
-			return ret < 0 ? ret : -EINVAL;			\
-		*((type *)kp->arg) = l;					\
-		return 0;						\
+		return strtolfn(val, 0, (type *)kp->arg);		\
 	}								\
 	int param_get_##name(char *buffer, const struct kernel_param *kp) \
 	{								\
@@ -253,13 +246,13 @@ int parse_args(const char *doing,
 	EXPORT_SYMBOL(param_ops_##name)
 
 
-STANDARD_PARAM_DEF(byte, unsigned char, "%hhu", unsigned long, kstrtoul);
-STANDARD_PARAM_DEF(short, short, "%hi", long, kstrtol);
-STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, kstrtoul);
-STANDARD_PARAM_DEF(int, int, "%i", long, kstrtol);
-STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, kstrtoul);
-STANDARD_PARAM_DEF(long, long, "%li", long, kstrtol);
-STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, kstrtoul);
+STANDARD_PARAM_DEF(byte, unsigned char, "%hhu", kstrtou8);
+STANDARD_PARAM_DEF(short, short, "%hi", kstrtos16);
+STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", kstrtou16);
+STANDARD_PARAM_DEF(int, int, "%i", kstrtoint);
+STANDARD_PARAM_DEF(uint, unsigned int, "%u", kstrtouint);
+STANDARD_PARAM_DEF(long, long, "%li", kstrtol);
+STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", kstrtoul);
 
 int param_set_charp(const char *val, const struct kernel_param *kp)
 {
_

Patches currently in -mm which might be from felipe.contreras@gmail.com are

kstrtox-remove-redundant-cleanup.patch
cmdline-fix-style-issues.patch
lib-cmdlinec-declare-exported-symbols-immediately.patch
linux-next.patch

