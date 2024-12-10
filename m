Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED67136326
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 02:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733796498; cv=none; b=WxwvV0HIRTW1A2a+NsR1J+cSVR6fI2GL87Awu7ZfuZgBTYPBF2uRwmEnTzBiKI5ws2lP9GgdfM5NeD+F8elXyr4qP0EbtPBf53TN952OYFdJvXhtYY9AfV48SwBMtiXUPGvv4w2DJBsceW2byi8gG6QRXnkh0tLDuaDkGEBzr9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733796498; c=relaxed/simple;
	bh=DN9MaxMBJ2Kl2G4AkZngzhJbTkjMCTZAs1EdJs0uOeg=;
	h=Date:To:From:Subject:Message-Id; b=NKJ5dbQYo8Cnf2ejkeu8xAdoZyMeMIarwC90uR7W4aOH6OcixMZsD2aGMV78JMqWGjhVsRm5uVqyPTw4t9nunNDLENZyqcO10cwWnUxQbLn8JGr73x5XteAHJq3H9ggp5xEkW41oRtDe8h975+jOJEyj/iqFcVgxPAPzKvAiTKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ehguaK3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ehguaK3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3FFC4CED1;
	Tue, 10 Dec 2024 02:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733796496;
	bh=DN9MaxMBJ2Kl2G4AkZngzhJbTkjMCTZAs1EdJs0uOeg=;
	h=Date:To:From:Subject:From;
	b=ehguaK3UruJJ6OaRegJoLbVykG9QLA/CJs4WYGBLc7PBnGdJfyoP9oBS1C2vbFHeI
	 qtJf9oJoelsID/SzssRsaD3jTvS+2kh1+yqG8UPIAWFAvGv59vdchZzR8vT8dvlN7W
	 phXomHeS2+kMSscpPiSSmDe3lzoggjkHvcd+NvAY=
Date: Mon, 09 Dec 2024 18:08:16 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-pkey_sighandler_tests-if-support-is-missing.patch added to mm-unstable branch
Message-Id: <20241210020816.9C3FFC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip pkey_sighandler_tests if support is missing
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-skip-pkey_sighandler_tests-if-support-is-missing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-pkey_sighandler_tests-if-support-is-missing.patch

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
Subject: selftests/mm: skip pkey_sighandler_tests if support is missing
Date: Mon, 9 Dec 2024 09:50:18 +0000

The pkey_sighandler_tests are bound to fail if either the kernel or CPU
doesn't support pkeys.  Skip the tests if pkeys support is missing.

Link: https://lkml.kernel.org/r/20241209095019.1732120-14-kevin.brodsky@arm.com
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

 tools/testing/selftests/mm/pkey_sighandler_tests.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-skip-pkey_sighandler_tests-if-support-is-missing
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -535,6 +535,9 @@ int main(int argc, char *argv[])
 	ksft_print_header();
 	ksft_set_plan(ARRAY_SIZE(pkey_tests));
 
+	if (!is_pkeys_supported())
+		ksft_exit_skip("pkeys not supported\n");
+
 	for (i = 0; i < ARRAY_SIZE(pkey_tests); i++)
 		(*pkey_tests[i])();
 
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

