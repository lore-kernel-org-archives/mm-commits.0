Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD28933C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293201; cv=none; b=Uu4RaHHjHNJcOE7L4Nu35d3a3pGtP/zK689nCfJySan58xUxnQq5OEeecJ9qajzFsPNZE/I6gWHteyHrZmxMCd5eKrkAsd2HrHbUH1OQp1LZM1BrmJ9q65nuGiOnQQTAhmHLYiSxJTWpOx8cHsdCykAmWKwiXlZ8u2zOON5jRgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293201; c=relaxed/simple;
	bh=3YZuPvB7H5iBdEq1IXMSE6K3zFm3g1b3XjgL42bzHZk=;
	h=Date:To:From:Subject:Message-Id; b=CWpBKx4SDTBloX+XCWUKFEWIduiXYnLnRZsxNW2dgA5gPhdNDls1j72o//nplGCY+bY34k3om/pGHlz0ayNOr47ONTjVA45dZ6COE1X/citbfIkreS68A0bXipaaFrS3CZeDVnhHzDvpLSEBV4eXTsvMnhN1xRKzNjtPyM9o6lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lIAA2Ulm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lIAA2Ulm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DAEC32782;
	Tue, 25 Jun 2024 05:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293201;
	bh=3YZuPvB7H5iBdEq1IXMSE6K3zFm3g1b3XjgL42bzHZk=;
	h=Date:To:From:Subject:From;
	b=lIAA2Ulm2ChdWQLHTSnu5xH5xcU5YlI1pOJh1+chKJXEmEt5W+Q3KGZMg43JAfYg6
	 WqQSpdeKnORlTHhpih+JtbecUo7HFhhafN1o7gAZh9EKl2xwV3Vm9kCTtz3j6OO/LI
	 ZulljyDlAlGqRVnNAy436JzRxy2ltdxKjRFT93mU=
Date: Mon, 24 Jun 2024 22:26:41 -0700
To: mm-commits@vger.kernel.org,keescook@chromium.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kunit-fortify-add-missing-module_description-macros.patch removed from -mm tree
Message-Id: <20240625052641.B2DAEC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kunit/fortify: add missing MODULE_DESCRIPTION() macros
has been removed from the -mm tree.  Its filename was
     kunit-fortify-add-missing-module_description-macros.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: kunit/fortify: add missing MODULE_DESCRIPTION() macros
Date: Fri, 31 May 2024 15:45:22 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/memcpy_kunit.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/fortify_kunit.o

Add the missing invocations of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240531-md-lib-fortify_source-v1-1-2c37f7fbaafc@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/fortify_kunit.c |    1 +
 lib/memcpy_kunit.c  |    1 +
 2 files changed, 2 insertions(+)

--- a/lib/fortify_kunit.c~kunit-fortify-add-missing-module_description-macros
+++ a/lib/fortify_kunit.c
@@ -1096,4 +1096,5 @@ static struct kunit_suite fortify_test_s
 
 kunit_test_suite(fortify_test_suite);
 
+MODULE_DESCRIPTION("Runtime test cases for CONFIG_FORTIFY_SOURCE");
 MODULE_LICENSE("GPL");
--- a/lib/memcpy_kunit.c~kunit-fortify-add-missing-module_description-macros
+++ a/lib/memcpy_kunit.c
@@ -510,4 +510,5 @@ static struct kunit_suite memcpy_test_su
 
 kunit_test_suite(memcpy_test_suite);
 
+MODULE_DESCRIPTION("test cases for memcpy(), memmove(), and memset()");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

kfifo-add-missing-module_description-macros.patch
resource-add-missing-module_description.patch
selftests-fpu-add-missing-module_description-macro.patch

