Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46FD3D575
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 19:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718913405; cv=none; b=LlitR2Iqd7GkX7hKfuWqtJ141Ap1AcphBEVsvndUT74TvDSs24qAXK+8LuWyoq7SXXjCTu/oolhR5xCUGbY+p/LVbQxRt2tPzvGKFsfKIpYtJkcXBCdKslm2SDYJ8o+NKxCxZ1jITUFk9uFcWvTnsPb/+eGQAERpxpSaF1OqBLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718913405; c=relaxed/simple;
	bh=H0M2dRZVl8WAg3mSQZgBFrSJTJVMtJm7JE9G4ly/q74=;
	h=Date:To:From:Subject:Message-Id; b=St3gKz+qvHRjgr25Bqgbeyb3aJbrwDC8elejnZh8Yc2mHfUdpQSCRdXeIJ/dOdu6dkNcvKBYPgCfSPcJyEGTNnS3GPB/PudGinYyeUvLp83RTX4Cf4/lAvA7OysLK/WCQ0VOrCVbDsS8ezwb4mQVNsSJS9n5Cia65+/yDINBfbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XJIk1hr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XJIk1hr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D849C32781;
	Thu, 20 Jun 2024 19:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718913405;
	bh=H0M2dRZVl8WAg3mSQZgBFrSJTJVMtJm7JE9G4ly/q74=;
	h=Date:To:From:Subject:From;
	b=XJIk1hr/YDhLCRbuxll1znwJytvOshq3pyvr4P5hp0UO3zW1SgCwGzcQXhyfT1Sjb
	 0g28BqJI+CQeVgFfjWoJr4CM1Xb4pPVCQ+9VkFWy8lJn8+Jc0peDYSxDMn+mtuU0rj
	 KbzXq7X7p4T9afFqfVvJnlaAhLmbngb2BqYm9Htw=
Date: Thu, 20 Jun 2024 12:56:44 -0700
To: mm-commits@vger.kernel.org,stefani@seibold.net,gregkh@linuxfoundation.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kfifo-add-missing-module_description-macros.patch added to mm-nonmm-unstable branch
Message-Id: <20240620195645.4D849C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kfifo: add missing MODULE_DESCRIPTION() macros
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kfifo-add-missing-module_description-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kfifo-add-missing-module_description-macros.patch

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
Subject: kfifo: add missing MODULE_DESCRIPTION() macros
Date: Sat, 1 Jun 2024 17:50:27 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in samples/kfifo/bytestream-example.o
WARNING: modpost: missing MODULE_DESCRIPTION() in samples/kfifo/dma-example.o
WARNING: modpost: missing MODULE_DESCRIPTION() in samples/kfifo/inttype-example.o
WARNING: modpost: missing MODULE_DESCRIPTION() in samples/kfifo/record-example.o

Add the missing invocations of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240601-md-samples-kfifo-v1-1-de34345c5fd8@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kfifo/bytestream-example.c |    1 +
 samples/kfifo/dma-example.c        |    1 +
 samples/kfifo/inttype-example.c    |    1 +
 samples/kfifo/record-example.c     |    1 +
 4 files changed, 4 insertions(+)

--- a/samples/kfifo/bytestream-example.c~kfifo-add-missing-module_description-macros
+++ a/samples/kfifo/bytestream-example.c
@@ -191,5 +191,6 @@ static void __exit example_exit(void)
 
 module_init(example_init);
 module_exit(example_exit);
+MODULE_DESCRIPTION("Sample kfifo byte stream implementation");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Stefani Seibold <stefani@seibold.net>");
--- a/samples/kfifo/dma-example.c~kfifo-add-missing-module_description-macros
+++ a/samples/kfifo/dma-example.c
@@ -138,5 +138,6 @@ static void __exit example_exit(void)
 
 module_init(example_init);
 module_exit(example_exit);
+MODULE_DESCRIPTION("Sample fifo dma implementation");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Stefani Seibold <stefani@seibold.net>");
--- a/samples/kfifo/inttype-example.c~kfifo-add-missing-module_description-macros
+++ a/samples/kfifo/inttype-example.c
@@ -182,5 +182,6 @@ static void __exit example_exit(void)
 
 module_init(example_init);
 module_exit(example_exit);
+MODULE_DESCRIPTION("Sample kfifo int type implementation");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Stefani Seibold <stefani@seibold.net>");
--- a/samples/kfifo/record-example.c~kfifo-add-missing-module_description-macros
+++ a/samples/kfifo/record-example.c
@@ -198,5 +198,6 @@ static void __exit example_exit(void)
 
 module_init(example_init);
 module_exit(example_exit);
+MODULE_DESCRIPTION("Sample dynamic sized record fifo implementation");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Stefani Seibold <stefani@seibold.net>");
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

