Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85B11CD23
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628635; cv=none; b=EQstcPRP5u0pRQFCAHSEOfvpIm0BkREPKHpjfHP8Iq6FLdOnPLVcLBDIG8x6afoQDXN6Sbnk1BZ3ypho24Matawh/YiTYXFoS9i7GWpuYx28Tlf3V0GMao9vrNQCPyV7a+TiePZUd4bB8tJ6ahksOLwiXSqM1QpcDUkmeiJVBTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628635; c=relaxed/simple;
	bh=o01pyxfhNQOi9B9m2NlCog7b/SkqLYddiW7J1k3eH/c=;
	h=Date:To:From:Subject:Message-Id; b=gbGjsKQSqOLDEFsFnQ+lgO43B1VXgcxEsXUaSejS8RXTa20swFu60KDnZlMko0fMRqAf/y22OhR5zvkq/TzzcvP2JSj9XOhcyi78Ruq+Zh9cVC5gCAy1DGoltcVngLfq3xuPaC8q5VlRBFAmwypIRd7LgvAK4YMnuW6rmLY9ujU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=skng1F76; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="skng1F76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC14C116B1;
	Sat, 29 Jun 2024 02:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628635;
	bh=o01pyxfhNQOi9B9m2NlCog7b/SkqLYddiW7J1k3eH/c=;
	h=Date:To:From:Subject:From;
	b=skng1F76SIqYzSJAJnq8ngd4qGcpSsQMht0w0p+kFAQD37tw/9U8XmpMOS/k9ZK5n
	 g7VES1tfS2CwEw4kWUdP3R/hYdOT05/XU1gn812UPpH3utIvZnqNIQInIFYz3GvYau
	 TKF2cojFA59ayQKEaUP96Rw9ZzUrTTqZ/sacs7y4=
Date: Fri, 28 Jun 2024 19:37:15 -0700
To: mm-commits@vger.kernel.org,samuel.holland@sifive.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-fpu-add-missing-module_description-macro.patch removed from -mm tree
Message-Id: <20240629023715.7BC14C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/fpu: add missing MODULE_DESCRIPTION() macro
has been removed from the -mm tree.  Its filename was
     selftests-fpu-add-missing-module_description-macro.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
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


