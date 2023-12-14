Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBB863BD
	for <mm-commits@vger.kernel.org>; Thu, 14 Dec 2023 19:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YJ2+6yi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08202C433C7;
	Thu, 14 Dec 2023 19:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702580783;
	bh=2E1Qgzirc1K1FEdPHR6D+pYONJu5WH0h71BujvLkG+8=;
	h=Date:To:From:Subject:From;
	b=YJ2+6yi9v0K76jJI7dUMIUnaefNmCLCTUGEeuGNE4dyszVRjM6tMzzSWKUl8IV19F
	 yNTXz5i3SpAQUBvZslinQDyhRHhp193UqL6b4Dwe0sgPOT/DZMMryTcxZlnyN+HoM0
	 MYhf85K3ifV3J54l1ewuALv5Hd9tGq8lpKsChkFg=
Date: Thu, 14 Dec 2023 11:06:22 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,peterx@redhat.com,broonie@kernel.org,aishwarya.tcv@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-log-run_vmtestssh-results-in-tap-format.patch added to mm-nonmm-unstable branch
Message-Id: <20231214190623.08202C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: log run_vmtests.sh results in TAP format
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-mm-log-run_vmtestssh-results-in-tap-format.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-log-run_vmtestssh-results-in-tap-format.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm: log run_vmtests.sh results in TAP format
Date: Thu, 14 Dec 2023 16:24:34 +0000

When running tests on a CI system (e.g.  LAVA) it is useful to output test
results in TAP (Test Anything Protocol) format so that the CI can parse
the fine-grained results to show regressions.  Many of the mm selftest
binaries already output using the TAP format.  And the kselftests runner
(run_kselftest.sh) also uses the format.  CI systems such as LAVA can
already handle nested TAP reports.  However, with the mm selftests we have
3 levels of nesting (run_kselftest.sh -> run_vmtests.sh -> individual test
binaries) and the middle level did not previously support TAP, which
breaks the parser.

Let's fix that by teaching run_vmtests.sh to output using the TAP format. 
Ideally this would be opt-in via a command line argument to avoid the
possibility of breaking anyone's existing scripts that might scrape the
output.  However, it is not possible to pass arguments to tests invoked
via run_kselftest.sh.  So I've implemented an opt-out option (-n), which
will revert to the existing output format.

Future changes to this file should be aware of 2 new conventions:

 - output that is part of the TAP reporting is piped through tap_output
 - general output is piped through tap_prefix

Link: https://lkml.kernel.org/r/20231214162434.3580009-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Aishwarya TCV <aishwarya.tcv@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |   51 +++++++++++++++-----
 1 file changed, 39 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-log-run_vmtestssh-results-in-tap-format
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -5,6 +5,7 @@
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
+count_total=0
 count_pass=0
 count_fail=0
 count_skip=0
@@ -17,6 +18,7 @@ usage: ${BASH_SOURCE[0]:-$0} [ options ]
   -a: run all tests, including extra ones
   -t: specify specific categories to tests to run
   -h: display this message
+  -n: disable TAP output
 
 The default behavior is to run required tests only.  If -a is specified,
 will run all tests.
@@ -77,12 +79,14 @@ EOF
 }
 
 RUN_ALL=false
+TAP_PREFIX="# "
 
-while getopts "aht:" OPT; do
+while getopts "aht:n" OPT; do
 	case ${OPT} in
 		"a") RUN_ALL=true ;;
 		"h") usage ;;
 		"t") VM_SELFTEST_ITEMS=${OPTARG} ;;
+		"n") TAP_PREFIX= ;;
 	esac
 done
 shift $((OPTIND -1))
@@ -184,30 +188,52 @@ fi
 VADDR64=0
 echo "$ARCH64STR" | grep "$ARCH" &>/dev/null && VADDR64=1
 
