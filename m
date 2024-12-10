Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807AB233129
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 02:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733796472; cv=none; b=mxYomX1aymw88ZS3YeZOjeIu3KmmaVG9d2nyL4HQWm9dr+P0Kg7MwLr4b3CoGspQPDFC1mT2No8Mo1ELeGLfrIwbBRx0tObVJkb2rXB2zYlfcea8jk44NlxZfPPVL4wPKdeQ0CVIzfWkiqFdjMpAIU4yctqIkQ297+sTu4A4b/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733796472; c=relaxed/simple;
	bh=SWN6DyvNMyuJGOcwmpPBpv4Ec51E/q3HD8gvxzGM+7g=;
	h=Date:To:From:Subject:Message-Id; b=JVoF6ZDsihqyNExcnPif/y78sGdSrUbJ7CtdX5eqeMBnYxSHD9OJLmOYwQ/2omS+PJHM3N7vmuDEsPCo6JlX08fqHqFgHhgaSfNbSXN7e9883nqrxP8PBR/vnpLQTMgDYZXY/nxHTnRCyjEA+88aQuE27PSXbQPQnNxP9cPEnDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=be8XpB2E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="be8XpB2E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F801C4CED1;
	Tue, 10 Dec 2024 02:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733796471;
	bh=SWN6DyvNMyuJGOcwmpPBpv4Ec51E/q3HD8gvxzGM+7g=;
	h=Date:To:From:Subject:From;
	b=be8XpB2ElCyYSKs0dAzxO9VbmJMOiCAy1wl5/t5wKV/BYA5IosDyJORSGlC1C9Uy9
	 PtbsEHyGfi0JDd65clDBvxII0Ae0vT5ks0f8NAebP8p/aMPEaFFl68cilfXXUX11f/
	 8lNEFEAQs7zke48dfTT0x9W8QlW3zRFj5S7AB2c8=
Date: Mon, 09 Dec 2024 18:07:50 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-strncpy-length.patch added to mm-unstable branch
Message-Id: <20241210020751.0F801C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix strncpy() length
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-strncpy-length.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-strncpy-length.patch

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
Subject: selftests/mm: fix strncpy() length
Date: Mon, 9 Dec 2024 09:50:08 +0000

GCC complains (with -O2) that the length is equal to the destination size,
which is indeed invalid.  Subtract 1 from the size of the array to leave
room for '\0'.

Link: https://lkml.kernel.org/r/20241209095019.1732120-4-kevin.brodsky@arm.com
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

 tools/testing/selftests/mm/write_to_hugetlbfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/write_to_hugetlbfs.c~selftests-mm-fix-strncpy-length
+++ a/tools/testing/selftests/mm/write_to_hugetlbfs.c
@@ -89,7 +89,7 @@ int main(int argc, char **argv)
 			size = atoi(optarg);
 			break;
 		case 'p':
-			strncpy(path, optarg, sizeof(path));
+			strncpy(path, optarg, sizeof(path) - 1);
 			break;
 		case 'm':
 			if (atoi(optarg) >= MAX_METHOD) {
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

