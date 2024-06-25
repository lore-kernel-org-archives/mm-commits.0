Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDCB14534C
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293209; cv=none; b=aPiqlkunQ+3coFcQutweJywseK92i9ChxLOu20cp3DDM5cRgWQMSyLWM1+JByw5G9F1SBSLzla6wB1DKXtgg2VtHdgP/JAjvKVFrYmzFe8ax7dI/spuJlz7tKyMVGAijP3iDq1FDVw2g1j9PZYTqNKbRyhpcIpRZ92gLs1rntpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293209; c=relaxed/simple;
	bh=LMa8efAk9fYAhwSplToKE1gdmHLn9TN6MGOl0Ypn8Vw=;
	h=Date:To:From:Subject:Message-Id; b=CPJdO+CRnaTLWUKfvEcBU5W09w3F2iSUk97Y0xF/oWshjGmKXj70PxZBF0YKwCDTGPf6vKhsZeHmYjYB6ntN9qplFQ5qqOxmqlgwXk7LORvJw9bZFuSTFuj/dxJAKTAkKxKSEAJfgjqlREbJo94MRYS5vJBmPhnNHMofjIkcUsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BjvOKjsk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BjvOKjsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47591C32782;
	Tue, 25 Jun 2024 05:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293209;
	bh=LMa8efAk9fYAhwSplToKE1gdmHLn9TN6MGOl0Ypn8Vw=;
	h=Date:To:From:Subject:From;
	b=BjvOKjskkGw4YqUFXOQ6dT9F9brfTniUO7tzCrB/8Dje3yAVVkyN1tP2G0GCL7Z11
	 lLLj4NLq2HIFZzMQSooLBOTthF/3+sI9FFhXjCnczaF4uztXOKnniq0izg3P5NQeIa
	 ToLEkdjJDmdbE/yK4h2zt2x7Uyo0rWVMAuuSlVD8=
Date: Mon, 24 Jun 2024 22:26:48 -0700
To: mm-commits@vger.kernel.org,mazziesaccount@gmail.com,broonie@kernel.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-test_linear_ranges-add-missing-module_description-macro.patch removed from -mm tree
Message-Id: <20240625052649.47591C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_linear_ranges: add missing MODULE_DESCRIPTION() macro
has been removed from the -mm tree.  Its filename was
     lib-test_linear_ranges-add-missing-module_description-macro.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kfifo-add-missing-module_description-macros.patch
resource-add-missing-module_description.patch
selftests-fpu-add-missing-module_description-macro.patch

