Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87841A4F28
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 20:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724875987; cv=none; b=SKaXDiCKEv1MubXqP02iCPqagjpo4bhN8iuhcXmhWt/V8xFH7kkxIFQoPDFnTGjhQuQ60LzPQXdbUobv7dSphP6y7ABuokOlnKEaSnr+vCCQGJZF2w4R0BxG5V6rbIxt7+enyFCzM4CQmP6JHQ1IiPxAy+Ur0Brm+T8q4k2sfL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724875987; c=relaxed/simple;
	bh=6E4z0v3hnIs365ZcbypEwjg+LDLJIa2EesYlMLqppTE=;
	h=Date:To:From:Subject:Message-Id; b=cwUqsWt2IhzUQgr+/Lezsec8M236Rpa4N6bo2xgSy/aB5qsS7wIIw8HY01jpwMpLUdy8SFx9ZHEZ6/nX7t6aMYnkVS8jpcnZzHzTuIl5tpUcIfY3qoLme5P0HQeQukPHBMeX3RVnXSTmkmGWlMpV4WfVStTvhQnYyPpuF37YnEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UYtCG3qI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UYtCG3qI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284D8C4CEC0;
	Wed, 28 Aug 2024 20:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724875987;
	bh=6E4z0v3hnIs365ZcbypEwjg+LDLJIa2EesYlMLqppTE=;
	h=Date:To:From:Subject:From;
	b=UYtCG3qIxQunAZOg41PJl72+D+BhAeOo/iO84Ub0wFJ37m33p/3zLfhJ/0fRKzlrm
	 spjaz1EsfparfcDW4LdqJ0OFMaxgqZx/ibUh5GE35cd6rg9AIkztEsq2VOk0ny6rPw
	 RovAWpQgF03W/slZcseumhpY2fqqYJoVlPjhToWI=
Date: Wed, 28 Aug 2024 13:13:06 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@infradead.org,lihongbo22@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-use-of-the-helper-macro-list_head.patch added to mm-unstable branch
Message-Id: <20240828201307.284D8C4CEC0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc.c: make use of the helper macro LIST_HEAD()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-use-of-the-helper-macro-list_head.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-use-of-the-helper-macro-list_head.patch

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
From: Hongbo Li <lihongbo22@huawei.com>
Subject: mm/vmalloc.c: make use of the helper macro LIST_HEAD()
Date: Wed, 28 Aug 2024 12:12:16 +0800

list_head can be initialized automatically with LIST_HEAD() instead of
calling INIT_LIST_HEAD().  Here we can simplify the code.

Link: https://lkml.kernel.org/r/20240828041216.1222582-1-lihongbo22@huawei.com
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/mm/vmalloc.c~mm-make-use-of-the-helper-macro-list_head
+++ a/mm/vmalloc.c
@@ -2131,23 +2131,18 @@ reclaim_list_global(struct list_head *he
 static void
 decay_va_pool_node(struct vmap_node *vn, bool full_decay)
 {
+	LIST_HEAD(decay_list);
+	struct rb_root decay_root = RB_ROOT;
 	struct vmap_area *va, *nva;
-	struct list_head decay_list;
-	struct rb_root decay_root;
 	unsigned long n_decay;
 	int i;
 
-	decay_root = RB_ROOT;
-	INIT_LIST_HEAD(&decay_list);
-
 	for (i = 0; i < MAX_VA_SIZE_PAGES; i++) {
-		struct list_head tmp_list;
+		LIST_HEAD(tmp_list);
 
 		if (list_empty(&vn->pool[i].head))
 			continue;
 
-		INIT_LIST_HEAD(&tmp_list);
-
 		/* Detach the pool, so no-one can access it. */
 		spin_lock(&vn->pool_lock);
 		list_replace_init(&vn->pool[i].head, &tmp_list);
_

Patches currently in -mm which might be from lihongbo22@huawei.com are

mm-make-use-of-the-helper-macro-list_head.patch
lib-string_choices-add-str_true_false-str_false_true-helper.patch
mm-make-use-of-str_true_false-helper.patch
nfs-make-use-of-str_false_true-helper.patch

