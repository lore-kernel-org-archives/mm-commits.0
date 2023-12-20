Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8544421
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 00:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="koMlxRBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EEDC433C9;
	Wed, 20 Dec 2023 00:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703033907;
	bh=KTYdL1X3pArgYLLE8g4hgLWidq/3nh4uIe28hPV7YsE=;
	h=Date:To:From:Subject:From;
	b=koMlxRBHCNGEE2XRJ4y3zI+pvdvs9etEVuW7SdicoizJFL7wC7AffUwhl3adeKHyI
	 1gE0KDLsUno48fhXJJxCuDnNvnDgzTDA5C9HREXjLbj4LyJ5HShNXY/oD5q0QVPdCZ
	 M8/A5TiYwxzxkMbRxM54e4Jb9RF2NvAbm+h9rnwY=
Date: Tue, 19 Dec 2023 16:58:26 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,penguin-kernel@i-love.sakura.ne.jp,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-fix-comment-in-include-linux-stackdepoth.patch added to mm-nonmm-unstable branch
Message-Id: <20231220005827.75EEDC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/stackdepot: fix comment in include/linux/stackdepot.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-stackdepot-fix-comment-in-include-linux-stackdepoth.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-fix-comment-in-include-linux-stackdepoth.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andrey Konovalov <andreyknvl@google.com>
Subject: lib/stackdepot: fix comment in include/linux/stackdepot.h
Date: Tue, 19 Dec 2023 22:19:53 +0100

As stack traces can now be evicted from the stack depot, remove the
comment saying that they are never removed.

Link: https://lkml.kernel.org/r/0ebe712d91f8d302a8947d3c9e9123bc2b1b8440.1703020707.git.andreyknvl@google.com
Fixes: 108be8def46e ("lib/stackdepot: allow users to evict stack traces")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackdepot.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/stackdepot.h~lib-stackdepot-fix-comment-in-include-linux-stackdepoth
+++ a/include/linux/stackdepot.h
@@ -11,8 +11,6 @@
  * SLUB_DEBUG needs 256 bytes per object for that). Since allocation and free
  * stack traces often repeat, using stack depot allows to save about 100x space.
  *
- * Stack traces are never removed from the stack depot.
- *
  * Author: Alexander Potapenko <glider@google.com>
  * Copyright (C) 2016 Google, Inc.
  *
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-rename-kasan_slab_free_mempool-to-kasan_mempool_poison_object.patch
kasan-move-kasan_mempool_poison_object.patch
kasan-document-kasan_mempool_poison_object.patch
kasan-add-return-value-for-kasan_mempool_poison_object.patch
kasan-introduce-kasan_mempool_unpoison_object.patch
kasan-introduce-kasan_mempool_poison_pages.patch
kasan-introduce-kasan_mempool_unpoison_pages.patch
kasan-clean-up-__kasan_mempool_poison_object.patch
kasan-save-free-stack-traces-for-slab-mempools.patch
kasan-clean-up-and-rename-____kasan_kmalloc.patch
kasan-introduce-poison_kmalloc_large_redzone.patch
kasan-save-alloc-stack-traces-for-mempool.patch
mempool-skip-slub_debug-poisoning-when-kasan-is-enabled.patch
mempool-use-new-mempool-kasan-hooks.patch
mempool-introduce-mempool_use_prealloc_only.patch
kasan-add-mempool-tests.patch
kasan-rename-pagealloc-tests.patch
kasan-reorder-tests.patch
kasan-rename-and-document-kasan_unpoison_object_data.patch
skbuff-use-mempool-kasan-hooks.patch
io_uring-use-mempool-kasan-hook.patch
lib-stackdepot-add-printk_deferred_enter-exit-guards.patch
kasan-handle-concurrent-kasan_record_aux_stack-calls.patch
kasan-memset-free-track-in-qlink_free.patch
lib-stackdepot-fix-comment-in-include-linux-stackdepoth.patch

