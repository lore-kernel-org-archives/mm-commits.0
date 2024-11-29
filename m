Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464A2155726
	for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 11:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732878700; cv=none; b=Arj2L9GxJ9KvF/QoD2Rq+1sw3e1ALr1Jdk/L0FRFepueCtCxu4rTODKP4/4//x60nKXNgA8iPGhoEThEAIooJhGVK3gQM1bTxp5cDiQ6+TSKzVyru7A0djNi+/IAN4K1Ye+uyl+M+3vAqnU0ZnjNuJYw6YoYk2dVD+z0YfIXM/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732878700; c=relaxed/simple;
	bh=7g4/V+vAVKx5zEoqpbujIkGfApkj5rjkt6n2QJKwkCg=;
	h=Date:To:From:Subject:Message-Id; b=Tz6ZFfMAh0kCzsxArjx3Sd7IwKkqgv9X2pvDED9ZHowHXWWI6rV+JWF0tTHZTpIHQOGubEjaFB6Ik5mmEaXX1pLUSan4gRe5Ky+YX5LGwe725/0rSgjceO12qlE+K7PsDaakI9szb52TcS0czn3NLmECroBqsr+V07l7K3j5r+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GEQbvJbK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GEQbvJbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5590C4CECF;
	Fri, 29 Nov 2024 11:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732878699;
	bh=7g4/V+vAVKx5zEoqpbujIkGfApkj5rjkt6n2QJKwkCg=;
	h=Date:To:From:Subject:From;
	b=GEQbvJbK+0nmNPwpgUONKEr8nEn7qHa44/F7b/poYLLdhWEbqleA+TVvr5w4xL5RY
	 1O+3LSHpEMkaV1KjsGf68IVhrMldNt4jV3D0i0OBaUIf8lFs1oEWrzm0woqOb8EjGu
	 kPW9MB2kQf7ax7kEoGCvdHlCpl1UGoSaOVrfSnJ4=
Date: Fri, 29 Nov 2024 03:11:39 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,pedro.falcato@gmail.com,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,Jason@zx2c4.com,hch@infradead.org,david.laight@aculab.com,dan.carpenter@linaro.org,axboe@kernel.dk,arnd@kernel.org,andriy.shevchenko@linux.intel.com,David.Laight@ACULAB.COM,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + minmaxh-use-build_bug_on_msg-for-the-lo-hi-test-in-clamp.patch added to mm-nonmm-unstable branch
Message-Id: <20241129111139.C5590C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     minmaxh-use-build_bug_on_msg-for-the-lo-hi-test-in-clamp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/minmaxh-use-build_bug_on_msg-for-the-lo-hi-test-in-clamp.patch

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

minmaxh-add-whitespace-around-operators-and-after-commas.patch
minmaxh-update-some-comments.patch
minmaxh-reduce-the-define-expansion-of-min-max-and-clamp.patch
minmaxh-use-build_bug_on_msg-for-the-lo-hi-test-in-clamp.patch
minmaxh-move-all-the-clamp-definitions-after-the-min-max-ones.patch
minmaxh-simplify-the-variants-of-clamp.patch
minmaxh-remove-some-defines-that-are-only-expanded-once.patch

