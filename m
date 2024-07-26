Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2568BFC1F
	for <mm-commits@vger.kernel.org>; Fri, 26 Jul 2024 20:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722026298; cv=none; b=rJ+CyL5GaO0z8aml19OiH0+qLVrpPfQOP2ZokpJIqRmQONdolUfshsHvbQMCvZ0eyQC0ZCc/D+hFjRbpKtj812nSs6DrTISvqRavauoXeAktTFp61k3NZYMU4/HlqmcARiCL2zogIPnZfyVT6AEjBdLJ7uGeFN4vHvGbrznrpAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722026298; c=relaxed/simple;
	bh=7y1qkI2PrO5PWWEHdKcvQwFsUUF3SuKZB2dsW4fMClY=;
	h=Date:To:From:Subject:Message-Id; b=ASINkXozOtrCtChYXaQQepxbTODfFx1fyTgqZ5aL88DOpGQlL+UvWPcMMKJvewDEPit9WRcGeuknz8nirU2N7k85ACG/3vKl0OXk2BP7p+Uk8IEzv0AOUPa1fJclZng21WqPgU2ezrL70oZHYN7O9DUfBUqcv9iJXhCHuThDKEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NS1HoLbL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NS1HoLbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA83C4AF0A;
	Fri, 26 Jul 2024 20:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722026298;
	bh=7y1qkI2PrO5PWWEHdKcvQwFsUUF3SuKZB2dsW4fMClY=;
	h=Date:To:From:Subject:From;
	b=NS1HoLbLxly9qoooshrurSkIwd9z9512KSJDFqheR1ZBfAcCp2oAOv/VfTYKL4mFD
	 DXZnCzwMNYJCzZfr5R/XC5yA5Txi9nOI95H9qj7hhJ0oyFhtrKYX+EOMTohwhTqfvB
	 6I20ihHx/kLmsFVhc5+PPEwDNZYRoaG/aigVXZ88=
Date: Fri, 26 Jul 2024 13:38:17 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,broonie@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-skip-test-for-non-lpa2-and-non-lva-systems.patch removed from -mm tree
Message-Id: <20240726203817.DDA83C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip test for non-LPA2 and non-LVA systems
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-test-for-non-lpa2-and-non-lva-systems.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm: skip test for non-LPA2 and non-LVA systems
Date: Thu, 18 Jul 2024 10:55:04 +0530

Post my improvement of the test in e4a4ba415419 ("selftests/mm:
va_high_addr_switch: dynamically initialize testcases to enable LPA2
testing"):

The test begins to fail on 4k and 16k pages, on non-LPA2 systems.  To
reduce noise in the CI systems, let us skip the test when higher address
space is not implemented.

Link: https://lkml.kernel.org/r/20240718052504.356517-1-dev.jain@arm.com
Fixes: e4a4ba415419 ("selftests/mm: va_high_addr_switch: dynamically initialize testcases to enable LPA2 testing")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/va_high_addr_switch.c |   16 ++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/va_high_addr_switch.c~selftests-mm-skip-test-for-non-lpa2-and-non-lva-systems
+++ a/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -293,6 +293,20 @@ static int run_test(struct testcase *tes
 	return ret;
 }
 
+#ifdef __aarch64__
+/* Check if userspace VA > 48 bits */
+static int high_address_present(void)
+{
+	void *ptr = mmap((void *)(1UL << 50), 1, PROT_READ | PROT_WRITE,
+			 MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
+	if (ptr == MAP_FAILED)
+		return 0;
+
+	munmap(ptr, 1);
+	return 1;
+}
+#endif
+
 static int supported_arch(void)
 {
 #if defined(__powerpc64__)
@@ -300,7 +314,7 @@ static int supported_arch(void)
 #elif defined(__x86_64__)
 	return 1;
 #elif defined(__aarch64__)
-	return 1;
+	return high_address_present();
 #else
 	return 0;
 #endif
_

Patches currently in -mm which might be from dev.jain@arm.com are


