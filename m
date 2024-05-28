Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBDB175567;
	Tue, 28 May 2024 20:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716926891; cv=none; b=OQceeJPaJLa8qML66zPxpAGWk4yM+W5l7HnBJui/etX6IEJ1+ztTmDs9wKRcvARINEAtxOTdplSsDfOZ4nBkecVtKLxOjjF6dF/pgWNz6ZUuUSJoaaTrxqJz2SqPMxSf+0UybW5NN/QsJzip2lln/FeiIZR5Uptj20bpGB/pe+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716926891; c=relaxed/simple;
	bh=9nK4Pt729bDyHsWtWfOueJ4b6xoCoKDa7FItRu9bWs0=;
	h=Date:To:From:Subject:Message-Id; b=UzP1QXbqXDpr/zJl00ZkeDAOMUdOebSPBoRaqfS/uWk5NX0Q+iN6dWPQCUiYLlkTdAlNiLvi6F+1PPJI/m/y3F+iAsWbpw50bsYufxqVMNPNvzZgRi/oIftJfTKN41bHuKGbZJI6JGYZbn/QAWI0Ih4tkJYGI01lrNErbPRkcVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=smtUY2yj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="smtUY2yj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83538C3277B;
	Tue, 28 May 2024 20:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716926890;
	bh=9nK4Pt729bDyHsWtWfOueJ4b6xoCoKDa7FItRu9bWs0=;
	h=Date:To:From:Subject:From;
	b=smtUY2yjYjkUZR7ZVRpFbJ81xBX2bI3kv0d2DzOiwYLznEPMmCQpI7mI+2bDf5B1f
	 uz61R1ylCZllrb61HJrK1dmuiK3ilnw/DcGe9zNH8hGlAnWZWBnhbn1nps+vd6XhOj
	 t2+6Y+8ex/LvezDnKHKfXIuzQ/WhRAAuPTqSF5S8=
Date: Tue, 28 May 2024 13:08:09 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,keescook@chromium.org,elver@google.com,dvyukov@google.com,bjohannesmeyer@gmail.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-do-not-wipe-out-origin-when-doing-partial-unpoisoning.patch added to mm-hotfixes-unstable branch
Message-Id: <20240528200810.83538C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmsan: do not wipe out origin when doing partial unpoisoning
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kmsan-do-not-wipe-out-origin-when-doing-partial-unpoisoning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-do-not-wipe-out-origin-when-doing-partial-unpoisoning.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Alexander Potapenko <glider@google.com>
Subject: kmsan: do not wipe out origin when doing partial unpoisoning
Date: Tue, 28 May 2024 12:48:06 +0200

As noticed by Brian, KMSAN should not be zeroing the origin when
unpoisoning parts of a four-byte uninitialized value, e.g.:

    char a[4];
    kmsan_unpoison_memory(a, 1);

This led to false negatives, as certain poisoned values could receive zero
origins, preventing those values from being reported.

To fix the problem, check that kmsan_internal_set_shadow_origin() writes
zero origins only to slots which have zero shadow.

Link: https://lkml.kernel.org/r/20240528104807.738758-1-glider@google.com
Fixes: f80be4571b19 ("kmsan: add KMSAN runtime core")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: Brian Johannesmeyer <bjohannesmeyer@gmail.com>
  Link: https://lore.kernel.org/lkml/20240524232804.1984355-1-bjohannesmeyer@gmail.com/T/
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Brian Johannesmeyer <bjohannesmeyer@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/core.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/kmsan/core.c~kmsan-do-not-wipe-out-origin-when-doing-partial-unpoisoning
+++ a/mm/kmsan/core.c
@@ -196,8 +196,7 @@ void kmsan_internal_set_shadow_origin(vo
 				      u32 origin, bool checked)
 {
 	u64 address = (u64)addr;
-	void *shadow_start;
-	u32 *origin_start;
+	u32 *shadow_start, *origin_start;
 	size_t pad = 0;
 
 	KMSAN_WARN_ON(!kmsan_metadata_is_contiguous(addr, size));
@@ -225,8 +224,16 @@ void kmsan_internal_set_shadow_origin(vo
 	origin_start =
 		(u32 *)kmsan_get_metadata((void *)address, KMSAN_META_ORIGIN);
 
-	for (int i = 0; i < size / KMSAN_ORIGIN_SIZE; i++)
-		origin_start[i] = origin;
+	/*
+	 * If the new origin is non-zero, assume that the shadow byte is also non-zero,
+	 * and unconditionally overwrite the old origin slot.
+	 * If the new origin is zero, overwrite the old origin slot iff the
+	 * corresponding shadow slot is zero.
+	 */
+	for (int i = 0; i < size / KMSAN_ORIGIN_SIZE; i++) {
+		if (origin || !shadow_start[i])
+			origin_start[i] = origin;
+	}
 }
 
 struct page *kmsan_vmalloc_to_page_or_null(void *vaddr)
_

Patches currently in -mm which might be from glider@google.com are

kmsan-do-not-wipe-out-origin-when-doing-partial-unpoisoning.patch

