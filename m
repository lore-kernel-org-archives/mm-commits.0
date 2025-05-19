Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94662EAD0
	for <mm-commits@vger.kernel.org>; Mon, 19 May 2025 23:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697666; cv=none; b=SxZbV5oNWlgWhetkQGVCxCqKQGH4ISNLYKOpfCnMbJWgBRrkoDNPrK0ZxekBP4qt5Ep1o/LL1zL8EYoTC3+J4soT6ZRlpu098124jnmuG0skDP+svXSg+bHXlcc2JLeOlOpbnGxbu7AiF1kc+IkAtdZWP66C025VKDSmnosMLU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697666; c=relaxed/simple;
	bh=v5ARBpBdsH28DQfmB0qhhiKopIzXW/4TXUSSQr1JNrk=;
	h=Date:To:From:Subject:Message-Id; b=tD0gUJA75v2Z81mL5IxXrJ3FyuF4arLfgXIQ243X6wabkF/UMs7+zudRGikzZTkhJlwzSuFhwR4mJuNfsaxQouz0bWHrwO2wqAslgWlK6Shcl6qQHCXV115Pe31eoSluD/D4PrWIjm/eTSITAzbYU2mleFxOSAvCUt2kl1dzx/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QPHyXV1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QPHyXV1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046BFC4CEE4;
	Mon, 19 May 2025 23:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747697666;
	bh=v5ARBpBdsH28DQfmB0qhhiKopIzXW/4TXUSSQr1JNrk=;
	h=Date:To:From:Subject:From;
	b=QPHyXV1P6YGscEoS2vPM35pdw2VsHBxgsWAHehKgvqZECVumRLpnbe0tYxmcCCMUt
	 jXW+NNG+cURT3RQWVtaOw82oQb2Br0RFngQn2zNo9b5zCjLyn+V/SxArqbN6ltPRth
	 5l5pI3/KnRRBw0JVJI6picZwdfaqYsYYGU0Y6IC4=
Date: Mon, 19 May 2025 16:34:25 -0700
To: mm-commits@vger.kernel.org,pfalcato@suse.de,lorenzo.stoakes@oracle.com,adam@wowsignal.io,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-hugevm-test-if-kernel-config-file-is-not-present.patch added to mm-new branch
Message-Id: <20250519233426.046BFC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip hugevm test if kernel config file is not present.
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-skip-hugevm-test-if-kernel-config-file-is-not-present.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-hugevm-test-if-kernel-config-file-is-not-present.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: skip hugevm test if kernel config file is not present.
Date: Fri, 16 May 2025 09:29:38 -0400

When running hugevm tests in a machine without kernel config present,
e.g., a VM running a kernel without CONFIG_IKCONFIG_PROC nor
/boot/config-*, skip hugevm tests, which reads kernel config to get page
table level information.

Link: https://lkml.kernel.org/r/20250516132938.356627-3-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Adam Sindelar <adam@wowsignal.io>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/va_high_addr_switch.sh |   26 ++++--------
 1 file changed, 9 insertions(+), 17 deletions(-)

--- a/tools/testing/selftests/mm/va_high_addr_switch.sh~selftests-mm-skip-hugevm-test-if-kernel-config-file-is-not-present
+++ a/tools/testing/selftests/mm/va_high_addr_switch.sh
@@ -7,23 +7,20 @@
 # real test to check that the kernel is configured to support at least 5
 # pagetable levels.
 
-# 1 means the test failed
-exitcode=1
-
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
-fail()
+skip()
 {
 	echo "$1"
-	exit $exitcode
+	exit $ksft_skip
 }
 
 check_supported_x86_64()
 {
 	local config="/proc/config.gz"
 	[[ -f "${config}" ]] || config="/boot/config-$(uname -r)"
-	[[ -f "${config}" ]] || fail "Cannot find kernel config in /proc or /boot"
+	[[ -f "${config}" ]] || skip "Cannot find kernel config in /proc or /boot"
 
 	# gzip -dcfq automatically handles both compressed and plaintext input.
 	# See man 1 gzip under '-f'.
@@ -33,11 +30,9 @@ check_supported_x86_64()
 		else {print 1}; exit}' /proc/cpuinfo 2>/dev/null)
 
 	if [[ "${pg_table_levels}" -lt 5 ]]; then
-		echo "$0: PGTABLE_LEVELS=${pg_table_levels}, must be >= 5 to run this test"
-		exit $ksft_skip
+		skip "$0: PGTABLE_LEVELS=${pg_table_levels}, must be >= 5 to run this test"
 	elif [[ "${cpu_supports_pl5}" -ne 0 ]]; then
-		echo "$0: CPU does not have the necessary la57 flag to support page table level 5"
-		exit $ksft_skip
+		skip "$0: CPU does not have the necessary la57 flag to support page table level 5"
 	fi
 }
 
@@ -45,24 +40,21 @@ check_supported_ppc64()
 {
 	local config="/proc/config.gz"
 	[[ -f "${config}" ]] || config="/boot/config-$(uname -r)"
-	[[ -f "${config}" ]] || fail "Cannot find kernel config in /proc or /boot"
+	[[ -f "${config}" ]] || skip "Cannot find kernel config in /proc or /boot"
 
 	local pg_table_levels=$(gzip -dcfq "${config}" | grep PGTABLE_LEVELS | cut -d'=' -f 2)
 	if [[ "${pg_table_levels}" -lt 5 ]]; then
-		echo "$0: PGTABLE_LEVELS=${pg_table_levels}, must be >= 5 to run this test"
-		exit $ksft_skip
+		skip "$0: PGTABLE_LEVELS=${pg_table_levels}, must be >= 5 to run this test"
 	fi
 
 	local mmu_support=$(grep -m1 "mmu" /proc/cpuinfo | awk '{print $3}')
 	if [[ "$mmu_support" != "radix" ]]; then
-		echo "$0: System does not use Radix MMU, required for 5-level paging"
-		exit $ksft_skip
+		skip "$0: System does not use Radix MMU, required for 5-level paging"
 	fi
 
 	local hugepages_total=$(awk '/HugePages_Total/ {print $2}' /proc/meminfo)
 	if [[ "${hugepages_total}" -eq 0 ]]; then
-		echo "$0: HugePages are not enabled, required for some tests"
-		exit $ksft_skip
+		skip "$0: HugePages are not enabled, required for some tests"
 	fi
 }
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-skip-guard_regionsuffd-tests-when-uffd-is-not-present.patch
selftests-mm-skip-hugevm-test-if-kernel-config-file-is-not-present.patch

