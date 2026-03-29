Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75D3255E43
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744889; cv=none; b=ZurESS5dI9T54BFArzpMKCY284kVftdmx4FgNy25ex730wbeGTo/zwUNIfb825fH40/Ceh6kBVHKG3YIl8l6GUhcE1UjFzmcDMALZb+2N6aP5EJ5UqsgUAngJvFG/UflynrqGENzuwZ2+dY2QPZgXNxwkB81Vrn7iaqPG3S8g/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744889; c=relaxed/simple;
	bh=2XU/hhFyn+mcfr1KaTCfhKzpNeZpeta+reeCTiiQSJY=;
	h=Date:To:From:Subject:Message-Id; b=XuJXm7d8KLDiwPw9e62yd44AsXF2DgxnpwYs08xcck3raYHtehiCYPKkKO2WDcBYbY8sQdW9hUZr7StgyREGGcaiJP2oXxsR9g8EQg6kV6NUJMZM47BmiL3azYRYfY3xmETVpZCI5rMvJwCwIEcUScwKsaeQV/8NqQlLqhXa9n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YS2OVWJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YS2OVWJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB8BC4CEF7;
	Sun, 29 Mar 2026 00:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744888;
	bh=2XU/hhFyn+mcfr1KaTCfhKzpNeZpeta+reeCTiiQSJY=;
	h=Date:To:From:Subject:From;
	b=YS2OVWJCpaVCQ89bdUaE90ECxjywJGYUwgKjLUjlU9x6Fl8LS6strui4ev42FmS9D
	 hAaj+b/s0Un1TZ0GxCbuvxwxgwVx21tJf/WlkbUXjcxjU0qVVK7OD7ZpsUV8g/QSST
	 XGNwIfH1rQ9TNDog1A0LEiQvU2cfhCIXceip/Mu8=
Date: Sat, 28 Mar 2026 17:41:28 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,julia.lawall@inria.fr,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,kexinsun@smail.nju.edu.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-update-outdated-comment.patch removed from -mm tree
Message-Id: <20260329004128.BFB8BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: update outdated comment
has been removed from the -mm tree.  Its filename was
     kasan-update-outdated-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kexin Sun <kexinsun@smail.nju.edu.cn>
Subject: kasan: update outdated comment
Date: Thu, 12 Mar 2026 13:38:12 +0800

kmalloc_large() was renamed kmalloc_large_noprof() by commit 7bd230a26648
("mm/slab: enable slab allocation tagging for kmalloc and friends"), and
subsequently renamed __kmalloc_large_noprof() by commit a0a44d9175b3 ("mm,
slab: don't wrap internal functions with alloc_hooks()"), making it an
internal implementation detail.

Large kmalloc allocations are now performed through the public kmalloc()
interface directly, making the reference to KMALLOC_MAX_SIZE also stale
(KMALLOC_MAX_CACHE_SIZE would be more accurate).  Remove the references to
kmalloc_large() and KMALLOC_MAX_SIZE, and rephrase the description for
large kmalloc allocations.

Link: https://lkml.kernel.org/r/20260312053812.1365-1-kexinsun@smail.nju.edu.cn
Signed-off-by: Kexin Sun <kexinsun@smail.nju.edu.cn>
Suggested-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Assisted-by: unnamed:deepseek-v3.2 coccinelle
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/kasan.h~kasan-update-outdated-comment
+++ a/include/linux/kasan.h
@@ -352,8 +352,8 @@ bool __kasan_mempool_poison_object(void
  * kasan_mempool_unpoison_object().
  *
  * This function operates on all slab allocations including large kmalloc
- * allocations (the ones returned by kmalloc_large() or by kmalloc() with the
- * size > KMALLOC_MAX_SIZE).
+ * allocations (i.e. the ones backed directly by the buddy allocator rather
+ * than kmalloc slab caches).
  *
  * Return: true if the allocation can be safely reused; false otherwise.
  */
@@ -381,8 +381,8 @@ void __kasan_mempool_unpoison_object(voi
  * original tags based on the pointer value.
  *
  * This function operates on all slab allocations including large kmalloc
- * allocations (the ones returned by kmalloc_large() or by kmalloc() with the
- * size > KMALLOC_MAX_SIZE).
+ * allocations (i.e. the ones backed directly by the buddy allocator rather
+ * than kmalloc slab caches).
  */
 static __always_inline void kasan_mempool_unpoison_object(void *ptr,
 							  size_t size)
_

Patches currently in -mm which might be from kexinsun@smail.nju.edu.cn are


