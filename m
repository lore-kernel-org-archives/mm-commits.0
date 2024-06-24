Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB6A4AECE
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 23:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719270311; cv=none; b=ObnhjEAuKWKWFau/Prb6nucZdUlqwCAHAbC395M6s+z9EA+ODHpOLcILjtwgL94reK6TLIYOQpkGYAeWxsIHJppAblnURnVVG0ntDGUuY9Wld/cUiK/b9p+sf2GkiTFZeZpnKLL0371vBKRy0m21H68hqTuGCPSRwO8MMjS8ynY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719270311; c=relaxed/simple;
	bh=Rqfbl8akbrCSwT9wYPb/rumb62CvMHtKYjOAkC1qjZU=;
	h=Date:To:From:Subject:Message-Id; b=J2MMvBew5kUh7A5jNArXa0Z8DAdgryU6ycpLz2vMhk8YxOOBV9U+lK1jiOyLtQs7K8mPv7R594G2whfWXRxdPbhhrVXmSGLaF/eCekypGi1GfWHSVa51YyCo8wUK27RvIYUYXez76NQ3SvaZz72xNScsaQJKdEaGWGPxu/dDSxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ru60rTgm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ru60rTgm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85522C2BBFC;
	Mon, 24 Jun 2024 23:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719270309;
	bh=Rqfbl8akbrCSwT9wYPb/rumb62CvMHtKYjOAkC1qjZU=;
	h=Date:To:From:Subject:From;
	b=Ru60rTgmqnfBBEAEFcXBKyPQk9xBSJXy7U3mPH6K6RHeZlvdNuh9hJHhEyBPb9HCI
	 eOGWsxkO4fbYeif3doRrsR9mvtFzGece1FyqKj1zQ8FesP54ObbM1teD5c2B+0XI5U
	 ZiHuiwQhwabQmAbQ9wtmK7nW+phlMlaVmRrnURPI=
Date: Mon, 24 Jun 2024 16:05:08 -0700
To: mm-commits@vger.kernel.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-fpu-add-missing-module_description-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20240624230509.85522C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/fpu: add missing MODULE_DESCRIPTION() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-fpu-add-missing-module_description-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-fpu-add-missing-module_description-macro.patch

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
Subject: selftests/fpu: add missing MODULE_DESCRIPTION() macro
Date: Sat, 22 Jun 2024 07:55:05 -0700

make allmodconfig && make W=1 C=1 now reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_fpu.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240622-md-i386-lib-test_fpu_glue-v1-1-a4e40b7b1264@quicinc.com
Fixes: 9613736d852d ("selftests/fpu: move FP code to a separate translation unit")
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_fpu_glue.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/test_fpu_glue.c~selftests-fpu-add-missing-module_description-macro
+++ a/lib/test_fpu_glue.c
@@ -59,4 +59,5 @@ static void __exit test_fpu_exit(void)
 module_init(test_fpu_init);
 module_exit(test_fpu_exit);
 
+MODULE_DESCRIPTION("Test cases for floating point operations");
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
selftests-fpu-add-missing-module_description-macro.patch

