Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBEF16191A
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 23:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629141; cv=none; b=XcxWc7Iwr/eWqKwRqNqbubi82GQNZuz5OB5pX0cC5Dz0aiQncRQ9SaQpX+Ox8UGqTfHfH+ppZuisewG3D1RIaHwOY6c5Kcj2g8gIW4pwj3b61WL8pN/LXFznQzdmcgX0FtZ6SOm2zT3JPCK1vfq0Ac2D89K5P/R/ZaV9Z9D22fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629141; c=relaxed/simple;
	bh=ehJC39MaH6qgTxTe8BkLl7OdXsLhlAHT+rSinjb8nX4=;
	h=Date:To:From:Subject:Message-Id; b=oHaDsVVrWp1N3AchwdXP452/VwWQU+kTruiz6jwb2zwYXFWq+9KZqgO8cdwVibWUYmSlT7mLSS1fNjrETrlQeqIUlFO0xfFJYsBu5+e3DM7PQBCy8f264BZiqQbVQmSVIkkSvTysyp/spwoHecSjxgApEMCxkoDwi4giiIf+R/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t1mzwkUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t1mzwkUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3570BC4AF08;
	Wed,  5 Jun 2024 23:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717629141;
	bh=ehJC39MaH6qgTxTe8BkLl7OdXsLhlAHT+rSinjb8nX4=;
	h=Date:To:From:Subject:From;
	b=t1mzwkUr0mPuc76wTh8Aj3Wx00kHBRWsFGjjAJ4uR0yuhhQCgY9JiwhlTKuPWRcpT
	 DJYIs9qtm8dTUY4iZLpgFEkmesqsRSaRH6/bV+yxYlM3fToh6GZAKEynJ7H7EYhwnK
	 ehrIpF5Ha+4eH+brG+oUNGB8yWHFCElRD9KXY5Jg=
Date: Wed, 05 Jun 2024 16:12:20 -0700
To: mm-commits@vger.kernel.org,mazziesaccount@gmail.com,broonie@kernel.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_linear_ranges-add-missing-module_description-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20240605231221.3570BC4AF08@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_linear_ranges: add missing MODULE_DESCRIPTION() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-test_linear_ranges-add-missing-module_description-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_linear_ranges-add-missing-module_description-macro.patch

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
Subject: lib/test_linear_ranges: add missing MODULE_DESCRIPTION() macro
Date: Fri, 31 May 2024 16:45:16 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/test_linear_ranges.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240531-md-lib-test_linear_ranges-v1-1-053a1aad37c6@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_linear_ranges.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/test_linear_ranges.c~lib-test_linear_ranges-add-missing-module_description-macro
+++ a/lib/test_linear_ranges.c
@@ -216,4 +216,5 @@ static struct kunit_suite range_test_mod
 
 kunit_test_suites(&range_test_module);
 
+MODULE_DESCRIPTION("KUnit test for the linear_ranges helper");
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
dyndbg-add-missing-module_description-macro.patch
lib-ts-add-missing-module_description-macros.patch
kunit-fortify-add-missing-module_description-macros.patch
kunit-add-missing-module_description-macros-for-lib-_testko.patch
lib-asn1_encoder-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-to-lib-_kunitc.patch
uuid-add-missing-module_description-macro.patch
siphash-add-missing-module_description-macro.patch
lib-test_kmod-add-missing-module_description-macro.patch
lib-test_linear_ranges-add-missing-module_description-macro.patch

