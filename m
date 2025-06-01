Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7891547F5
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756840; cv=none; b=s34Yvds06o/cgBaxTjRSkgJoWvZU+ivvk8F3F/0ite8n2SjW4G1W34r8SKPFLfHm+rVideEqE4oOaq7tuRFV5rF1pthGXwgZWREnzfcJp610zL3BLDJvpy7EenMxDIwrY5nX6rd6zn37/iDzmvsocF1JCBWVEGlbA5EVRM7yi8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756840; c=relaxed/simple;
	bh=C5QytnKDHQ7rVUwDB2de9kyTJSHxeh6/uRwjYHwyZaw=;
	h=Date:To:From:Subject:Message-Id; b=Wu9xIeOlUPPemG0mRpoPPNo/MgJu/B1nlsCUUUT3TYxxGuX4XmXxCOb9VbBbB1O/mcmu5LWixxNnO8cdGzVUHvXi9enYbnmdzER/9/jAOnJKeiHxwlTl6G7tgxiZCJ6LsOf6RSklmPQsrJDaZtq0915B5/DCOxnl5VwKmfjR5fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XijQuG7m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XijQuG7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3894C4CEED;
	Sun,  1 Jun 2025 05:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756839;
	bh=C5QytnKDHQ7rVUwDB2de9kyTJSHxeh6/uRwjYHwyZaw=;
	h=Date:To:From:Subject:From;
	b=XijQuG7mru21mRVHjPspORet3BTmaLkOTcWpcT95OC9CDj74FY/YLnCq5++wXWKqB
	 2GD9KWQ1o5UeqGJix0H5WoLgpUMZFRQ4yDm+QBLFdc+9d3TwcM2qjCiLqmKBA8CZnv
	 I4rvR68XVXoBcnHqDDjog4ChjiTU+dd8tRDqKXxA=
Date: Sat, 31 May 2025 22:47:19 -0700
To: mm-commits@vger.kernel.org,pfalcato@suse.de,lorenzo.stoakes@oracle.com,adam@wowsignal.io,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-hugevm-test-if-kernel-config-file-is-not-present.patch removed from -mm tree
Message-Id: <20250601054719.B3894C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip hugevm test if kernel config file is not present
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-hugevm-test-if-kernel-config-file-is-not-present.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: selftests/mm: skip hugevm test if kernel config file is not present
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


