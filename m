Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E105233129
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 02:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733796479; cv=none; b=Sbhb6KpT/1Nc055R5l6zgRc3mz1MES5ZBAi6f8+VG5LZhMHAD76bkNI9ljc1Q/I1znQe83V0x+20pp4Xci04OCXL6bMoGFItPzg1Tp+FGjn+KDX1LGGB5W3QxuRe3c/xy1QR/sPVL9oZfs5cwW5HC/AySzoFwHrjXCJjAJRjCZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733796479; c=relaxed/simple;
	bh=hpiI6vB5jKlEX1GUC17gCT7T1NY50m7SPv0PJ6O9q8o=;
	h=Date:To:From:Subject:Message-Id; b=TSE8L2UDTUojan77+NUX/q7AlJqO5ZeyuEjKmcQSsIbBCs5x3vOrp4K/k0VUSIWLUcXMD5adGYs7pRHIgpn8rmZZzNqT8T84kS9b0bgJ89ouo/KliXzNvEn+7J1QjtiwIduoFmP5fgcLnW4IoUVUcCP3YN8Ecm/+kMx99EM9mpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iyOuOQSo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iyOuOQSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA45C4CED1;
	Tue, 10 Dec 2024 02:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733796479;
	bh=hpiI6vB5jKlEX1GUC17gCT7T1NY50m7SPv0PJ6O9q8o=;
	h=Date:To:From:Subject:From;
	b=iyOuOQSogbWsHQa9MuVbOjaV4vOKb3eRjFybhnJ4pbecUptOYbU2r1pbfXHttPYLH
	 PMTdUinkmhtgdNVaX1dKr3eTYgxuSD6T0b5VPeA7g57w/6FKN1MC7FRirPnGn9nAip
	 D564kTVFs8R7fliOP+boSb/m6MaRs/v8vP2CTUbU=
Date: Mon, 09 Dec 2024 18:07:58 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-define-types-using-typedef-in-pkey-helpersh.patch added to mm-unstable branch
Message-Id: <20241210020759.2DA45C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: define types using typedef in pkey-helpers.h
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-define-types-using-typedef-in-pkey-helpersh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-define-types-using-typedef-in-pkey-helpersh.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: define types using typedef in pkey-helpers.h
Date: Mon, 9 Dec 2024 09:50:12 +0000

Using #define to define types should be avoided.  Use typedef instead. 
Also ensure that __u* types are actually defined by including
<linux/types.h>.

Link: https://lkml.kernel.org/r/20241209095019.1732120-8-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pkey-helpers.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/pkey-helpers.h~selftests-mm-define-types-using-typedef-in-pkey-helpersh
+++ a/tools/testing/selftests/mm/pkey-helpers.h
@@ -13,13 +13,15 @@
 #include <ucontext.h>
 #include <sys/mman.h>
 
+#include <linux/types.h>
+
 #include "../kselftest.h"
 
 /* Define some kernel-like types */
-#define  u8 __u8
-#define u16 __u16
-#define u32 __u32
-#define u64 __u64
+typedef __u8	u8;
+typedef __u16	u16;
+typedef __u32	u32;
+typedef __u64	u64;
 
 #define PTR_ERR_ENOTSUP ((void *)-ENOTSUP)
 
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

selftests-mm-fix-condition-in-uffd_move_test_common.patch
selftests-mm-fix-wmaybe-uninitialized-warnings.patch
selftests-mm-fix-strncpy-length.patch
selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests.patch
selftests-mm-build-with-o2.patch
selftests-mm-remove-unused-pkey-helpers.patch
selftests-mm-define-types-using-typedef-in-pkey-helpersh.patch
selftests-mm-ensure-pkey-h-define-inline-functions-only.patch
selftests-mm-remove-empty-pkey-helper-definition.patch
selftests-mm-ensure-non-global-pkey-symbols-are-marked-static.patch
selftests-mm-use-sys_pkey-helpers-consistently.patch
selftests-mm-rename-pkey-register-macro.patch
selftests-mm-skip-pkey_sighandler_tests-if-support-is-missing.patch
selftests-mm-remove-x-permission-from-sigaltstack-mapping.patch

