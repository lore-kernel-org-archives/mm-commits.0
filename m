Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D73817BA6
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743990491; cv=none; b=a/mdri89DTwHQSxYSjdk5uHjL4aBZfHVFqtgkZE3Cb+aJAx/pKLoQRnpQOVrxIere84vu0LidKU8wgSKx7Ds+wxSo0+ROHLv0UHX5/zybNPylHbQhoJf9JCrb9I3s7CzSVzvJzZ/hLz12Il/xUeffECnFq2twHpc3EKuHmNmr6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743990491; c=relaxed/simple;
	bh=N8uNJdE6lQDDM9/IMHtiglvW9REhiWvkUlFvFKp8k24=;
	h=Date:To:From:Subject:Message-Id; b=IgBF4/ZcAvrJXdB4BG7sVVjYFXZ/hDPRQjGbveBBZaMko20GU02pRqqdPpV61sMcIeB8r85rTGvWHbIAk4MZOOwl+YfrxtqMpKRqbbgq9RA006pt971C7AJ/mLeS5EWyDUl1/6WwP5oWncyOYPzmOxzBwG5/9/dN+UqEBJ/PUlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YGWQm/Pc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YGWQm/Pc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774C4C4CEE3;
	Mon,  7 Apr 2025 01:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743990490;
	bh=N8uNJdE6lQDDM9/IMHtiglvW9REhiWvkUlFvFKp8k24=;
	h=Date:To:From:Subject:From;
	b=YGWQm/PcAF+4Vvxr8dz5OH9Tet9nR6zmIyCpTtQYiwU6gzMHM1GV+0hGgCa/cybdV
	 /Za3k5HISQIy4Q1K5X2jSXFYlLioS9aqPF8A1qrJUzpBHmqxNVyWztfmtUYQG+ylIv
	 QF0eV2VPJH1keF0wgE7m//isdRW6PjI4i3eyGRA0=
Date: Sun, 06 Apr 2025 18:48:09 -0700
To: mm-commits@vger.kernel.org,yilun.xu@intel.com,trix@redhat.com,sfr@canb.auug.org.au,russ.weight@linux.dev,mdf@kernel.org,masahiroy@kernel.org,marpagan@redhat.com,jeff.johnson@oss.qualcomm.com,hao.wu@intel.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fpga-tests-add-module-descriptions.patch added to mm-nonmm-unstable branch
Message-Id: <20250407014810.774C4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fpga: tests: add module descriptions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fpga-tests-add-module-descriptions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fpga-tests-add-module-descriptions.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Arnd Bergmann <arnd@arndb.de>
Subject: fpga: tests: add module descriptions
Date: Mon, 24 Mar 2025 18:32:29 +0100

Modules without a description now cause a warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/fpga/tests/fpga-bridge-test.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/fpga/tests/fpga-mgr-test.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/fpga/tests/fpga-region-test.o

Link: https://lkml.kernel.org/r/20250324173242.1501003-4-arnd@kernel.org
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

exportfs-add-module-description.patch
asn1-add-module-description.patch
samples-livepatch-add-module-descriptions.patch
fpga-tests-add-module-descriptions.patch
xenbus-add-module-description.patch
zlib-add-module-description.patch
ucs2_string-add-module-description.patch
mm-kasan-add-module-decription.patch
kunit-slub-add-module-description.patch

