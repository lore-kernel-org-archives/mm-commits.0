Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538E3134D4
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418010; cv=none; b=NRstMRKLnUHoTwprwxxmsO9LvUgepyMGFhtb6FnQlfAFxZr5kL2e+XYle6i7IFrv14/yWw/GT+P4Xmby+H2InQYZnv6l0vencn/MJG/5QKIZcN1f+72VLpYaqeAcjfuhVAhskZTYyEaVzXW4PTXolKsCXEwn040dSQEem8qCLIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418010; c=relaxed/simple;
	bh=GzZvpKtFQi2++9ARLS29Ot3BIOTWVgTErmFz+fBOMLE=;
	h=Date:To:From:Subject:Message-Id; b=QSIReqHlfNpbmiHQJUUQKgvjYtclXI37aRXvnIs8oU8zQb32uwtVDe/TlySpgZRNhWJJ9TL75u0pD6yApe4WOXXZtsfvdD/8/td36u0dS8UeZ1ET1Ej9vuyDIkZm/Mmf8Z3EN3RUVlKvl6ncwKQ+oHQhoG6hJAGyywzOMXFRt+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CW4GH8Rj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CW4GH8Rj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F9DC4CEE2;
	Sat, 12 Apr 2025 00:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744418010;
	bh=GzZvpKtFQi2++9ARLS29Ot3BIOTWVgTErmFz+fBOMLE=;
	h=Date:To:From:Subject:From;
	b=CW4GH8RjzDylKSLRWPN7cRwVpmtQGcKxeZoyfhi8HvwTCfTkbxohHfuTxjgb1Lir0
	 hr6/lak3BhUdy2zgKAUkaHx1AjrNU8X2Szh6U56UGHUiwxLGUeJNAQr0ZYkvxf78mb
	 f923EE2Cebdiix8t4BBXOdDrjO/fLWY5T+SVJG5M=
Date: Fri, 11 Apr 2025 17:33:29 -0700
To: mm-commits@vger.kernel.org,yilun.xu@intel.com,trix@redhat.com,sfr@canb.auug.org.au,russ.weight@linux.dev,mdf@kernel.org,masahiroy@kernel.org,marpagan@redhat.com,jeff.johnson@oss.qualcomm.com,hao.wu@intel.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fpga-tests-add-module-descriptions.patch removed from -mm tree
Message-Id: <20250412003330.27F9DC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fpga: tests: add module descriptions
has been removed from the -mm tree.  Its filename was
     fpga-tests-add-module-descriptions.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: fpga: tests: add module descriptions
Date: Mon, 24 Mar 2025 18:32:29 +0100

Modules without a description now cause a warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/fpga/tests/fpga-bridge-test.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/fpga/tests/fpga-mgr-test.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/fpga/tests/fpga-region-test.o

Link: https://lkml.kernel.org/r/20250324173242.1501003-4-arnd@kernel.org
Fixes: 6c6c1fc09de3 ("modpost: require a MODULE_DESCRIPTION()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Hao Wu <hao.wu@intel.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Marco Pagani <marpagan@redhat.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>
Cc: Russ Weight <russ.weight@linux.dev>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Cc: Tom Rix <trix@redhat.com>
Cc: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/fpga/tests/fpga-bridge-test.c |    1 +
 drivers/fpga/tests/fpga-mgr-test.c    |    1 +
 drivers/fpga/tests/fpga-region-test.c |    1 +
 3 files changed, 3 insertions(+)

--- a/drivers/fpga/tests/fpga-bridge-test.c~fpga-tests-add-module-descriptions
+++ a/drivers/fpga/tests/fpga-bridge-test.c
@@ -170,4 +170,5 @@ static struct kunit_suite fpga_bridge_su
 
 kunit_test_suite(fpga_bridge_suite);
 
+MODULE_DESCRIPTION("KUnit test for the FPGA Bridge");
 MODULE_LICENSE("GPL");
--- a/drivers/fpga/tests/fpga-mgr-test.c~fpga-tests-add-module-descriptions
+++ a/drivers/fpga/tests/fpga-mgr-test.c
@@ -330,4 +330,5 @@ static struct kunit_suite fpga_mgr_suite
 
 kunit_test_suite(fpga_mgr_suite);
 
+MODULE_DESCRIPTION("KUnit test for the FPGA Manager");
 MODULE_LICENSE("GPL");
--- a/drivers/fpga/tests/fpga-region-test.c~fpga-tests-add-module-descriptions
+++ a/drivers/fpga/tests/fpga-region-test.c
@@ -214,4 +214,5 @@ static struct kunit_suite fpga_region_su
 
 kunit_test_suite(fpga_region_suite);
 
+MODULE_DESCRIPTION("KUnit test for the FPGA Region");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from arnd@arndb.de are


