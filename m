Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C03B21CC5C
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545884; cv=none; b=PVOZIQfzFRVnvT4mTKaoSP6pKPqoDOPsyWpH57NzgSVBfobA1mgx0JItKMoSbnYCXSz41vqYZMoLzu82QPksD7eLiwZCJ/eoVLkvk1DjC366UGFkUo+08IldnhFEKRO+/d5T0fQ3wGwzdmuxpr6cXtepSU71zF9e6E3gQdc615k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545884; c=relaxed/simple;
	bh=SB229MURLXHd6Y8gbzZxUn6zrxhiANfRK9jBUt5DgAM=;
	h=Date:To:From:Subject:Message-Id; b=NaLLeFjHNnw0Slmf0CIqYUVv4NeASRvnjwt8LkRNEJpBt1UvK7S4spwztimEnm0A04pgDuJB+hLJCzoyXRHJPcci/sNUcgKazxti3HnXBfp63GMIteoiqh9M7fgU6wWe7S/wTWqAP9G3vkMg1BIJRnYSH1ugqyoBCEC+b37l0ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bFOFRyqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bFOFRyqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98408C4CEE4;
	Tue,  1 Apr 2025 22:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545883;
	bh=SB229MURLXHd6Y8gbzZxUn6zrxhiANfRK9jBUt5DgAM=;
	h=Date:To:From:Subject:From;
	b=bFOFRyqJzGWSUlSnMI8P4PK4pz/aak3Y+QxoNnsxV1ttadepbE/7Ei6JQHGvnio1r
	 Qi9fe1EdEWXhbsfQO5I4G8mXNNXA6iDHCyYuy4sHPqE5695RJabIBT/z31s9iG1mu6
	 +JUd2azmznchq/lh/tIaMXUGRmwP6I8mTfclgeUE=
Date: Tue, 01 Apr 2025 15:18:03 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,kirill.shutemov@linux.intel.com,dev.jain@arm.com,anshuman.khandual@arm.com,liwang@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftest-mm-va_high_addr_switch-add-ppc64-support-check.patch removed from -mm tree
Message-Id: <20250401221803.98408C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest/mm: va_high_addr_switch: add ppc64 support check
has been removed from the -mm tree.  Its filename was
     selftest-mm-va_high_addr_switch-add-ppc64-support-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Wang <liwang@redhat.com>
Subject: selftest/mm: va_high_addr_switch: add ppc64 support check
Date: Thu, 27 Mar 2025 19:48:13 +0800

Add PPC64 Radix MMU support to the va_high_addr_switch.sh by introducing
check_supported_ppc64().  The function verifies:

  - 5-level paging (PGTABLE_LEVELS >= 5) enable in kernel config
  - Radix MMU (required for PPC64 5-level translation)
  - HugePages availability (needed for some tests)

If any check fails, the test is skipped (ksft_skip).  This ensures
compatibility with Power9/Power10 systems running in Radix MMU mode.

Avoid failures on 4-level paging system:

  # mmap(NULL, MAP_HUGETLB): 0xffffffffffffffff - FAILED
  # mmap(LOW_ADDR, MAP_HUGETLB): 0xffffffffffffffff - FAILED
  # mmap(HIGH_ADDR, MAP_HUGETLB): 0xffffffffffffffff - FAILED
  # mmap(HIGH_ADDR, MAP_HUGETLB) again: 0xffffffffffffffff - FAILED
  # mmap(HIGH_ADDR, MAP_FIXED | MAP_HUGETLB): 0xffffffffffffffff - FAILED
  # mmap(-1, MAP_HUGETLB): 0xffffffffffffffff - FAILED
  # mmap(-1, MAP_HUGETLB) again: 0xffffffffffffffff - FAILED
  # mmap(ADDR_SWITCH_HINT - PAGE_SIZE, 2*HUGETLB_SIZE, MAP_HUGETLB): 0xffffffffffffffff - FAILED
  # mmap(ADDR_SWITCH_HINT , 2*HUGETLB_SIZE, MAP_FIXED | MAP_HUGETLB): 0xffffffffffffffff - FAILED

Link: https://lkml.kernel.org/r/20250327114813.25980-1-liwang@redhat.com
Signed-off-by: Li Wang <liwang@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/va_high_addr_switch.sh |   28 ++++++++++++
 1 file changed, 28 insertions(+)

--- a/tools/testing/selftests/mm/va_high_addr_switch.sh~selftest-mm-va_high_addr_switch-add-ppc64-support-check
+++ a/tools/testing/selftests/mm/va_high_addr_switch.sh
@@ -41,6 +41,31 @@ check_supported_x86_64()
 	fi
 }
 
+check_supported_ppc64()
+{
+	local config="/proc/config.gz"
+	[[ -f "${config}" ]] || config="/boot/config-$(uname -r)"
+	[[ -f "${config}" ]] || fail "Cannot find kernel config in /proc or /boot"
+
+	local pg_table_levels=$(gzip -dcfq "${config}" | grep PGTABLE_LEVELS | cut -d'=' -f 2)
+	if [[ "${pg_table_levels}" -lt 5 ]]; then
+		echo "$0: PGTABLE_LEVELS=${pg_table_levels}, must be >= 5 to run this test"
+		exit $ksft_skip
+	fi
+
+	local mmu_support=$(grep -m1 "mmu" /proc/cpuinfo | awk '{print $3}')
+	if [[ "$mmu_support" != "radix" ]]; then
+		echo "$0: System does not use Radix MMU, required for 5-level paging"
+		exit $ksft_skip
+	fi
+
+	local hugepages_total=$(awk '/HugePages_Total/ {print $2}' /proc/meminfo)
+	if [[ "${hugepages_total}" -eq 0 ]]; then
+		echo "$0: HugePages are not enabled, required for some tests"
+		exit $ksft_skip
+	fi
+}
+
 check_test_requirements()
 {
 	# The test supports x86_64 and powerpc64. We currently have no useful
@@ -50,6 +75,9 @@ check_test_requirements()
 		"x86_64")
 			check_supported_x86_64
 		;;
+		"ppc64le"|"ppc64")
+			check_supported_ppc64
+		;;
 		*)
 			return 0
 		;;
_

Patches currently in -mm which might be from liwang@redhat.com are


