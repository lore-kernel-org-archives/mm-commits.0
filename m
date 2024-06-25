Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C001145359
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293207; cv=none; b=UEFmLWDJmBShPb0S3NVumqKFsvyEahefWa9rAvbRHp6y9QnuLusGfAROpFziJRrsxZm1+nFMzEWlqHEaN32LI633gD+L6DUa+BCdutKgTKAVeiXudQ8oD5UkLdF14M1oQUPX/NbZT61B69bn0pnuzWN2wX5P1i6+qCvLAxbGmog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293207; c=relaxed/simple;
	bh=llVWHzcfAvBRYLsJbNy7JO+MU+FfUEadXMJPfMEsbTY=;
	h=Date:To:From:Subject:Message-Id; b=sTC3YQVxlx4PRTswcSAleLP4SuPPvO5hYf5XTcha3XludgT7baUaqTUb16eVv1E57z9g/gJl4R8XwAQBlDBgPpfilw2nPxDwLeMyEA1E5MXPNj3ZraZcf+fJ2BS2rnO2Ti/yR6w/yEuQTNFXzJHjirMVfrlsx/u/UZ77zsBGJxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ACiakUyD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ACiakUyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405F2C32789;
	Tue, 25 Jun 2024 05:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293207;
	bh=llVWHzcfAvBRYLsJbNy7JO+MU+FfUEadXMJPfMEsbTY=;
	h=Date:To:From:Subject:From;
	b=ACiakUyDk/y7U9FF7eLDEqmmulbu7CT4XyL6VE8Iuls+6BRN0lHPpN1e8UNgY68nx
	 I4uzM8NQBFhcFHx4hl+qJQ6f2xGSBiRIqLWo74zg7gWHCnEbVA7TISYu2yPFyZRsrO
	 KHKZ2GwTiWDZE+C9CwW2OQX1YtKbTpcknId6TAaU=
Date: Mon, 24 Jun 2024 22:26:46 -0700
To: mm-commits@vger.kernel.org,Jason@zx2c4.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] siphash-add-missing-module_description-macro.patch removed from -mm tree
Message-Id: <20240625052647.405F2C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: siphash: add missing MODULE_DESCRIPTION() macro
has been removed from the -mm tree.  Its filename was
     siphash-add-missing-module_description-macro.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: siphash: add missing MODULE_DESCRIPTION() macro
Date: Fri, 31 May 2024 18:49:47 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/siphash_kunit.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240531-md-lib-siphash_kunit-v1-1-38688065b796@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/siphash_kunit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/siphash_kunit.c~siphash-add-missing-module_description-macro
+++ a/lib/siphash_kunit.c
@@ -194,4 +194,5 @@ static struct kunit_suite siphash_test_s
 kunit_test_suite(siphash_test_suite);
 
 MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
+MODULE_DESCRIPTION("Test cases for siphash.c");
 MODULE_LICENSE("Dual BSD/GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

kfifo-add-missing-module_description-macros.patch
resource-add-missing-module_description.patch
selftests-fpu-add-missing-module_description-macro.patch

