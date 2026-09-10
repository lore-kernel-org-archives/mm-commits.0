Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450C54718EC
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 21:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789076613; cv=none; b=pNA8rHNs8d283awIcQyG9VkKAuT7+OGOuy6hYnAzWpPjNSHCkHEBZQB0GjsXwqwOnGaDnD8SMa4MB0dl6gCoZx1gkZ8N4xcjO5a25qFP2oyYeGYn3dAqTVD0h0eGt4pV4Uf8XfWaFj/BmRBEuuLEReJCnPKQsy3F/24eE9u8eiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789076613; c=relaxed/simple;
	bh=xZRM5/TwUF+buN+KNnIH9aHAjdqsODFoQtNuCyi4YV4=;
	h=Date:To:From:Subject:Message-Id; b=fuHPB3OXb6r0i8ZseJnHxgeqINHqiHOkDZ1H2aN9Bo+i+d1Bu+MBNLXqQ7IFmRTFvNNXuqIeD3PdOvd7LS1WaB+PiOCw/im4gSo7BufcTI7TVnp6RlFxC0Ahs0POQ8O3gMYMWDWMxViz4PA5O/yswwxuzjshs8dQ8hkr0Gp6dpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jC1j0+E1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jC1j0+E1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B093B1F000FF;
	Thu, 10 Sep 2026 21:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789076611;
	bh=GAMUoLooRLTO5XHNBrBHO4MzcH3mKFNKobt6ZRUrgqg=;
	h=Date:To:From:Subject;
	b=jC1j0+E17d1YMIfDTtu8K0b5/1NYeDYisFJA1dFcVdoqn5gbp4RV7P5y1AgiB2y44
	 IN2UA36VkB4TslndLk8Sl0Lkagn+2f+zbjJHVVJA69sZOn9GO2C0PlvSMRSom70vgC
	 bpTMz81UQrnCNfEw7+MsnRf2/q07DEM8kPkgyeHc=
Date: Thu, 10 Sep 2026 14:43:31 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,jsavitz@redhat.com,david@kernel.org,hi@tychen.cc,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-reject-invalid-test-selections-before-running-tests.patch added to mm-new branch
Message-Id: <20260910214331.B093B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: reject invalid test selections before running tests
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-reject-invalid-test-selections-before-running-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-reject-invalid-test-selections-before-running-tests.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Assisted-by: LLM
Signed-off-by: Tianyi Chen <hi@tychen.cc>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Joel Savitz <jsavitz@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

selftests-mm-reject-invalid-test-selections-before-running-tests.patch
selftests-mm-only-prepare-ptrace_scope-when-memfd_secret-is-selected.patch

