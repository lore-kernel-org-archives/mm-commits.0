Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0245D4F885;
	Mon, 12 Feb 2024 22:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707777587; cv=none; b=cbJruVj0B4NuaWcAgKVmBqxNXJZely3f8bqAUZN5TfhsULCcrCn+vPRVd8dDmuSyFUnPvnyyhQDX4MceJLWybDIGb35wty3wa9wUzRT6DP4uaeHswyad0oW9gtArQGhtPMPSoDC1dt9hlLL7wpxce7YOp/MKbpktcztlqst6jVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707777587; c=relaxed/simple;
	bh=Gbq6N9yaMNPEmQq/1JXGM3VVTsxorM+XxrcI+HHAiCY=;
	h=Date:To:From:Subject:Message-Id; b=bGkmeRm9DeRaVlv0C8l+t8jOe/MaLZUMAWkw6NiePBZyezG2pp4UssNSeJBxha5TVZmZgWYv2UeziaGnaz3vp3A6MxZIfJea7FVdmL+5MAB1eQBtZbbh1khHWMeVL21JU7UTAleYwMhdR3fzJ6jBj458dmY6EmyBlp34wl8vb+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L2Dy9W00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L2Dy9W00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A04C433F1;
	Mon, 12 Feb 2024 22:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707777586;
	bh=Gbq6N9yaMNPEmQq/1JXGM3VVTsxorM+XxrcI+HHAiCY=;
	h=Date:To:From:Subject:From;
	b=L2Dy9W00SsJoF1uMzI7v9VbSIcWF9bKmfT6darMm8EIrxGwWLuo/cjUSyjS3FugdD
	 ySGiMOSLFRsXeiwdTq+dgWZTc5Yzcrk8Si3WEhkSbskcsQDbXLAa+lWh01/VfK+ZNz
	 TjA9h/8RIV6s1tYGybSQuyohwIkG3XmXNAy5+BtU=
Date: Mon, 12 Feb 2024 14:39:45 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-test-avoid-gcc-warning-for-intentional-overflow.patch added to mm-unstable branch
Message-Id: <20240212223946.52A04C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan/test: avoid gcc warning for intentional overflow
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-test-avoid-gcc-warning-for-intentional-overflow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-test-avoid-gcc-warning-for-intentional-overflow.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: kasan/test: avoid gcc warning for intentional overflow
Date: Mon, 12 Feb 2024 12:15:52 +0100

The out-of-bounds test allocates an object that is three bytes too short
in order to validate the bounds checking.  Starting with gcc-14, this
causes a compile-time warning as gcc has grown smart enough to understand
the sizeof() logic:

mm/kasan/kasan_test.c: In function 'kmalloc_oob_16':
mm/kasan/kasan_test.c:443:14: error: allocation of insufficient size '13' for type 'struct <anonymous>' with size '16' [-Werror=alloc-size]
  443 |         ptr1 = kmalloc(sizeof(*ptr1) - 3, GFP_KERNEL);
      |              ^

Hide the actual computation behind a RELOC_HIDE() that ensures
the compiler misses the intentional bug.

Link: https://lkml.kernel.org/r/20240212111609.869266-1-arnd@kernel.org
Fixes: 3f15801cdc23 ("lib: add kasan test module")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/kasan/kasan_test.c~kasan-test-avoid-gcc-warning-for-intentional-overflow
+++ a/mm/kasan/kasan_test.c
@@ -440,7 +440,8 @@ static void kmalloc_oob_16(struct kunit
 	/* This test is specifically crafted for the generic mode. */
 	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
 
-	ptr1 = kmalloc(sizeof(*ptr1) - 3, GFP_KERNEL);
+	/* RELOC_HIDE to prevent gcc from warning about short alloc */
+	ptr1 = RELOC_HIDE(kmalloc(sizeof(*ptr1) - 3, GFP_KERNEL), 0);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr1);
 
 	ptr2 = kmalloc(sizeof(*ptr2), GFP_KERNEL);
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-damon-dbgfs-implement-deprecation-notice-file-fix.patch
kasan-test-avoid-gcc-warning-for-intentional-overflow.patch

