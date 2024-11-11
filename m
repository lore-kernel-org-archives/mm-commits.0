Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8611662FA
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313734; cv=none; b=GDDwVHRfxMcrxcqxV3KEYqBDQjXdfj8hlQwywqYdq6AzQY7tFGIbEbTe1jWrFuX4G5PxkhsWK0Anm72Go2y+vE2Dxdv5CdL4dGtiZ27ZPbxg6FrrBJx+anyJCXa64MKJTqtq5p7lrJY+ct8dwwjZR6QmXEVb/m1tQviX0kOWY5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313734; c=relaxed/simple;
	bh=KY8OTdJxS17Ve+gt7i9m+g+qf8tVRqZqL+LXxq6IOCE=;
	h=Date:To:From:Subject:Message-Id; b=lOY11EM5LvtfvBfXy9dS/IvBSGmSkbXYuvHP6tB+sA71nVDPnZkZ9ETNSJZzTKOD3sWGNfVdg6XpD7Hup2T7MXMQyyzjJhT9msIBorEgQ4aHE30mVYbAD8iz+JPYr5vuTYdMRbwfPOEvDf2jJS9OAQzecCBNARNdebmAH6+duHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0BzyFzk8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0BzyFzk8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230BDC4CED0;
	Mon, 11 Nov 2024 08:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313734;
	bh=KY8OTdJxS17Ve+gt7i9m+g+qf8tVRqZqL+LXxq6IOCE=;
	h=Date:To:From:Subject:From;
	b=0BzyFzk8Pj2R4wH5qACUDjFuYR4AFX8CqFR5VWTbDuO0kyFGAegOkgGTGnuqBzsz+
	 fafKz6pkpmoFo/JP5ojX/DXO1ckvdh/x7oLAPzBP6KnRL9BXf8Ngx2ZrPeq/1oOOOz
	 3T41jxIuHnm1oenaABnACf30shujR5rKvNMD3Mkc=
Date: Mon, 11 Nov 2024 00:28:53 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-change-kasan_atomics-kunit-test-as-kunit_case_slow.patch removed from -mm tree
Message-Id: <20241111082854.230BDC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: change kasan_atomics kunit test as KUNIT_CASE_SLOW
has been removed from the -mm tree.  Its filename was
     kasan-change-kasan_atomics-kunit-test-as-kunit_case_slow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Subject: kasan: change kasan_atomics kunit test as KUNIT_CASE_SLOW
Date: Fri, 1 Nov 2024 23:40:11 +0500

During running KASAN Kunit tests with CONFIG_KASAN enabled, the following
"warning" is reported by kunit framework:

	# kasan_atomics: Test should be marked slow (runtime: 2.604703115s)

It took 2.6 seconds on my PC (Intel(R) Core(TM) i7-7700K CPU @ 4.20GHz),
apparently, due to multiple atomic checks in kasan_atomics_helper().

Let's mark it with KUNIT_CASE_SLOW which reports now as:

	# kasan_atomics.speed: slow

Link: https://lkml.kernel.org/r/20241101184011.3369247-3-snovitoll@gmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/kasan_test_c.c~kasan-change-kasan_atomics-kunit-test-as-kunit_case_slow
+++ a/mm/kasan/kasan_test_c.c
@@ -2075,7 +2075,7 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kasan_strings),
 	KUNIT_CASE(kasan_bitops_generic),
 	KUNIT_CASE(kasan_bitops_tags),
-	KUNIT_CASE(kasan_atomics),
+	KUNIT_CASE_SLOW(kasan_atomics),
 	KUNIT_CASE(vmalloc_helpers_tags),
 	KUNIT_CASE(vmalloc_oob),
 	KUNIT_CASE(vmap_tags),
_

Patches currently in -mm which might be from snovitoll@gmail.com are


