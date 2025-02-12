Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE47202F9F
	for <mm-commits@vger.kernel.org>; Wed, 12 Feb 2025 21:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739396217; cv=none; b=EPPMsQMFYKLeSq32An9riAlmfQoY6Lo2WK0QjX0C5RDUOMekem1l/Itgv5ldcc6IJCOGn9vM03Lu+oawdk/5EEE8mm8ofW2mHW/XGMWqJg7Nt/FUcAajWPuHIInN//4EooICt7O4aBXC/f74O2worgA0paadl1IuIExMFCw2JX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739396217; c=relaxed/simple;
	bh=uOzce7J48fNOg43I/e2Jx9yitho8x9gdAy6iMKs7OAA=;
	h=Date:To:From:Subject:Message-Id; b=bGlmqNzQF/b30Dy345DLpWjAGlye0qcWHquPWAmogccrtiNNY/WZkVqJjUm8rDlDe0j9kd500KeI0Q9rg9xaeG0nvHCFcw9L+pbggu8q3+CgDCMZQutrFQ8yBmkRBEiFWi6xYPxxGVbCAAn1SUpE1wiHB8yLrYxcT7r8CE3bWdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J3Bw6pWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J3Bw6pWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25B3C4CEE9;
	Wed, 12 Feb 2025 21:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739396217;
	bh=uOzce7J48fNOg43I/e2Jx9yitho8x9gdAy6iMKs7OAA=;
	h=Date:To:From:Subject:From;
	b=J3Bw6pWfPEaOuMuxP8CAoqNfkhNh0ALdOhwmNKUCZzHzlFpvyT4t/BvTIcfVTztNs
	 XSkVTabZDz2D4sa9dRdJTqP9BF4Fxu0B+MiTOTcw/ZP15yDTi/aJHiP9UNpuHjoHGz
	 CQovq9ephL7FAdfZMxp4MER54Ui4RT1XIJoMXxXo=
Date: Wed, 12 Feb 2025 13:36:56 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,npache@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-allow-tests-to-run-with-no-huge-pages-support.patch added to mm-unstable branch
Message-Id: <20250212213656.E25B3C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: allow tests to run with no huge pages support
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-allow-tests-to-run-with-no-huge-pages-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-allow-tests-to-run-with-no-huge-pages-support.patch

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
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: allow tests to run with no huge pages support
Date: Wed, 12 Feb 2025 17:44:26 +0000

Currently the mm selftests refuse to run if huge pages are not available
in the current system but this is an optional feature and not all the
tests actually require them.  Change the test during startup to be
non-fatal and skip or omit tests which actually rely on having huge pages,
allowing the other tests to be run.

The gup_test does support using madvise() to configure huge pages but it
ignores the error code so we just let it run.