+tap_prefix() {
+	sed -e "s/^/${TAP_PREFIX}/"
+}
+
+tap_output() {
+	if [[ ! -z "$TAP_PREFIX" ]]; then
+		read str
+		echo $str
+	fi
+}
+
+pretty_name() {
+	echo "$*" | sed -e 's/^\(bash \)\?\.\///'
+}
+
 # Usage: run_test [test binary] [arbitrary test arguments...]
 run_test() {
 	if test_selected ${CATEGORY}; then
+		local test=$(pretty_name "$*")
 		local title="running $*"
 		local sep=$(echo -n "$title" | tr "[:graph:][:space:]" -)
-		printf "%s\n%s\n%s\n" "$sep" "$title" "$sep"
+		printf "%s\n%s\n%s\n" "$sep" "$title" "$sep" | tap_prefix
 
-		"$@"
-		local ret=$?
+		("$@" 2>&1) | tap_prefix
+		local ret=${PIPESTATUS[0]}
+		count_total=$(( count_total + 1 ))
 		if [ $ret -eq 0 ]; then
 			count_pass=$(( count_pass + 1 ))
-			echo "[PASS]"
+			echo "[PASS]" | tap_prefix
+			echo "ok ${count_total} ${test}" | tap_output
 		elif [ $ret -eq $ksft_skip ]; then
 			count_skip=$(( count_skip + 1 ))
-			echo "[SKIP]"
+			echo "[SKIP]" | tap_prefix
+			echo "ok ${count_total} ${test} # SKIP" | tap_output
 			exitcode=$ksft_skip
 		else
 			count_fail=$(( count_fail + 1 ))
-			echo "[FAIL]"
+			echo "[FAIL]" | tap_prefix
+			echo "not ok ${count_total} ${test} # exit=$ret" | tap_output
 			exitcode=1
 		fi
 	fi # test_selected
 }
 
+echo "TAP version 13" | tap_output
+
 CATEGORY="hugetlb" run_test ./hugepage-mmap
 
 shmmax=$(cat /proc/sys/kernel/shmmax)
@@ -231,9 +257,9 @@ CATEGORY="hugetlb" run_test ./hugetlb_fa
 echo "$nr_hugepages_tmp" > /proc/sys/vm/nr_hugepages
 
 if test_selected "hugetlb"; then
-	echo "NOTE: These hugetlb tests provide minimal coverage.  Use"
-	echo "      https://github.com/libhugetlbfs/libhugetlbfs.git for"
-	echo "      hugetlb regression testing."
+	echo "NOTE: These hugetlb tests provide minimal coverage.  Use"	  | tap_prefix
+	echo "      https://github.com/libhugetlbfs/libhugetlbfs.git for" | tap_prefix
+	echo "      hugetlb regression testing."			  | tap_prefix
 fi
 
 CATEGORY="mmap" run_test ./map_fixed_noreplace
@@ -312,7 +338,7 @@ CATEGORY="hmm" run_test bash ./test_hmm.
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
 CATEGORY="madv_populate" run_test ./madv_populate
 
-echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
+(echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
 CATEGORY="memfd_secret" run_test ./memfd_secret
 
 # KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
@@ -369,6 +395,7 @@ CATEGORY="mkdirty" run_test ./mkdirty
 
 CATEGORY="mdwe" run_test ./mdwe_test
 
-echo "SUMMARY: PASS=${count_pass} SKIP=${count_skip} FAIL=${count_fail}"
+echo "SUMMARY: PASS=${count_pass} SKIP=${count_skip} FAIL=${count_fail}" | tap_prefix
+echo "1..${count_total}" | tap_output
 
 exit $exitcode
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-thp-introduce-multi-size-thp-sysfs-interface.patch
mm-thp-introduce-multi-size-thp-sysfs-interface-fix.patch
mm-thp-support-allocation-of-anonymous-multi-size-thp.patch
selftests-mm-kugepaged-restore-thp-settings-at-exit.patch
selftests-mm-factor-out-thp-settings-management.patch
selftests-mm-support-multi-size-thp-interface-in-thp_settings.patch
selftests-mm-khugepaged-enlighten-for-multi-size-thp.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-tests-for-anonymous-multi-size-thp.patch
selftests-mm-log-run_vmtestssh-results-in-tap-format.patch

