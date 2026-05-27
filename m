Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0017C3B19D4
	for <mm-commits@vger.kernel.org>; Wed, 27 May 2026 19:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779911553; cv=none; b=FiJ8bZAK2wPHg3BHEicAc5L1mcsBpW7++3Agv/VvxGfM0ZtOYWJ/Z0rlI4VyQ9JcnCN9lxoxKzcWJBfZro5uoyeboRWjekT1WYapt9eoucgtcUdlgIOTfjtSgafrEMyYFVhX97KrMVOhL5lMoTSG6BTtz2kue/ys/yvTIgaBi2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779911553; c=relaxed/simple;
	bh=GWv7Kz6KdHzZ1/V5nms493PZSzLF6VhbZauXK+tsv8U=;
	h=Date:To:From:Subject:Message-Id; b=TBM1Jr5Z4eJ++F/lBUF50TOZFEkmo0sQ3wb85Nory0ptE9OI5+b9zRHB+rCZzSfp/mxDdzIsD93a5tuPLOZcVlvhdFXQfKPtuf/IF/DOrPRJTp4iqHF5dUObQSXm6SDSN2B+raTg2Y9kjR00nKJrFaMTH+Kpm6ctPYvXNt4rkDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PIDD/Lwe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PIDD/Lwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43F11F000E9;
	Wed, 27 May 2026 19:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779911551;
	bh=XNuMLUOtV1XSLhl6b4lVG17Wb+Yk5ZtStc4GTjXD3cs=;
	h=Date:To:From:Subject;
	b=PIDD/LweQKeli3AoJIMG4TZYBw6wZRnzsuSW8MmO30ZPm/Db11CQkfoWGqfI/zXo2
	 U8vSzBEdCu/D7fgw3V2zLSuqLaA1swN+WKgewKzJfeVZV/8xrGd4pfp/TVH+K0AMU7
	 snnwDDCzzVqQsc8KvDSShDx5s1ckbeP8bCpzn7wU=
Date: Wed, 27 May 2026 12:52:31 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,linux@weissschuh.net,fan.yu9@zte.com.cn,corbet@lwn.net,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-headers-uapi-sync-linux-taskstatsh-for-procacctc.patch added to mm-hotfixes-unstable branch
Message-Id: <20260527195231.A43F11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools headers UAPI: sync linux/taskstats.h for procacct.c
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-headers-uapi-sync-linux-taskstatsh-for-procacctc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-headers-uapi-sync-linux-taskstatsh-for-procacctc.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Wang Yaxin <wang.yaxin@zte.com.cn>
Subject: tools headers UAPI: sync linux/taskstats.h for procacct.c
Date: Wed, 27 May 2026 21:35:58 +0800 (CST)

