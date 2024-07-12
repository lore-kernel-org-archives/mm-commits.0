Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3A1127E0F
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824918; cv=none; b=C9VEZZI3AtK5Kn/VvEldJmKbOyasKOg18s3FTlymUYjsvm8ieIfYFauJvosbGi/bI/dSY3En7xTBzqvC6Sr+vqHJpkeKZAHqgOgd9X6Psx6XIF4FdARAAGw6tcWD2PfuDP2zkJ/t2sz3SkNgkdX/1WUvErnvr9t0PfY7SNcFsM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824918; c=relaxed/simple;
	bh=+QZDytNKCZBfbDee9ca7wdKB9i7fjjb3Lf0G7pjqvOY=;
	h=Date:To:From:Subject:Message-Id; b=RK6Xvtr2dNbLp4VNFehWPiqtthYCyfb/Cnq8FUcb9RLPC9d2j3zGO8IefQChIfgiEfa/IYJSlRS+ATxN26TWBVCCdz5j/0w/1WfOo6yIJBVl2slUh2RPIFL8qrjslQXcqnGfAPlgOVsmzPCz79ITHWcx6s7/k+33nVsu9rNvpgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ma6jpFxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ma6jpFxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0152AC32782;
	Fri, 12 Jul 2024 22:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824918;
	bh=+QZDytNKCZBfbDee9ca7wdKB9i7fjjb3Lf0G7pjqvOY=;
	h=Date:To:From:Subject:From;
	b=ma6jpFxPcWiDL9APn7Ve0haPzDQnwSQ6664DIF9wqE36ViZCdbWemsIQidON/2DuM
	 rRNLC3Yf8FQ0G/qXI3tb9cI68EY3+FVvvddp4t2U+DdLSdFQ2Gt5vx956XWyQplGNg
	 N5xjbmsyseIu99Xc2XyIbzYdNAqcR0TNnstrMDVE=
Date: Fri, 12 Jul 2024 15:55:17 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,souravpanda@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,keescook@chromium.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-reuse-page_ext_data-to-obtain-codetag_ref.patch removed from -mm tree
Message-Id: <20240712225518.0152AC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: reuse page_ext_data() to obtain codetag_ref
has been removed from the -mm tree.  Its filename was
     lib-reuse-page_ext_data-to-obtain-codetag_ref.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

