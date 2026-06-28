Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667372765FF
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 04:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782621375; cv=none; b=CTJn2EsCwADj4L9VMsFl2mqqYy7qF9JQfSD4aLGw1elYqezbGyUOtUtgn7U2Q5RMJWuBYVvMSQ3p4SP6XJKPogSZ5l1Ur5XppxCBE/7cXtDty+3pgPMfYOs7jhpjOikgfL1p9Bb4DwnCf/ER4k7/FBqgCumjTUhFLVhXEKVx6Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782621375; c=relaxed/simple;
	bh=h36rYgyUfyKGwGr943EtiXl/XrHL5UdQsDYMDDQntUA=;
	h=Date:To:From:Subject:Message-Id; b=IkDupj1phYKpxaQ+SjVczC67xJt/Kzm5s9IlOf0U8ajL6REmBkz3lG19YJHZRQHc+GIxZ89GU/leyzHD23XUbyfdYR1V+q0eoXTjqoGrn45Eu5RYLZW2NJRx2SVeoY6SZ7266O/Ci3Le1ktzvPztOCvcVfma8yr5ZfapY1XSmAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g23yYnGt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g23yYnGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F272B1F000E9;
	Sun, 28 Jun 2026 04:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782621374;
	bh=s04FHZ9iKpgCm4OXKiuM4frGMhSxMB8ubnM7Pl1Z5dc=;
	h=Date:To:From:Subject;
	b=g23yYnGtOSIBmFII7iFiVYZr09J6nxEUQRD/vaiojy2MqOQSukRqdnZzW58FUcSTE
	 /GvTtZpIuoncPBHdh8rlfv24/+qV78mDb+0b8HowdIZayc31kwJN6oDKt58YQVuGeI
	 4oZaL8WYeC78KsrUvHFFHoMhLwq4nEKu/R8+jN6A=
Date: Sat, 27 Jun 2026 21:36:13 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,joshua.hahnjy@gmail.com,baohua@kernel.org,haowenchao@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-document-free_zspage-helper-variants.patch added to mm-new branch
Message-Id: <20260628043613.F272B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: document free_zspage helper variants
has been added to the -mm mm-new branch.  Its filename is
     mm-zsmalloc-document-free_zspage-helper-variants.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-document-free_zspage-helper-variants.patch

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
From: Wenchao Hao <haowenchao@xiaomi.com>
Subject: mm/zsmalloc: document free_zspage helper variants
Date: Fri, 26 Jun 2026 09:50:03 +0800

After splitting __free_zspage() into a lockless core and a wrapper that
does the class-stat bookkeeping, three similarly-named helpers coexist:
free_zspage / __free_zspage / __free_zspage_lockless.

Add a comment block above them describing what each does and where it is
used, so the names are not easy to confuse.

No functional change.

Link: https://lore.kernel.org/20260626015003.2965881-5-haowenchao22@gmail.com
Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/mm/zsmalloc.c~mm-zsmalloc-document-free_zspage-helper-variants
+++ a/mm/zsmalloc.c
@@ -883,6 +883,22 @@ unlock:
 	return 0;
 }
 
+/*
+ * Three free helpers, kept apart here:
+ *
+ * __free_zspage_lockless(): bare core; walks zpdescs and returns pages
+ *   to the buddy allocator.  Caller owns all zpdesc locks and has
+ *   removed the zspage from its class list.  Used by zs_free() outside
+ *   class->lock so the buddy-side work does not stall the class.
+ *
+ * __free_zspage(): __free_zspage_lockless() + per-class accounting,
+ *   under class->lock.  Used by async_free_zspage(), the worker for
+ *   zspages whose trylock_zspage() failed.
+ *
+ * free_zspage(): full wrapper - trylock zpdescs, remove from class
+ *   list, call __free_zspage(); kicks deferred free on contention.
+ *   Used by compaction.
+ */
 static inline void __free_zspage_lockless(struct zspage *zspage)
 {
 	struct zpdesc *zpdesc, *next;
_

Patches currently in -mm which might be from haowenchao@xiaomi.com are

mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems.patch
mm-zsmalloc-document-free_zspage-helper-variants.patch

