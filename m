Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5164811C8B;
	Thu, 22 Feb 2024 00:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560217; cv=none; b=c/H7bIbhzUSgjH52qQq6WjxAYb6xxpwnCQjuSoiDJjpgHjK4txi3gny/FM/p8kfYo00HKw0FPnwh4QGmynKYUMPsvbU9Ji6QR8ZHrXDZb49z01RUXZWhQArFqBR6hMHWHCeaP0C/jm0fgM/NDXENJG1GJBkQxmJ8JqvG6b+YH38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560217; c=relaxed/simple;
	bh=NCLBDF1aWq1vjCKSbdviULZqVSrZVvXw0hGMSa3udjg=;
	h=Date:To:From:Subject:Message-Id; b=W5cVvkxgMjJ9jkIzATdpUNmiTeSRQ4vS4JWMzV1j8f3pqIC1RwrkBzdAregE5Kb+xaeIDxqDNk05Fwx8H9GaPuBxmeGPEwOh6oFYni0N+JmKYq7FSFTHx4xC4yLYeyUr6eVOIbaQeR3Ut07qzwsXa5WxX1rnq/wXnSg9iOTd/gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lk00iwCh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lk00iwCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262BDC433F1;
	Thu, 22 Feb 2024 00:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560217;
	bh=NCLBDF1aWq1vjCKSbdviULZqVSrZVvXw0hGMSa3udjg=;
	h=Date:To:From:Subject:From;
	b=Lk00iwChkZ8YaU7AmUhrMZlpILEYgKqX+GRIYZrn8pzovqN8jr9y6cSPL6+tDeP+c
	 rSc3ElxRX0eF5LneXOUD2M+SP1cI67RypiMiJ5B9DF7L5xNMmkEdUhjEg3NoTSn95J
	 9XGpMFV1sUbaXgeA6XShnxewJJWBqACwYGC6D7XE=
Date: Wed, 21 Feb 2024 16:03:36 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-test-avoid-gcc-warning-for-intentional-overflow.patch removed from -mm tree
Message-Id: <20240222000337.262BDC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan/test: avoid gcc warning for intentional overflow
has been removed from the -mm tree.  Its filename was
     kasan-test-avoid-gcc-warning-for-intentional-overflow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
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

mm-mmu_gather-add-tlb_remove_tlb_entries-fix.patch

