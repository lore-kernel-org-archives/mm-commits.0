Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5ED38945A
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298381; cv=none; b=BZSuFQyitCFqvowBQuWxsLcUM1Lp0DTCYHLG2aQ/GSD04NQm2zapTRJVusfz9PgHLHOZsJHfKxMfmkgJ0Oddq+kLrBgzrJWYtKOIM4dv290dWCJKZkiGW/n0VmlXHGocNKhI2q04bA9KiNYcS9W8wADZDo/GnjTbHm5Nbro5JjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298381; c=relaxed/simple;
	bh=FmXZkyFFUaBG+IlPdZdZSgSDdnjOICDXm3aKUZUKEhs=;
	h=Date:To:From:Subject:Message-Id; b=dD59hjcRcJ1t8YW8p0sWiPtM4SL2By/K7lirRj99b4JAnnzqeS6OF+1RXS4RdqUtCCcMiX8rCy2CQx0vHvALpSB/7B0rqjHB6Xw/H15B8k15AbIy0s0ygmmf9SuIGZMaxvtzz5+3n3cEwRPdljsWf61YlmYhymeJ/cOM74bEYTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HgzeMhJr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HgzeMhJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02621F000E9;
	Wed, 29 Jul 2026 04:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298379;
	bh=EIvnhGfmROCKK8u4b6/eEYGogZeS8Z/N8NsKpMiHt9I=;
	h=Date:To:From:Subject;
	b=HgzeMhJr+utj+jKBlmKMXtdCW0elWxxwrLttfNkq9iE5TR3fCUVQfR+LASfLiGozN
	 F2rPijRj/PmQcPgdJO1stNjVl6MAUM8nFDMlA3u21+1BO5LUNWB/93/X/uLw+rXgzj
	 uiZXW0lLZ7dmzo6KIny5UFg3oBAT2E78eYij8HIQ=
Date: Tue, 28 Jul 2026 21:12:59 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,sj@kernel.org,ryabinin.a.a@gmail.com,nao.horiguchi@gmail.com,linmiaohe@huawei.com,lance.yang@linux.dev,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,igorpetindev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kasan-remove-redundant-initialization-for-kasan_flag_write_only.patch removed from -mm tree
Message-Id: <20260729041259.C02621F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kasan: remove redundant initialization for kasan_flag_write_only
has been removed from the -mm tree.  Its filename was
     mm-kasan-remove-redundant-initialization-for-kasan_flag_write_only.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


