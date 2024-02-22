Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B017D13BAD8
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645215; cv=none; b=ThyxAJavnrUfqxb1k7G7uN0z5AvzRZqdZRxWogaOQ90CobmbG+mJWl6gGKNXGQLZ2hBYmjOXfRn/EpUHKId9e1GYzTPleFhoq+K/xfVRrjXgek9Oxny9ksvhVNODScS+1g/0oETeZ2lCPGnMXjc481zpOEtrGzEHEYunWoBEobA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645215; c=relaxed/simple;
	bh=5MLdCxwducfHTBbCbrC3jEOm7JGFJd9J3mBpOTfYfy4=;
	h=Date:To:From:Subject:Message-Id; b=Oj38JAJrIEb0poklAzVFpNHYbCV4BYDGkoH5Ed2gPc8rEXQQZMRpgfWklsblMHj7H1Y97zh/xWVixDq6zjjS4bU7PEYW3xhIDw2+2ArlphKywh6j0V3mIscg4iCEQ6UBVWPlidHjrbkvROxmymoNr67l1DAWCzMqgK2Q2nigThM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OadJcMe6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OadJcMe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EDEC433C7;
	Thu, 22 Feb 2024 23:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645215;
	bh=5MLdCxwducfHTBbCbrC3jEOm7JGFJd9J3mBpOTfYfy4=;
	h=Date:To:From:Subject:From;
	b=OadJcMe6t68OcZyuQtqpPQ1r9JqHyJgHVSoSZnBU/o+4ELMZoDfurGlueZK7GW7XK
	 PmAhBWo6DF3FnIC6Nsc5EyWnv0O4NM0NpIgwc1Mn84wAGqs6ZFKIqt4lJniMnACdrp
	 HPnfUVt8SpzK8CmvGqVdvav63gkZGbO/upXJNV9A=
Date: Thu, 22 Feb 2024 15:40:14 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-run_vmtestssh-add-missing-tests.patch removed from -mm tree
Message-Id: <20240222234015.27EDEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: run_vmtests.sh: add missing tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-run_vmtestssh-add-missing-tests.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: run_vmtests.sh: add missing tests
Date: Thu, 25 Jan 2024 20:46:08 +0500

Add missing tests to run_vmtests.sh.  The mm kselftests are run through
run_vmtests.sh.  If a test isn't present in this script, it'll not run
with run_tests or `make -C tools/testing/selftests/mm run_tests`.

[usama.anjum@collabora.com: use correct flag in the code]
  Link: https://lkml.kernel.org/r/20240201130538.1404897-2-usama.anjum@collabora.com
Link: https://lkml.kernel.org/r/20240125154608.720072-6-usama.anjum@collabora.com
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile       |    5 +++++
 tools/testing/selftests/mm/run_vmtests.sh |   10 +++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-run_vmtestssh-add-missing-tests
+++ a/tools/testing/selftests/mm/Makefile
@@ -114,6 +114,11 @@ TEST_PROGS := run_vmtests.sh
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
@@ -15,10 +15,11 @@ usage() {
 	cat <<EOF
 usage: ${BASH_SOURCE[0]:-$0} [ options ]
 
-  -a: run all tests, including extra ones
+  -a: run all tests, including extra ones (other than destructive ones)
   -t: specify specific categories to tests to run
   -h: display this message
   -n: disable TAP output
+  -d: run destructive tests
 
 The default behavior is to run required tests only.  If -a is specified,
 will run all tests.
@@ -79,6 +80,7 @@ EOF
 }
 
 RUN_ALL=false
+RUN_DESTRUCTIVE=false
 TAP_PREFIX="# "
 
 while getopts "aht:n" OPT; do
@@ -87,6 +89,7 @@ while getopts "aht:n" OPT; do
 		"h") usage ;;
 		"t") VM_SELFTEST_ITEMS=${OPTARG} ;;
 		"n") TAP_PREFIX= ;;
+		"d") RUN_DESTRUCTIVE=true ;;
 	esac
 done
 shift $((OPTIND -1))
@@ -309,6 +312,11 @@ CATEGORY="process_mrelease" run_test ./m
 CATEGORY="mremap" run_test ./mremap_test
 
 CATEGORY="hugetlb" run_test ./thuge-gen
+CATEGORY="hugetlb" run_test ./charge_reserved_hugetlb.sh -cgroup-v2
+CATEGORY="hugetlb" run_test ./hugetlb_reparenting_test.sh -cgroup-v2
+if $RUN_DESTRUCTIVE; then
+CATEGORY="hugetlb" run_test ./hugetlb-read-hwpoison
+fi
 
 if [ $VADDR64 -ne 0 ]; then
 
_

Patches currently in -mm which might be from usama.anjum@collabora.com are


