Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7ABC21ABC8;
	Thu,  8 May 2025 06:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686462; cv=none; b=hPCh8eCwtABuNWLOEVnVtPrUIdiR4Z0Vjfh0fxzM0bGtACHxJO2/lkBf1wPEHS7a0bn9tWcJaixNgRxm5cp0qYlZD2Yfd86U2qdbOk2XSUzfcTAdElez5V+pIR1IOC1D5bL4bRbajRWjPRwgy79V/X+HqdqJOtDLwOlpmhIq9gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686462; c=relaxed/simple;
	bh=3AQeYuM1jU0DohFF/pGs0MKP3jDNF2Ss2swa6PwAe6I=;
	h=Date:To:From:Subject:Message-Id; b=aWrv7nW+7FMzUv410knzomUlAieKYwB0s77ql1UAEzpGHOOG82q2Um+H8RUMbnXBVeBKJ3KJMk2HEuW8L6tZM5ia7Bd4/zc2PywcbxRpJaGfhw6pA3LlGF992q4VgR1SBDspUVa4cfvsBLy/qwxjeOjtO52cbFDch3oQhDZ7mAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fcm7kaF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fcm7kaF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB138C4CEEB;
	Thu,  8 May 2025 06:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746686462;
	bh=3AQeYuM1jU0DohFF/pGs0MKP3jDNF2Ss2swa6PwAe6I=;
	h=Date:To:From:Subject:From;
	b=fcm7kaF2JfeNV4kMisFdGGY25WdCVQzOZZz8g8CaSjy724Cl9dcmc9ltLvr/yYJeA
	 FsjupjfLEnLtxSkxdvAuban0CRwbJLHKce5XvwT8kbewSRgVib/aqJ5xo18gMbgLMZ
	 4IXGRpbLqSV1Ckk9FbKYfskt1l5EWZNGUyyVE/5I=
Date: Wed, 07 May 2025 23:41:02 -0700
To: mm-commits@vger.kernel.org,venkat88@linux.ibm.com,stable@vger.kernel.org,nysal@linux.ibm.com,maddy@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-fix-build-break-when-compiling-pkey_utilc.patch removed from -mm tree
Message-Id: <20250508064102.AB138C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix build break when compiling pkey_util.c
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-build-break-when-compiling-pkey_utilc.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: selftests/mm: fix build break when compiling pkey_util.c
Date: Mon, 28 Apr 2025 18:49:34 +0530

Commit 50910acd6f615 ("selftests/mm: use sys_pkey helpers consistently")
added a pkey_util.c to refactor some of the protection_keys functions
accessible by other tests.  But this broken the build in powerpc in two
ways,

pkey-powerpc.h: In function `arch_is_powervm':
pkey-powerpc.h:73:21: error: storage size of `buf' isn't known
   73 |         struct stat buf;
      |                     ^~~
pkey-powerpc.h:75:14: error: implicit declaration of function `stat'; did you mean `strcat'? [-Wimplicit-function-declaration]
   75 |         if ((stat("/sys/firmware/devicetree/base/ibm,partition-name", &buf) == 0) &&
      |              ^~~~
      |              strcat

Since pkey_util.c includes pkeys-helper.h, which in turn includes pkeys-powerpc.h,
stat.h including is missing for "struct stat". This is fixed by adding "sys/stat.h"
in pkeys-powerpc.h

Secondly,

pkey-powerpc.h:55:18: warning: format `%llx' expects argument of type `long long unsigned int', but argument 3 has type `u64' {aka `long unsigned int'} [-Wformat=]
   55 |         dprintf4("%s() changing %016llx to %016llx\n",
      |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   56 |                          __func__, __read_pkey_reg(), pkey_reg);
      |                                    ~~~~~~~~~~~~~~~~~
      |                                    |
      |                                    u64 {aka long unsigned int}
pkey-helpers.h:63:32: note: in definition of macro `dprintf_level'
   63 |                 sigsafe_printf(args);           \
      |                                ^~~~

These format specifier related warning are removed by adding
"__SANE_USERSPACE_TYPES__" to pkeys_utils.c.

Link: https://lkml.kernel.org/r/20250428131937.641989-1-nysal@linux.ibm.com
Fixes: 50910acd6f61 ("selftests/mm: use sys_pkey helpers consistently")
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Nysal Jan K.A. <nysal@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pkey-powerpc.h |    2 ++
 tools/testing/selftests/mm/pkey_util.c    |    1 +
 2 files changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/pkey-powerpc.h~selftests-mm-fix-build-break-when-compiling-pkey_utilc
+++ a/tools/testing/selftests/mm/pkey-powerpc.h
@@ -3,6 +3,8 @@
 #ifndef _PKEYS_POWERPC_H
 #define _PKEYS_POWERPC_H
 
+#include <sys/stat.h>
+
 #ifndef SYS_pkey_alloc
 # define SYS_pkey_alloc		384
 # define SYS_pkey_free		385
--- a/tools/testing/selftests/mm/pkey_util.c~selftests-mm-fix-build-break-when-compiling-pkey_utilc
+++ a/tools/testing/selftests/mm/pkey_util.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
+#define __SANE_USERSPACE_TYPES__
 #include <sys/syscall.h>
 #include <unistd.h>
 
_

Patches currently in -mm which might be from maddy@linux.ibm.com are


