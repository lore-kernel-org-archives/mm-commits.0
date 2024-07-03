Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26372623
	for <mm-commits@vger.kernel.org>; Wed,  3 Jul 2024 00:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719967421; cv=none; b=tu5LAxLBcX5/lEIKqelyF04lByYI2LOzxnQ7TIZb8zkZeYSw9nzG6zaM3059+xMtGuSVPeOlFBVw+gyD1Luofi9ogwHah1ycDPoIwQjY83vYo73GxLwve8qPJhMXQAvIzTiLmDx4Uu/Ou6eAMi+ofxTz+/uErjMNupilAb4pgZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719967421; c=relaxed/simple;
	bh=KNdcYLwMrVDSq37q76QvO2HXT6QIXVyI7IpAFhIZYSE=;
	h=Date:To:From:Subject:Message-Id; b=k3m6E/BRLZcwjyD7qRLaIFvfvskbUfxK0VkWfMxh3lRrSbDNJ5Vf+ajA/TXLqmSJCUWS7mfK/GwDyky444mxgsj3Dz36txzyzMRVZ9nKK6qaP799z9JriD3hxEEymDLA1/7/2H0Wrp2HuAGekzDb7yk5QLW0r5W3Fa0EPq4FCrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V2k+YBGY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V2k+YBGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34BDC116B1;
	Wed,  3 Jul 2024 00:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719967420;
	bh=KNdcYLwMrVDSq37q76QvO2HXT6QIXVyI7IpAFhIZYSE=;
	h=Date:To:From:Subject:From;
	b=V2k+YBGY9ZbpZNA2zPlonxP1jEsF70b+jEXMQHIODk2lm929ScVx8R/AqmTSLze9P
	 Kd3TpirV+PB7tJAHo3GB7b91u9vsCmWsGdCZV+f1cP5GOk4bZCG4q1OlIPp6IRyxtM
	 1EKkw032Bf/Nke9hBmVacKpSGhDlM7sV5FREiWkw=
Date: Tue, 02 Jul 2024 17:43:40 -0700
To: mm-commits@vger.kernel.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + math-rational-add-missing-module_description-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20240703004340.A34BDC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: math: rational: add missing MODULE_DESCRIPTION() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     math-rational-add-missing-module_description-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/math-rational-add-missing-module_description-macro.patch

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
Subject: math: rational: add missing MODULE_DESCRIPTION() macro
Date: Tue, 2 Jul 2024 15:47:59 -0700

With ARCH=sh, make allmodconfig && make W=1 C=1 reports: WARNING: modpost:
missing MODULE_DESCRIPTION() in lib/math/rational.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240702-md-sh-lib-math-v1-1-93f4ac4fa8fd@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/math/rational.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/math/rational.c~math-rational-add-missing-module_description-macro
+++ a/lib/math/rational.c
@@ -108,4 +108,5 @@ void rational_best_approximation(
 
 EXPORT_SYMBOL(rational_best_approximation);
 
+MODULE_DESCRIPTION("Rational fraction support library");
 MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

fs-ufs-add-module_description.patch
lib-zlib-add-missing-module_description-macro.patch
math-rational-add-missing-module_description-macro.patch

