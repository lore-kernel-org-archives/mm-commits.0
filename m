Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D8D3E1686
	for <mm-commits@vger.kernel.org>; Wed, 24 Jun 2026 20:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782333891; cv=none; b=JubmcBSfKaMqLSnBhnwCr7nQJQzgYD5dm17Tih7MlOfjU8nmwmteZIiAvK9/Ce48twrPQf/C8LYibk62jM3jfzDB+27yl6aocryEldF5BsFZXtkkwJh5B3Z7KrFtX/8iSIzw30FcZPDhOGIjFSkHQyqpjXjsS4pJMbQ0B/BjVLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782333891; c=relaxed/simple;
	bh=V2y443F261q0KhI7HAn+gjpePM9U0XQthH7/pP6WyjU=;
	h=Date:To:From:Subject:Message-Id; b=VnnE7aKfhvpR4rq0OWqyiXzVM2qROxPBF4OBWJZkA7nZFLKy3+iOBnuL8zEdJhrFahEGBDt/xFoQdqWPnFD3wvKRMgLlAny1I3JIhT9vu07aXSJ0Q02w3oBf2jJUPBJcjyhqGK2s+yw4zLrOyxkqjPu9INT2g36oUa3YZNwWlAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xp8JbsKD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xp8JbsKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9171F000E9;
	Wed, 24 Jun 2026 20:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782333889;
	bh=l9lU1hRU5fqmRoiKjpQP2R2P/7dYEcWLk6Wr+blivpc=;
	h=Date:To:From:Subject;
	b=Xp8JbsKDwr3MsEP5gkoZ9kEkBD/u43m1clqiewHn8HXrSv7x00u2la0hJrXnhP9bE
	 QSI2qywKvZrB4DAUYz2E6TWrfI3ygvchq7i+RVbe4RXAC+kF+NugK/+oIoHhC34kE6
	 PAiMmCkeO5WhkiTnYaQyLReXrBwNCiqFlHwBBAWM=
Date: Wed, 24 Jun 2026 13:44:48 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,sj@kernel.org,ryabinin.a.a@gmail.com,nao.horiguchi@gmail.com,linmiaohe@huawei.com,lance.yang@linux.dev,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,igorpetindev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-remove-redundant-initialization-for-kasan_flag_write_only.patch added to mm-new branch
Message-Id: <20260624204449.5C9171F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kasan: remove redundant initialization for kasan_flag_write_only
has been added to the -mm mm-new branch.  Its filename is
     mm-kasan-remove-redundant-initialization-for-kasan_flag_write_only.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-remove-redundant-initialization-for-kasan_flag_write_only.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Igor Putko <igorpetindev@gmail.com>
Subject: mm/kasan: remove redundant initialization for kasan_flag_write_only
Date: Tue, 23 Jun 2026 14:47:42 +0300

Patch series "mm: remove redundant static variable initializations".

This series removes explicit initializations of static bool variables to
false within the mm/ subsystem.  In C, static variables without explicit
initialization are implicitly placed in the .bss section and initialized
to zero/false by default.  Removing these explicit initializations follows
the Linux kernel coding style and avoids cluttering the data section.


This patch (of 2):

The static variable 'kasan_flag_write_only' is implicitly initialized to
false.  Remove the explicit initialization to follow the Linux kernel
coding style.

Link: https://lore.kernel.org/20260623114743.4565-1-igorpetindev@gmail.com
Link: https://lore.kernel.org/20260623114743.4565-2-igorpetindev@gmail.com
Signed-off-by: Igor Putko <igorpetindev@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/hw_tags.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/hw_tags.c~mm-kasan-remove-redundant-initialization-for-kasan_flag_write_only
+++ a/mm/kasan/hw_tags.c
@@ -61,7 +61,7 @@ DEFINE_STATIC_KEY_FALSE(kasan_flag_vmall
 EXPORT_SYMBOL_GPL(kasan_flag_vmalloc);
 
 /* Whether to check write accesses only. */
-static bool kasan_flag_write_only = false;
+static bool kasan_flag_write_only;
 
 #define PAGE_ALLOC_SAMPLE_DEFAULT	1
 #define PAGE_ALLOC_SAMPLE_ORDER_DEFAULT	3
_

Patches currently in -mm which might be from igorpetindev@gmail.com are

mm-kasan-remove-redundant-initialization-for-kasan_flag_write_only.patch
mm-memory-failure-remove-redundant-initialization-for-hw_memory_failure.patch

