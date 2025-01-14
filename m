Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EEFEC5;
	Tue, 14 Jan 2025 01:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736817668; cv=none; b=XwVBzer4vPLuHKsmVvtLsdl+X9FsscpA0U/45lrykuT0eF72GSU8b916+PWCN8SFSO7VkjqtU23nFbIRSMRkiOhWZDdG9a080LqbBKVwwG/svd2HqplRw/wgYmIZSZOs9cKA12t7LZ4l/Odk+RGPIZ15G3RkseRDx5L/w7E25Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736817668; c=relaxed/simple;
	bh=laVzPaQ7+Yz6O+Dcs2uKzi2jmwhlY71qoRQSt29ojog=;
	h=Date:To:From:Subject:Message-Id; b=KpcjMH+dCLj+mLJ0SDk37eopuNhv0XrybPiC12lVir8TE24N/3m8JAO/xcGGIsfxO6iXT8xFcrsDh9at1wYMP8BAT976bXUaK9ZHTwm9t4cZ74pn1jQBAFpSRsglSMoP5t2RLBTEwrXhQwBkRDw+zw6dzVLfsCqr3LhF5la+wjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zr+QeTCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zr+QeTCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844ABC4CED6;
	Tue, 14 Jan 2025 01:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736817666;
	bh=laVzPaQ7+Yz6O+Dcs2uKzi2jmwhlY71qoRQSt29ojog=;
	h=Date:To:From:Subject:From;
	b=zr+QeTCpEsdzDN1CM3QvViQ60prUpOA1WAEGWkNKwRyDstsqDPLpgPxgBzVy/tEuA
	 rBdDphfUIxjXTleoE7As5HfjfDlOSR8nPKYUr/eO1GEotWgVZztp7N6jCczB9Xof3S
	 DEispX5/i6f1gvia+97wqvc9SBIyM5MLeUzvNQEw=
Date: Mon, 13 Jan 2025 17:21:05 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,stable@vger.kernel.org,shuah@kernel.org,oliver.sang@intel.com,dev.jain@arm.com,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-virtual_address_range-fix-error-when-commitlimit-1gib.patch removed from -mm tree
Message-Id: <20250114012106.844ABC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: virtual_address_range: fix error when CommitLimit < 1GiB
has been removed from the -mm tree.  Its filename was
     selftests-mm-virtual_address_range-fix-error-when-commitlimit-1gib.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Subject: selftests/mm: virtual_address_range: fix error when CommitLimit < 1GiB
Date: Tue, 07 Jan 2025 16:14:45 +0100

If not enough physical memory is available the kernel may fail mmap(); see
__vm_enough_memory() and vm_commit_limit().  In that case the logic in
validate_complete_va_space() does not make sense and will even incorrectly
fail.  Instead skip the test if no mmap() succeeded.

Link: https://lkml.kernel.org/r/20250107-virtual_address_range-tests-v1-1-3834a2fb47fe@linutronix.de
Fixes: 010409649885 ("selftests/mm: confirm VA exhaustion without reliance on correctness of mmap()")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: <stable@vger.kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-mm-virtual_address_range-fix-error-when-commitlimit-1gib
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -178,6 +178,12 @@ int main(int argc, char *argv[])
 		validate_addr(ptr[i], 0);
 	}
 	lchunks = i;
+
+	if (!lchunks) {
+		ksft_test_result_skip("Not enough memory for a single chunk\n");
+		ksft_finished();
+	}
+
 	hptr = (char **) calloc(NR_CHUNKS_HIGH, sizeof(char *));
 	if (hptr == NULL) {
 		ksft_test_result_skip("Memory constraint not fulfilled\n");
_

Patches currently in -mm which might be from thomas.weissschuh@linutronix.de are

selftests-mm-virtual_address_range-avoid-reading-vvar-mappings.patch

