Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45651369980
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 02:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782787837; cv=none; b=nJktGh8sF5f6LBJtUZun5tLzvEsJePmCFCnMDOmMP8zECdCB22LgbsBgfErpgLjgD6+Ot0TjafbJu1ruPYFnE3oSMMBlz9tJFueXmCa1HbAMaQkJzm3DHlUgi5z3hh2dWGM2Ec566T24Y3IESX4aDCDcy7XlcLvXu7Xw/qY67nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782787837; c=relaxed/simple;
	bh=GfGxtHY3tjVRXKySVgZL16/YAzCN5+4ASFheo76r/Hs=;
	h=Date:To:From:Subject:Message-Id; b=B9bXDw4tTcw2xBFbEd6eX7O6HnwNYrhGKplM0Qm9VIzo3Bq3moWENzBUgug2bIlOeNsQT3hGLd8KRnguI0UznT5WjJO6s892B/zK5Oq9bhpcsQ0uHBEqHNemhgoXOdzEAYbLHWCWO2Efk0rzihfMwSN7B2Ia1IUNMsieo4dyue0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CoDIRykN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CoDIRykN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38CD1F000E9;
	Tue, 30 Jun 2026 02:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782787835;
	bh=fiKdihXM3IJhLdUV/vLZ+4gx9mUn0cCQm9EDstXYUsw=;
	h=Date:To:From:Subject;
	b=CoDIRykNMRd1IvETV02y4jocqr3ZcVrzV8NjRj41h5w05jJK9gPIfSrhE9v8dro1n
	 eRpFfBup+HDO+lNRqJ72vzN6/31U4/upHhqbSjmeQM6FUpDe0A9iKLQwuOO4KgxRyh
	 oKC1TIWGNMkAFicETQpZQQrLAIFuncblf2QiDDYs=
Date: Mon, 29 Jun 2026 19:50:35 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,joshua.hahnjy@gmail.com,haowenchao@xiaomi.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch added to mm-unstable branch
Message-Id: <20260630025035.B38CD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix
Date: Mon Jun 29 07:48:04 PM PDT 2026

build fix

mm/zsmalloc.c: In function 'obj_class_get_and_lock':
mm/zsmalloc.c:1481:36: error: implicit declaration of function 'obj_to_class_idx' [-Wimplicit-function-declaration]
 1481 |         *classp = pool->size_class[obj_to_class_idx(obj)];
      |                                    ^~~~~~~~~~~~~~~~

Cc: Barry Song <baohua@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Wenchao Hao <haowenchao@xiaomi.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix
+++ a/mm/zsmalloc.c
@@ -1457,6 +1457,12 @@ static void obj_free(int class_size, uns
 	mod_zspage_inuse(zspage, -1);
 }
 
+/* Folds to 0 when ZS_OBJ_CLASS_BITS == 0; no ifdef needed at callers. */
+static unsigned int obj_to_class_idx(unsigned long obj)
+{
+	return (obj >> ZS_OBJ_IDX_BITS) & ZS_OBJ_CLASS_MASK;
+}
+
 /*
  * Resolve @handle to its zspage / size_class and acquire class->lock.
  *
@@ -1759,12 +1765,6 @@ static void lock_zspage(struct zspage *z
 	zspage_read_unlock(zspage);
 }
 
-/* Folds to 0 when ZS_OBJ_CLASS_BITS == 0; no ifdef needed at callers. */
-static unsigned int obj_to_class_idx(unsigned long obj)
-{
-	return (obj >> ZS_OBJ_IDX_BITS) & ZS_OBJ_CLASS_MASK;
-}
-
 static void replace_sub_page(struct size_class *class, struct zspage *zspage,
 				struct zpdesc *newzpdesc, struct zpdesc *oldzpdesc)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-page_owner-add-print_mode-filter-fix.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

