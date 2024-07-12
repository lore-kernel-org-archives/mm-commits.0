Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A2F127E0F
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824919; cv=none; b=IKcBIsdxsZDjOtXo6k8w/rU2BYeG50n96+cAMl6N5FN5GjJUY/yqd6HGiuTgjjvRnnISwlubHT04I7Puuj1fSCWAzXQ8ehZyh63MZbM30UFC5+DZZ892MJe62xfIVDLmgzn+1rr+BJps+PLFA0uhryAEOpYMr6XFOuG7wqqMOpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824919; c=relaxed/simple;
	bh=VQ34EeR/NzeLIK9cjNIv2IC7epKeuhzaYq8qEEGsznI=;
	h=Date:To:From:Subject:Message-Id; b=Fxm5U+m2TUSsFj0gxzhhEXcnEaz7kfytcVnTvNcf4RKSWKVL3WT9F3XJGeiY7ldL1PHpX79JYPKCUgclmACbHCX+LD2+9ILyAk/ZIZIYDa/ssy8TgRP14hmO9keEpAmmCsQPVvHiHYgj5OR3A2Ci6mEb9OPyWlITWcFQ5a5Q5qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JMzkyfRn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JMzkyfRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1181AC32782;
	Fri, 12 Jul 2024 22:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824919;
	bh=VQ34EeR/NzeLIK9cjNIv2IC7epKeuhzaYq8qEEGsznI=;
	h=Date:To:From:Subject:From;
	b=JMzkyfRneVCPE3hiqNpzLawgV/ALx67ZrTuPd8SDH4tcFHPORfDlAwupKmoSNrC/I
	 +OQda9/jbgHW7TwIl/sACExugRRH0GV/GEzx1KfuKVIZoIR1SFqAah3EOAzW01aG8M
	 iMhPhvuhTBIuvOy/FZCwDUs35MXDoHr5Xmamx7zc=
Date: Fri, 12 Jul 2024 15:55:18 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,souravpanda@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-fix-page_ext_get-page_ext_put-sequence-during-page-splitting.patch removed from -mm tree
Message-Id: <20240712225519.1181AC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: fix page_ext_get/page_ext_put sequence during page splitting
has been removed from the -mm tree.  Its filename was
     alloc_tag-fix-page_ext_get-page_ext_put-sequence-during-page-splitting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: fix page_ext_get/page_ext_put sequence during page splitting
Date: Thu, 11 Jul 2024 15:04:57 -0700

pgalloc_tag_sub() might call page_ext_put() using a page different from
the one used in page_ext_get() call.  This does not pose an issue since
page_ext_put() ignores this parameter as long as it's non-NULL but
technically this is wrong.  Fix it by storing the original page used in
page_ext_get() and passing it to page_ext_put().

Link: https://lkml.kernel.org/r/20240711220457.1751071-3-surenb@google.com
Fixes: be25d1d4e822 ("mm: create new codetag references during page splitting")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgalloc_tag.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/pgalloc_tag.h~alloc_tag-fix-page_ext_get-page_ext_put-sequence-during-page-splitting
+++ a/include/linux/pgalloc_tag.h
@@ -71,6 +71,7 @@ static inline void pgalloc_tag_sub(struc
 static inline void pgalloc_tag_split(struct page *page, unsigned int nr)
 {
 	int i;
+	struct page_ext *first_page_ext;
 	struct page_ext *page_ext;
 	union codetag_ref *ref;
 	struct alloc_tag *tag;
@@ -78,7 +79,7 @@ static inline void pgalloc_tag_split(str
 	if (!mem_alloc_profiling_enabled())
 		return;
 
-	page_ext = page_ext_get(page);
+	first_page_ext = page_ext = page_ext_get(page);
 	if (unlikely(!page_ext))
 		return;
 
@@ -94,7 +95,7 @@ static inline void pgalloc_tag_split(str
 		page_ext = page_ext_next(page_ext);
 	}
 out:
-	page_ext_put(page_ext);
+	page_ext_put(first_page_ext);
 }
 
 static inline struct alloc_tag *pgalloc_tag_get(struct page *page)
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-export-memory-allocation-profiling-symbols-used-by-modules.patch

