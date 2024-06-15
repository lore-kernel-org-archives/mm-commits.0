Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228681EB3D
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 17:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473433; cv=none; b=QPTR+5rO05hIaJf9Y4N5wDkisHGMAPQ/WuumtxXYD2V9QBsDOislatB0zoRWBmwwl6o8/fpu0C7mf7F1aS9D2GxcGBGYqtZnnSxMlUoaP5WXqXhB6HxvRq3ZsURXsXoX4DsMOMswZiqucMzS618y+kAuJlMp8FmVq9aPdw/Pl1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473433; c=relaxed/simple;
	bh=j/1hiPC0ybqZQ3hcdmERRvDJPsqElN1Omkl4vp7gks4=;
	h=Date:To:From:Subject:Message-Id; b=CG3XcNPiz/gLS2xtgp3RdrV4ReVpwPwN0NW1KehCT/oo68sw8WjWKSFKQquFQlM4l7ddol7zHZuPNACbIMwUt34rn/54CXWvIVA036NVuWIMh7sIztd1niAAL8OPRnFGqqOnMrOucYovvdTJspSXXiJUIfN4li3ayg3JKkg87VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2dfDmBjx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2dfDmBjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB08DC116B1;
	Sat, 15 Jun 2024 17:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473433;
	bh=j/1hiPC0ybqZQ3hcdmERRvDJPsqElN1Omkl4vp7gks4=;
	h=Date:To:From:Subject:From;
	b=2dfDmBjxSiOY/cceomltGaxKmwHGW3mM1+H8jY+7WXdfppBvHsmzFdxVJik9sPX25
	 Wrzi2pT0crEt7vm2JeYi5nb9lVaQRzyT6xBHnAwuZ5552rRjcxm3rTIwQusuBt37Gc
	 9lUM2zeADrBvsfbFGkGilro1SkzO91AuRHUglol0=
Date: Sat, 15 Jun 2024 10:43:52 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pasha.tatashin@soleen.com,oliver.sang@intel.com,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-alloc_tag-fix-rcu-imbalance-in-pgalloc_tag_get.patch removed from -mm tree
Message-Id: <20240615174352.EB08DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/alloc_tag: fix RCU imbalance in pgalloc_tag_get()
has been removed from the -mm tree.  Its filename was
     lib-alloc_tag-fix-rcu-imbalance-in-pgalloc_tag_get.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: lib/alloc_tag: fix RCU imbalance in pgalloc_tag_get()
Date: Sat, 1 Jun 2024 16:38:40 -0700

put_page_tag_ref() should be called only when get_page_tag_ref() returns a
valid reference because only in that case get_page_tag_ref() enters RCU
read section while put_page_tag_ref() will call rcu_read_unlock() even if
the provided reference is NULL.  Fix pgalloc_tag_get() which does not
follow this rule causing RCU imbalance.  Add a warning in
put_page_tag_ref() to catch any future mistakes.

Link: https://lkml.kernel.org/r/20240601233840.617458-1-surenb@google.com
Fixes: cc92eba1c88b ("mm: fix non-compound multi-order memory accounting in __free_pages")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202405271029.6d2f9c4c-lkp@intel.com
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgalloc_tag.h |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/include/linux/pgalloc_tag.h~lib-alloc_tag-fix-rcu-imbalance-in-pgalloc_tag_get
+++ a/include/linux/pgalloc_tag.h
@@ -37,6 +37,9 @@ static inline union codetag_ref *get_pag
 
 static inline void put_page_tag_ref(union codetag_ref *ref)
 {
+	if (WARN_ON(!ref))
+		return;
+
 	page_ext_put(page_ext_from_codetag_ref(ref));
 }
 
@@ -102,9 +105,11 @@ static inline struct alloc_tag *pgalloc_
 		union codetag_ref *ref = get_page_tag_ref(page);
 
 		alloc_tag_sub_check(ref);
-		if (ref && ref->ct)
-			tag = ct_to_alloc_tag(ref->ct);
-		put_page_tag_ref(ref);
+		if (ref) {
+			if (ref->ct)
+				tag = ct_to_alloc_tag(ref->ct);
+			put_page_tag_ref(ref);
+		}
 	}
 
 	return tag;
_

Patches currently in -mm which might be from surenb@google.com are

mm-slab-fix-variable-obj_exts-set-but-not-used-warning.patch
mm-handle-profiling-for-fake-memory-allocations-during-compaction.patch

