Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE501401B;
	Tue,  5 Aug 2025 20:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754425773; cv=none; b=H0hR6p0N13gAA47vQHU0OCvyjhlu76vCHieEybP7ChfVeLA0qZwpgi4x+zu8x9q5gQ9smfCMBnMT7yQ23GGVqu6cRYaoLrAZL0T63zYXA7HwohX8cyr67d5G9P0MmmqEh8RisvF6ALAn3nmmFvqdSG8CGRIWhR1B10JQ6/r6RBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754425773; c=relaxed/simple;
	bh=3gpW9CyhHojneix+fgNw+WV8FuIaeJgT5eTfjFUht8g=;
	h=Date:To:From:Subject:Message-Id; b=nbxFbKB7Og5oz3AMlcOQKVUz4I3UgNCBBIw1ngbXiZLLrnPZBhZFCxneXUOgGv9Q5KoI2kDYUSo14SDx4KxLNAPnLhplzrgVHXelizg6aTCQaNExl8b+wcNXSs1A6ciTGitASgsZh76f/x2PhfWmbnvE+s3zxXf3cej4UXhq2kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yx5gcBGl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yx5gcBGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B1AC4CEF0;
	Tue,  5 Aug 2025 20:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754425772;
	bh=3gpW9CyhHojneix+fgNw+WV8FuIaeJgT5eTfjFUht8g=;
	h=Date:To:From:Subject:From;
	b=yx5gcBGlz9BbjGEUrJsFCA3Z4yTD55JHnfiK/Sv0CwI7slN6qBsZXI6aC5eHHWCzS
	 3/Hhx/vPoS2S/qGIcLPTLsWknWN2A91IAABalOQ3t3KQ4FBbfX6sUznN59vRUuLLbV
	 mWDtFxAL7iqrB2Sc7HLfjg5NavUOZ3A0H+tiGpFM=
Date: Tue, 05 Aug 2025 13:29:32 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,niharchaithanya@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kasan-test-fix-protection-against-compiler-elision.patch removed from -mm tree
Message-Id: <20250805202932.B9B1AC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan/test: fix protection against compiler elision
has been removed from the -mm tree.  Its filename was
     kasan-test-fix-protection-against-compiler-elision.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: kasan/test: fix protection against compiler elision
Date: Mon, 28 Jul 2025 22:11:54 +0200

The kunit test is using assignments to
"static volatile void *kasan_ptr_result" to prevent elision of memory
loads, but that's not working:
In this variable definition, the "volatile" applies to the "void", not to
the pointer.
To make "volatile" apply to the pointer as intended, it must follow
after the "*".

This makes the kasan_memchr test pass again on my system.  The
kasan_strings test is still failing because all the definitions of
load_unaligned_zeropad() are lacking explicit instrumentation hooks and
ASAN does not instrument asm() memory operands.

Link: https://lkml.kernel.org/r/20250728-kasan-kunit-fix-volatile-v1-1-e7157c9af82d@google.com
Fixes: 5f1c8108e7ad ("mm:kasan: fix sparse warnings: Should it be static?")
Signed-off-by: Jann Horn <jannh@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Nihar Chaithanya <niharchaithanya@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/kasan_test_c.c~kasan-test-fix-protection-against-compiler-elision
+++ a/mm/kasan/kasan_test_c.c
@@ -47,7 +47,7 @@ static struct {
  * Some tests use these global variables to store return values from function
  * calls that could otherwise be eliminated by the compiler as dead code.
  */
-static volatile void *kasan_ptr_result;
+static void *volatile kasan_ptr_result;
 static volatile int kasan_int_result;
 
 /* Probe for console output: obtains test_status lines of interest. */
_

Patches currently in -mm which might be from jannh@google.com are

kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping.patch
kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v2.patch