Link: https://lkml.kernel.org/r/20250212-kselftest-mm-no-hugepages-v1-2-44702f538522@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Mariano Pache <npache@redhat.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |   66 ++++++++++++--------
 1 file changed, 42 insertions(+), 24 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-allow-tests-to-run-with-no-huge-pages-support
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -187,9 +187,10 @@ if [ -n "$freepgs" ] && [ -n "$hpgsize_K
 		printf "Not enough huge pages available (%d < %d)\n" \
 		       "$freepgs" "$needpgs"
 	fi
+	HAVE_HUGEPAGES=1
 else
 	echo "no hugetlbfs support in kernel?"
-	exit 1
+	HAVE_HUGEPAGES=0
 fi
 
 # filter 64bit architectures
@@ -218,13 +219,20 @@ pretty_name() {
 # Usage: run_test [test binary] [arbitrary test arguments...]
 run_test() {
 	if test_selected ${CATEGORY}; then
+		local skip=0
+
 		# On memory constrainted systems some tests can fail to allocate hugepages.
 		# perform some cleanup before the test for a higher success rate.
 		if [ ${CATEGORY} == "thp" -o ${CATEGORY} == "hugetlb" ]; then
-			echo 3 > /proc/sys/vm/drop_caches
-			sleep 2
-			echo 1 > /proc/sys/vm/compact_memory
-			sleep 2
+			if [ "${HAVE_HUGEPAGES}" = "1" ]; then
+				echo 3 > /proc/sys/vm/drop_caches
+				sleep 2
+				echo 1 > /proc/sys/vm/compact_memory
+				sleep 2
+			else
+				echo "hugepages not supported" | tap_prefix
+				skip=1
+			fi
 		fi
 
 		local test=$(pretty_name "$*")
@@ -232,8 +240,12 @@ run_test() {
 		local sep=$(echo -n "$title" | tr "[:graph:][:space:]" -)
 		printf "%s\n%s\n%s\n" "$sep" "$title" "$sep" | tap_prefix
 
-		("$@" 2>&1) | tap_prefix
-		local ret=${PIPESTATUS[0]}
+		if [ "${skip}" != "1" ]; then
+			("$@" 2>&1) | tap_prefix
+			local ret=${PIPESTATUS[0]}
+		else
+			local ret=$ksft_skip
+		fi
 		count_total=$(( count_total + 1 ))
 		if [ $ret -eq 0 ]; then
 			count_pass=$(( count_pass + 1 ))
@@ -271,13 +283,15 @@ CATEGORY="hugetlb" run_test ./hugepage-v
 CATEGORY="hugetlb" run_test ./hugetlb-madvise
 CATEGORY="hugetlb" run_test ./hugetlb_dio
 
-nr_hugepages_tmp=$(cat /proc/sys/vm/nr_hugepages)
-# For this test, we need one and just one huge page
-echo 1 > /proc/sys/vm/nr_hugepages
-CATEGORY="hugetlb" run_test ./hugetlb_fault_after_madv
-CATEGORY="hugetlb" run_test ./hugetlb_madv_vs_map
-# Restore the previous number of huge pages, since further tests rely on it
-echo "$nr_hugepages_tmp" > /proc/sys/vm/nr_hugepages
+if [ "${HAVE_HUGEPAGES}" = "1" ]; then
+	nr_hugepages_tmp=$(cat /proc/sys/vm/nr_hugepages)
+	# For this test, we need one and just one huge page
+	echo 1 > /proc/sys/vm/nr_hugepages
+	CATEGORY="hugetlb" run_test ./hugetlb_fault_after_madv
+	CATEGORY="hugetlb" run_test ./hugetlb_madv_vs_map
+	# Restore the previous number of huge pages, since further tests rely on it
+	echo "$nr_hugepages_tmp" > /proc/sys/vm/nr_hugepages
+fi
 
 if test_selected "hugetlb"; then
 	echo "NOTE: These hugetlb tests provide minimal coverage.  Use"	  | tap_prefix
@@ -391,7 +405,9 @@ CATEGORY="memfd_secret" run_test ./memfd
 fi
 
 # KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
-CATEGORY="ksm" run_test ./ksm_tests -H -s 100
+if [ "${HAVE_HUGEPAGES}" = "1" ]; then
+	CATEGORY="ksm" run_test ./ksm_tests -H -s 100
+fi
 # KSM KSM_MERGE_TIME test with size of 100
 CATEGORY="ksm" run_test ./ksm_tests -P -s 100
 # KSM MADV_MERGEABLE test with 10 identical pages
@@ -440,15 +456,17 @@ CATEGORY="thp" run_test ./transhuge-stre
 
 # Try to create XFS if not provided
 if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
-    if test_selected "thp"; then
-        if grep xfs /proc/filesystems &>/dev/null; then
-            XFS_IMG=$(mktemp /tmp/xfs_img_XXXXXX)
-            SPLIT_HUGE_PAGE_TEST_XFS_PATH=$(mktemp -d /tmp/xfs_dir_XXXXXX)
-            truncate -s 314572800 ${XFS_IMG}
-            mkfs.xfs -q ${XFS_IMG}
-            mount -o loop ${XFS_IMG} ${SPLIT_HUGE_PAGE_TEST_XFS_PATH}
-            MOUNTED_XFS=1
-        fi
+    if [ "${HAVE_HUGEPAGES}" = "1" ]; then
+	if test_selected "thp"; then
+	    if grep xfs /proc/filesystems &>/dev/null; then
+		XFS_IMG=$(mktemp /tmp/xfs_img_XXXXXX)
+		SPLIT_HUGE_PAGE_TEST_XFS_PATH=$(mktemp -d /tmp/xfs_dir_XXXXXX)
+		truncate -s 314572800 ${XFS_IMG}
+		mkfs.xfs -q ${XFS_IMG}
+		mount -o loop ${XFS_IMG} ${SPLIT_HUGE_PAGE_TEST_XFS_PATH}
+		MOUNTED_XFS=1
+	    fi
+	fi
     fi
 fi
 
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-fix-check-for-running-thp-tests.patch
selftests-mm-fix-thuge-gen-test-name-uniqueness.patch
selftests-mm-allow-tests-to-run-with-no-huge-pages-support.patch

