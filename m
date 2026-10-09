Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F48406804
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525489; cv=none; b=GbvnAI7hEkB/E6Y6qeG6ieCkn3uvYlBCQYdjWWQivCeBD3/gbKMkp2ERGPfNrx6Lz7CTAGx8KuNbPuDmPEzxl+Ki5VId2tShTVc0/Cwi8+YNkV9WbT3u2oS3L+jAc3dnKxFvEMEYOgPRwVQzlAYFAj8vi9a7k7PbU6KuZ0WdZ8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525489; c=relaxed/simple;
	bh=T53f7lAbOrAupxjwnf3panZJXSKugGNDAEDGRkm+zaE=;
	h=Date:To:From:Subject:Message-Id; b=X0u9SWA5MKvOEdbRygBgNi6qTKk8lbqQFhH/G0PYWHRjkyQxwNjc3l/BxXA0n3EmmgLyP8nEyrzV49uIaJAhLwGT17iqCN8fM/QiQnqI8MjhReuEDLu/XkNTKMYlkUEcfQa8grUH6juzJQDFvcL8LvdZe0EwyeVRU5yEsfDtNIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EaO9qJyz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EaO9qJyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891A71F000FF;
	Fri,  9 Oct 2026 05:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525488;
	bh=zCTyb6Hu4oFP0RkUNjOzRQA3rhbkdOdjcXIPsI/PkyY=;
	h=Date:To:From:Subject;
	b=EaO9qJyzflt07kW5mMOsYKA6HeRjuho0Gn5vqk/lYlJ/LRYVWqjCIH2dZCiNaFxgu
	 Mofd6qXp1OZW5KN0Nu9+8pP4Rv/4uD/3yERzplBdTNGJoUQgHPttXfV6M1AnVqhk8A
	 2KNGtt11Pe/OpV3o6//lFdMjaCAnHxofJ8esAPrk=
Date: Thu, 08 Oct 2026 22:58:08 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,jsavitz@redhat.com,david@kernel.org,hi@tychen.cc,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-reject-invalid-test-selections-before-running-tests.patch removed from -mm tree
Message-Id: <20261009055808.891A71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: reject invalid test selections before running tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-reject-invalid-test-selections-before-running-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tianyi Chen <hi@tychen.cc>
Subject: selftests/mm: reject invalid test selections before running tests
Date: Thu, 10 Sep 2026 20:56:44 +0800

Patch series "selftests/mm: Validate selections and scope memfd_secret
setup", v3.

run_vmtests.sh can reach test setup after invalid options or category
selections.  Its memfd_secret preparation can also change ptrace_scope
when that category was not selected.

Patch 1 rejects invalid selections before setup.  Patch 2 gates
memfd_secret preparation on category selection and executable presence.


This patch (of 2):

getopts reports unknown options and missing arguments, but run_vmtests.sh
ignores its error result and continues with test setup.  An empty -t
argument also falls back to the default selection, while unknown category
names can silently select no tests and still reach setup code.

Exit on getopts errors and validate category names against the existing
list in usage() before any test setup.  Reject empty and whitespace-only
selections, and normalize category separators so validation and execution
agree.  Initialize the default selection before parsing options so only -t
changes the selection.

Link: https://lore.kernel.org/20260910125645.285866-1-diannaaav@gmail.com
Link: https://lore.kernel.org/20260910125645.285866-2-diannaaav@gmail.com
Fixes: 85463321e726 ("selftests/vm: enable running select groups of tests")
Signed-off-by: Tianyi Chen <hi@tychen.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Joel Savitz <jsavitz@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |   26 ++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-reject-invalid-test-selections-before-running-tests
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -96,26 +96,44 @@ separated by spaces:
 
 example: ./run_vmtests.sh -t "hmm mmap ksm"
 EOF
-	exit 0
 }
 
 RUN_ALL=false
 RUN_DESTRUCTIVE=false
 TAP_PREFIX="# "
 
+VM_SELFTEST_ITEMS="default"
+
 while getopts "aht:nd" OPT; do
 	case ${OPT} in
 		"a") RUN_ALL=true ;;
-		"h") usage ;;
+		"h") usage; exit 0 ;;
 		"t") VM_SELFTEST_ITEMS=${OPTARG} ;;
 		"n") TAP_PREFIX= ;;
 		"d") RUN_DESTRUCTIVE=true ;;
+		"?") exit 1 ;;
 	esac
 done
 shift $((OPTIND -1))
 
-# default behavior: run all tests
-VM_SELFTEST_ITEMS=${VM_SELFTEST_ITEMS:-default}
+# Normalize whitespace so validation and test_selected() use the same names.
+read -r -a selected_categories <<< "${VM_SELFTEST_ITEMS//$'\n'/ }"
+VM_SELFTEST_ITEMS="${selected_categories[*]}"
+if [ -z "$VM_SELFTEST_ITEMS" ]; then
+	echo "No test categories specified" >&2
+	exit 1
+fi
+
+if [ "$VM_SELFTEST_ITEMS" != "default" ]; then
+	# Keep the documented category list as the source of valid names.
+	valid_categories=$(usage | sed -n 's/^- //p')
+	for category in "${selected_categories[@]}"; do
+		if ! grep -Fxq -- "$category" <<< "$valid_categories"; then
+			echo "Unknown test category: $category" >&2
+			exit 1
+		fi
+	done
+fi
 
 test_selected() {
 	if [ "$VM_SELFTEST_ITEMS" == "default" ]; then
_

Patches currently in -mm which might be from hi@tychen.cc are


