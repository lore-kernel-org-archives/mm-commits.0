Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48039233129
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 02:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733796485; cv=none; b=FvA86+GPq9C+To/0jVw7AoYkD0zXVKMt9WrDe0xwZTtM2VcyaYMsujrg6/O9pkvzJHXV/4u5X1v9EXoc9QUTNFJutNeaJaXxILNUKIyucrcNBR0ylO+TFd+TvMI3iDgk7YWmtX1ZKiK24Uo2PS+Wa2ziazRAn1RX+IebccmR7EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733796485; c=relaxed/simple;
	bh=8U7RS/XJI4TJ8971OzxeSDQ7zYY1BFovGc4tuGZBe0g=;
	h=Date:To:From:Subject:Message-Id; b=VbLbAq/LqK6q/W+Okqswh6iXlZax8doO5sZu5BNsYXTHHhnNBiuaKhoEVpqy6JMopRUXHy2yqgfVFiNRzO+DNHzRFInEw8fD1BbTrO8KvNWHvfd8uoRTiD4sDD/S4cjGCyOfxphZwul1oUU06OUuDEuGcBWfD4cUunYm04nwXzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hJ46R/Fr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hJ46R/Fr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85B1C4CED1;
	Tue, 10 Dec 2024 02:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733796484;
	bh=8U7RS/XJI4TJ8971OzxeSDQ7zYY1BFovGc4tuGZBe0g=;
	h=Date:To:From:Subject:From;
	b=hJ46R/FrqVnl5uclcgN2JM+4mLdtc51Sz8aedEM/QItmv3tAFA636QSHSz2ExV/HR
	 NxJxPaNenh8k93yOK3IwQ43hEvH/lDwx+YLK52THKnI3+5PV6IavN8dxs3YVLz/WTO
	 u4hsDnQ/kzlWIIEawxk+hBAu53qFBIgqo6dIMpak=
Date: Mon, 09 Dec 2024 18:08:04 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-remove-empty-pkey-helper-definition.patch added to mm-unstable branch
Message-Id: <20241210020804.B85B1C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: remove empty pkey helper definition
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-remove-empty-pkey-helper-definition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-remove-empty-pkey-helper-definition.patch

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
Subject: selftests/mm: remove empty pkey helper definition
Date: Mon, 9 Dec 2024 09:50:14 +0000

Some of the functions declared in pkey-helpers.h are actually defined in
protections_keys.c, meaning they can only be called from
protections_keys.c.  This is less than ideal, but it is hard to avoid as
these helpers are themselves called from inline functions in
pkey-<arch>.h.  Let's at least add a comment clarifying that.  We can also
remove the empty definition in pkey_sighandler_tests.c:
expected_pkey_fault() is not meant to be called from there.

Link: https://lkml.kernel.org/r/20241209095019.1732120-10-kevin.brodsky@arm.com
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

 tools/testing/selftests/mm/pkey-helpers.h          |    6 ++++--
 tools/testing/selftests/mm/pkey_sighandler_tests.c |    2 --
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/pkey-helpers.h~selftests-mm-remove-empty-pkey-helper-definition
+++ a/tools/testing/selftests/mm/pkey-helpers.h
@@ -84,10 +84,12 @@ extern void abort_hooks(void);
 # define noinline __attribute__((noinline))
 #endif
 
-noinline int read_ptr(int *ptr);
-void expected_pkey_fault(int pkey);
 int sys_pkey_alloc(unsigned long flags, unsigned long init_val);
 int sys_pkey_free(unsigned long pkey);
+
+/* For functions called from protection_keys.c only */
+noinline int read_ptr(int *ptr);
+void expected_pkey_fault(int pkey);
 int mprotect_pkey(void *ptr, size_t size, unsigned long orig_prot,
 		unsigned long pkey);
 void record_pkey_malloc(void *ptr, long size, int prot);
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-remove-empty-pkey-helper-definition
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -32,8 +32,6 @@
 
 #define STACK_SIZE PTHREAD_STACK_MIN
 
-void expected_pkey_fault(int pkey) {}
-
 pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
 pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
 siginfo_t siginfo = {0};
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

