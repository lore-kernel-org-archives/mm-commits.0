Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CC63D575
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 19:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718913496; cv=none; b=Pd8iozNDCd8sdpvcWeCVHkx3iQaVBfWQ/f8AFWa3ARCOYTNpoK3Ls0FEnYS4rXXqXQB336Bsp84Onxu/dMEzvfLTTplnUSzEFnvRTHpUgqqCUDlaP05NFiogGpN0r4o3S5Kw3A9ZukOXAvPr9sFbE3CZzHDQWAephB7G9GLoF1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718913496; c=relaxed/simple;
	bh=16t5S1SSqYwoXYuyeHfgThI3PHtq5iciK0f31mBD8h0=;
	h=Date:To:From:Subject:Message-Id; b=jLO6/L28KdMGYwcMvJlsm1iOp8LyNPrx19ZYId8SDNvITv9yq1Agofr4sneoIeSFqi82Gk7zjO8tpqGkvL8hSBi2VBTQY1xSLiW5WEUi1vI8LApyUuikuO5Ni2bFW2OaV9wivCxmj/8PU1hCROsERyW0C/p1jF2pjmai+m6UqH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VaAGqry5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VaAGqry5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2102CC2BD10;
	Thu, 20 Jun 2024 19:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718913496;
	bh=16t5S1SSqYwoXYuyeHfgThI3PHtq5iciK0f31mBD8h0=;
	h=Date:To:From:Subject:From;
	b=VaAGqry5R4mixZFR26/v5Ed3RQiRdVKksrOh/BegTRhEt4NRmMZVB2kwO86DAxkjM
	 eK56GIoyIlgmHSyPAz8isokjrpOUTKXeom8uAqMNYVenwKM2k2tPzkTBF3GfSD5I79
	 50X2zI7l0AelMzzFo9Uix1a9f9aDtCMjqlstLfw0=
Date: Thu, 20 Jun 2024 12:58:15 -0700
To: mm-commits@vger.kernel.org,rafael.j.wysocki@intel.com,gregkh@linuxfoundation.org,andriy.shevchenko@linux.intel.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-add-missing-module_description.patch added to mm-nonmm-unstable branch
Message-Id: <20240620195816.2102CC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: add missing MODULE_DESCRIPTION()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     resource-add-missing-module_description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-add-missing-module_description.patch

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
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: resource: add missing MODULE_DESCRIPTION()
Date: Wed, 29 May 2024 16:31:58 -0700

Fix the 'make W=1' warning:
WARNING: modpost: missing MODULE_DESCRIPTION() in kernel/resource_kunit.o

Link: https://lkml.kernel.org/r/20240529-md-kernel-resource_kunit-v1-1-bb719784b714@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource_kunit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/resource_kunit.c~resource-add-missing-module_description
+++ a/kernel/resource_kunit.c
@@ -149,4 +149,5 @@ static struct kunit_suite resource_test_
 };
 kunit_test_suite(resource_test_suite);
 
+MODULE_DESCRIPTION("I/O Port & Memory Resource manager unit tests");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

mm-hwpoison-add-module_description.patch
mm-dmapool-add-module_description.patch
mm-kfence-add-module_description.patch
mm-zsmalloc-add-module_description.patch
kmemleak-test-add-missing-module_description-macro.patch
test_xarray-add-missing-module_description-macro.patch
ubsan-add-missing-module_description-macro.patch
test_maple_tree-add-the-missing-module_description-macro.patch
lib-test_hmm-add-missing-module_description-macro.patch
backtracetest-add-module_description.patch
lib-ts-add-missing-module_description-macros.patch
kunit-fortify-add-missing-module_description-macros.patch
kunit-add-missing-module_description-macros-for-lib-_testko.patch
lib-asn1_encoder-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-to-lib-_kunitc.patch
uuid-add-missing-module_description-macro.patch
siphash-add-missing-module_description-macro.patch
lib-test_kmod-add-missing-module_description-macro.patch
lib-test_linear_ranges-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-for-lib-test_ko.patch
kfifo-add-missing-module_description-macros.patch
resource-add-missing-module_description.patch

