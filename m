Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45F4C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011124; cv=none; b=Tgwrt+khrO0uyJi34kgEiwnvD52AJhfistcSQrZGVWiwogIrp/TewpJGOvP8FFbruyHcGR5g1dw1Cyy/Fz5mRtyIOV9fxPZwSqLtXm0KKO0xcjkpMYw9gbsQJ02f8UJzdLtl6dIDp8RWYA6sXA2APcCZNANDrE3eZthHjJzGVg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011124; c=relaxed/simple;
	bh=AOSg63ldx6ofZiTlTZ7KG+koC/OPGnORmtS6cNGy9jg=;
	h=Date:To:From:Subject:Message-Id; b=b/ZowiFqdD9ZgH9XY8KvOpFpK7q4BYDr8I2JJI9V6CcTsfZftMb3ZqiXxmJ13y5EG02BejD/Fe88N7smFAm3kEdaC6vytqEee6Sia2WPmFYirAPsOuZOUzSsoLCHiH2sLWlsiIPyx99jG5CoVfLLJLY30gLPf7/p3JM4unXSbTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NDQgCf27; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NDQgCf27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A916C4CEE4;
	Mon, 12 May 2025 00:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011124;
	bh=AOSg63ldx6ofZiTlTZ7KG+koC/OPGnORmtS6cNGy9jg=;
	h=Date:To:From:Subject:From;
	b=NDQgCf272OeZ9mc0uwhcdGp++lU22kgom49jzHsHALp2Sg++Q9g9sVsQFSzVsGeK6
	 XlXTpNoEEgN4KfOBSQSu+nyk2HC7Nh1IPAdJ1pafErobWt+6EHM0Kbsm/D6qkaD2GB
	 XRF4rAOj1VCgn5NIMqaYeOOWnp1DPliKHxrhvZew=
Date: Sun, 11 May 2025 17:52:04 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,ritesh.list@gmail.com,longman@redhat.com,liwang@redhat.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-restore-default-nr_hugepages-value-during-cleanup-in-hugetlb_reparenting_testsh.patch removed from -mm tree
Message-Id: <20250512005204.8A916C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: restore default nr_hugepages value during cleanup in hugetlb_reparenting_test.sh
has been removed from the -mm tree.  Its filename was
     selftests-mm-restore-default-nr_hugepages-value-during-cleanup-in-hugetlb_reparenting_testsh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Donet Tom <donettom@linux.ibm.com>
Subject: selftests/mm: restore default nr_hugepages value during cleanup in hugetlb_reparenting_test.sh
Date: Thu, 10 Apr 2025 05:07:48 -0500

During cleanup, the value of /proc/sys/vm/nr_hugepages is currently being
set to 0.  At the end of the test, if all tests pass, the original
nr_hugepages value is restored.  However, if any test fails, it remains
set to 0.

With this patch, we ensure that the original nr_hugepages value is
restored during cleanup, regardless of whether the test passes or fails.

Link: https://lkml.kernel.org/r/20250410100748.2310-1-donettom@linux.ibm.com
Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Cc: Li Wang <liwang@redhat.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb_reparenting_test.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh~selftests-mm-restore-default-nr_hugepages-value-during-cleanup-in-hugetlb_reparenting_testsh
+++ a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -56,7 +56,7 @@ function cleanup() {
   rmdir "$CGROUP_ROOT"/a/b 2>/dev/null
   rmdir "$CGROUP_ROOT"/a 2>/dev/null
   rmdir "$CGROUP_ROOT"/test1 2>/dev/null
-  echo 0 >/proc/sys/vm/nr_hugepages
+  echo $nr_hugepgs >/proc/sys/vm/nr_hugepages
   set -e
 }
 
_

Patches currently in -mm which might be from donettom@linux.ibm.com are


