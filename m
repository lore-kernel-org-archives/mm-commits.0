Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C9CEBE
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714100707; cv=none; b=KCvI/u3K6BKLT0zIdTzpQnS03/4nKiDIEX6VMuR++3tvbQAP/vZAYx32maeWOD9XA3yRnpppTs/Zndu51gl3VSyP6WzmJI3Ms6VggU3h8SY2poYyQpO0mRZ4v0G91yF0QBDa8h8ki7x3U0kwAgfK5kfHJgM+TAi1R0fKGCOaEis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714100707; c=relaxed/simple;
	bh=cBJct3WZF0ln4dx8Lfaws6bLhj/OF7IhT2v7d+/pgys=;
	h=Date:To:From:Subject:Message-Id; b=RzkWf/6QdNttME+Oy8DQHXZ9bi3IxUPLnco/RzSXzRWaErGXEj5xtQOHIWMv9m/dw9ISOPYbg0YQPMKWp5TgYnll+aX2j3Y1gkTUiGBsH4icO3U1M23aR6tC/KGbrQ15aaRXHt/m0B8zB6YOJmerhzA3Y7un4wxPQA3OKJuVmQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HpGGLvBD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HpGGLvBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8003C113CC;
	Fri, 26 Apr 2024 03:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714100706;
	bh=cBJct3WZF0ln4dx8Lfaws6bLhj/OF7IhT2v7d+/pgys=;
	h=Date:To:From:Subject:From;
	b=HpGGLvBDVPpinVwE2TLRun62XSfPuhHzLBUNGSf8dtUt+0duYIt04/VS6XRQwBlrv
	 QAgY2UeWLKFqg+9Mrr/4UjHg66rhqlSU7WA/XO9hiaHnAjCPAhH9AR8UYFo/0Yt0A3
	 cRyEBBXJLwb1EXDzro8PPqMkVYRrPj/XIn2z4wDQ=
Date: Thu, 25 Apr 2024 20:05:06 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,surenb@google.com,ryabinin.a.a@gmail.com,mark.rutland@arm.com,kent.overstreet@linux.dev,keescook@chromium.org,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fix-missing-vmalloch-includes-fix-5.patch removed from -mm tree
Message-Id: <20240426030506.A8003C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: hw_tags: include linux/vmalloc.h
has been removed from the -mm tree.  Its filename was
     fix-missing-vmalloch-includes-fix-5.patch

This patch was dropped because it was folded into fix-missing-vmalloch-includes.patch

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
Tested-by: Kees Cook <keescook@chromium.org>
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

fix-missing-vmalloch-includes.patch
kcov-avoid-clang-out-of-range-warning.patch
test_hexdump-avoid-string-truncation-warning.patch
block-partitions-ldm-convert-strncpy-to-strscpy.patch
blktrace-convert-strncpy-to-strscpy_pad.patch
kbuild-turn-on-wextra-by-default.patch
kbuild-remove-redundant-extra-warning-flags.patch
kbuild-turn-on-wrestrict-by-default.patch
kbuild-enable-wformat-truncation-on-clang.patch
kbuild-enable-wcast-function-type-strict-unconditionally.patch

