Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6752F3E
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122696; cv=none; b=BcViQvuhy6Bs0LXjmimagah6ku1s+aD4kY5U7hPc99YK5eKAM19gaPPKel1mcnJVV4PtL711eap07wUZ7fLrTJJRsK5OXqJGMv1wj0bpqJ2DlcjCPa7W4LwpDhDnM5VCu8DZM7kqA/Jcp9dWGtWLMiC8M9q4CDyw7+fAvsRAhB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122696; c=relaxed/simple;
	bh=7q3R65B7vnWp5NpKksMJsvmELwSqDZS9yadRHPDsKbI=;
	h=Date:To:From:Subject:Message-Id; b=SBEMl3t1U9A/zS+5wJMkxE5ZsRw/PWSuHadM2scFlbvjmp2McHjfUCommeS4PanA5sHQQGyAmvMFtUmeMhATAD5g0zxpcDUaRqKWYyFChMz4GSxYmmTl36ZmvZTM+yaQkKU7jb68ISqHS8Txry30uV+9Em+EBMZIqus9QajcHDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V+24+qnv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V+24+qnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F830C4CEE3;
	Thu, 10 Jul 2025 04:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752122696;
	bh=7q3R65B7vnWp5NpKksMJsvmELwSqDZS9yadRHPDsKbI=;
	h=Date:To:From:Subject:From;
	b=V+24+qnvL8yjPW00GfVg/W3nv0OmGn343J8KnbgZavYBfTj+hEjO3UKKAy3APkx2t
	 88ZELWLb1TTcc7LeT9WB6VxYrEWw0v2Tmmdaem0eOHYVWutW8QTyYJobS6NmxrEapX
	 v7hlN8u6yrjszOxoC8CU0l1sKqDZNzOEFn0Zt808=
Date: Wed, 09 Jul 2025 21:44:55 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,hch@infradead.org,glider@google.com,elver@google.com,dvyukov@google.com,david@redhat.com,arnd@arndb.de,andreyknvl@gmail.com,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-unexport-globally-copy_to_kernel_nofault-v2.patch removed from -mm tree
Message-Id: <20250710044456.0F830C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-unexport-globally-copy_to_kernel_nofault-v2
has been removed from the -mm tree.  Its filename was
     mm-unexport-globally-copy_to_kernel_nofault-v2.patch

This patch was dropped because it was folded into mm-unexport-globally-copy_to_kernel_nofault.patch

------------------------------------------------------
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Subject: mm-unexport-globally-copy_to_kernel_nofault-v2
Date: Sun, 22 Jun 2025 19:11:42 +0500

add a brief comment to `#ifndef MODULE`

Link: https://lkml.kernel.org/r/20250622141142.79332-1-snovitoll@gmail.com
Fixes: ca79a00bb9a8 ("kasan: migrate copy_user_test to kunit")
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/kasan/kasan_test_c.c~mm-unexport-globally-copy_to_kernel_nofault-v2
+++ a/mm/kasan/kasan_test_c.c
@@ -1977,6 +1977,10 @@ static void rust_uaf(struct kunit *test)
 	KUNIT_EXPECT_KASAN_FAIL(test, kasan_test_rust_uaf());
 }
 
+/*
+ * copy_to_kernel_nofault() is an internal helper available when
+ * kasan_test is built-in, so it must not be visible to loadable modules.
+ */
 #ifndef MODULE
 static void copy_to_kernel_nofault_oob(struct kunit *test)
 {
_

Patches currently in -mm which might be from snovitoll@gmail.com are

mm-unexport-globally-copy_to_kernel_nofault.patch

