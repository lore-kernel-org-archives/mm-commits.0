Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78340233129
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 02:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733796466; cv=none; b=H75j18V0Xm5laFc0T4c1tWG+2F0oCMdUeFK+VfhsTZF2u/1ft1/cKH1R41zeJtxQplYvlQZuMyYpX6OtAezC08MvmFq8OvfTOBxifBRt59MNis8jJwFIMmo1/5mlss+BwfxyR2pvAyfj00j1obBZzUCWFiOr7uMuzbAx5yA3JBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733796466; c=relaxed/simple;
	bh=aQv56eFR4YU1PeObP10ofxnlpT79z7etEem/lACP3ro=;
	h=Date:To:From:Subject:Message-Id; b=ivOkxFIhS2/pLhB4T69eQ729Vum4T20/r0hvVT8QnqfV6hzyGcX1ltpTQqNzn3gvVSyK/CRT4GEmstjUHZeYQZY+StUTd2qQrmZrPWU60eiOj3uG3GvM2DOlDqkgCrR8sTPJIY9pOtST9Z4GviKd9vfYYS2V3tPtdqXlBH6ZAps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kJpIocsK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kJpIocsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EB4C4CED1;
	Tue, 10 Dec 2024 02:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733796465;
	bh=aQv56eFR4YU1PeObP10ofxnlpT79z7etEem/lACP3ro=;
	h=Date:To:From:Subject:From;
	b=kJpIocsK1A+iBwnYxMcSNUcPLk0QOe17fCj44TUhiWhgdrkCKK58rNANlJ0xyC1Hz
	 K3vga/cLAp13WEOUgUhrukByqq8l7mAHpxGz9tttviklmoU+8dW85PKzgU0PH2UxoR
	 wkomE6HTWRCp1oGd1JPTzizQkKzFzyyRvtYRA1Xs=
Date: Mon, 09 Dec 2024 18:07:45 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-condition-in-uffd_move_test_common.patch added to mm-unstable branch
Message-Id: <20241210020745.D6EB4C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix condition in uffd_move_test_common()
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-condition-in-uffd_move_test_common.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-condition-in-uffd_move_test_common.patch

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
Subject: selftests/mm: fix condition in uffd_move_test_common()
Date: Mon, 9 Dec 2024 09:50:06 +0000

Patch series "pkeys kselftests improvements".

This series brings various cleanups and fixes for the mm (mostly pkeys)
kselftests.  The original goal was to make the pkeys tests work out of the
box and without build warning - it turned out to be more involved than
expected.

The most important change is enabling -O2 when building all mm kselftests
(patch 5).  This is actually needed for the pkeys tests to run
successfully (see gcc command line at the top of protection_keys.c and
pkey_sighandler_tests.c), and seems to have no negative impact on the
other tests.  It certainly can't hurt performance!

The following patches address a few obvious issues in the pkeys tests
(unused code, bad scope for functions/variables, etc.) and finally make a
couple of small improvements.

There is one ugliness that this series does not fix: some functions in
pkey-<arch>.h call functions that are actually defined in
protection_keys.c.  For instance, expect_fault_on_read_execonly_key() in
pkey-x86.h calls expected_pkey_fault().  This means that other test
programs that use pkey-helpers.h (namely pkey_sighandler_tests) would fail
to link if they called such functions defined in pkey-<arch>.h.  Fixing
this would require a more comprehensive reorganisation of the pkey-*
headers, which doesn't seem worth it (patch 9 adds a comment to
pkey-helpers.h to clarify the situation).

Some more details on the patches:

- Patch 1 is an unrelated fix that was revealed by inspecting a warning.
  It seems fairly harmless though, so I thought I'd just post it as part
  of this series.

- Patch 2-5 fix various warnings that come up by building the mm tests
  at -O2 and finally enable -O2.

- Patch 6-12 are various cleanups for the pkeys tests. Patch 11 in
  particular enables is_pkeys_supported() to be called from outside
  protection_keys.c (patch 13 relies on this).

- Patch 13-14 are small improvements to pkey_sighandler_tests.c.

Many thanks to Ryan Roberts for checking that the mm tests still run fine
on arm64 with those patches applied.  I've also checked that the pkeys
tests run fine on arm64 and x86.


This patch (of 14):

area_src and area_dst are saved at the beginning of the function if
chunk_size > page_size.  The intention is quite clearly to restore them at
the end based on the same condition, but step_size is considered instead
of chunk_size.  Considering that step_size is a number of pages, the
condition is likely to be false.

Use the same condition as when saving so that the globals are restored as
intended.

Link: https://lkml.kernel.org/r/20241209095019.1732120-1-kevin.brodsky@arm.com
Link: https://lkml.kernel.org/r/20241209095019.1732120-2-kevin.brodsky@arm.com
Fixes: a2bf6a9ca805 ("selftests/mm: add UFFDIO_MOVE ioctl test")
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

 tools/testing/selftests/mm/uffd-unit-tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-fix-condition-in-uffd_move_test_common
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1190,7 +1190,7 @@ uffd_move_test_common(uffd_test_args_t *
 				    nr, count, count_verify[src_offs + nr + i]);
 		}
 	}
-	if (step_size > page_size) {
+	if (chunk_size > page_size) {
 		area_src = orig_area_src;
 		area_dst = orig_area_dst;
 	}
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

