Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2048713AED
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S9kjGRkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3EAC433C8;
	Fri, 29 Dec 2023 20:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880057;
	bh=oV3uOOw1bzh5mWAzGw/R1ohiKpN9jR1KAg/K4XULnOw=;
	h=Date:To:From:Subject:From;
	b=S9kjGRkkAENynfVJuOadElfLQp4lR+ZQnsYvtb7VrR832XdlGRTk5sHH8U6viyz86
	 Xiph3QI0icS9VT+PP7zHTh1M1WlfTLM83/6huKhOXS5tdcV682DfDhB3WyMOfO9fHT
	 WqJlxbZqVWDdelcz3f03DOALFVkuy45y4TggqKTI=
Date: Fri, 29 Dec 2023 12:00:56 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,leitao@debian.org,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,alobakin@pm.me,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] io_uring-use-mempool-kasan-hook.patch removed from -mm tree
Message-Id: <20231229200056.DF3EAC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: io_uring: use mempool KASAN hook
has been removed from the -mm tree.  Its filename was
     io_uring-use-mempool-kasan-hook.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: io_uring: use mempool KASAN hook
Date: Tue, 19 Dec 2023 23:29:05 +0100

Use the proper kasan_mempool_unpoison_object hook for unpoisoning cached
objects.

A future change might also update io_uring to check the return value of
kasan_mempool_poison_object to prevent double-free and invalid-free bugs. 
This proves to be non-trivial with the current way io_uring caches
objects, so this is left out-of-scope of this series.

Link: https://lkml.kernel.org/r/eca18d6cbf676ed784f1a1f209c386808a8087c5.1703024586.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 io_uring/alloc_cache.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/alloc_cache.h~io_uring-use-mempool-kasan-hook
+++ a/io_uring/alloc_cache.h
@@ -33,7 +33,7 @@ static inline struct io_cache_entry *io_
 		struct io_cache_entry *entry;
 
 		entry = container_of(cache->list.next, struct io_cache_entry, node);
-		kasan_unpoison_range(entry, cache->elem_size);
+		kasan_mempool_unpoison_object(entry, cache->elem_size);
 		cache->list.next = cache->list.next->next;
 		cache->nr_cached--;
 		return entry;
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

