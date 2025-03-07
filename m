Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B07523AD;
	Fri,  7 Mar 2025 00:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741306128; cv=none; b=khs0pIdlPubx0MXb4v643rzoxQedzjul1jm8X+MDodu7UcjL0bAtQBpeV+pNig9d/O9zhJ+SG7k+2VTpZxh845IP07xZpRlhRJRESVPvHX0sexaj4pTsf6lcrpGYTPuTQgUXGHvQEHDFoUtWIskmgI2kObXYC/vtN29cIv/1PxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741306128; c=relaxed/simple;
	bh=NvsJGOhayW2LbauVB//FuaX8DtkkNiDuI+8pRBv10S4=;
	h=Date:To:From:Subject:Message-Id; b=GGf/2pOf/Fv3Q3/sIKf0JWjMdJJ3k3/OWvi8NIe72gAxot8v1cNpFtwFOFh4JX6AFE0bpraIWccjOUgLFXSNRXH2GnGrQOMrBOqTu5BRtMeMBs6U5Vm5YrByZxwsljihOfhoLNmXmHLObIgDqZ6Nedq23cvrlDpUKr8PLn4p2lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yMMsFcG0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yMMsFcG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEED0C4CEE5;
	Fri,  7 Mar 2025 00:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741306128;
	bh=NvsJGOhayW2LbauVB//FuaX8DtkkNiDuI+8pRBv10S4=;
	h=Date:To:From:Subject:From;
	b=yMMsFcG0s1NI1yIaZxVswa50Un+phLY33IU69VnkTnTrMq07LJzu1IPAF62u3Qdbg
	 vLzjwhAPTXvP6pm03/rSX8umqG4/YYuvVQ2MSzkJIir2GPWoKNIKzfGoJsBreHrqN/
	 RzCwT5BCDRaVAT60JiiAGxzax+X0xl71ubayUQkA=
Date: Thu, 06 Mar 2025 16:08:47 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,peterx@redhat.com,david@redhat.com,raquini@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-run_vmtestssh-fix-half_ufd_size_mb-calculation.patch added to mm-hotfixes-unstable branch
Message-Id: <20250307000847.EEED0C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: run_vmtests.sh: fix half_ufd_size_MB calculation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-run_vmtestssh-fix-half_ufd_size_mb-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-run_vmtestssh-fix-half_ufd_size_mb-calculation.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

selftests-mm-run_vmtestssh-fix-half_ufd_size_mb-calculation.patch

