Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB990134D4
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418013; cv=none; b=QphbgcGXCN3wsRLzimEARMwaxwxjlNseIJZ2lST87b+2M9PJS6ovi937rYnVAG9ZyWxXOMkT0lz01ilDRPlhKHU6Zr0qDlfekeY4TxyRLI3bO0d2CbeWRBIOfSjJpaJGRW3HMqMj/DbYXIFC3L2C+4/NSPQp1QSfe7J7vC4xwlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418013; c=relaxed/simple;
	bh=7tdzu2LgRfJDdewk02eMK3sO2hddfDJ7OU3ri5tRm1w=;
	h=Date:To:From:Subject:Message-Id; b=c4mxX/slZ32cYfzeyK5Jkvxsn2JjSWYjHu4YIBXPFUf8fyrn7Dg6S41j9gHFmiv3PeojwNXINWGTQt4t6U2dyz/uQEZNzVwnViCt3dBpWjCGpUi9Gk4o6drhMhOJYBPvNkFrNEyiaqP9Zmd+y3I9xyz1Paa6P2p9UdVefBFPoiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fme79hCd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fme79hCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B144DC4CEE2;
	Sat, 12 Apr 2025 00:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744418013;
	bh=7tdzu2LgRfJDdewk02eMK3sO2hddfDJ7OU3ri5tRm1w=;
	h=Date:To:From:Subject:From;
	b=fme79hCd+WTi0BgahlxntCxumxfQ3oQEgUv5DC3nkmBc5/zytJiCSfK4lCW2XagLd
	 RPbHB3x7OTM8p57ExLu8X0JsVAIhep9g5ZoI8VSzC1+wt8fwyNDx1BlGoP8hIZPVXX
	 2g176Y1/Pvy/DiDyxHXqHdljTMiLAK/2NSKgIc4k=
Date: Fri, 11 Apr 2025 17:33:33 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,snovitoll@gmail.com,sfr@canb.auug.org.au,ryabinin.a.a@gmail.com,peterz@infradead.org,niharchaithanya@gmail.com,masahiroy@kernel.org,jeff.johnson@oss.qualcomm.com,jannh@google.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kasan-add-module-decription.patch removed from -mm tree
Message-Id: <20250412003333.B144DC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kasan: add module decription
has been removed from the -mm tree.  Its filename was
     mm-kasan-add-module-decription.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/kasan: add module decription
Date: Mon, 24 Mar 2025 18:32:34 +0100

Modules without a description now cause a warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in mm/kasan/kasan_test.o

[akpm@linux-foundation.org: update description text, per Andrey]
Link: https://lkml.kernel.org/r/20250324173242.1501003-9-arnd@kernel.org
Fixes: 6c6c1fc09de3 ("modpost: require a MODULE_DESCRIPTION()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Macro Elver <elver@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nihar Chaithanya <niharchaithanya@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kasan/kasan_test_c.c~mm-kasan-add-module-decription
+++ a/mm/kasan/kasan_test_c.c
@@ -2127,4 +2127,5 @@ static struct kunit_suite kasan_kunit_te
 
 kunit_test_suite(kasan_kunit_test_suite);
 
+MODULE_DESCRIPTION("KUnit tests for checking KASAN bug-detection capabilities");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from arnd@arndb.de are


