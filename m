Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD952F3C26
	for <mm-commits@vger.kernel.org>; Thu, 12 Mar 2026 22:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773355012; cv=none; b=twt098irotrcQpn1RY8V2huMQ+rfRk9a++teRw3EsgMq6VJgMi49Cf3H1WMGOHPNkplFsYOmL8Csja0XjGQG+FFrsoK8zSE9/13gRsXsaShquZ3ZYliUyopu6TtIwgp2Kzj5VyZvdRc+Ap6oRilz2To7sGFBI9jO3hszkV/rrTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773355012; c=relaxed/simple;
	bh=XH61TRVN14aq69+eYeKbOvKeBSBwxOSfJoeZAib99UE=;
	h=Date:To:From:Subject:Message-Id; b=DCdao84vJofCEo3C80Uz5N56k5rwmXrBK7N9+X2bStkyx77A3e+YhaPlyOUAqn85ob2DlUStcllEKZVQwXvJSPZH8yVnYuT5h/oz8QtmZp/lHWplYyy45WQ8XGfYguFuLFTLlEHtpDDZSN035BvzwWIYBKZojCiv7gUDm0UEJpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h5vzyEMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h5vzyEMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C46AC4CEF7;
	Thu, 12 Mar 2026 22:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773355012;
	bh=XH61TRVN14aq69+eYeKbOvKeBSBwxOSfJoeZAib99UE=;
	h=Date:To:From:Subject:From;
	b=h5vzyEMa8gr62+FmZBE0fCCeSLkLLwy3p/jf4E7tDlflgIL70TBMNtv7/a0bjA+oV
	 Dwj8QVIk2+PYCgMjFn3YVc8D+OFCZJHwpGYweXAOM8zUnLxBb/BDIN7Dh95ctTTj1C
	 lY86nm9Ci3gWcLuK1EwO26FS9WkYUqrTtfiquh2A=
Date: Thu, 12 Mar 2026 15:36:51 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,julia.lawall@inria.fr,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,kexinsun@smail.nju.edu.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-update-outdated-comment.patch added to mm-unstable branch
Message-Id: <20260312223652.3C46AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: update outdated comment
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-update-outdated-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-update-outdated-comment.patch

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

kasan-update-outdated-comment.patch

