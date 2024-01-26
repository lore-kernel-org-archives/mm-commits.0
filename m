Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165FA6FB9
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235355; cv=none; b=XzqBIa6tA2LzlyGDUR0GT1MXhUaveKse+SMZxxkQrnf3oMrSfpiiC2aX72Ufvnz+pp4HOgEVKz7SCRGIyEaj+bmUdiA7EjVjXOqdO5us7jvhy0Tac/+H/UreY7+pNDG0gC3c7ScK0AAfe587Qql9e3ZHB2N03BgI5xKLWvSxAv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235355; c=relaxed/simple;
	bh=PwsE+7cVWsj1YWF4Q3zwswVhk/elNwmoKGIpRX8SI5s=;
	h=Date:To:From:Subject:Message-Id; b=YSFFLhtu8GUK/JOj8fIzcdANrvLC6y14Jo6SVSSZEP89ApYra909pcFVdsBEIgks6TM0LHDJJbDaAbeDyr8/11dvBj3rWqqhBUc1/OmdjmlL+SyMk6H0jnj0y/y6iz1SY6Mg5q3DFvRexo2sod1oEawIubTazdSvuk0UMDWQ/Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KTJeIi/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KTJeIi/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE20C433F1;
	Fri, 26 Jan 2024 02:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235354;
	bh=PwsE+7cVWsj1YWF4Q3zwswVhk/elNwmoKGIpRX8SI5s=;
	h=Date:To:From:Subject:From;
	b=KTJeIi/NmusY/wJrXWtHhB/D/c0T6ebF6k+/NJCtZuwwjjnDOrr6rE5L1y4QXkEpm
	 rSbwBW8ImssSzQE/vAqD/pqWYsEW6Nq5y6Sp6IIML/PtL5Y5Las3ny9amE35YvsNDy
	 UaDyVOuXVMNWtUiPgfgiNSj421X/LB9Zs2k/5tl0=
Date: Thu, 25 Jan 2024 18:15:51 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-run_vmtestssh-add-missing-tests.patch added to mm-nonmm-unstable branch
Message-Id: <20240126021554.1DE20C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: run_vmtests.sh: add missing tests
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-mm-run_vmtestssh-add-missing-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-run_vmtestssh-add-missing-tests.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: run_vmtests.sh: add missing tests
Date: Thu, 25 Jan 2024 20:46:08 +0500

Add missing tests to run_vmtests.sh.  The mm kselftests are run through
run_vmtests.sh.  If a test isn't present in this script, it'll not run
with run_tests or `make -C tools/testing/selftests/mm run_tests`.

Link: https://lkml.kernel.org/r/20240125154608.720072-6-usama.anjum@collabora.com
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile       |    5 +++++
 tools/testing/selftests/mm/run_vmtests.sh |    8 ++++++++
 2 files changed, 13 insertions(+)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-run_vmtestssh-add-missing-tests
+++ a/tools/testing/selftests/mm/Makefile
@@ -115,6 +115,11 @@ TEST_PROGS := run_vmtests.sh
 TEST_FILES := test_vmalloc.sh
 TEST_FILES += test_hmm.sh
 TEST_FILES += va_high_addr_switch.sh
+TEST_FILES += charge_reserved_hugetlb.sh
+TEST_FILES += hugetlb_reparenting_test.sh
+
+# required by charge_reserved_hugetlb.sh
+TEST_FILES += write_hugetlb_memory.sh
 
 include ../lib.mk
 
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtestssh-add-missing-tests
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -19,6 +19,7 @@ usage: ${BASH_SOURCE[0]:-$0} [ options ]
   -t: specify specific categories to tests to run
   -h: display this message
   -n: disable TAP output
+  -d: run destructive tests
 
 The default behavior is to run required tests only.  If -a is specified,
 will run all tests.
@@ -79,6 +80,7 @@ EOF
 }
 
 RUN_ALL=false
+RUN_DESTRUCTIVE_TEST=false
 TAP_PREFIX="# "
 
 while getopts "aht:n" OPT; do
@@ -87,6 +89,7 @@ while getopts "aht:n" OPT; do
 		"h") usage ;;
 		"t") VM_SELFTEST_ITEMS=${OPTARG} ;;
 		"n") TAP_PREFIX= ;;
+		"a") RUN_DESTRUCTIVE_TEST=true ;;
 	esac
 done
 shift $((OPTIND -1))
@@ -314,6 +317,11 @@ CATEGORY="process_mrelease" run_test ./m
 CATEGORY="mremap" run_test ./mremap_test
 
 CATEGORY="hugetlb" run_test ./thuge-gen
+CATEGORY="hugetlb" run_test ./charge_reserved_hugetlb.sh -cgroup-v2
+CATEGORY="hugetlb" run_test ./hugetlb_reparenting_test.sh -cgroup-v2
+if $RUN_DESTRUCTIVE_TEST; then
+CATEGORY="hugetlb" run_test ./hugetlb-read-hwpoison
+fi
 
 if [ $VADDR64 -ne 0 ]; then
 
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-mremap_test-fix-build-warning.patch
selftests-mm-switch-to-bash-from-sh.patch
selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch

