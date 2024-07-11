Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01501A071F
	for <mm-commits@vger.kernel.org>; Thu, 11 Jul 2024 22:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720736652; cv=none; b=VopT9SDqhCpkGDxl/6w0/FTJhfRnylKKqapPMPPh6kmV3i5ISX2/323VY2ldrMdxd2IQ0zwihhBAvw0atrWNjgVvbTVhm/2wHW/Onk1q/ClCLpAYH5YiSXFPb2evS/wgMJst2BQQbBBvQW5O6EG9ZwO1+kL9usDPJLQIej1pSg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720736652; c=relaxed/simple;
	bh=7ty2N876q9ilsz9sxq8Xx9N0w3MqxUTNCMTVgBeN3DU=;
	h=Date:To:From:Subject:Message-Id; b=FEcI0ZraACes0H/4agp3TB/Qvm6PWXMiDYtvT4ZNVfkna015+TzWx19rvYxyT/0DruqF50vkCqrz4ZChWEETosDMs0UCqhrfwtBSDTpgkZCC6pA2Y1QezDRNXJ3k9ALrp429qyXoljcjtJUcdhXo2IQdq9PXpTBJmp548Sow69c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kU2yqxkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kU2yqxkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8ABC32782;
	Thu, 11 Jul 2024 22:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720736651;
	bh=7ty2N876q9ilsz9sxq8Xx9N0w3MqxUTNCMTVgBeN3DU=;
	h=Date:To:From:Subject:From;
	b=kU2yqxkEVwkBz+KQ5xrYgct5n7sTsjDk/tcgQLCEWjZdnTXsYd9/vbXuXxxK7qX5P
	 40vi2/AjtsqhmUd/yXQyHDzxRhEB6++ws6ne3nsoP711TgzUhrqhs7taM3vOghafJb
	 Y7HB0MUHPgdj/HV1ixm5PjppS9VqQaDX/oyM2A5M=
Date: Thu, 11 Jul 2024 15:24:11 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,souravpanda@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-fix-page_ext_get-page_ext_put-sequence-during-page-splitting.patch added to mm-unstable branch
Message-Id: <20240711222411.AA8ABC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: fix page_ext_get/page_ext_put sequence during page splitting
has been added to the -mm mm-unstable branch.  Its filename is
     alloc_tag-fix-page_ext_get-page_ext_put-sequence-during-page-splitting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-fix-page_ext_get-page_ext_put-sequence-during-page-splitting.patch

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
mm-add-comments-for-allocation-helpers-explaining-why-they-are-macros.patch
lib-add-missing-newline-character-in-the-warning-message.patch
lib-reuse-page_ext_data-to-obtain-codetag_ref.patch
alloc_tag-fix-page_ext_get-page_ext_put-sequence-during-page-splitting.patch

