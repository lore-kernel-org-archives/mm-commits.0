Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EA015531B
	for <mm-commits@vger.kernel.org>; Thu, 11 Jul 2024 22:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720736650; cv=none; b=a6b7MEOGTRYQSlkrlfPd4m9JqmvejBcHSiblHFClLhWRZB5jTFzjO2RRJ9MgXNhg1tMR5B9uF43/ATCpX3kSrvUdifZmJ+WTpuIlHpBIxzqnEiOH+PIum/VH8V9dLVaLJQbgiKKfFdDKDbvuamJHjA9RQa3atvlY5UYmG0FgAKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720736650; c=relaxed/simple;
	bh=phHOE/tMzz0YgiPY6AOTTnM7Jnt+QPkzIz4KvBKbemU=;
	h=Date:To:From:Subject:Message-Id; b=O//suqBSpDv7mkdMIwNVUt5qKb2mHgmveqBDJyBnX01xrG1OrBZaNplktrXMMZ7O75ACQfBTd5JyRWCRbL3ZifJ2nofHmi0omX4IDYWoCKswRLf9IiDQD5TedZUGp0HFjaGgeuxayx0OOcZBqEuiUAz8502vQBszpVE1qHVo6RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lND/FG4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lND/FG4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42D2C116B1;
	Thu, 11 Jul 2024 22:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720736649;
	bh=phHOE/tMzz0YgiPY6AOTTnM7Jnt+QPkzIz4KvBKbemU=;
	h=Date:To:From:Subject:From;
	b=lND/FG4USS5v0gnrl3v9e4EbqIXng5wpiPnHKgdXT/M7Ssh1NasEWoF0IWntqLY2g
	 2OKz8S+Vf77/ByzDNnVYQ4q7SkhnmKQJ10By9VGD+uK3WfArBQOY0B+s49/TqNfxkh
	 8E5cuyGEZ6fp02GpHFHy9hqpDPlQpLFpUfnzi8y0=
Date: Thu, 11 Jul 2024 15:24:09 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,souravpanda@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-reuse-page_ext_data-to-obtain-codetag_ref.patch added to mm-unstable branch
Message-Id: <20240711222409.C42D2C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: reuse page_ext_data() to obtain codetag_ref
has been added to the -mm mm-unstable branch.  Its filename is
     lib-reuse-page_ext_data-to-obtain-codetag_ref.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-reuse-page_ext_data-to-obtain-codetag_ref.patch

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
Subject: lib: reuse page_ext_data() to obtain codetag_ref
Date: Thu, 11 Jul 2024 15:04:56 -0700

codetag_ref_from_page_ext() reimplements the same calculation as
page_ext_data().  Reuse existing function instead.

Link: https://lkml.kernel.org/r/20240711220457.1751071-2-surenb@google.com
Fixes: dcfe378c81f7 ("lib: introduce support for page allocation tagging")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgalloc_tag.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/pgalloc_tag.h~lib-reuse-page_ext_data-to-obtain-codetag_ref
+++ a/include/linux/pgalloc_tag.h
@@ -15,7 +15,7 @@ extern struct page_ext_operations page_a
 
 static inline union codetag_ref *codetag_ref_from_page_ext(struct page_ext *page_ext)
 {
-	return (void *)page_ext + page_alloc_tagging_ops.offset;
+	return (union codetag_ref *)page_ext_data(page_ext, &page_alloc_tagging_ops);
 }
 
 static inline struct page_ext *page_ext_from_codetag_ref(union codetag_ref *ref)
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-export-memory-allocation-profiling-symbols-used-by-modules.patch
mm-add-comments-for-allocation-helpers-explaining-why-they-are-macros.patch
lib-add-missing-newline-character-in-the-warning-message.patch
lib-reuse-page_ext_data-to-obtain-codetag_ref.patch
alloc_tag-fix-page_ext_get-page_ext_put-sequence-during-page-splitting.patch

