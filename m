Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA84921C9F9
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545873; cv=none; b=U6f93UhebQim+2H6QjIyDF7Z/coufIjW7fOuiPtGMbQM6ywOUaaSc6S36f72xelLQJNtZBDPdjjBK+PWmv1e+oABgizamHxBRBu+M2+paycEXNpWzDdUH1+hZT1LvqX3GKz22iLHKiM23agSSgySe+oeojK21P7VH6IcRq/xQSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545873; c=relaxed/simple;
	bh=QBCoqG0Q61Hzj3mRF7JICO4qm83ITkcHSfKIpzRbHOk=;
	h=Date:To:From:Subject:Message-Id; b=Cp+3+IPBD5jiMKy167VO8Zn8DPdNNRc6goFi5elEfS0Kjc3ltPfvjXPp7hVQZJAquEYGcnHrymM9oiFz3E0umYiIrdmwfS3Dx7GbKsmYDabwcDpZzESsrWGJYjiyISEcrmez2zm/0cIMbgq6sCaWrdgZXoYeBDNsL6MSQPr5Tns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XQwEpIaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XQwEpIaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52659C4CEE4;
	Tue,  1 Apr 2025 22:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545873;
	bh=QBCoqG0Q61Hzj3mRF7JICO4qm83ITkcHSfKIpzRbHOk=;
	h=Date:To:From:Subject:From;
	b=XQwEpIaWNPXu9/7wibhdoh3oZjTkL5kUP9F0cLAN6Bd6LH/t/JytSZJIJbk9JXu7+
	 ISmgxqXRYmjiGfvk+si2ECQjrRV4gxlsO/Kzhrj+ECzoSl4Sx1SR/7oLAcpJ8I2jAq
	 Qs+ZRZOtJ7tDzveGxUVuX2zvo4VCvhjRbebIfEko=
Date: Tue, 01 Apr 2025 15:17:52 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,harry.yoo@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kasan-use-slab_no_merge-flag-instead-of-an-empty-constructor.patch removed from -mm tree
Message-Id: <20250401221753.52659C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kasan: use SLAB_NO_MERGE flag instead of an empty constructor
has been removed from the -mm tree.  Its filename was
     mm-kasan-use-slab_no_merge-flag-instead-of-an-empty-constructor.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Harry Yoo <harry.yoo@oracle.com>
Subject: mm/kasan: use SLAB_NO_MERGE flag instead of an empty constructor
Date: Tue, 18 Mar 2025 10:59:26 +0900

Use SLAB_NO_MERGE flag to prevent merging instead of providing an empty
constructor.  Using an empty constructor in this manner is an abuse of
slab interface.

The SLAB_NO_MERGE flag should be used with caution, but in this case, it
is acceptable as the cache is intended solely for debugging purposes.

No functional changes intended.

Link: https://lkml.kernel.org/r/20250318015926.1629748-1-harry.yoo@oracle.com
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Acked-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/kasan/kasan_test_c.c~mm-kasan-use-slab_no_merge-flag-instead-of-an-empty-constructor
+++ a/mm/kasan/kasan_test_c.c
@@ -1073,14 +1073,11 @@ static void kmem_cache_rcu_uaf(struct ku
 	kmem_cache_destroy(cache);
 }
 
-static void empty_cache_ctor(void *object) { }
-
 static void kmem_cache_double_destroy(struct kunit *test)
 {
 	struct kmem_cache *cache;
 
-	/* Provide a constructor to prevent cache merging. */
-	cache = kmem_cache_create("test_cache", 200, 0, 0, empty_cache_ctor);
+	cache = kmem_cache_create("test_cache", 200, 0, SLAB_NO_MERGE, NULL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
 	kmem_cache_destroy(cache);
 	KUNIT_EXPECT_KASAN_FAIL(test, kmem_cache_destroy(cache));
_

Patches currently in -mm which might be from harry.yoo@oracle.com are