After commit 9b93f7e32774 ("tools/getdelays: use the static UAPI headers
from tools/include/uapi"), the Makefile was changed to use
-I../include/uapi/ instead of -I../../usr/include to ensure tools always
use the up-to-date UAPI headers.

However, only linux/taskstats.h was added to tools/include/uapi/ in commit
e5bbb35a07b3 ("tools headers UAPI: sync linux/taskstats.h"), but
linux/acct.h was missing.

This causes procacct.c to fail to compile with:

procacct.c:234:37: error: 'AGROUP' undeclared (first use in this function)

gcc -I../include/uapi/    getdelays.c   -o getdelays
gcc -I../include/uapi/    procacct.c   -o procacct
procacct.c: In function `print_procacct':
procacct.c:234:37: error: `AGROUP' undeclared (first use in this function)
did you mean `NOGROUP'?
  234 |  , t->version >= 12 ? (t->ac_flag & AGROUP ? 'P' : 'T') : '?'
      |                                     ^~~~~~
      |                                     NOGROUP
procacct.c:234:37: note: each undeclared ident

because procacct.c uses the AGROUP macro defined in linux/acct.h.

Add the missing linux/acct.h to complete the static UAPI header set.

Link: https://lore.kernel.org/20260527213558929EhiHHy9EDTMjmg3uuDOMi@zte.com.cn
Fixes: 9b93f7e32774 ("tools/getdelays: use the static UAPI headers from tools/include/uapi")
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/uapi/linux/acct.h |  128 ++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)

diff --git a/tools/include/uapi/linux/acct.h a/tools/include/uapi/linux/acct.h
new file mode 100644
--- /dev/null
+++ a/tools/include/uapi/linux/acct.h
@@ -0,0 +1,128 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ *  BSD Process Accounting for Linux - Definitions
+ *
+ *  Author: Marco van Wieringen (mvw@planets.elm.net)
+ *
+ *  This header file contains the definitions needed to implement
+ *  BSD-style process accounting. The kernel accounting code and all
+ *  user-level programs that try to do something useful with the
+ *  process accounting log must include this file.
+ *
+ *  Copyright (C) 1995 - 1997 Marco van Wieringen - ELM Consultancy B.V.
+ *
+ */
+
+#ifndef _UAPI_LINUX_ACCT_H
+#define _UAPI_LINUX_ACCT_H
+
+#include <linux/types.h>
+
+#include <asm/param.h>
+#include <asm/byteorder.h>
+
+/*
+ *  comp_t is a 16-bit "floating" point number with a 3-bit base 8
+ *  exponent and a 13-bit fraction.
+ *  comp2_t is 24-bit with 5-bit base 2 exponent and 20 bit fraction
+ *  (leading 1 not stored).
+ *  See linux/kernel/acct.c for the specific encoding systems used.
+ */
+
+typedef __u16	comp_t;
+typedef __u32	comp2_t;
+
+/*
+ *   accounting file record
+ *
+ *   This structure contains all of the information written out to the
+ *   process accounting file whenever a process exits.
+ */
+
+#define ACCT_COMM	16
+
+struct acct
+{
+	char		ac_flag;		/* Flags */
+	char		ac_version;		/* Always set to ACCT_VERSION */
+	/* for binary compatibility back until 2.0 */
+	__u16		ac_uid16;		/* LSB of Real User ID */
+	__u16		ac_gid16;		/* LSB of Real Group ID */
+	__u16		ac_tty;			/* Control Terminal */
+	/* __u32 range means times from 1970 to 2106 */
+	__u32		ac_btime;		/* Process Creation Time */
+	comp_t		ac_utime;		/* User Time */
+	comp_t		ac_stime;		/* System Time */
+	comp_t		ac_etime;		/* Elapsed Time */
+	comp_t		ac_mem;			/* Average Memory Usage */
+	comp_t		ac_io;			/* Chars Transferred */
+	comp_t		ac_rw;			/* Blocks Read or Written */
+	comp_t		ac_minflt;		/* Minor Pagefaults */
+	comp_t		ac_majflt;		/* Major Pagefaults */
+	comp_t		ac_swaps;		/* Number of Swaps */
+/* m68k had no padding here. */
+#if !defined(CONFIG_M68K) || !defined(__KERNEL__)
+	__u16		ac_ahz;			/* AHZ */
+#endif
+	__u32		ac_exitcode;		/* Exitcode */
+	char		ac_comm[ACCT_COMM + 1];	/* Command Name */
+	__u8		ac_etime_hi;		/* Elapsed Time MSB */
+	__u16		ac_etime_lo;		/* Elapsed Time LSB */
+	__u32		ac_uid;			/* Real User ID */
+	__u32		ac_gid;			/* Real Group ID */
+};
+
+struct acct_v3
+{
+	char		ac_flag;		/* Flags */
+	char		ac_version;		/* Always set to ACCT_VERSION */
+	__u16		ac_tty;			/* Control Terminal */
+	__u32		ac_exitcode;		/* Exitcode */
+	__u32		ac_uid;			/* Real User ID */
+	__u32		ac_gid;			/* Real Group ID */
+	__u32		ac_pid;			/* Process ID */
+	__u32		ac_ppid;		/* Parent Process ID */
+	/* __u32 range means times from 1970 to 2106 */
+	__u32		ac_btime;		/* Process Creation Time */
+#ifdef __KERNEL__
+	__u32		ac_etime;		/* Elapsed Time */
+#else
+	float		ac_etime;		/* Elapsed Time */
+#endif
+	comp_t		ac_utime;		/* User Time */
+	comp_t		ac_stime;		/* System Time */
+	comp_t		ac_mem;			/* Average Memory Usage */
+	comp_t		ac_io;			/* Chars Transferred */
+	comp_t		ac_rw;			/* Blocks Read or Written */
+	comp_t		ac_minflt;		/* Minor Pagefaults */
+	comp_t		ac_majflt;		/* Major Pagefaults */
+	comp_t		ac_swaps;		/* Number of Swaps */
+	char		ac_comm[ACCT_COMM];	/* Command Name */
+};
+
+/*
+ *  accounting flags
+ */
+				/* bit set when the process/task ... */
+#define AFORK		0x01	/* ... executed fork, but did not exec */
+#define ASU		0x02	/* ... used super-user privileges */
+#define ACOMPAT		0x04	/* ... used compatibility mode (VAX only not used) */
+#define ACORE		0x08	/* ... dumped core */
+#define AXSIG		0x10	/* ... was killed by a signal */
+#define AGROUP		0x20	/* ... was the last task of the process (task group) */
+
+#if defined(__BYTE_ORDER) ? __BYTE_ORDER == __BIG_ENDIAN : defined(__BIG_ENDIAN)
+#define ACCT_BYTEORDER	0x80	/* accounting file is big endian */
+#elif defined(__BYTE_ORDER) ? __BYTE_ORDER == __LITTLE_ENDIAN : defined(__LITTLE_ENDIAN)
+#define ACCT_BYTEORDER	0x00	/* accounting file is little endian */
+#else
+#error unspecified endianness
+#endif
+
+#ifndef __KERNEL__
+#define ACCT_VERSION	2
+#define AHZ		(HZ)
+#endif	/* __KERNEL */
+
+
+#endif /* _UAPI_LINUX_ACCT_H */
_

Patches currently in -mm which might be from wang.yaxin@zte.com.cn are

tools-headers-uapi-sync-linux-taskstatsh-for-procacctc.patch

