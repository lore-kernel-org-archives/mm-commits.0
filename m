Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1C620E037
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 23:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744328552; cv=none; b=pz2LZhlC2jctW8wNglnjV+gpUKWD0O5J6bDa6Klk2mZ3wuVl1HLZs3WnEHs7inFaAoQbEAUWGDvHsa8mdeV8rj9IoDFYa1WiZG0VxlppWHvapXsEnQWukmUyNwFPHB4c+zQI9XHurKJIJRB+rx+281tVDxAIHbQwHKf/fCi7pUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744328552; c=relaxed/simple;
	bh=mON8suuJCzjJ2Uiu69TDdnHxRFFs1xe2a5j2qS6zvho=;
	h=Date:To:From:Subject:Message-Id; b=JHNjICOcE7wQA6ESSnxSwoMwCM+jtfUOB5ewL1+vieWawaBOooL5lRqXRlc5yJlKfcVi1T5NEugVY/srYEmajw5SmkJGXU9jRhDoi5mwNqMFjpL9sXSCITqkWt5wRrHcfPl6bnW2Eh4o2T8nFDeIcPKSDdje6tDyuq0P+/YSSsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dlxec0by; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dlxec0by"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E79C4CEDD;
	Thu, 10 Apr 2025 23:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744328551;
	bh=mON8suuJCzjJ2Uiu69TDdnHxRFFs1xe2a5j2qS6zvho=;
	h=Date:To:From:Subject:From;
	b=dlxec0bysR4pbu9gBHbcZXTqm/h1X65atiimHQwVfyo6TTgOT1RvHi24GBeqqJYA+
	 SVzMML131bslZQmIWdw0M4z43ius+YSlYqEwAGapFJPe6RKvVWwGraHjbo5vPs7LIt
	 Tw7a1etNEOgL2KGNkhAlBZFwuRQ8EPiqMIa40ae8=
Date: Thu, 10 Apr 2025 16:42:31 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,ritesh.list@gmail.com,longman@redhat.com,liwang@redhat.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-restore-default-nr_hugepages-value-during-cleanup-in-hugetlb_reparenting_testsh.patch added to mm-new branch
Message-Id: <20250410234231.B1E79C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: restore default nr_hugepages value during cleanup in hugetlb_reparenting_test.sh
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-restore-default-nr_hugepages-value-during-cleanup-in-hugetlb_reparenting_testsh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-restore-default-nr_hugepages-value-during-cleanup-in-hugetlb_reparenting_testsh.patch

This patch will later appear in the mm-new branch at
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

selftests-mm-restore-default-nr_hugepages-value-during-cleanup-in-hugetlb_reparenting_testsh.patch

