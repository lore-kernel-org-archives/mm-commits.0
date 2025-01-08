Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959287083A
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 04:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736310873; cv=none; b=sTBRdbjaHEgwLE4jJd18dYZzfx7IvB3OFQn6zJHHAXO4THBcmvRUz2GKpLXQRD0xVl3tXtq4bJb3ulgEuTBJojN2Shzirzf6EWsuysy5EtIwbLEQHhLNPGiRnk6TqlOOT79p1VEPcFw1U8qHSt8fC6UwU9+3bmqG7XbiJ6D2Odc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736310873; c=relaxed/simple;
	bh=LtTzCT72DknHXO6BK19tdLhHCK5qqtlJQrtFlUj/2Rg=;
	h=Date:To:From:Subject:Message-Id; b=KPVIGVbvdMXjy995VVgFkNXDzt52ov9/K0qdkO/yoCLicyjoijyiodA/Ne1fUD/83mtg/uxEx/ueriyuq5UpP38U6XSYK/vSJT7gIKjcQAfgKoinhRiefQZeMOegDacsYEY1ZBsuaviBm3Iv/vGjJ/PE2KpN5IFvQ4ma49o3Tc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0ZTO+tiK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0ZTO+tiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08ECAC4CEE1;
	Wed,  8 Jan 2025 04:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736310873;
	bh=LtTzCT72DknHXO6BK19tdLhHCK5qqtlJQrtFlUj/2Rg=;
	h=Date:To:From:Subject:From;
	b=0ZTO+tiKXKNc/S+2kvk/HJjpO8pY+FTZVsdeXgxocFcaer3LELboJuCgyfscEaZjH
	 EguyALZEqRMU7TEohv/cgfuIQAwOz8QgqH6KF4jG+ike082iQ57dfJUAsOD1gLQUPF
	 d0TixoMI2wAZIGZXOeVWPsylT5tcfAufZCs3Cn9s=
Date: Tue, 07 Jan 2025 20:34:32 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-build-with-o2-fix.patch added to mm-unstable branch
Message-Id: <20250108043433.08ECAC4CEE1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: silence unused-result warnings
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-build-with-o2-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-build-with-o2-fix.patch

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
Subject: selftests/mm: silence unused-result warnings
Date: Tue, 7 Jan 2025 17:01:10 +0000

Switching to -O2 when building the mm tests has the unexpected side effect
of triggering many unused-result warnings on certain distros like Ubuntu,
where GCC is configured so that -O2 implies -D_FORTIFY_SOURCE.

Explicitly disable FORTIFY_SOURCE to avoid those warnings. This has
no effect on upstream toolchains where FORTIFY_SOURCE is not
implicitly enabled.

Link: https://lkml.kernel.org/r/20250107170110.2819685-1-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Suggested-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-build-with-o2-fix
+++ a/tools/testing/selftests/mm/Makefile
@@ -36,6 +36,13 @@ MAKEFLAGS += --no-builtin-rules
 CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
 LDLIBS = -lrt -lpthread -lm
 
+# Some distributions (such as Ubuntu) configure GCC so that _FORTIFY_SOURCE is
+# automatically enabled at -O1 or above. This triggers various unused-result
+# warnings where functions such as read() or write() are called and their
+# return value is not checked. Disable _FORTIFY_SOURCE to silence those
+# warnings.
+CFLAGS += -U_FORTIFY_SOURCE
+
 KDIR ?= /lib/modules/$(shell uname -r)/build
 ifneq (,$(wildcard $(KDIR)/Module.symvers))
 ifneq (,$(wildcard $(KDIR)/include/linux/page_frag_cache.h))
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

selftests-mm-fix-condition-in-uffd_move_test_common.patch
selftests-mm-fix-wmaybe-uninitialized-warnings.patch
selftests-mm-fix-strncpy-length.patch
selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests.patch
selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests-fix.patch
selftests-mm-build-with-o2.patch
selftests-mm-build-with-o2-fix.patch
selftests-mm-remove-unused-pkey-helpers.patch
selftests-mm-define-types-using-typedef-in-pkey-helpersh.patch
selftests-mm-ensure-pkey-h-define-inline-functions-only.patch
selftests-mm-remove-empty-pkey-helper-definition.patch
selftests-mm-ensure-non-global-pkey-symbols-are-marked-static.patch
selftests-mm-use-sys_pkey-helpers-consistently.patch
selftests-mm-use-sys_pkey-helpers-consistently-fix.patch
selftests-mm-rename-pkey-register-macro.patch
selftests-mm-skip-pkey_sighandler_tests-if-support-is-missing.patch
selftests-mm-remove-x-permission-from-sigaltstack-mapping.patch
riscv-mm-skip-pgtable-level-check-in-pudp4d_alloc_one.patch
asm-generic-pgalloc-provide-generic-p4d_alloc_onefree.patch
mm-move-common-part-of-pagetable__ctor-to-helper.patch
parisc-mm-ensure-pagetable_pmd_tor-are-called.patch
m68k-mm-add-calls-to-pagetable_pmd_tor.patch
arm-mm-rename-pgd-helpers.patch
asm-generic-pgalloc-provide-generic-__pgd_allocfree.patch
mm-introduce-ctor-dtor-at-pgd-level.patch

