Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60E62EDD57
	for <mm-commits@vger.kernel.org>; Fri, 16 Jan 2026 21:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768599491; cv=none; b=Bdtsa6rH6PgWMZwzSeSEjyLhQcr01stpFglGw9RhsBOpkHiA8BizWreudpS2CvA39spJZZ/ZKZg/Hj9RHfaA8rsFzgNaHguU7CeKjd59FIkECz2gJnqgnms1IaKXSxD1sZLsDc5xSYJz9zTyco0bBAkv0SlKl0gb4TlTatnIVic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768599491; c=relaxed/simple;
	bh=6zhg0yL1/Nh5MJzTOYw3yVhygdz0qDPIGmBxiBJuBfY=;
	h=Date:To:From:Subject:Message-Id; b=Zp7AjmigwbpliFanChMt7dpEowYVmY3OaUTZLOWjCEBvZJvRl6AnMubkh7fMFtlnSX8dVXNOuZiCWf3Xr8Ln6bQHMHyJ7EifmmU8nNhJ2psTuFuawxK44CBav/psACp+DUu8N5LZ5tH/ycK+SEJETeopQILWvN3i+HFRJMyimgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d4gxCR4J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d4gxCR4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2963BC116C6;
	Fri, 16 Jan 2026 21:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768599491;
	bh=6zhg0yL1/Nh5MJzTOYw3yVhygdz0qDPIGmBxiBJuBfY=;
	h=Date:To:From:Subject:From;
	b=d4gxCR4JlYVllP56xCSuxVBSjOy9lG5DBvZ7ZKZDeqVKbLXp9IpN5nvu2Z4GBfM2S
	 FYhhCq75Bl+OeqHA4aDKrCuh+3XC7Pio0yZzLPlre2Y09aYuVeO+xwfh3kixB9C2i1
	 FMxiBQExC0BHRQG7x5MUb84EQ75amp8fRqrhtoWc=
Date: Fri, 16 Jan 2026 13:38:10 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,urezki@gmail.com,maze@google.com,maciej.wieczor-retman@intel.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,ryabinin.a.a@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc-fix.patch added to mm-unstable branch
Message-Id: <20260116213811.2963BC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc-fix
Date: Fri, 16 Jan 2026 14:28:22 +0100

Adjust vrealloc() size to verify full-granule poisoning/unpoisoning in
tag-based modes.

Link: https://lkml.kernel.org/r/20260116132822.22227-1-ryabinin.a.a@gmail.com
Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Tested-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Maciej Żenczykowski <maze@google.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kasan/kasan_test_c.c~mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc-fix
+++ a/mm/kasan/kasan_test_c.c
@@ -1881,7 +1881,7 @@ static void vmalloc_oob(struct kunit *te
 
 	vmalloc_oob_helper(test, v_ptr, size);
 
-	size--;
+	size -= KASAN_GRANULE_SIZE + 1;
 	v_ptr = vrealloc(v_ptr, size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
 
@@ -1889,7 +1889,7 @@ static void vmalloc_oob(struct kunit *te
 
 	vmalloc_oob_helper(test, v_ptr, size);
 
-	size += 2;
+	size += 2 * KASAN_GRANULE_SIZE + 2;
 	v_ptr = vrealloc(v_ptr, size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
 
_

Patches currently in -mm which might be from ryabinin.a.a@gmail.com are

mm-kasan-fix-kasan-poisoning-in-vrealloc.patch
mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc.patch
mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc-fix.patch

