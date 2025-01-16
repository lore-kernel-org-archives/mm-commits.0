Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059894C81
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006485; cv=none; b=lSu74hW8b8bcDUscuBrjJhzJJjCbs0/ysYC18QnVCPblsWZ++CeCwqBOVN0ExnOgUWj6s99C55uqFwrSJg4776/S70hUInkiCooop4CXsIBySjUtng2uDU5gXjIj2h6ND4d/McWi81ExOneo2Xyd8JvmundUcbLdJ/vP5PGAkqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006485; c=relaxed/simple;
	bh=bGfmJs7/oaR5kvywp88TRY10GZPNaPEyGgw2ezMI43U=;
	h=Date:To:From:Subject:Message-Id; b=FstJktsuwA4JvPkyltaWoWp/WIOSLDjIAoOeSmtX200kl3+bUCXDXentfe1zi1gJTuQ8zF2bh07AJRVoV29Bj2ce+XE1HrXeO09X6J4yiSE5swbR56y3ilkom7APIrKNJgqnpuLw0E0VGagBn7yiDUsx1jO3FuDTrtm/tk6hxrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MSFOdljM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MSFOdljM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82800C4CED6;
	Thu, 16 Jan 2025 05:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006484;
	bh=bGfmJs7/oaR5kvywp88TRY10GZPNaPEyGgw2ezMI43U=;
	h=Date:To:From:Subject:From;
	b=MSFOdljMhVIf0LdXR9oGnqJ8WU3wYkiO8kCVxVoJiU39o5+FaPR7Dyl9QO/izqDde
	 QEVV1EUiprl+uWuLcFGWKEVoD5iYJB+oyZ4ZgWa2Vd0WVAnr7H08d6BG0QCyEq6Sa1
	 oOv9BgkASL91kzB5Kc8mc+itXStX2qsZoQfc6Ksk=
Date: Wed, 15 Jan 2025 21:48:04 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,pedro.falcato@gmail.com,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,Jason@zx2c4.com,hch@infradead.org,david.laight@aculab.com,dan.carpenter@linaro.org,axboe@kernel.dk,arnd@kernel.org,andriy.shevchenko@linux.intel.com,David.Laight@ACULAB.COM,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] minmaxh-use-build_bug_on_msg-for-the-lo-hi-test-in-clamp.patch removed from -mm tree
Message-Id: <20250116054804.82800C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
has been removed from the -mm tree.  Its filename was
     minmaxh-use-build_bug_on_msg-for-the-lo-hi-test-in-clamp.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Laight <David.Laight@ACULAB.COM>
Subject: minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
Date: Mon, 18 Nov 2024 19:13:31 +0000

Use BUILD_BUG_ON_MSG(statically_true(ulo > uhi), ...) for the sanity check
of the bounds in clamp().  Gives better error coverage and one less
expansion of the arguments.

Link: https://lkml.kernel.org/r/34d53778977747f19cce2abb287bb3e6@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/minmax.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/minmax.h~minmaxh-use-build_bug_on_msg-for-the-lo-hi-test-in-clamp
+++ a/include/linux/minmax.h
@@ -106,8 +106,7 @@
 	__auto_type uval = (val);						\
 	__auto_type ulo = (lo);							\
 	__auto_type uhi = (hi);							\
-	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
-			(lo) <= (hi), true),					\
+	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
 	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
_

Patches currently in -mm which might be from David.Laight@ACULAB.COM are


