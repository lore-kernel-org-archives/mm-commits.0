Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6165B3542D1
	for <mm-commits@vger.kernel.org>; Mon, 25 May 2026 22:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779746743; cv=none; b=LiZMjTevCrNVtTobl+d+mhHDJjXejSE06BAm21Kb/JJDATLikNgYaBuYuZfRGVtegsEEIIiMhpscmH+gfBxUIvzSElVjxpGalJ34meUewGtHBUYRsSKCp5/4+JvuPoII5LgdAlWQcdDEf2KOyi/OSU5jp6mqGSQJy5U5BN8x3xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779746743; c=relaxed/simple;
	bh=fLYVPM3eZ0Xi4NDxxrmBpG7kaLBdV8jDDXz80qn7jQA=;
	h=Date:To:From:Subject:Message-Id; b=AVWbOisTO35xfzj6YVGkU7LHnkMGsy1kke1JlF9aMS9VNGC5dbKo1hPh38Cmze18V35E7VQOIZIbhXFydfW00alDLS8whNJWpqUOUGhv78shpKGbFMDtZw0wY5cYI90Jzw9Z5AlJL5bYkhlxwlnEuP4Aaa2qfJnZigFmnmxHfjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dj0kIooQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dj0kIooQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3BB1F000E9;
	Mon, 25 May 2026 22:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779746742;
	bh=gEKGIiUG/3NEJIf5E3b4ag+AAgzNnqKzNph6/iSgzWs=;
	h=Date:To:From:Subject;
	b=Dj0kIooQ3QScSb0NiGajYCgKAxrODLsoqNUv0isKjKs/gcrVBhxu1SsgdgzwunamX
	 hdjPX9sN/WbyBXgG7hk9zqFvGp/iX6pxL/wA9XjYPkYSnx5/obiH1pEEHfPNMsR6Kl
	 7T+9c7/UV82r4xTmLYWu/f7b6A7uJ6LiHKu5h0RE=
Date: Mon, 25 May 2026 15:05:41 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,wsw9603@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kasan-test-only-do-kmalloc_double_kzfree-for-generic-mode.patch removed from -mm tree
Message-Id: <20260525220541.DE3BB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan/test: only do kmalloc_double_kzfree for generic mode
has been removed from the -mm tree.  Its filename was
     kasan-test-only-do-kmalloc_double_kzfree-for-generic-mode.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Wang Wensheng <wsw9603@163.com>
Subject: kasan/test: only do kmalloc_double_kzfree for generic mode
Date: Sun, 17 May 2026 15:17:13 +0800

kmalloc_double_kzfree() would corrupt kernel memory when the just freed
memory were allocated by another thread before the second call to
kfree_sensitive().

This could not happen in GENERIC mode as it uses quarantine.

Link: https://lore.kernel.org/20260517071713.353579-1-wsw9603@163.com
Signed-off-by: Wang Wensheng <wsw9603@163.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/kasan/kasan_test_c.c~kasan-test-only-do-kmalloc_double_kzfree-for-generic-mode
+++ a/mm/kasan/kasan_test_c.c
@@ -874,6 +874,12 @@ static void kmalloc_double_kzfree(struct
 	char *ptr;
 	size_t size = 16;
 
+	/*
+	 * Only generic KASAN uses quarantine, which could prevent the just freed
+	 * memory from being allocated soon.
+	 */
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
+
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
_

Patches currently in -mm which might be from wsw9603@163.com are


