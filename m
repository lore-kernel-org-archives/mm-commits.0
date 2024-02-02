Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29E07763F
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706875958; cv=none; b=hUkeASkYcqiw0v2ZgxCu5oT1c7jZd4CcEg44rSCiQHmm1TPKV6SOp3PDz34KUtUmwsEJSpdyCE64x7TwZnchVUAibkPhachBnpgn/eMsgO9rN0p9p4lXl6RKHWU95gk3hNVyKKETMuNePsYkg8peFquTQ32qM4hsOofQ0w+viOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706875958; c=relaxed/simple;
	bh=lYMtMGub0ffvUs5F79pX3VOMPODwxSNI0PKTR8DbTfs=;
	h=Date:To:From:Subject:Message-Id; b=dgnrI5hNH3/VaPP5H6gQOdGYPoUQCw75+e1c4leqleKbfE84pGjaiwd02NBDFi33UItpeIjdOzMlnM8uyGSepWGpdnXaISDrXFtoeksfnoXxjHYkQbECuzFfYiFbefQ8CjbUHGTOxCBcwEIm+/O4wo+RMi7/rtFEjcftUXGQII8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f0+4Uqpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f0+4Uqpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDADAC433C7;
	Fri,  2 Feb 2024 12:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706875958;
	bh=lYMtMGub0ffvUs5F79pX3VOMPODwxSNI0PKTR8DbTfs=;
	h=Date:To:From:Subject:From;
	b=f0+4Uqpy6QzRjPJ6zCnqveHMIhuvxk1mKryOe6jhPVnqMKd4DwftR6I/bHL96xvh1
	 VGq7dS1KdaX8nyMpmOIGxgfM+NI59SBfg00ietyYwc/+/u29RJWKBZ5SL7MUi2N1ae
	 wECIxfttB541Bis37DeYJjArpakGos7RJMt+MM+Q=
Date: Fri, 02 Feb 2024 04:12:35 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-run_vmtestssh-add-missing-tests-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20240202121237.DDADAC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: run_vmtests: use correct flag in the code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-mm-run_vmtestssh-add-missing-tests-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-run_vmtestssh-add-missing-tests-fix.patch

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
Subject: selftests/mm: run_vmtests: use correct flag in the code
Date: Thu, 1 Feb 2024 18:05:37 +0500

Use correct -d flag as mentioned in comments for destructive tests.
Rename variable and update comment for some clarification.

Link: https://lkml.kernel.org/r/20240201130538.1404897-2-usama.anjum@collabora.com
Fixes: cc7b9955344c ("selftests/mm: run_vmtests.sh: add missing tests")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtestssh-add-missing-tests-fix
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -15,7 +15,7 @@ usage() {
 	cat <<EOF
 usage: ${BASH_SOURCE[0]:-$0} [ options ]
 
-  -a: run all tests, including extra ones
+  -a: run all tests, including extra ones (other than destructive ones)
   -t: specify specific categories to tests to run
   -h: display this message
   -n: disable TAP output
@@ -80,7 +80,7 @@ EOF
 }
 
 RUN_ALL=false
-RUN_DESTRUCTIVE_TEST=false
+RUN_DESTRUCTIVE=false
 TAP_PREFIX="# "
 
 while getopts "aht:n" OPT; do
@@ -89,7 +89,7 @@ while getopts "aht:n" OPT; do
 		"h") usage ;;
 		"t") VM_SELFTEST_ITEMS=${OPTARG} ;;
 		"n") TAP_PREFIX= ;;
-		"a") RUN_DESTRUCTIVE_TEST=true ;;
+		"d") RUN_DESTRUCTIVE=true ;;
 	esac
 done
 shift $((OPTIND -1))
@@ -318,7 +318,7 @@ CATEGORY="mremap" run_test ./mremap_test
 CATEGORY="hugetlb" run_test ./thuge-gen
 CATEGORY="hugetlb" run_test ./charge_reserved_hugetlb.sh -cgroup-v2
 CATEGORY="hugetlb" run_test ./hugetlb_reparenting_test.sh -cgroup-v2
-if $RUN_DESTRUCTIVE_TEST; then
+if $RUN_DESTRUCTIVE; then
 CATEGORY="hugetlb" run_test ./hugetlb-read-hwpoison
 fi
 
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-core-include-linux-close_rangeh-for-close_range_-macros.patch
selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch
selftests-mm-run_vmtestssh-add-missing-tests-fix.patch
selftests-mm-hugepage-shm-conform-test-to-tap-format-output.patch
selftests-mm-hugepage-vmemmap-conform-test-to-tap-format-output.patch
selftests-mm-hugetlb-madvise-conform-test-to-tap-format-output.patch
selftests-mm-khugepaged-conform-test-to-tap-format-output.patch
selftests-mm-hugetlb-read-hwpoison-conform-test-to-tap-format-output.patch
selftests-mm-config-add-missing-configs.patch
selftests-mm-on-fault-limit-run-test-without-root-privileges-otherwise-skip.patch

