Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEF512DD95;
	Mon, 17 Mar 2025 00:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742172078; cv=none; b=VhpQdSzumURcWWYfisFqVTsFFw3Wppmq7iVSJUeShisynfLpr/bPGaq4fPS/3IGsQpk6eTDVIrAsIk6Po4a8B3uvjscd8X9ujzEyanQsRb32SmWWnauu5LAiyVSddKZPx0AwutsmThagvjmx6Iq5RnVg/QklbCkGZvGhjht/YRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742172078; c=relaxed/simple;
	bh=RNPSi08xreO7dEN//XWC/MpGF7TkXfArpxnlYosbqng=;
	h=Date:To:From:Subject:Message-Id; b=pK8MYMtrr4YWbfEQKoKNRxg7d+IgaiujhwD5XPzUuy+uZtjUQwkTDu4bYxC844cjOJnNCalFYg0YzkPHOVtoLmpNbaqo4/XPkVXfbV+/rnsM+hEKFz56+DqirUiQbERKz4C20Hh7+fBy6BZuPY7PeHhNmOyeO7pVovwQ3F5pnsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oZx+XbtN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oZx+XbtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537A0C4CEDD;
	Mon, 17 Mar 2025 00:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742172078;
	bh=RNPSi08xreO7dEN//XWC/MpGF7TkXfArpxnlYosbqng=;
	h=Date:To:From:Subject:From;
	b=oZx+XbtNewt1ZUmjzrSbtp9BL4yzETAIaUBVOzRoj6sMv1b7gkItVC4SR42AGnt5A
	 vyU+I6rrSaLD3UaMHhAgZbG6rqBrF7oe2Pfdkberv5KHgW4WLvVfBJsCRLNxgrkkJI
	 V9zdtluL0PwCZMofr68mDjb/B9SNalUYEkEWwnJ4=
Date: Sun, 16 Mar 2025 17:41:17 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,peterx@redhat.com,david@redhat.com,raquini@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-run_vmtestssh-fix-half_ufd_size_mb-calculation.patch removed from -mm tree
Message-Id: <20250317004118.537A0C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: run_vmtests.sh: fix half_ufd_size_MB calculation
has been removed from the -mm tree.  Its filename was
     selftests-mm-run_vmtestssh-fix-half_ufd_size_mb-calculation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rafael Aquini <raquini@redhat.com>
Subject: selftests/mm: run_vmtests.sh: fix half_ufd_size_MB calculation
Date: Tue, 18 Feb 2025 14:22:51 -0500

We noticed that uffd-stress test was always failing to run when invoked
for the hugetlb profiles on x86_64 systems with a processor count of 64 or
bigger:

  ...
  # ------------------------------------
  # running ./uffd-stress hugetlb 128 32
  # ------------------------------------
  # ERROR: invalid MiB (errno=9, @uffd-stress.c:459)
  ...
  # [FAIL]
  not ok 3 uffd-stress hugetlb 128 32 # exit=1
  ...

The problem boils down to how run_vmtests.sh (mis)calculates the size of
the region it feeds to uffd-stress.  The latter expects to see an amount
of MiB while the former is just giving out the number of free hugepages
halved down.  This measurement discrepancy ends up violating uffd-stress'
assertion on number of hugetlb pages allocated per CPU, causing it to bail
out with the error above.

This commit fixes that issue by adjusting run_vmtests.sh's
half_ufd_size_MB calculation so it properly renders the region size in
MiB, as expected, while maintaining all of its original constraints in
place.

Link: https://lkml.kernel.org/r/20250218192251.53243-1-aquini@redhat.com
Fixes: 2e47a445d7b3 ("selftests/mm: run_vmtests.sh: fix hugetlb mem size calculation")
Signed-off-by: Rafael Aquini <raquini@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtestssh-fix-half_ufd_size_mb-calculation
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -304,7 +304,9 @@ uffd_stress_bin=./uffd-stress
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} anon 20 16
 # Hugetlb tests require source and destination huge pages. Pass in half
 # the size of the free pages we have, which is used for *each*.
-half_ufd_size_MB=$((freepgs / 2))
+# uffd-stress expects a region expressed in MiB, so we adjust
+# half_ufd_size_MB accordingly.
+half_ufd_size_MB=$(((freepgs * hpgsize_KB) / 1024 / 2))
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb "$half_ufd_size_MB" 32
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb-private "$half_ufd_size_MB" 32
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem 20 16
_

Patches currently in -mm which might be from raquini@redhat.com are


