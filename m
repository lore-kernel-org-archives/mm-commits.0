Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5865D23C710
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837039; cv=none; b=nVswQzatFgdoKb9atjfUGlmccG215rKjs9+JwzEWu2+XO9yMCo2zeq9jJD8tXyv/ZbUFF/dh9H6vpuL2+/Ji+ImO3kIEQgSRpf6JdFb90ZB8OrsNZF/DfFDFLlk785RnUwN1d87c53LO2qGMOl516l6jD59zcpQq0Zwih0xhcdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837039; c=relaxed/simple;
	bh=x0kamAM77z0zMojB5QCE/5feUmAvitj2GNMWPKRwTJE=;
	h=Date:To:From:Subject:Message-Id; b=e1LIvusw9BUSDbjn8hp9dy0FxKrqJyQ4ymkeoMdvbQ4Zbk9+GG84RH2eR4OmVxFBxYxzSu1JSns2OK0TsGChTn6n7SWSW6MsRSKVc9ciep3kjTvA8bbJZCheniXxK/4Uj5qqJ+JOaS2HJooK3HkQsxbErSwDU7ivy8RlJ/eMlHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EJPgEq8T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EJPgEq8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D585C4CEDD;
	Tue, 14 Jan 2025 06:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837039;
	bh=x0kamAM77z0zMojB5QCE/5feUmAvitj2GNMWPKRwTJE=;
	h=Date:To:From:Subject:From;
	b=EJPgEq8TS9c+VHV0jFRj1PO3QjEteycKh/kdZDWc4115q6S5mc6CQK9Z5pjmZie0+
	 QXKcW2TGsrPjLNhR4IspZAJ9ipBnsfH9klmtCEDnWpowi4G6f13mbEqgX8ZTckRZf8
	 ugCUuzx+sdb5muWMS5TSQX+TScJ6LO283XPdXrqc=
Date: Mon, 13 Jan 2025 22:43:58 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-condition-in-uffd_move_test_common.patch removed from -mm tree
Message-Id: <20250114064359.2D585C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix condition in uffd_move_test_common()
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-condition-in-uffd_move_test_common.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


