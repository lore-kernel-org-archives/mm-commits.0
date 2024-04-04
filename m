Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC5D12D76B
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 19:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712260464; cv=none; b=p/1Tc9xVRnIhMHW4pJD9hd3ExGBakANhZmKEUJv1vh+CrKiFfPiupBKsyJqlhB3grHX0aAhaOvtFW09NGgQMREbZbJakKkijah4fR9SbPpwvnzTWCjvkHzcdGIgZnAxNHOUE68ZpzrX3O/1uC45dwGap7ZFiu/htG1RAMJFEDb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712260464; c=relaxed/simple;
	bh=yWEJnwgdfSEb/1hrA7QyoKwwDIaJ8FPBSE5nvnnuFWs=;
	h=Date:To:From:Subject:Message-Id; b=M7pNIG9WlvPXktHCCV0FH87027JJNFrwaimU9Cy/nTnQ6dJt5/g8TXZ1ODJ/gFqcsERCDHfFicpjfUPbRRzivb+UoZP3NpFMVRWoyAMt+8jnVoa6C5LdEp6pUOb/gfKq+/6q41Iaqe2kkaeWaAuzY+y62U5xBxltaXUVrHRUl1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oTyx4Wgw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oTyx4Wgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECAFC433F1;
	Thu,  4 Apr 2024 19:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712260463;
	bh=yWEJnwgdfSEb/1hrA7QyoKwwDIaJ8FPBSE5nvnnuFWs=;
	h=Date:To:From:Subject:From;
	b=oTyx4Wgw2E6ZOTEkfK0L0d8nHn0CfBOWeu+9U1J4YZ+ouXAQFengFTRZrczS+fwX2
	 lJ5jYCWGlyBJIE+4XgmKpzWBMSfUn4ZrGq0axEx4x0pJLbw/WJ91Q9W9PTyEZ1zLuL
	 yLdpO0uA+8NVQW0b7nrO7HHyBDVglWCM7dXmlMLg=
Date: Thu, 04 Apr 2024 12:54:22 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,surenb@google.com,ryabinin.a.a@gmail.com,mark.rutland@arm.com,kent.overstreet@linux.dev,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-missing-vmalloch-includes-fix-5.patch added to mm-unstable branch
Message-Id: <20240404195423.5ECAFC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: hw_tags: include linux/vmalloc.h
has been added to the -mm mm-unstable branch.  Its filename is
     fix-missing-vmalloch-includes-fix-5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-missing-vmalloch-includes-fix-5.patch

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
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/hw_tags.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kasan/hw_tags.c~fix-missing-vmalloch-includes-fix-5
+++ a/mm/kasan/hw_tags.c
@@ -16,6 +16,7 @@
 #include <linux/static_key.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/vmalloc.h>
 
 #include "kasan.h"
 
_

Patches currently in -mm which might be from arnd@arndb.de are

fix-missing-vmalloch-includes-fix-5.patch
kcov-avoid-clang-out-of-range-warning.patch

