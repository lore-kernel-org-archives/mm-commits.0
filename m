Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23919482DD
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 19:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708803393; cv=none; b=XNJHM/mKs/nXNawU+OWHdhtmI0d79DQVY13ni1t6SvwlnCTylCoIsQbwH9RJ6vbv1dyWXQcRcJANXP3FlZtnq2TMrvZwp5iCAdsSIeFC/PxbWkutMfvQskx7wsTPcb7DpkDDIfFZRXuJekLCVzpaLQVV3ALh45Kp0NKwJQUc6Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708803393; c=relaxed/simple;
	bh=K7ne8ofZGOWSdtmjMfnBU0LaddIkdiLMSVxwBh2lZAA=;
	h=Date:To:From:Subject:Message-Id; b=i3xBOINWxKD+jhtjiILK+9SlSi3PRDnQH/nTVwrlgut3tzqe63JEzsgTmsQ0KwUAl+DOXbKggSnG7dJqT17Y5Z1OzoHOwlrQPZJDUFByvZeXXjIzsH4r+fku0blw1QSpHvdZvPF9zBFD6pURBBvfeCm+4nomUkXENp5bFxhQRwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wYtElXol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wYtElXol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABCFC433F1;
	Sat, 24 Feb 2024 19:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708803392;
	bh=K7ne8ofZGOWSdtmjMfnBU0LaddIkdiLMSVxwBh2lZAA=;
	h=Date:To:From:Subject:From;
	b=wYtElXolAYSNJh91Oet0RbfIFxw2P7xUoRUq8n6xEebEbH0czfv0xDkldgsIq/u0p
	 0oZeei5PrLFVPrSErwfKq8ES5SnWPJry8orW8BKBvTKj0uY5DeolrdPxngg0ZEN/TR
	 ojgs8DTlBDY5tE9eiBJ7WSp2PsGl/0ds0+avH0rc=
Date: Sat, 24 Feb 2024 11:36:31 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,mark.rutland@arm.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,paul.heidekrueger@tum.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fix-a2-allocation-and-remove-explicit-cast-in-atomic-tests.patch added to mm-unstable branch
Message-Id: <20240224193632.9ABCFC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: fix a2 allocation and remove explicit cast in atomic tests
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-fix-a2-allocation-and-remove-explicit-cast-in-atomic-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-fix-a2-allocation-and-remove-explicit-cast-in-atomic-tests.patch

This patch will later appear in the mm-unstable branch at
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
From: Paul Heidekrüger <paul.heidekrueger@tum.de>
Subject: kasan: fix a2 allocation and remove explicit cast in atomic tests
Date: Sat, 24 Feb 2024 10:54:14 +0000

Address the additional feedback since 4e76c8cc3378 kasan: add atomic tests
(""kasan: add atomic tests") by removing an explicit cast and fixing the
size as well as the check of the allocation of `a2`.

Link: https://lkml.kernel.org/r/20240224105414.211995-1-paul.heidekrueger@tum.de
Link: https://lore.kernel.org/all/20240131210041.686657-1-paul.heidekrueger@tum.de/T/#u
Fixes: 4e76c8cc3378a20923965e3345f40f6b8ae0bdba
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

kasan-fix-a2-allocation-and-remove-explicit-cast-in-atomic-tests.patch

