Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1A6433B1
	for <mm-commits@vger.kernel.org>; Thu, 27 Mar 2025 17:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743097515; cv=none; b=oQJHmM8ussjFIUyg0zrn7Q6ieU8D/Wv02CD2pwY7jIcRXZen13x/4DlttN3lts7Z4wLAe6XZXaojEzDOFPyYXCTZWYtCpNDydr9RsdMcuIiVmsKagMhusCdFouTJWrcmsvw3kgdGOOmvgj8R0N8YR6QHDP9leHuLDTN5iTg0x5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743097515; c=relaxed/simple;
	bh=uLbhYRkiHpLzvHUujdbvCwNZGgUAxJItINjS+Br62PU=;
	h=Date:To:From:Subject:Message-Id; b=Xnyjkvje5m28i4BMucFTOgseg8YcKsvyUBwy3WEKgFIBhsIXLk8w0rep4CrhApKiAG800iFDZQ/uMrU+R681SXGKGMkWitArU7J2A3y5dl4BUS1/E63kBtcBQ2FG/TT0/4BouvdIlrFABQ55QrtGX4KlKRK9MflfAkc81PuQKLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=16Rca592; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="16Rca592"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64871C4CEDD;
	Thu, 27 Mar 2025 17:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743097514;
	bh=uLbhYRkiHpLzvHUujdbvCwNZGgUAxJItINjS+Br62PU=;
	h=Date:To:From:Subject:From;
	b=16Rca592dR86D251qG1ZJ3iqzZFodpFiS/XESZvIpcv0fHBU/mo83LjPISTT1tFTN
	 mCWJuk5P2z3caDKY10udB5y+JFVvXMaggmUuZrELz+Rpfx74kcnxLgV3AnA1YW3fJs
	 7/JQ41GHb9XYzp1jKRg6xWarLURdlELpETwur+84=
Date: Thu, 27 Mar 2025 10:45:13 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,kirill.shutemov@linux.intel.com,dev.jain@arm.com,anshuman.khandual@arm.com,liwang@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-va_high_addr_switch-add-ppc64-support-check.patch added to mm-unstable branch
Message-Id: <20250327174514.64871C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest/mm: va_high_addr_switch: add ppc64 support check
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-mm-va_high_addr_switch-add-ppc64-support-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-va_high_addr_switch-add-ppc64-support-check.patch

This patch will later appear in the mm-unstable branch at
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

selftest-mm-va_high_addr_switch-add-ppc64-support-check.patch

