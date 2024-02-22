Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473741B7FE
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644903; cv=none; b=ZIQWwaVuef5WgHjxfjipbFJdPhqH672Gij2Twvsw7HxGn96rWqjGv0RpHDiQ3VwHQef4+ZNKgA8c9k0etcKktlPjNUnecz6kZoDLjReKgfrqvdyFDBRt5ao45rnFZWKqFMW3bPmR38nAAwiGt8vV3JVXq9fM+fMumABA/RgV+iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644903; c=relaxed/simple;
	bh=eF6hqYZdF9fhVT+BwE02Dt2cCFDKW+o8g6IxxMMpv6k=;
	h=Date:To:From:Subject:Message-Id; b=qCm5oZhXUQC3XiCU02kbPsiLQ9VJgVZd7TbVvcKbPaQyPq/ZdfXFXv1oU/3ODwk67WArQDDIqQaxl0DwaJifvNjuD9gUEtM2EIImoFvkbGvf/5GVbaiBNixu9nWWF0ZgDpLIMrJlb2hatsW6YgHeUBpAHC3OKzjjJaY48j9pBpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gEEFzNLB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gEEFzNLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18B2C433F1;
	Thu, 22 Feb 2024 23:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644902;
	bh=eF6hqYZdF9fhVT+BwE02Dt2cCFDKW+o8g6IxxMMpv6k=;
	h=Date:To:From:Subject:From;
	b=gEEFzNLBS7aQBzn5BpWQmfWSCdrz3q9BgqR9Q+KodxYjDmghwhGwC3ARNQb5gs7t3
	 gBRiImitO1VeGJIcPCUiZJArilgPLMX8TbIGxtyfC2XPdvRPcB2L4lJ115w2mvGm5F
	 4wzqJGD95VCXKBI3tsHMj2b7dHR3aDzC2nOHAJQg=
Date: Thu, 22 Feb 2024 15:35:02 -0800
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-run_vmtestssh-add-missing-tests-fix.patch removed from -mm tree
Message-Id: <20240222233502.A18B2C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: run_vmtests: use correct flag in the code
has been removed from the -mm tree.  Its filename was
     selftests-mm-run_vmtestssh-add-missing-tests-fix.patch

This patch was dropped because it was folded into selftests-mm-run_vmtestssh-add-missing-tests.patch

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
@@ -314,7 +314,7 @@ CATEGORY="mremap" run_test ./mremap_test
 CATEGORY="hugetlb" run_test ./thuge-gen
 CATEGORY="hugetlb" run_test ./charge_reserved_hugetlb.sh -cgroup-v2
 CATEGORY="hugetlb" run_test ./hugetlb_reparenting_test.sh -cgroup-v2
-if $RUN_DESTRUCTIVE_TEST; then
+if $RUN_DESTRUCTIVE; then
 CATEGORY="hugetlb" run_test ./hugetlb-read-hwpoison
 fi
 
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch

