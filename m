Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A7E2BE64D
	for <mm-commits@vger.kernel.org>; Wed,  3 Sep 2025 21:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756935153; cv=none; b=Y/Pko04fwFRudlrgpkUvzpS5583pYK0dLFiEsCZDa6+3SSf9pX0bW1QgCAI8IizFMaDwAy86Xn6fC+0fJC7huhEpwBbLhwotOrGInbIRVFs6ggrVrjQ8yalTnBN8HnP0pcmsC/WQkGWshyMayo7iwpwaxf8TwTMbjJ3U/FCK+2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756935153; c=relaxed/simple;
	bh=t0Q0N+kWrgjwbaBu9cQlFBSI7qi7DHrMSy812flwHvE=;
	h=Date:To:From:Subject:Message-Id; b=gfMEdc6Sw+UtZ1XC1qyEFxXp7Hmh4BlIMFUqQSuxNIN8uBp9/HuBLecn054nyeUPeUm1f5v8Cu7MIeTlbuaZNeyTDxar6S8025D+PoE6lZ23jhBCMu1MgrKoCKdUd54tFmdfK/lRtFfhbqQTJsKmhyoLPux3/2Ta3VbcFA4Kswc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fHz9ZzzJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fHz9ZzzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025BAC4CEE7;
	Wed,  3 Sep 2025 21:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756935153;
	bh=t0Q0N+kWrgjwbaBu9cQlFBSI7qi7DHrMSy812flwHvE=;
	h=Date:To:From:Subject:From;
	b=fHz9ZzzJAbc6WoNBBgZ5B3Y9K8dPqFRBvajHeMkBFRD1LrgbZbKkl+29Ij4xNPvQB
	 NtZBMwkX9AuhnzG3jHwjQ51E8bYZd7MdJKa9+/3AGGYeiR0lp0Cza6vqLjxrOrEZSV
	 R/9DYj5eKNe2602Ewzg8o0OEPajjDuQIyKq/10dw=
Date: Wed, 03 Sep 2025 14:32:32 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,will@kernel.org,vincenzo.frascino@arm.com,scott@os.amperecomputing.com,ryabinin.a.a@gmail.com,pankaj.gupta@amd.com,oliver.upton@linux.dev,maz@kernel.org,leitao@debian.org,kaleshsingh@google.com,jhubbard@nvidia.com,james.morse@arm.com,hardevsinh.palaniya@siliconsignals.io,glider@google.com,dvyukov@google.com,david@redhat.com,corbet@lwn.net,catalin.marinas@arm.com,broonie@kernel.org,ardb@kernel.org,andreyknvl@gmail.com,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-apply-write-only-mode-in-kasan-kunit-testcases-v7.patch added to mm-new branch
Message-Id: <20250903213233.025BAC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan-apply-write-only-mode-in-kasan-kunit-testcases-v7
has been added to the -mm mm-new branch.  Its filename is
     kasan-apply-write-only-mode-in-kasan-kunit-testcases-v7.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-apply-write-only-mode-in-kasan-kunit-testcases-v7.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kasan-apply-write-only-mode-in-kasan-kunit-testcases-v7
Date: Wed, 3 Sep 2025 16:00:20 +0100

update a comment

Link: https://lkml.kernel.org/r/20250903150020.1131840-3-yeoreum.yun@arm.com
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Breno Leitao <leitao@debian.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: D Scott Phillips <scott@os.amperecomputing.com>
Cc: Hardevsinh Palaniya <hardevsinh.palaniya@siliconsignals.io>
Cc: James Morse <james.morse@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/kasan/kasan_test_c.c~kasan-apply-write-only-mode-in-kasan-kunit-testcases-v7
+++ a/mm/kasan/kasan_test_c.c
@@ -94,8 +94,9 @@ static void kasan_test_exit(struct kunit
 }
 
 /**
- * KUNIT_EXPECT_KASAN_RESULT - check that the executed expression
- * causes a KUnit test failure when the result is different from @fail.
+ * KUNIT_EXPECT_KASAN_RESULT - checks whether the executed expression
+ * produces a KASAN report; causes a KUnit test failure when the result
+ * is different from @fail.
  *
  * @test: Currently executing KUnit test.
  * @expr: Expression to be tested.
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are

kasan-hw-tags-introduce-kasanwrite_only-option.patch
kasan-apply-write-only-mode-in-kasan-kunit-testcases.patch
kasan-apply-write-only-mode-in-kasan-kunit-testcases-v7.patch

