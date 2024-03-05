Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F8EEEC6
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600535; cv=none; b=V11HOckFcQa7RcID9J8svUycPgp350FRox70kV1NIJTg3WofkTEq6G7HK1JWMpVN3HWN1QyvKgxQG66aYO5Z9KJOdfGVmCTBqDSzFOWEAZb1YXSl1S7b8ktTGpc0vrLz8ltcIkyYDfff5r4xsjVTgB3EJLd9/bS78cyUHWeHZPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600535; c=relaxed/simple;
	bh=RFVblZBX18bhLSfyGk2Hi2a2WMhM/SmyOiD81gOxwlA=;
	h=Date:To:From:Subject:Message-Id; b=EQJtcuKPtSAaxC6JsowkpTSHaAKjFpoNo3+BXlx43Ja8hOBSELN3U43nrH3SP9V4+7ZEsArkTk1KaKimrr81I7XHNG6Z//7ZDGGQx+R1M9XLbCZmxqI4w3qmztV8KOEXXAADTkOamqduJPxnPIvseDcKvkmn64XCbm7b1+f0HSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cXO21VMY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cXO21VMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AA2C433F1;
	Tue,  5 Mar 2024 01:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600535;
	bh=RFVblZBX18bhLSfyGk2Hi2a2WMhM/SmyOiD81gOxwlA=;
	h=Date:To:From:Subject:From;
	b=cXO21VMY8CSCwJlMaEaqSyMmvv3AdbQGF3Y5CLLuXrjskY2rxmlHsq7s5p3hmCxkI
	 hGmh+DGppahoqE2c6E0sGzL0eY4L/bGP8I6JCUp2npuz0QQUy1XZf0bX9VF4lVPcVh
	 DOT1SVjLWa4P2mFFcWpMaHfWB75Z3nlYEuCfdSWg=
Date: Mon, 04 Mar 2024 17:02:15 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,mark.rutland@arm.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,paul.heidekrueger@tum.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-fix-a2-allocation-and-remove-explicit-cast-in-atomic-tests.patch removed from -mm tree
Message-Id: <20240305010215.A7AA2C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: fix a2 allocation and remove explicit cast in atomic tests
has been removed from the -mm tree.  Its filename was
     kasan-fix-a2-allocation-and-remove-explicit-cast-in-atomic-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Paul Heidekrüger <paul.heidekrueger@tum.de>
Subject: kasan: fix a2 allocation and remove explicit cast in atomic tests
Date: Sat, 24 Feb 2024 10:54:14 +0000

Address the additional feedback since 4e76c8cc3378 kasan: add atomic tests
(""kasan: add atomic tests") by removing an explicit cast and fixing the
size as well as the check of the allocation of `a2`.

Link: https://lkml.kernel.org/r/20240224105414.211995-1-paul.heidekrueger@tum.de
Link: https://lore.kernel.org/all/20240131210041.686657-1-paul.heidekrueger@tum.de/T/#u
Fixes: 4e76c8cc3378 ("kasan: add atomic tests")
Signed-off-by: Paul Heidekrüger <paul.heidekrueger@tum.de>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=214055
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Marco Elver <elver@google.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/kasan/kasan_test.c~kasan-fix-a2-allocation-and-remove-explicit-cast-in-atomic-tests
+++ a/mm/kasan/kasan_test.c
@@ -700,7 +700,7 @@ static void kmalloc_uaf3(struct kunit *t
 
 static void kasan_atomics_helper(struct kunit *test, void *unsafe, void *safe)
 {
-	int *i_unsafe = (int *)unsafe;
+	int *i_unsafe = unsafe;
 
 	KUNIT_EXPECT_KASAN_FAIL(test, READ_ONCE(*i_unsafe));
 	KUNIT_EXPECT_KASAN_FAIL(test, WRITE_ONCE(*i_unsafe, 42));
@@ -766,8 +766,8 @@ static void kasan_atomics(struct kunit *
 	 */
 	a1 = kzalloc(48, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, a1);
-	a2 = kzalloc(sizeof(int), GFP_KERNEL);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, a1);
+	a2 = kzalloc(sizeof(atomic_long_t), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, a2);
 
 	/* Use atomics to access the redzone. */
 	kasan_atomics_helper(test, a1 + 48, a2);
_

Patches currently in -mm which might be from paul.heidekrueger@tum.de are


