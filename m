Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF00212EBDC
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 18:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712254722; cv=none; b=rUZmqXCwbQ/6flhmXZu1RnzdyODG/XqK6Uj+fH/nBNlJAfGUCk3b99/Ysb4XsHc+ZbFgOXN4V7Q7ICCxZD/rEujpiyLSei7losIzwIYa4lOurZo+WNnjj0dYpjhcLgwDPXGcwJVYTnIll+Nmyjn6pW2PhsvTQSvoiEZgJ1VkciQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712254722; c=relaxed/simple;
	bh=Da4OlSTAQA1CNjdoz/iAkneN4COn0UdxiKUL0bIvYxI=;
	h=Date:To:From:Subject:Message-Id; b=eEXgcNsv79l/PswVPPQHdBUNz+Y/vl1AibsJHixkXLrEVH0tMxPObWB02oii8FwJJhqaylZrL1Qj1KP57r52VVnSTzLLkX4EGrUv4ptPjsJKhmtinOOMgJh2fc1QH+lqLEbZ8qgb//Cg1xZt7giXooF93ubP9cTp15vMfG/svxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vBZTwTuB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vBZTwTuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F61C433F1;
	Thu,  4 Apr 2024 18:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712254722;
	bh=Da4OlSTAQA1CNjdoz/iAkneN4COn0UdxiKUL0bIvYxI=;
	h=Date:To:From:Subject:From;
	b=vBZTwTuBN3Pdqi+KiCBjfoeCOKBXFpQiPynSVc1XMqqWEWQ4S4ohq7Jzgpa06SQRD
	 0L5Lpi0uFGEOHzMMQtNTz/Fto2NeLUREL6NfJ13XEVmmudRfHd1nKeCJYaGUIMS9EY
	 AIRTOU86ulkKNgCLHLmtYu/jvNwC3WDp/7lZa0+0=
Date: Thu, 04 Apr 2024 11:18:41 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,mark.rutland@arm.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-hw_tags-include-linux-vmalloch.patch added to mm-unstable branch
Message-Id: <20240404181842.15F61C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: hw_tags: include linux/vmalloc.h
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-hw_tags-include-linux-vmalloch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-hw_tags-include-linux-vmalloch.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kasan: hw_tags: include linux/vmalloc.h
Date: Thu, 4 Apr 2024 14:44:30 +0200

This header is no longer included implicitly and instead needs to be
pulled in directly:

mm/kasan/hw_tags.c: In function 'unpoison_vmalloc_pages':
mm/kasan/hw_tags.c:280:16: error: implicit declaration of function 'find_vm_area'; did you mean 'find_vma_prev'? [-Werror=implicit-function-declaration]
  280 |         area = find_vm_area((void *)addr);
      |                ^~~~~~~~~~~~
      |                find_vma_prev
mm/kasan/hw_tags.c:280:14: error: assignment to 'struct vm_struct *' from 'int' makes pointer from integer without a cast [-Werror=int-conversion]
  280 |         area = find_vm_area((void *)addr);
      |              ^
mm/kasan/hw_tags.c:284:29: error: invalid use of undefined type 'struct vm_struct'
  284 |         for (i = 0; i < area->nr_pages; i++) {
      |                             ^~
mm/kasan/hw_tags.c:285:41: error: invalid use of undefined type 'struct vm_struct'
  285 |                 struct page *page = area->pages[i];
      |                                         ^~

Link: https://lkml.kernel.org/r/20240404124435.3121534-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/hw_tags.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kasan/hw_tags.c~kasan-hw_tags-include-linux-vmalloch
+++ a/mm/kasan/hw_tags.c
@@ -16,6 +16,7 @@
 #include <linux/static_key.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/vmalloc.h>
 
 #include "kasan.h"
 
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-hw_tags-include-linux-vmalloch.patch
kcov-avoid-clang-out-of-range-warning.patch

