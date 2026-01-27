Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEF01D45E8
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 03:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486200; cv=none; b=btTvpHCqpeqDrqG1vIECagQFt517csa4S7a3ub+hkTz6XEim629zZvvDNje2Ea2LCiFY0CIf0EuyNL1sVn0bNF4xNSmDZYrL/oizrPf910xndIFl6KmruZv1QwnPmBc1FL4AhGWXRDsif5UfQzxwpj1k+K3RqQiyShVCq8wAdkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486200; c=relaxed/simple;
	bh=HQufrGhVajFQ17Df3U8/rYbtvEAyXqjv5ckGRqL7iLM=;
	h=Date:To:From:Subject:Message-Id; b=f2CfZ995rkaA69NUDa7mYDTThq0jJeYYhoi+Y9d68gLQ8QcKbtijseZHnQhe9gG8C5yOovfm95NjROmycdKqaf1oJ1xf6A7KCjc9sQNnq+8KhDJi/OEYR//6+7AOGqmAXweEUXQaRD2+jXdpxDk4U5dUPEiNe5LlosX3SOvz8mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jyhv3vWD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jyhv3vWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9826C116C6;
	Tue, 27 Jan 2026 03:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486199;
	bh=HQufrGhVajFQ17Df3U8/rYbtvEAyXqjv5ckGRqL7iLM=;
	h=Date:To:From:Subject:From;
	b=jyhv3vWDzRBNKIFmyi4kn+GxKnZHrtKWilfK7UwxKrs+SRGhkJSVCJcUQdoM2EAI6
	 fOSFLqfzoD5GbwqVHRXFfIsLVBLZpQfnW3efJ7Ygn90RbZdne+pvdlu9R6+YUV92LH
	 9/oMeZyHK8brE6PHbvY9FJ4NLGgXCX8WDWocG09c=
Date: Mon, 26 Jan 2026 19:56:39 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,urezki@gmail.com,maze@google.com,maciej.wieczor-retman@intel.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,ryabinin.a.a@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc-fix.patch removed from -mm tree
Message-Id: <20260127035639.A9826C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc-fix
has been removed from the -mm tree.  Its filename was
     mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc-fix.patch

This patch was dropped because it was folded into mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc.patch

------------------------------------------------------
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc-fix
Date: Fri, 16 Jan 2026 14:28:22 +0100

Adjust vrealloc() size to verify full-granule poisoning/unpoisoning in
tag-based modes.

Link: https://lkml.kernel.org/r/20260116132822.22227-1-ryabinin.a.a@gmail.com
Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Tested-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
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

mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc.patch

