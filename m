Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA46144312
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 06:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720161824; cv=none; b=UkS5KL78GplhWVQPizWNXdQB9xXSDbae7HtDbeiYW68y8M4t1xkEV4coWka/TaIYZXx+lMn/1PpsKCK7ckQPgTMVw5GbMIuwU6J+jY8rOjQ3jjKgzFI719B4faEAG99j5CZe0r3TbkLE+wagWefeqv5GDnaAtFxWbhQDlfjOFds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720161824; c=relaxed/simple;
	bh=40WX9tHzgozw86dCb2Nh9AyH6B1hRrGVBhT/hmhgBxo=;
	h=Date:To:From:Subject:Message-Id; b=LiaUFNPUsXzavlhF6GI71NBGEZSbotydQdtwZ2Ar0uT9lVr0hfMD40CHRkZirKvGhTC9f+gzsqhqkz/rBFNlFSSghljfKGJwUTAAdkaO4bxWXXMFzxppNYrNrrv8qVXW9xE5qVnrEJS4sshFztXJlXHZl0yeMugwew61mu8UuVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZYv1Imd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZYv1Imd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AF3C4AF0A;
	Fri,  5 Jul 2024 06:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720161823;
	bh=40WX9tHzgozw86dCb2Nh9AyH6B1hRrGVBhT/hmhgBxo=;
	h=Date:To:From:Subject:From;
	b=ZYv1Imd7KPDmCxVBYud1L9/H97hFxjhyOXbfDvpH5sgm0hzYQR88+VO7QHnH453J2
	 l98U2l/NWwc63q1iCTkqNpC9U8wpAy892mWxR2bVUzayiaGFMsFiGKx05StenG9Lup
	 DJGsGLHLoRTOnd6me3c39kWX+E/wZsC3hdeTrUf4=
Date: Thu, 04 Jul 2024 23:43:43 -0700
To: mm-commits@vger.kernel.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] math-rational-add-missing-module_description-macro.patch removed from -mm tree
Message-Id: <20240705064343.D7AF3C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: math: rational: add missing MODULE_DESCRIPTION() macro
has been removed from the -mm tree.  Its filename was
     math-rational-add-missing-module_description-macro.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


