Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18D4FBF4
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645211; cv=none; b=tHVOxl81IbWkZ9cUKcbwn8rQBIhHDSXyEFEqiCuMA1aSOiFBihsVlZUQbVSZotSq2R7uNBgx9nUQ+Z0ojEcLjFHnIcg3uw5Jv6IIIihQDjxTOG6wcklC78+HPG+T6FXz5pK7pVeZwNPXZq/vwUoyTa9XlOhgI0y/u83gb5y40Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645211; c=relaxed/simple;
	bh=KqRZ+bQSdn/r3dA8vucIpIv0U2wjQtrR51LPfzR4Hd0=;
	h=Date:To:From:Subject:Message-Id; b=Bi6YaSYQvdgcQa+wnuJYwj12ttYPU7gVy2wXEeINJQtSg9eRw3KhOnXhYKW9NEuoWDjqNscGOO/gv94O6u/Fr8YTZkUHecDQFvR56V0mW2liuOXSLcrhXkmQEkTrkEcXYckmXAZ0wNYcvBrRIRDkBuFGV/KsqJe0hPQwu2b9w6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tHpEd+V6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tHpEd+V6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B238C433C7;
	Thu, 22 Feb 2024 23:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645211;
	bh=KqRZ+bQSdn/r3dA8vucIpIv0U2wjQtrR51LPfzR4Hd0=;
	h=Date:To:From:Subject:From;
	b=tHpEd+V6hodlyLfKzo0q2uXGWUocD5ZHgBjDBt8eIsFU53WqlktXkImk/yR5Q3K3k
	 txpFfKWK4YJkIaf7XTcblOhhDY8Qto3IjCsFgVTGauN2PAeVEGt7l6UZ1BiOZ8+XjD
	 NPBVP9KR2uxzhs1/cvLHJRZBLgGZVMQwZ6qrY540=
Date: Thu, 22 Feb 2024 15:40:10 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch removed from -mm tree
Message-Id: <20240222234011.4B238C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: hugetlb_reparenting_test: do not unmount
has been removed from the -mm tree.  Its filename was
     selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


