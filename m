Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B441C11
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235344; cv=none; b=T+askjdPo0Ktud1+VmPcmyZX9r7nm/9GA1JE3HuB8y9EGvFPJSk4KoMDXO3XQ6AI29E1PqnhWDNzfleCaELaT8X9wJWZF7Ev24JaWIJRE3u7kbEqdUZhpMrNUfJR2eHLWRxGgn3h6UivgSHWdlz+5IVz+xLjKo4dh1Od1PocUJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235344; c=relaxed/simple;
	bh=zNv6AlpKljn9So8yOEHacJusw/F02XSPJv4RR7V8y+8=;
	h=Date:To:From:Subject:Message-Id; b=EhndsONtCqt9YLQMQkPPKbTCw+gMff2p9Z5HEnXhKQFZHrsB0esgXzB3xfQpZR3FnJrhIvFkrKTwRcmcNSvpPEnLmandlcXjVj7XsPVoslrsRkzlXMR14Y+ynPUc2xArDg5bQ8TD1D7WguuX9+R0RhA5WD+jMLS06a0RzBsGUcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vQF3a4/Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vQF3a4/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DA5C433F1;
	Fri, 26 Jan 2024 02:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235344;
	bh=zNv6AlpKljn9So8yOEHacJusw/F02XSPJv4RR7V8y+8=;
	h=Date:To:From:Subject:From;
	b=vQF3a4/ZDAuA934odu+bNjhypFydHrFgFSuh3NO5lNIqDcbvfSX8szYUPgSRvl+q/
	 CPEs0rfR2yecPQrvPjqn+0llCRu2aRM8cPwWDn69JwcClsl2Be9sWy9qYyRrbxwKOU
	 7nTSm3jyAC1PhccMFaZBDBZfJB3psKy6bYCOyZus=
Date: Thu, 25 Jan 2024 18:15:40 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch added to mm-nonmm-unstable branch
Message-Id: <20240126021543.84DA5C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: hugetlb_reparenting_test: do not unmount
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch

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
Subject: selftests/mm: hugetlb_reparenting_test: do not unmount
Date: Thu, 25 Jan 2024 20:46:04 +0500

Patch series "selftests/mm: Improve run_vmtests.sh", v3.

In this series, I'm trying to add 3 missing tests to vm_runtests.sh which
is used to run all the tests in mm suite.  These tests weren't running by
CIs.  While enabling them and through review feedback, I've fixed some
problems in tests as well.  I've found more flakiness in more tests which
I'll be fixing with future patches.

hugetlb-read-hwpoison test is being added where it can only run with newly
added "-d" (destructive) flag only.  Not sure why it is failing again.  So
once it become stable, we can think of moving it to default set of tests
if it doesn't have any side-effect to them.


This patch (of 5):

Do not unmount the cgroup if it wasn't mounted by the test.  The earlier
patch had fixed this for charge_reserved_hugetlb, but not for this test. 
I'm adding fixes tag to that earlier patch.

Link: https://lkml.kernel.org/r/20240125154608.720072-1-usama.anjum@collabora.com
Link: https://lkml.kernel.org/r/20240125154608.720072-2-usama.anjum@collabora.com
Fixes: 209376ed2a84 ("selftests/vm: make charge_reserved_hugetlb.sh work with existing cgroup setting")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb_reparenting_test.sh |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh~selftests-mm-hugetlb_reparenting_test-do-not-unmount
+++ a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -248,5 +248,7 @@ cleanup
 
 echo ALL PASS
 
-umount $CGROUP_ROOT
-rm -rf $CGROUP_ROOT
+if [[ $do_umount ]]; then
+  umount $CGROUP_ROOT
+  rm -rf $CGROUP_ROOT
+fi
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-mremap_test-fix-build-warning.patch
selftests-mm-switch-to-bash-from-sh.patch
selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch

